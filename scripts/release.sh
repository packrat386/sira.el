#!/usr/bin/env bash

name="sira"
desc="Utilities for bible passages"
version="$(date -u +%Y%m%d.%_H%M | sed 's/ //g')"

pkgdir="out/${name}-${version}"

mkdir -p $pkgdir

find src/ -mindepth 1 -maxdepth 1 -name '*.el' -exec cp {} $pkgdir \;
cp -R src/data $pkgdir

pkgfile="${pkgdir}/${name}-pkg.el"
printf ';; -*- no-byte-compile: t; lexical-binding: nil -*-\n' >>$pkgfile
printf '(define-package "%s" "%s" "%s")' "${name}" "${version}" "${desc}" >>$pkgfile

COPYFILE_DISABLE=true tar cvf "${pkgdir}.tar" -C out/ "$(basename $pkgdir)"

printf "RELEASE COMPLETE\ninstall with:\nemacs --batch --eval '(package-install-file \"%s\")'\n" "${pkgdir}.tar"
