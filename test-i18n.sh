#!/usr/bin/env bash

bash package/translate/merge
bash package/translate/build

LANGUAGE='ja_JP'
LANG='ja_JP.UTF-8'

plasmoidviewer -a 'xyz.attacktive.nyan-wanderer'
