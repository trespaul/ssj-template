#let author_styled(name) = {
  v(3mm)
  text(style: "italic", size: 23pt, name)
}

// for removing chapter (h1) number from section numbers
#let strip_numbering(first, ..tail) = {
  tail.pos().map(str).join(".") + "."
}

// plain footer (for frontmatter)
#let plain_footer = context {
  if calc.even(counter(page).get().first()) {
    counter(page).display()
  } else {
    align(right, counter(page).display())
  }
}

// journal metadata on first page of section, article metadata on rest
#let article_footer(
  journal: "",
  volume: "",
  date: datetime.today(),
  article
) = context {

  // footer of first page of each "section" has journal metadata
  let section_firstpage_footer = context [
    #journal, #volume, #date.display("[month repr:long] [year]")
    #h(1fr)
    #counter(page).display()
  ]

  // footer of rest of article has article metadata
  let article_body_footer(article) = context {
    if calc.even(counter(page).get().first()) [
      // if verso, numbers outside and title inside
      #counter(page).display()
      #h(1fr)
      #if article.keys().contains("short_title") [
        #article.short_title
      ] else [
        #article.title.split(":").first()
      ]
    ] else [
      // if recto, author inside and numbers outside
      #text(style: "italic", article.author)
      #h(1fr)
      #counter(page).display()
    ]
  }

  // if page has h1, it means it's the first page of a section
  let section_heading = query(heading.where(level: 1).before(here())).last()
  let is_section_first_page = section_heading.location().page() == here().page()

  if is_section_first_page {
    section_firstpage_footer
  } else {
    article_body_footer(article)
  }
}
