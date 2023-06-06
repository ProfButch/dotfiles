# ------------------------------------------------------------------------------
# /Users/butchwesley/Library/Application Support/Godot/editor_settings-3.tres
#		lines that start with "projects/::" are the lines that define what shows
#   up when you launch gut.
# ------------------------------------------------------------------------------
export GODOT='/Applications/Godot.app/Contents/MacOS/Godot'
export GODOT_USER_DIR=~/Library/Application\ Support/Godot/app_userdata
export GODOT_EDITOR_DIR=~/Library/ApplicatioN\ Support/Godot/


alias ngodot='open -n $GODOT'
alias cpgut_here='cp -r $GUT/addons/gut/* ./addons/gut/'
alias cpbitools_here='cp -r $BITOOLS/addons/bitools/* ./addons/bitools/'


# ------------------------------------------------------------------------------
# Pixel stuff
# ------------------------------------------------------------------------------
alias adb='/Users/butchwesley/Library/Android/sdk/platform-tools/adb'
func connect_pixel(){
  adb devices
  #adb tcpip 5555 (adb -s FA7B41A00312 tcpip 5555)
  adb connect 192.168.1.115
}
alias disconnect_pixel='adb usb'


# ------------------------------------------------------------------------------
# Godot version switching
# ------------------------------------------------------------------------------
function _swith_to_godot_version(){
  app=$1
  export GODOT="/Applications/${app}/Contents/MacOS/Godot"
  godot --version
  echo $GODOT
}


dot_it godot_tools
