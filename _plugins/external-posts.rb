require 'feedjira'
require 'fileutils'
require 'httparty'
require 'jekyll'
require 'nokogiri'
require 'time'

module ExternalPosts
  class ExternalPostsGenerator < Jekyll::Generator
    safe true
    priority :high

    def generate(site)
      if site.config['external_sources'] != nil
        site.config['external_sources'].each do |src|
          puts "Fetching external posts from #{src['name']}:"
          begin
            if src['rss_url']
              fetch_from_rss(site, src)
            elsif src['posts']
              fetch_from_urls(site, src)
            end
          rescue StandardError => e
            # A flaky or rate-limited feed must not fail the whole build.
            Jekyll.logger.warn "External posts:", "skipping #{src['name']} (#{e.class}: #{e.message})"
          end
        end
      end
    end

    # Feeds behind Cloudflare (medium.com) intermittently answer 429 with an HTML
    # challenge page, which is not parseable as a feed. Cache the last good
    # response so a throttled fetch reuses it instead of dropping every post.
    def cache_path(site, src)
      dir = site.in_source_dir('.jekyll-cache', 'external-posts')
      FileUtils.mkdir_p(dir)
      slug = src['name'].to_s.downcase.gsub(/[^\w.-]/, '-')
      File.join(dir, "#{slug}.xml")
    end

    def fetch_from_rss(site, src)
      cache = cache_path(site, src)
      xml = nil

      response = HTTParty.get(src['rss_url'])
      if response.code == 200 && !response.body.to_s.empty?
        xml = response.body
        File.write(cache, xml)
      else
        Jekyll.logger.warn "External posts:", "#{src['name']} returned HTTP #{response.code}"
      end

      if xml.nil? && File.exist?(cache)
        Jekyll.logger.warn "External posts:", "using cached feed for #{src['name']}"
        xml = File.read(cache)
      end

      return if xml.nil?

      begin
        feed = Feedjira.parse(xml)
      rescue Feedjira::NoParserAvailable
        # A poisoned cache is worse than none: drop it so the next build refetches.
        File.delete(cache) if File.exist?(cache)
        raise
      end

      process_entries(site, src, feed.entries)
    end

    def process_entries(site, src, entries)
      entries.each do |e|
        puts "...fetching #{e.url}"
        create_document(site, src['name'], e.url, {
          title: e.title,
          content: e.content,
          summary: e.summary,
          published: e.published,
          thumbnail: first_image(e.content),
          tags: entry_tags(e)
        })
      end
    end

    # Medium publishes each post's tags as <category> elements, so external
    # posts can carry the same tag list as local ones.
    def entry_tags(entry)
      raw = entry.respond_to?(:categories) ? entry.categories : nil
      return [] if raw.nil?
      Array(raw).map { |t| t.to_s.strip }.reject(&:empty?).uniq
    end

    # Pull the lead image out of the feed body so external posts get a thumbnail
    # in the blog list, the same as local posts with a `thumbnail` front matter.
    def first_image(content)
      return nil if content.nil? || content.empty?
      img = Nokogiri::HTML(content).at('img')
      return nil if img.nil?
      src = img['src']
      return nil if src.nil? || src.strip.empty?
      # Feeds sometimes carry 1px tracking pixels; those make useless thumbnails.
      return nil if img['width'].to_i == 1 || img['height'].to_i == 1
      src.strip
    end

    def create_document(site, source_name, url, content)
      # check if title is composed only of whitespace or foreign characters
      if content[:title].gsub(/[^\w]/, '').strip.empty?
        # use the source name and last url segment as fallback
        slug = "#{source_name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')}-#{url.split('/').last}"
      else
        # parse title from the post or use the source name and last url segment as fallback
        slug = content[:title].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
        slug = "#{source_name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')}-#{url.split('/').last}" if slug.empty?
      end

      path = site.in_source_dir("_posts/#{slug}.md")
      doc = Jekyll::Document.new(
        path, { :site => site, :collection => site.collections['posts'] }
      )
      doc.data['external_source'] = source_name
      doc.data['title'] = content[:title]
      doc.data['feed_content'] = content[:content]
      doc.data['description'] = content[:summary]
      doc.data['date'] = content[:published]
      doc.data['redirect'] = url
      doc.data['thumbnail'] = content[:thumbnail] if content[:thumbnail]
      doc.data['tags'] = content[:tags] if content[:tags] && !content[:tags].empty?
      site.collections['posts'].docs << doc
    end

    def fetch_from_urls(site, src)
      src['posts'].each do |post|
        puts "...fetching #{post['url']}"
        content = fetch_content_from_url(post['url'])
        content[:published] = parse_published_date(post['published_date'])
        create_document(site, src['name'], post['url'], content)
      end
    end

    def parse_published_date(published_date)
      case published_date
      when String
        Time.parse(published_date).utc
      when Date
        published_date.to_time.utc
      else
        raise "Invalid date format for #{published_date}"
      end
    end

    def fetch_content_from_url(url)
      html = HTTParty.get(url).body
      parsed_html = Nokogiri::HTML(html)

      title = parsed_html.at('head title')&.text.strip || ''
      description = parsed_html.at('head meta[name="description"]')&.attr('content') || ''
      body_content = parsed_html.at('body')&.inner_html || ''

      {
        title: title,
        content: body_content,
        summary: description
        # Note: The published date is now added in the fetch_from_urls method.
      }
    end

  end
end
