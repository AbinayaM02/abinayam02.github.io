---
layout: page
title: Genetic Markers for Cancer
description: This is a GPU based project aimed at implementing a machine learning algorithm that can examine cancer datasets and identify multiple genetic markers that are associated with the same type of cancer, and also cases where a single genetic marker is associated with multiple types of cancers. The implementation of backend is done using CUDA C. HTML and Javascript is used for the frontend.
img: assets/img/cancer.png
importance: 1
url: https://github.com/AbinayaM02/OSProject9C2
category: academic
related_publications: true
---

<b> Abstract </b>

We propose a classification scheme for genetic markers, to associate them with a single type or
multiple types of cancer. Given multiple unknown datasets with genetic markers that are associated
with particular types of cancer, we classify these genetic markers into two different classes. One
class comprises the single genetic markers associated with a particular type of cancer, but with
the potential to cause other cancers. The other class is comprised of multiple genetic markers
each associated with a particular type of cancer, which in combination also have the potential to
be associated with a different type of cancer. Use of this classification scheme would be helpful
in predicting a possibility of new cancers from available data about genetic markers, and would
thus have diagnostic or therapeutic value in oncology. A graphics processing unit (GPU) is used to
accelerate the process of classification by making the entire classification scheme faster compared
to the same process running on a CPU. A feature subset selection algorithm is used to remove
irrelevant features by comparison of all the features from the dataset with the threshold file which
contains the appropriate feature that relate them with the possibility of causing cancer. This work
enables the classification of all given genetic markers into two categories, of which one category
in particular consists of markers whose influence in causing multiple types of cancer is otherwise
unknown.

Link to publication: <a href="https://www.researchgate.net/publication/280744992_Cross-Referencing_Cancer_Data_Using_GPU_for_Multinomial_Classification_of_Genetic_Markers">Genetic Markers for Cancer</a>
