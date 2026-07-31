---
layout: page
permalink: /talks/
title: talks
description: Technical talks and presentations.
nav: true
nav_order: 4
---

<!-- Talks, grouped by year. Content lives in _data/talks.yml and the card
     markup in _includes/talks.liquid, which mirrors _includes/projects.liquid
     so this page matches /projects/. Keeping the card in an include also keeps
     liquid-built hrefs out of this .md, which the link checker scans. -->

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
        {% include talks.liquid talk=talk %}
      {% endfor %}
    </div>
  {% endfor %}
</div>
