The pr_nonotes and tas_nonotes folders are not kept under version control.

These folders contain about 1.5 GB of images.

You can download them here by running:

wget -nH --cut-dirs=1 --no-parent -r http://d2ow8032j7094s.cloudfront.net/20150123/index.html

They were uploaded by:

1. ruby generate-index.html
2. aws s3 sync --recursive . s3://global-calculator-tool-images/20150123 --acl=public-read

---

For future reference

These gifs have been optimised from their originals using:
gifsicle --optimize=2 --colors 256 -b *.gif

gifsicle is available from: https://github.com/kohler/gifsicle

