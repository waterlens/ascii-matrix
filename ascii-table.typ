#set page(margin: 1cm)
#set text(
  font: (
    (name: "Arial Unicode MS", covers: regex("[\u2400-\u243f]")),
    "Hack Nerd Font Mono",
  ),
  size: 10pt,
  fallback: false,
)



#let ascii_table() = {
  let col-num = 16
  let row-num = 16
  let rows = array.range(row-num)
  let cols = array.range(col-num)

  let col_label = for i in range(16) {
    let t = if i < 10 { str(i) } else {
      let hex = ("A", "B", "C", "D", "E", "F")
      hex.at(i - 10)
    }
    (t,)
  }
  let ctrl_symbols = (
    "␀",
    "␁",
    "␂",
    "␃",
    "␄",
    "␅",
    "␆",
    "␇",
    "␈",
    "␉",
    "␊",
    "␋",
    "␌",
    "␍",
    "␎",
    "␏",
    "␐",
    "␑",
    "␒",
    "␓",
    "␔",
    "␕",
    "␖",
    "␗",
    "␘",
    "␙",
    "␚",
    "␛",
    "␜",
    "␝",
    "␞",
    "␟",
    // 32
    "␠",
    // 127
    "␡",
  ).map(i => text(i, size: 12pt))
  let table_cells = (
    box(width: 1.2em, height: 1em)[H\\L],
    col_label,
    rows.map(i => {
      let row = i * 16
      let row_label = if i < 10 { str(i) } else {
        let hex = ("A", "B", "C", "D", "E", "F")
        hex.at(i - 10)
      }
      let row_cells = (
        row_label,
        ..cols.map(j => {
          let code = row + j
          let char_repr = if code <= 32 {
            ctrl_symbols.at(code)
          } else if code == 127 {
            ctrl_symbols.at(33)
          } else if code >= 128 and code < 161 {
            ""
          } else {
            str.from-unicode(code)
          }
          char_repr
        }),
      )
      row_cells
    }),
  )
  table(
    columns: 17,
    stroke: 0pt,
    gutter: 1pt,
    fill: (row, col) => if col == 0 or row == 0 { rgb("#d6d6d6") } else { white },
    align: center + horizon,
    ..table_cells.flatten(),
  )
}



#align(center)[#ascii_table()]
