make-package version:
    mkdir -p packages/preview/asciim/{{version}}
    cp lib.typ typst.toml README.md LICENSE packages/preview/asciim/{{version}}/

compile-example:
    #!/usr/bin/env sh
    for file in examples/*.typ; do
        typst compile --root $(pwd) -f png --ppi 300 $file gallery/$(basename $file .typ).png 
    done