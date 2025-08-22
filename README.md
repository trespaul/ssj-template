# Typst Template for the Stellenbosch Socratic Journal

This is a [Typst](https://typst.app) template used to generate the Stellenbosch Socratic Journal of the Stellenbosch University Philosophy Department.

I created the design in 2022, using Microsoft Word for accessibility by future editorial teams. But even though Microsoft Word is easy to use, getting a consistent result is hard for someone who is not experienced with the details of design.

This template allows future teams to generate the document and get the format exactly right.

## Usage

### Importing and setting up the template

Either on your computer or using the Typst web-app, place the template, which is the folder that this document is in, in your project folder. In your project folder, create a Typst file called `main.typ`, and place the following contents in it:

```typ
#import "template/main.typ": meta

#show: doc => meta(
  journal: "Stellenbosch Socratic Journal",
  volume: "Volume 5",
  date: datetime(year: 2025, month: 10, day: 31),

  document_title: "SSJ Vol. 5, 2025",
  // logo: "/assets/logo.svg", // OPTIONAL: if not specified, the default logo will be used

  author: "Stellenbosch Socratic Society",
  institution: "Stellenbosch University",

  // see below for format
  // colophon: [], // OPTIONAL: default will be used if none provided

  editorial_team: (
    "Editor-in-Chief": ("NAME HERE",),
    "Co-Editors": (
      "NAME 1 HERE",
      "NAME 2 HERE",
      // ...
    ),
    "Designer": ("Paul Joubert",),
  ),

  // to exclude reviewers list, simply delete these two items
  reviewers_message: "We would like to thank the peer-reviewers who made this volume possible, including:",
  reviewers: (
    "NAME 1 HERE",
    "NAME 2 HERE",
  ),

  // this file defines the Harvard Stellenbosch style
  // csl: "/assets/harvard-stellenbosch-university.csl", // OPTIONAL: the file is used by default, update to change the style

  foreword: (
    author: "EDITOR-IN-CHIEF NAME HERE",
    title: "Foreword",
    file: "/articles/foreword.md",
  ),

  articles: (
    ( short: "ONE WORD SHORT IDENTIFIER", // used to distinguish bibliographies
      file: "/articles/FOLDER/article.md",
      abstract: "/articles/FOLDER/abstract.md",
      bibliography: "/articles/FOLDER/bib.yaml", // see below for file format
      title: "ARTICLE TITLE",
      short_title: "SHORT TITLE", // OPTIONAL: leave out to use first part of title before colon
      author: "AUTHOR NAME",
      about: "AUTHOR BIO",
    ),
    // ...
  )
)
```

Customise the content as necessary (see the following sections for information about how to do so).

### Compiling the document

If you're running Typst on your computer, run the following command to produce a PDF ready to upload (i.e., it includes the A4 cover):

```bash
typst compile main.typ "SSJ vol. X.pdf"
```

If you're using the web app, the document will be automatically rendered, and you can download it using the buttons above the preview.

To produce PDFs of the individual articles, tell the command which pages they are on (these are the PDF pages, not the page numbers printed on the page, e.g., p. iii is PDF page 3, and p. 1 is PDF page 9, depending on how many pages there are before the first article).

```bash
typst compile main.typ --pages "1-8" "Frontmatter.pdf"
typst compile main.typ --pages "9-16" "Article 1.pdf"
# etc.
```

To produce a PDF without the A4 cover added, for sending to the printers, set the option on the command line:

```bash
typst compile main.typ --input cover=none "SSJ vol. X - no cover.pdf"
```

You will then also want to generate the wrap-around cover to send to the printers separately:

```bash
typst compile main.typ --input cover=full "SSJ vol. X - cover.pdf"
```

Tell the printers this cover has a 10 mm bleed (this is extra space that they can cut off so that the picture fills the entire page).

### Documents in Typst or Markdown format

In the `main.typ` file, where values are in square brackets (such as the colophon setting), and in the article documents, content can be written with Typst markup. See the [Typst Tutorial](https://typst.app/docs/tutorial/) for more information.

The articles can be in either Typst or Markdown format. For more about Markdown, see the [CommonMark specification](https://spec.commonmark.org/current/).

The files necessary for each article are referenced in the `articles` part of the setup in your `main.typ` file. I suggest putting them in a folder called `articles` and giving each article its own subfolder.

### Bibliography files

The bibliography files can be either BibTex/BibLaTex files, which can be exported from a reference manager such as Zotero, or written by hand in Typst's own [Hayagriva format](https://github.com/typst/hayagriva/blob/main/docs/file-format.md).

The entire contents of the bibliography files will be rendered in each article's Reference section. This is because I have decided it would be too much effort to rewrite each citation in Typst's format, and I have thus not tried either. Typst actually does not currently support multiple different bibliographies, so I'm using a third-party package which adds this functionality. Ideally, each citation would link to its reference in the bibliography.

### Font

The font used is Brill, by Brill Publishing, which is free for non-commercial use. Before rendering the document, install the font files [available on Brill's website](https://brill.com/fileasset/The_Brill_Typeface_Package_v_4_0.zip).

### Cover pattern

To create a cover pattern, you need an SVG file (although this would work with other formats too) that is big enough to cover the full wrap-around cover. For the default bleed and spine width settings (which are added to the final size, which is A3), this is 442 × 317 mm. You can use the free SVG editor [Inkscape](https://inkscape.org/) to create this document. An example SVG of the right size is included as a default cover, in the `assets` folder.
