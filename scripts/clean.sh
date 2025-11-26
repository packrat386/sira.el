#!/usr/bin/env bash

find out/ -mindepth 1 -maxdepth 1 -not -name .gitkeep -exec rm -rf {} \;
