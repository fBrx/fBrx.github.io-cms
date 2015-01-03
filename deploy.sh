rm -rvf public && hugo
cp -rvf public/* ../fBrx.github.io/
cd ../fBrx.github.io
git add -A
git status
git commit -m "updated site content"
git push
