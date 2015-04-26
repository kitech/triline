#!/bin/sh


gem sources --remove https://rubygems.org/
gem sources -a http://ruby.taobao.org/
gem sources -l # 请确保只有 ruby.taobao.org
# gem install foo
