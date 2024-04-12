#!/bin/bash

set -eu

export PATH=/bin:/usr/bin

ROOT=$(cd $(dirname $0)/.. && pwd)
TEMPLATES_DIR="$ROOT/scripts/xcode_templates"
XCODE_TEMPLATES_DIR="$HOME/Library/Developer/Xcode/Templates/app.ukitaka-lab"

echo "Installing xcode templates ..."

mkdir -p $XCODE_TEMPLATES_DIR

for template in "$TEMPLATES_DIR/*.xctemplate"; do
    template_file=$(echo $template)
    template_name=$(basename $template_file)
    ln -svf $template $XCODE_TEMPLATES_DIR
done

echo "Done"
