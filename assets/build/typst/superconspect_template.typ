#import "$preamble_location$": *

#let subject-name = [$subject_name$]
#let lecturer-name = [$lecturer_name$]

#show: basic-template
#show: doc => header-template(
  subject-name: subject-name,
  date-header: [],
  lecturer-name: lecturer-name,
  doc
)

= $top_level_header$

#outline(
  title: text(14pt)[Содержание]
)

#pagebreak()

$conspects$


