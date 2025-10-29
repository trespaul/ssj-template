#let cover(
  journal: "Stellenbosch Socratic Journal",
  volume: "Volume X",
  author: "Stellenbosch Socratic Society",
  publisher: "Stellenbosch University Department of Philosophy",
  date: datetime.today(),
  logo: "assets/logo_white.svg",
  editorial_team: (),
  articles: (),
  full: false,
  spine: 2mm,
  bleed: 5mm,
  background: "assets/cover_pattern.svg",
) = {
  // SETUP

  set text(
    lang: "en",
    region: "ZA",
    font: "Brill",
    size: 11pt,
    fill: white,
    hyphenate: false,
  )

  // COMPONENTS

  show title: set text(
    size: 63pt,
    style: "italic",
  )

  let base_margin = 25mm
  let margin = base_margin + if full {bleed} else {0mm}

  let subtitle = [
    #volume, #date.display("[month repr:long] [year]")
  ]

  let full_size = (
    width: 420mm + spine + (bleed * 2),
    height: 297mm + (bleed * 2),
  )

  // PAGE

  set page(
    margin: margin,
    background: place(
      top + left,
      ..if not full {(
        // dx = spine +   A4width +   bleed
        // fw = spine + 2 A4width + 2 bleed
        // a = (f - s - 2b)/2
        // dx = s + (f - s - 2b)/2 + b
        //    = (s + f)/2
        dx: - (full_size.width + spine)/2,
        dy: - bleed
      )},
      image(
        width: full_size.width,
        height: full_size.height,
        background
      )
    ),

    ..if full {
      full_size
    } else {(
      paper: "a4",
    )}
  )

  // LAYOUT

  pdf.artifact({ // cover is decorative

  // spine
  if full {
    place(
      center + horizon,
      rotate(
        90deg,
        {
          set block(width: full_size.height - margin*2)
          set text(style: "italic", size: 16.8pt)
          grid(
            columns: (1fr, 1fr),
            align: (left, right),
            journal,
            subtitle
          )
        }
      )
    )
  }

  columns(
    if full {2} else {1},
    gutter: 2 * base_margin + spine,
    {
      // back cover
      if full {
        set text(size: 16pt)
        set par(justify: false)
        for article in articles {
          block(
            width: 85%,
            [
              #article.title\
              #block(
                above: 0.8em,
                text(style: "italic", article.author)
              )
              #v(3mm)
            ]
          )
        }
        v(1fr) // necessary because placing spine makes columns shrink?
        place(
          bottom,
          {
            grid(
              columns: (4fr, 1fr),
              align(
                bottom + left,
                [
                  #author\
                  #publisher
                ],
              ),
              place(
                horizon + center,
                {
                  image(
                    width: 20mm,
                    logo
                  )
                }
              )
            )
          }
        )
      }

      if full {colbreak()}

      // front cover
      {
        v(10mm)
        block(
          width: 110mm,
          {
            par(
              leading: 2em,
              text(
                size: 63pt,
                style: "italic",
                journal
              )
            )
          }
        )
        block(
          above: 13mm,
          text(
            size: 25pt,
            style: "italic",
            subtitle
          )
        )
        v(1fr)
        align(
          bottom,
          grid(
            columns: (2fr, 1fr),
            align(
              bottom + left,
              [
                #set par(leading: 1.1em)
                #text(
                  size: 18pt,
                  smallcaps([Editor-in-Chief])
                )\
                #text(
                  size: 25pt,
                  style: "italic",
                  editorial_team.at("Editor-in-Chief").at(0)
                )\
                #v(5mm)
                #text(
                  size: 18pt,
                  smallcaps([Co-Editors])
                )\
                #text(
                  size: 25pt,
                  style: "italic",
                  for name in editorial_team.at("Co-Editors") {
                    block(above: 0.5em, name)
                  }
                )
              ],
            ),
            place(
              bottom + center,
              dx: 10mm,
              {
                image(
                  width: 25mm,
                  alt: "The SSJ logo.",
                  logo
                )
              }
            )
          )
        )
      }
    }
  )
  })
}
