#import "@preview/cetz:0.4.1": canvas, draw
#import draw: content, rect

#set text(
  font: (
    (name: "Arial Unicode MS", covers: regex("[\u2400-\u243f]")),
    "Hack Nerd Font Mono",
  ),
  size: 10pt,
  fallback: false,
)
#set page(width: auto, height: auto, margin: 1em)

#let covering = (
  ("col", 0, 10, blue, "0x1"),
  ("row", 5, 5, blue, "0x1"),
  ("row", 7, 7, blue, "0x1"),

  ("col", 1, 15, yellow, "0x2"),
  ("row", 4, 4, yellow, "0x2"),
  ("row", 6, 6, yellow, "0x2"),

  ("col", 1, 10, green, "     0x4"),
  ("row", 3, 3, green, "0x4"),
)

#let intersection = (
  ((1, 4), (15, 4), yellow.transparentize(85%)),
  ((1, 6), (15, 6), yellow.transparentize(85%)),
  ((0, 5), (10, 5), blue.transparentize(85%)),
  ((0, 7), (10, 7), blue.transparentize(85%)),
  ((1, 3), (10, 3), green.transparentize(85%)),
)

#canvas({
  let labels = "0123456789ABCDEF".split("").slice(1)
  let cell-size = 1. // Size of each heatmap cell
  let covering-margin = .15
  let cell-data = array
    .range(16)
    .map(i => {
      let row = i * 16
      let ctrl-symbols = "␀␁␂␃␄␅␆␇␈␉␊␋␌␍␎␏␐␑␒␓␔␕␖␗␘␙␚␛␜␝␞␟␠␡".split("").slice(1).map(i => text(i, size: 12pt))
      let row_cells = array
        .range(16)
        .map(j => {
          let code = row + j
          if code <= 32 {
            ctrl-symbols.at(code)
          } else if code == 127 {
            ctrl-symbols.at(33)
          } else if code >= 128 and code < 161 {
            ""
          } else {
            str.from-unicode(code)
          }
        })
      row_cells
    })

  for col in range(16) {
    content(
      ((col + 1) * cell-size, 0),
      labels.at(col),
      name: "col-label-" + str(col + 1),
    )
  }

  for row in range(16) {
    content(
      (0, -(row + 1) * cell-size),
      labels.at(row),
      name: "row-label-" + labels.at(row),
    )
  }

  for row in range(16) {
    for col in range(16) {
      let value = cell-data.at(row).at(col)
      rect(
        ((col + 1) * cell-size - cell-size / 2, -(row + 1) * cell-size - cell-size / 2),
        ((col + 1) * cell-size + cell-size / 2, -(row + 1) * cell-size + cell-size / 2),
        name: "cell-" + str(row) + "-" + str(col),
        stroke: .1pt + gray.lighten(60%),
      )
      content(
        ((col + 1) * cell-size, -(row + 1) * cell-size),
        value,
        name: "value-" + str(row) + "-" + str(col),
      )
    }
  }


  // frame
  rect(
    (0 + cell-size / 2, 0 - cell-size / 2),
    (16 * cell-size + cell-size / 2, -16 * cell-size - cell-size / 2),
    stroke: 1pt,
    fill: none,
  )

  for (col-or-row, start-index, end-index, color, label) in covering {
    if col-or-row == "row" {
      rect(
        (-cell-size / 2, -(start-index + 1) * cell-size + cell-size / 2 - covering-margin),
        (16 * cell-size + cell-size / 3, -(end-index + 1) * cell-size - cell-size / 2 + covering-margin),
        stroke: (dash: "dashed", join: "round", thickness: 1pt, paint: color),
      )
      if label != "" {
        content(
          (-cell-size, -(start-index + end-index + 2) * cell-size / 2),
          text(label, fill: color),
        )
      }
    }
  }
  for (col-or-row, start-index, end-index, color, label) in covering {
    if col-or-row == "col" {
      rect(
        ((start-index + 1) * cell-size - cell-size / 2 + covering-margin, cell-size / 2),
        ((end-index + 1) * cell-size + cell-size / 2 - covering-margin, -16 * cell-size - cell-size / 3),
        stroke: (dash: "dashed", join: "round", thickness: 1pt, paint: color),
      )
      if label != "" {
        content(
          ((start-index + end-index + 2) * cell-size / 2, cell-size),
          text(label, fill: color),
        )
      }
    }
  }
  for ((col-start, row-start), (col-end, row-end), color) in intersection {
    rect(
      ((col-start + 1) * cell-size - cell-size / 2, -(row-start + 1) * cell-size + cell-size / 2),
      ((col-end + 1) * cell-size + cell-size / 2, -(row-end + 1) * cell-size - cell-size / 2),
      stroke: 0pt,
      fill: color,
    )
  }
})
