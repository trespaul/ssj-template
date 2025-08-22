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
  bleed: 10mm,
  background: "/cover_pattern.svg",
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

  let margin = if full {bleed * 2 + 20mm} else {30mm}

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
        dx: - (full_size.width - bleed)/2,
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
    gutter: 50mm,
    {
      // back cover
      if full {
        set text(size: 16pt)
        for article in articles {
          block(
            width: 60%,
            [
              #article.title\
              #block(
                above: 0.8em,
                text(style: "italic", article.author)
              )
              #v(5mm)
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
                  logo
                )
              }
            )
          )
        )
      }
    }
  )
}
