#!/bin/zsh
say_set_name(){
  alias say="say -v '$*' "
}

say_show_names() {
  say -v '?'
}

alias cpwd='pwd | pbcopy;pwd'
export IOS_SIMULATORS="/Users/butchwesley/Library/Developer/CoreSimulator/Devices/"


my_diff(){
  sdiff -w200 -lbWBs "$1" "$2"
}

alias unsecure_chrome='open -n -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --args --user-data-dir="/tmp/chrome_dev_test" --disable-web-security'