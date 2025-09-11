#!/usr/bin/env bash

set -e

outdir="../../src/assets/icons"
echo "copying SVGs to $outdir"
cp *.svg "$outdir/"

echo "creating icons to $outdir..."
cairosvg "bashly-icon-arrow.svg" \
  -o "$outdir/bashly-icon-arrow-96.png" \
  --output-width 96 \
  --background white

for size in 180 192 512; do
  cairosvg "bashly-icon-square.svg" \
    -o "$outdir/bashly-icon-square-${size}.png" \
    --output-width $size \
    --background white
done

for size in 192 512; do
  cairosvg "bashly-icon-square-maskable.svg" \
    -o "$outdir/bashly-icon-square-maskable-${size}.png" \
    --output-width $size \
    --background white
done
echo "done"
