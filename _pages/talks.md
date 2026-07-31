---
layout: page
permalink: /talks/
title: talks
description: Technical talks and presentations.
nav: true
nav_order: 4
---

<div class="publications">
  <table class="table table-sm table-borderless">
    {% assign talks = site.data.talks | sort: "date" | reverse %}
    {% for talk in talks %}
      <tr>
        <th scope="row" style="width: 20%">{{ talk.date | date: '%b %d, %Y' }}</th>
        <td>
          {% if talk.url %}
            <a href="{{ talk.url }}" target="_blank" rel="noopener noreferrer">{{ talk.title }}</a>
          {% else %}
            {{ talk.title }}
          {% endif %}
          {% if talk.venue or talk.mode %}
            <p class="text-muted mb-0" style="font-size: 0.85rem">
              {{ talk.venue }}{% if talk.venue and talk.mode %} &middot; {% endif %}{{ talk.mode }}
            </p>
          {% endif %}
        </td>
      </tr>
    {% endfor %}
  </table>
</div>
