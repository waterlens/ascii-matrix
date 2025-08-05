make-package:
    cp lib.typ typst.toml README.md LICENSE package

compile-example:
    #!/usr/bin/env sh
    for file in examples/*.typ; do
        typst compile --root $(pwd) -f png --ppi 300 $file gallery/$(basename $file .typ).png 
    done