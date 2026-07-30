---
layout: page
permalink: /publications/
title: publications
description: Research publications and White papers.
years: [2024, 2022, 2020, 2019, 2018, 2015]
nav: true
nav_order: 1
---

<!-- _pages/publications.md -->

<!-- Bibsearch Feature -->

{% include bib_search.liquid %}

<div class="publications">

{%- for y in page.years %}
  {% bibliography -f papers -q @*[year={{y}}]* %}
{% endfor %}

</div>
