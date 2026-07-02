// Import the rendercv function and all the refactored components
#import "@preview/rendercv:0.3.0": *

// Apply the rendercv template with custom configuration
#show: rendercv.with(
  name: "Jan Pfänder",
  title: "Jan Pfänder - CV",
  footer: context { [#emph[Jan Pfänder -- #str(here().page())\/#str(counter(page).final().first())]] },
  top-note: [ #emph[Last updated in July 2026] ],
  locale-catalog-language: "en",
  text-direction: ltr,
  page-size: "us-letter",
  page-top-margin: 0.6in,
  page-bottom-margin: 0.6in,
  page-left-margin: 0.6in,
  page-right-margin: 0.6in,
  page-show-footer: true,
  page-show-top-note: true,
  colors-body: rgb(0, 0, 0),
  colors-name: rgb(126, 86, 194),
  colors-headline: rgb(126, 86, 194),
  colors-connections: rgb(0, 0, 0),
  colors-section-titles: rgb(126, 86, 194),
  colors-links: rgb(126, 86, 194),
  colors-footer: rgb(126, 86, 194),
  colors-top-note: rgb(126, 86, 194),
  typography-line-spacing: 0.6em,
  typography-alignment: "justified",
  typography-date-and-location-column-alignment: right,
  typography-font-family-body: "JetBrains Mono",
  typography-font-family-name: "JetBrains Mono",
  typography-font-family-headline: "JetBrains Mono",
  typography-font-family-connections: "JetBrains Mono",
  typography-font-family-section-titles: "JetBrains Mono",
  typography-font-size-body: 8pt,
  typography-font-size-name: 20pt,
  typography-font-size-headline: 8pt,
  typography-font-size-connections: 8pt,
  typography-font-size-section-titles: 1.4em,
  typography-small-caps-name: false,
  typography-small-caps-headline: false,
  typography-small-caps-connections: false,
  typography-small-caps-section-titles: false,
  typography-bold-name: true,
  typography-bold-headline: false,
  typography-bold-connections: false,
  typography-bold-section-titles: true,
  links-underline: false,
  links-show-external-link-icon: true,
  header-alignment: center,
  header-photo-width: 3.5cm,
  header-space-below-name: 0.7cm,
  header-space-below-headline: 0.7cm,
  header-space-below-connections: 0.7cm,
  header-connections-hyperlink: true,
  header-connections-show-icons: true,
  header-connections-display-urls-instead-of-usernames: false,
  header-connections-separator: "",
  header-connections-space-between-connections: 0.5cm,
  section-titles-type: "with_partial_line",
  section-titles-line-thickness: 0.5pt,
  section-titles-space-above: 0.5cm,
  section-titles-space-below: 0.3cm,
  sections-allow-page-break: true,
  sections-space-between-text-based-entries: 0.3em,
  sections-space-between-regular-entries: 1.2em,
  entries-date-and-location-width: 4.15cm,
  entries-side-space: 0.2cm,
  entries-space-between-columns: 0.1cm,
  entries-allow-page-break: true,
  entries-short-second-row: false,
  entries-degree-width: 1cm,
  entries-summary-space-left: 0cm,
  entries-summary-space-above: 0cm,
  entries-highlights-bullet:  "•" ,
  entries-highlights-nested-bullet:  "•" ,
  entries-highlights-space-left: 0.15cm,
  entries-highlights-space-above: 0cm,
  entries-highlights-space-between-items: 0cm,
  entries-highlights-space-between-bullet-and-text: 0.5em,
  date: datetime(
    year: 2026,
    month: 7,
    day: 2,
  ),
)


= Jan Pfänder

#connections(
  [#connection-with-icon("location-dot")[Zurich, Switzerland]],
  [#link("mailto:janlukas.pfaender@gmail.com", icon: false, if-underline: false, if-color: false)[#connection-with-icon("envelope")[janlukas.pfaender\@gmail.com]]],
  [#link("https://janpfander.github.io/", icon: false, if-underline: false, if-color: false)[#connection-with-icon("link")[janpfander.github.io]]],
  [#link("https://github.com/janpfander", icon: false, if-underline: false, if-color: false)[#connection-with-icon("github")[janpfander]]],
  [#link("https://orcid.org/0009-0009-4389-2807", icon: false, if-underline: false, if-color: false)[#connection-with-icon("orcid")[0009-0009-4389-2807]]],
)


== Positions

#regular-entry(
  [
    #strong[Swiss Federal Institute of Aquatic Science and Technology (Eawag)]

    Postdoctoral researcher

  ],
  [
    Zurich, Switzerland

    Jan 2025 – present

  ],
  main-column-second-row: [
    - Advisor: Viktoria Cologna

  ],
)

== Education

#education-entry(
  [
    #strong[École Normale Supérieure (ENS-PSL), Institut Jean Nicod], Psychology

    - Supervisors: Hugo Mercier & Kevin Arceneaux

  ],
  [
    Paris, France

    2022 – 2025

  ],
  degree-column: [
    #strong[PhD]
  ],
  main-column-second-row: [
    - Thesis: Essays on Understanding Trust in Science

  ],
)

#education-entry(
  [
    #strong[École Normale Supérieure (ENS-PSL)], Cognitive Science

    - Supervisor: Hugo Mercier

  ],
  [
    Paris, France

    2020 – 2022

  ],
  degree-column: [
    #strong[MA]
  ],
  main-column-second-row: [
    - Thesis: Can we infer people are accurate and competent merely because they agree with each other?

  ],
)

#education-entry(
  [
    #strong[Universität Freiburg], Journalism (1st year)

  ],
  [
    Freiburg, Germany

    2019 – 2020

  ],
  degree-column: [
    #strong[MA]
  ],
  main-column-second-row: [
  ],
)

#education-entry(
  [
    #strong[Universität Konstanz], Political Science and Public Administration

  ],
  [
    Konstanz, Germany

    2014 – 2018

  ],
  degree-column: [
    #strong[BA]
  ],
  main-column-second-row: [
  ],
)

== Work Experience

#regular-entry(
  [
    #strong[Direction Interministérielle de la Transformation Publique (DITP)]

    Research Intern

  ],
  [
    Paris, France

    Jun 2021 – Aug 2021

  ],
  main-column-second-row: [
  ],
)

#regular-entry(
  [
    #strong[Assemblée Nationale]

    Parliamentary Assistant

  ],
  [
    Paris, France

    Sep 2018 – Jul 2019

  ],
  main-column-second-row: [
  ],
)

#regular-entry(
  [
    #strong[University of St. Gallen]

    Research Assistant

  ],
  [
    St. Gallen, Switzerland

    Jun 2017 – Jul 2018

  ],
  main-column-second-row: [
  ],
)

== Publications

  #regular-entry(
  [
    #strong[Peer-reviewed publications]

  ],
  [
  ],
  main-column-second-row: [
    (#emph[n] = 5)

  ],
)

#regular-entry(
  [
    #strong[Global studies on trust in science suggest new theoretical and methodological directions]

  ],
  [
    2026

  ],
  main-column-second-row: [
    #strong[J. Pfänder], N. G. Mede, V. Cologna

    #link("https://doi.org/https://doi.org/10.1016/j.copsyc.2025.102215")[https:\/\/doi.org\/10.1016\/j.copsyc.2025.102215] (Current Opinion in Psychology)

  ],
)

#regular-entry(
  [
    #strong[Trusting but forgetting impressive science]

  ],
  [
    2025

  ],
  main-column-second-row: [
    #strong[J. Pfänder], S. de Rouilhan, H. Mercier

    #link("https://doi.org/https://doi.org/10.1163/15685373-12340227")[https:\/\/doi.org\/10.1163\/15685373-12340227] (Journal of Cognition and Culture)

  ],
)

#regular-entry(
  [
    #strong[Quasi-universal acceptance of basic science in the United States]

  ],
  [
    2025

  ],
  main-column-second-row: [
    #strong[J. Pfänder], L. Kerzreho, H. Mercier

    #link("https://doi.org/https://doi.org/10.1177/09636625251364407")[https:\/\/doi.org\/10.1177\/09636625251364407] (Public Understanding of Science)

  ],
)

#regular-entry(
  [
    #strong[Spotting false news and doubting true news: a systematic review and meta-analysis of news judgements]

  ],
  [
    2025

  ],
  main-column-second-row: [
    #strong[J. Pfänder], S. Altay

    #link("https://doi.org/https://doi.org/10.1038/s41562-024-02086-1")[https:\/\/doi.org\/10.1038\/s41562-024-02086-1] (Nature Human Behaviour)

  ],
)

#regular-entry(
  [
    #strong[How wise is the crowd: Can we infer people are accurate and competent merely because they agree with each other?]

  ],
  [
    2025

  ],
  main-column-second-row: [
    #strong[J. Pfänder], B. de Courson, H. Mercier

    #link("https://doi.org/https://doi.org/10.1016/j.cognition.2024.106005")[https:\/\/doi.org\/10.1016\/j.cognition.2024.106005] (Cognition)

  ],
)

  #regular-entry(
  [
    #strong[Conference proceedings]

  ],
  [
  ],
  main-column-second-row: [
    (#emph[n] = 1)

  ],
)

#regular-entry(
  [
    #strong[How wise is the crowd: Can we infer people are accurate and competent merely because they agree with each other?]

  ],
  [
    2024

  ],
  main-column-second-row: [
    #strong[J. Pfänder], B. de Courson, H. Mercier

    #link("https://escholarship.org/uc/item/4ms2n8wd")[escholarship.org\/uc\/item\/4ms2n8wd] (Proceedings of the Annual Meeting of the Cognitive Science Society)

  ],
)

  #regular-entry(
  [
    #strong[Large collaborations (minor role)]

  ],
  [
  ],
  main-column-second-row: [
    (#emph[n] = 2)

  ],
)

#regular-entry(
  [
    #strong[Trust in scientists and their role in society across 68 countries]

  ],
  [
    2025

  ],
  main-column-second-row: [
    V. Cologna, N. G. Mede, S. Berger, ..., #strong[J. Pfänder], ... et al.

    #link("https://doi.org/https://doi.org/10.1038/s41562-024-02090-5")[https:\/\/doi.org\/10.1038\/s41562-024-02090-5] (Nature Human Behaviour)

  ],
)

#regular-entry(
  [
    #strong[Perceptions of science, science communication, and climate change attitudes in 68 countries – the TISP dataset]

  ],
  [
    2025

  ],
  main-column-second-row: [
    N. G. Mede, V. Cologna, S. Berger, ..., #strong[J. Pfänder], ... et al.

    #link("https://doi.org/https://doi.org/10.1038/s41597-024-04100-7")[https:\/\/doi.org\/10.1038\/s41597-024-04100-7] (Scientific Data)

  ],
)

  #regular-entry(
  [
    #strong[Working papers]

  ],
  [
  ],
  main-column-second-row: [
    (#emph[n] = 2)

  ],
)

#regular-entry(
  [
    #strong[The rational impression account of trust in science]

  ],
  [
    2025

  ],
  main-column-second-row: [
    #strong[J. Pfänder], H. Mercier

    #link("https://doi.org/https://doi.org/10.31234/osf.io/nwka2_v1")[https:\/\/doi.org\/10.31234\/osf.io\/nwka2\_v1]

  ],
)

#regular-entry(
  [
    #strong[The French trust more the sciences they perceive as precise and consensual]

  ],
  [
    2025

  ],
  main-column-second-row: [
    #strong[J. Pfänder], H. Mercier

    #link("https://doi.org/https://doi.org/10.31219/osf.io/k9m6e_v1")[https:\/\/doi.org\/10.31219\/osf.io\/k9m6e\_v1]

  ],
)

== Presentations

  #regular-entry(
  [
    #strong[Invited talks]

  ],
  [
  ],
  main-column-second-row: [
  ],
)

#regular-entry(
  [
    #strong[Trust in science]

  ],
  [
    2025

  ],
  main-column-second-row: [
    #summary[Paris School of International Affairs (Sciences Po), Paris]

  ],
)

  #regular-entry(
  [
    #strong[Conference presentations]

  ],
  [
  ],
  main-column-second-row: [
  ],
)

#regular-entry(
  [
    #strong[Belief in & interventions against misinformation]

  ],
  [
    2025

  ],
  main-column-second-row: [
    #summary[15th Annual Conference of the European Political Science Association, Madrid]

  ],
)

#regular-entry(
  [
    #strong[The rational impression account of trust in science]

  ],
  [
    2025

  ],
  main-column-second-row: [
    #summary[Explaining culture: an interdisciplinary approach, Paris]

  ],
)

#regular-entry(
  [
    #strong[Spotting False News and Doubting True News. A Meta-Analysis of News Judgments (Keynote)]

  ],
  [
    2025

  ],
  main-column-second-row: [
    #summary[Infox sur Seine, Paris]

  ],
)

#regular-entry(
  [
    #strong[How wise is the crowd: Can we infer people are accurate and competent merely because they agree with each other? (Poster)]

  ],
  [
    2024

  ],
  main-column-second-row: [
    #summary[46th Annual Meeting of the Cognitive Science Society, Rotterdam]

  ],
)

#regular-entry(
  [
    #strong[Processus sous-tendant la confiance dans la science]

  ],
  [
    2024

  ],
  main-column-second-row: [
    #summary[5ème édition des Rencontres Jeunes Chercheur·euse·s, Grenoble]

  ],
)

#regular-entry(
  [
    #strong[Spotting False News and Doubting True News: A Meta-Analysis of News Judgments]

  ],
  [
    2024

  ],
  main-column-second-row: [
    #summary[EDMO Scientific Conference on Disinformation, Amsterdam]

  ],
)

== Teaching

  #regular-entry(
  [
    #strong[Courses]

  ],
  [
  ],
  main-column-second-row: [
  ],
)

#regular-entry(
  [
    #strong[Fact-Checking and Critical Thinking]

  ],
  [
    2022 – 2025

  ],
  main-column-second-row: [
    #summary[Université PSL (Paris Sciences & Lettres) — BA program \"Sciences pour un monde durable\"]

    - A hands-on introduction to research design for an interdisciplinary BA program

    - Sole instructor & creator of the course

    - 30h in-class per semester; one semester a year

  ],
)

  #regular-entry(
  [
    #strong[Workshops]

  ],
  [
  ],
  main-column-second-row: [
  ],
)

#regular-entry(
  [
    #strong[Meta-analysis for beginners]

  ],
  [
    2024

  ],
  main-column-second-row: [
    #summary[Laboratoire de Psychologie du Développement et de l'Éducation de l'Enfant (LaPsyDÉ)]

  ],
)

== Advising

  #regular-entry(
  [
    #strong[Graduate students]

  ],
  [
  ],
  main-column-second-row: [
    - Lou Kerzreho (2023)

  ],
)

  #regular-entry(
  [
    #strong[Undergraduate students]

  ],
  [
  ],
  main-column-second-row: [
    - Mateo Pivert (2024)

    - Ludivine Million (2024)

    - Prune Lefevre Jachimowicz (2024)

    - Kevin Chen (2023)

    - Théodore Lellouche (2022)

  ],
)

== Professional Service

  #regular-entry(
  [
    #strong[Peer Reviewing]

  ],
  [
  ],
  main-column-second-row: [
    #summary[(#emph[n] = 10)]

    - Journals: #emph[Nature Climate Change] (1), #emph[Public Understanding of Science] (3), #emph[PNAS Nexus] (1), #emph[Social Science & Medicine] (1), #emph[Društvena istraživanja] (1), #emph[Behavior Research Methods] (1), #emph[Educational Research Review] (1), #emph[Artificial Intelligence Review] (1)

  ],
)

== Summer Schools

#regular-entry(
  [
    #strong[Diverse Intelligences Summer Institute]

    #summary[Hosted by the University of St. Andrews, organized by Indiana University Bloomington]

  ],
  [
    St. Andrews, UK

    2024

  ],
  main-column-second-row: [
  ],
)

== Skills

#strong[Languages:] German, English, French, Spanish

#strong[Programming:] R, Git (basics), Python (rudimentary)
