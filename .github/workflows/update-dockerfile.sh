#!/bin/sh

run='CMD \["\/app\/bin\/server"\]'
migrate='CMD \["sh", "-c", "\/app\/bin\/migrate \& \/app\/bin\/server"\]'

sed -i "s/$run/$migrate/g" $GITHUB_WORKSPACE/Dockerfile

