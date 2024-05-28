#!/bin/bash

mkdir -p docs/

for target in "$@"
do
    echo "Generating docs for $target"
    swift package --allow-writing-to-directory "$target-docs" generate-documentation --disable-indexing --transform-for-static-hosting --hosting-base-path tidal-sdk-ios --output-path "$target-docs" --target "$target"
    cp -r $target-docs/* docs/
    modified_target=$(echo $target | tr '-' '_' | tr '[:upper:]' '[:lower:]')
    cp -r $target-docs/index/index.json "docs/index/$modified_target.json"
done

echo "<!DOCTYPE html><html><head><meta http-equiv=\"refresh\" content=\"0; url=/tidal-sdk-ios/documentation/\" /></head><body><ol>" > docs/index.html

for target in "$@"
do
    cp -R $target-docs/data/documentation/* docs/data/documentation/
    cp -R $target-docs/documentation/* docs/documentation/
    rm -r "$target-docs"
    modified_target=$(echo $target | tr '-' '_' | tr '[:upper:]' '[:lower:]')
    echo "<li><a href=\"/tidal-sdk-ios/documentation/$modified_target/\">$target</a></li>" >> docs/index.html
done

echo "</ol></body></html>" >> docs/index.html

custom_javascript="window.location.pathname.split('documentation/')[1].split('/')[0]"
file_to_modify=$(ls docs/js/documentation-topic\~topic\~tutorials-overview.*.js)

sed  -i '' 's/"index.json"/window.location.pathname.split("documentation\/")[1].split("\/")[0]+".json"/g' $file_to_modify
echo "Modified $file_to_modify"

cp Scripts/landing.html docs/documentation/index.html
cp Scripts/Resources/tidal-logo-white.png docs/documentation/tidal-logo-white.png