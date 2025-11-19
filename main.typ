#import "components.typ": author_styled, strip_numbering, plain_footer, article_footer
#import "cover.typ": cover

#import "@preview/cmarker:0.1.7"
#import "@preview/alexandria:0.2.1": alexandria, bibliographyx as _bibliographyx

#let meta(
  journal: "JOURNAL NAME",
  volume: "Volume X",
  date: datetime.today(),
  document_title: "SSJ Vol. X, 202X",
  logo: "assets/logo.svg",
  cover_background: "assets/cover_pattern.svg",

  author: "Stellenbosch Socratic Society",
  institution: "Stellenbosch University",

  colophon: [
    Copyright © belongs to the respective authors.\
    This work is published under a Creative Commons BY-NC-SA 4.0 license.\
    #link(
      "https://creativecommons.org/licenses/by-nc-sa/4.0",
      [creativecommons.org/licenses/by-nc-sa/4.0]
    )
    #v(5pt)
    Published by the Stellenbosch University Department of Philosophy,\
    Stellenbosch, South Africa.\
    #link(
      "https://www.su.ac.za/en/faculties/arts/departments/philosophy",
      [su.ac.za/en/faculties/arts/departments/philosophy]
    )
    #v(5pt)
    Published on SUNJournals.\
    #link(
      "https://www.journals.ac.za/ssj",
      [journals.ac.za/ssj]
    )
  ],

  editorial_team: (),

  reviewers_message: "",
  reviewers: none,

  csl: "assets/ssj-ref.csl",

  foreword: (),

  articles: ()
) = {
  // SETUP

  set text(
    lang: "en",
    region: "ZA",
    font: "Brill",
    size: 11pt,
  )

  // PDF metadata
  set document(
    title: if (sys.inputs.keys().contains("cover") and sys.inputs.cover == "full") [
      #document_title — cover
    ] else {
      document_title
    },
    author: author,
    date: date,
  )

  set page(
    paper: "a4",
    margin: 2cm,
  )

  set par(
    justify: true,
    justification-limits: (
      tracking: (min: -0.01em, max: 0.01em),
    ),
    leading: 0.8em,
    linebreaks: "optimized",
  )

  set footnote.entry(indent: 0mm, gap: 0.8em)

  // tighten blockquote to previous par
  show quote.where(block: true): set block(above: 1.5em)

  show heading: it => {
    // relax heading spacing
    set block(above: 1.5em, below: 1em)
    // don't justify or hyphenate or bold headings
    set par(justify: false)
    set text(
      weight: "regular",
      hyphenate: false,
    )
    it
  }

  show title: set text(
    size: 25pt,
    weight: "regular",
  )

  let article_title(article) = {
    let title_outline = {
      if ( article.keys().contains("title_pretty")
      and article.title_pretty.keys().contains("contents_page") ) {
        article.title_pretty.contents_page
      } else {
        article.title
      }
    }

    let title_display = {
      if ( article.keys().contains("title_pretty")
      and article.title_pretty.keys().contains("article_first_page") ) {
        article.title_pretty.article_first_page
      } else {
        article.title
      }
    }

    counter(heading).step()

    // for display
    [ // label only works in content block
      #heading(
        level: 1,
        outlined: false,
        bookmarked: false,
        title_display
      )
      #label(article.short)
    ]

    // bookmark must come before the displayed heading so when jumping, the
    // heading is in view, but the bookmark heading must be directly before
    // all h2 headings, otherwise those h2 headings don't have an h1, and thus
    // become top-level in PDF bookmarks. Currently the bookmark is the top of
    // the page, which is different than other h1s in the document, but it looks
    // better this way anyway.
    place(
      top + left,
      {
        show heading: none
        // for outline
        heading(
          level: 1,
          bookmarked: false,
          title_outline
        )
        // for bookmark
        heading(
          level: 1,
          outlined: false,
          bookmarked: true,
          article.title
        )
      }
    )
  }

  // h1 is section (incl. article) title
  show heading.where(level: 1): it => {
    set text(size: 23pt)
    set par(leading: 0.5em)
    set block(above: 20mm)
    set heading(numbering: none)
    v(20mm)
    it
  }

  // h2 is article sections
  show heading.where(level: 2): it => {
    set text(size: 14pt, weight: "regular", hyphenate: false)
    set par(leading: 0.6em)
    let num = counter(heading).display()
    block(
      above: 1.5em,
      below: 1em,
      {
        if it.numbering != none {
          place(num, dx: -(measure(num).width + 0.3em))
        }
        it.body
      }
    )
  }

  // lining figures in links (URLs are usually bare for print)
  show link: set text(number-type: "lining")

  // match outline heading spacing to other h1s without author
  set outline(title: [
    Contents
    #v(10mm)
  ])
  // ToC in PDF bookmarks
  show outline: set heading(bookmarked: true)

  show outline.entry.where(level: 1): set block(above: 2em)
  set outline.entry(fill: none)

  // author state necessary before being used in outline below
  let author_state = state("author", "")

  // add author to outline; limit titles to 2/3 width
  show outline.entry: it => {
    let author = author_state.at(it.element.location())
    let element_grid(..contents) = grid(
      columns: (2fr, 1fr),
      align: (left, right),
      gutter: 1em,
      ..contents
    )
    link(
      it.element.location(),
      it.indented(
        it.prefix(),
        if author != "" {
          element_grid(
            it.element.body.text, it.page(),
            text(style: "italic", author)
          )
        } else {
          element_grid(
            it.element.body.text, it.page(),
          )
        }
      ),
    )
  }

  // hack for multiple bibliographies

  // define prefix for each bibliography
  for article in articles {
    show: alexandria(prefix: article.short + "-", read: path => read(path))
  }
  // set bibliography heading styles
  // (have to override/wrap function, show rules don't work)
  let bibliographyx(..args) = {
    set heading(numbering: none)
    set heading(level: 2)
    _bibliographyx(
      ..args,
      title: "References",
      style: csl,
      full: true,
    )
  }

  // FRONTMATTER

  // cover page
  let render_document = true
  let cover_page = {
    cover(
      articles: articles,
      editorial_team: editorial_team,
      date: date,
      volume: volume,
      background: cover_background,
     )
    pagebreak(to: "odd", weak: true)
  }

  if sys.inputs.keys().contains("cover") {
    if sys.inputs.cover == "none" {
      cover_page = {}
    }
    if sys.inputs.cover == "full" {
      cover_page = cover(
        full: true,
        articles: articles,
        editorial_team: editorial_team,
        date: date,
        volume: volume,
        background: cover_background,
       )
      render_document = false
    }
  }

  counter(page).update(0)
  set page(
    numbering: none,
  )

  cover_page

  if render_document {
    set page(
      numbering: "i",
      footer: none
    )
    // title page
    counter(page).update(1)
    page({
      align(
        center + top,
        {
          v(30mm)
          image(logo, alt: "The SSJ logo.", width: 15%)
          v(5mm)
          title(smallcaps(journal))
          v(5mm)
          text(
            size: 18pt,
            volume
          )
        }
      )
      align(
        center + bottom,
        [
          #date.display("[month repr:long] [year]")\
          #author\
          #institution
        ]
      )
    })

    // colophon
    page(
      align(
        left + bottom,
        colophon
      )
    )

    // table of contents
    page(
      footer: plain_footer,
      outline(depth: 1)
    )

    // credits
    pagebreak(to: "odd", weak: true)
    page(
      footer: plain_footer,
      {
        heading(level: 1, [Contributors])
        v(10mm)
        heading(level: 2, [Editorial])
        show table: set par(leading: 1.2em)
        table(
          columns: (1fr, 1fr),
          align: (left, left),
          stroke: none,
          inset: (x: 0mm),
          gutter: 0.2em,
          ..editorial_team.pairs().map( ( (k, v) ) => (
            text(style: "italic", k),
            v.join("\n")
          )).flatten()
        )
        v(10mm)

        if reviewers != none {
          heading(level: 2, [Reviewers])
          v(2mm)
          reviewers_message
          table(
            columns: (1fr, 1fr),
            align: (left, left),
            stroke: none,
            inset: (x: 0mm),
            gutter: 0.2em,
            ..reviewers
          )
        }
      }
    )

    // foreword
    pagebreak(to: "odd", weak: true)
    page(
      footer: article_footer(journal: journal, volume: volume, date: date, foreword),
      {
        author_state.update(foreword.author)
        heading(level: 1, foreword.title)
        author_styled(foreword.author)
        v(15mm)
        if foreword.file.ends-with(".md") {
          cmarker.render(
            h1-level: 2,
            label-prefix: "foreword-",
            scope: (image: (path, alt: none) => image(path, alt: alt)),
            read(foreword.file)
          )
        } else {
          set heading(offset: 1)
          include(foreword.file)
        }
      }
    )


    // MAIN MATTER

    set page(
      numbering: "1",
      footer: none
    )

    counter(page).update(1)

    for article in articles {
      pagebreak(to: "odd", weak: true)
      author_state.update(article.author)
      page(
        footer: article_footer(journal: journal, volume: volume, date: date, article),
        {
          counter(footnote).update(0)
          // article title page
          article_title(article)
          author_styled(article.author)

          v(15mm)
          heading(level: 2, [Abstract])
          if article.abstract.ends-with(".md") {
            cmarker.render(
              label-prefix: article.short + "-",
              scope: (image: (path, alt: none) => image(path, alt: alt)),
              read(article.abstract)
            )
          } else {
            include(article.abstract)
          }

          if article.keys().contains("about") {
            v(15mm)
            heading(level: 2, [About the author])
            if article.about.ends-with(".md") {
              cmarker.render(
                label-prefix: article.short + "-",
                scope: (image: (path, alt: none) => image(path, alt: alt)),
                read(article.about)
              )
            } else {
              include(article.about)
            }
          }

          v(1fr)

          // article metadata: DOI, copyright, orcids
          {
            set par(justify: false)

            // DOI
            if article.keys().contains("doi") {
              link(
                "https://doi.org/" + article.doi,
                [DOI: #article.doi]
              )
              h(3mm)

              // if multiple author orcids, then line will overflow,
              // so rather put DOI on separate line
              if ( article.keys().contains("orcid")
              and type(article.orcid) == array ) {
                linebreak()
              }
            }


            // Copyright
            link(
              "https://creativecommons.org/licenses/by-nc-sa/4.0",
              [© CC BY-NC-SA 4.0]
            )
            h(1mm)
            article.author

            // Author ORCID
            let orcid_logo = {
              h(3mm)
              box(
                height: 0.7em,
                baseline: 0.5pt,
                image("assets/orcid.svg", alt: "The ORCID logo.")
              )
              h(1mm)
            }

            let orcid_link(id) = link(
              "https://orcid.org/" + id,
              id
            )

            if article.keys().contains("orcid") {
              orcid_logo
              if type(article.orcid) == array {
                article.orcid.map(orcid_link).join(", ")
              } else {
                orcid_link(article.orcid)
              }
            }
          }

          // article body
          pagebreak(to: "even")
          columns(
            2,
            gutter: 10mm,
            { 
              set heading(numbering: strip_numbering)
              if article.file.ends-with(".md") {
                cmarker.render(
                  label-prefix: article.short + "-",
                  scope: (image: (path, alt: none) => image(path, alt: alt)),
                  h1-level: 2,
                  read(article.file)
                )
              } else {
                set heading(offset: 1)
                include(article.file)
              }
            }
          )

          // references
          if article.keys().contains("bibliography") {
            pagebreak()
            bibliographyx(article.bibliography, prefix: article.short + "-")
          }
        }
      )
    }


    // BACKMATTER

    pagebreak(to: "even")
    align(
      center + bottom,
      image(logo, alt: "The SSJ logo.", width: 10%)
    )

  }

}
