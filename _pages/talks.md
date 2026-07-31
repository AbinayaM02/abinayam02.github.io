---
layout: page
permalink: /talks/
title: talks
description: Technical talks and presentations.
nav: true
nav_order: 4
---

<!-- Talks, grouped by year. Content lives in _data/talks.yml. The card markup
     mirrors _includes/projects.liquid so this page matches /projects/. -->

<div class="projects">
  {% assign talks = site.data.talks | sort: "date" | reverse %}
  {%- assign year_list = "" -%}
  {%- for talk in talks -%}
    {%- assign y = talk.date | date: "%Y" -%}
    {%- unless year_list contains y -%}
      {%- assign year_list = year_list | append: y | append: "," -%}
    {%- endunless -%}
  {%- endfor -%}
  {% assign years = year_list | split: "," %}
  {% for talk_year in years %}
    <a id="{{ talk_year }}" href=".#{{ talk_year }}">
      <h2 class="category">{{ talk_year }}</h2>
    </a>
    <div class="row row-cols-1 row-cols-md-3">
      {% for talk in talks %}
        {%- assign this_year = talk.date | date: "%Y" -%}
        {% if this_year != talk_year %}{% continue %}{% endif %}
        <div class="col">
          {% if talk.url %}
            <a href="{{ talk.url }}" target="_blank" rel="noopener noreferrer">
          {% endif %}
          <div class="card h-100 {% if talk.url %}hoverable{% endif %}">
            {% if talk.img %}
              {%
                include figure.liquid
                loading="eager"
                path=talk.img
                sizes="250px"
                alt="talk thumbnail"
                class="card-img-top"
              %}
            {% endif %}
            <div class="card-body">
              <h2 class="card-title">{{ talk.title }}</h2>
              <p class="card-text">{{ talk.description }}</p>
              <p class="post-meta">
                {{ talk.date | date: '%B %d, %Y' }}
                {% if talk.venue or talk.mode %}
                  &nbsp; &middot; &nbsp; {{ talk.venue }}{{ talk.mode }}
                {% endif %}
                {% if talk.url %}
                  &nbsp; &middot; &nbsp; <i class="fa-brands fa-youtube"></i> recording
                {% endif %}
              </p>
            </div>
          </div>
          {% if talk.url %}
            </a>
          {% endif %}
        </div>
      {% endfor %}
    </div>
  {% endfor %}
</div>
