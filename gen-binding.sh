#!/bin/bash

[ -z "$GCC_INCLUDE" ] && GCC_INCLUDE=$(gcc -Wp,-v -xc /dev/null -fsyntax-only 2>&1 | grep '#include <...> search starts here:' -A1 | tail -1 | awk '{$1=$1};1')

if [ ! -d "$GCC_INCLUDE" ]; then
    >&2 echo "GCC_INCLUDE is not a directory: $GCC_INCLUDE"
    exit 1
fi

[ -z "$WASMER_INCLUDE" ] && WASMER_INCLUDE=$(dirname $(find /usr -name wasmer.h 2>/dev/null | tail -1))

if [ ! -d "$WASMER_INCLUDE" ]; then
    >&2 echo "WASMER_INCLUDE is not a directory: $WASMER_INCLUDE"
    exit 1
fi

dub run dpp -- --preprocess-only --no-sys-headers --ignore-macros --scoped-enums --include-path "$GCC_INCLUDE" --include-path "$WASMER_INCLUDE" source/wasmer/bindings/cwasmer.dpp
sed -i '/^[[:space:]]*$/d' source/wasmer/bindings/cwasmer.d