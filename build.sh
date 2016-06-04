#!/usr/bin/bash

# number of demos
num=6

mkdir -p dist

count=1;
while [ $count -le $num ]; do
  cp -rf demo0$count dist
  echo -e "cp demo0$count succeed"
  pushd dist/demo0$count
  ../../node_modules/.bin/webpack
  popd
  echo -e "build demo0$count succeed"
  echo "============="
  count=$((count + 1))
done

./node_modules/.bin/gh-pages -d dist
echo -e "commit to gh-pages branch succeed"
rm -rf dist
echo -e "delete dist directory succeed"
