# purge and rebuild site
#rm -rf public
#docker run --rm -v $PWD:/data fbrx/hugo -s /data

# copy to correct repo for publishing
rm -rf ../fBrx.github.io/*
cp -rf public/* ../fBrx.github.io/

## switch to publishing repo
cd ../fBrx.github.io

# add all changes
git add -A && git status

# commit and push updated content
message="updated site content"
if [ $# -eq 1 ]
    then message="$1"
fi
git commit -m "$message" && git push
