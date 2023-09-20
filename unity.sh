export UNITY='NOT SET YET, call switch_unity_version or switch_unity_to_project_version'
export UNITY_BUILD_PATH=~/temp/unity_builds/TheBuild.app

alias unity='eval $UNITY'
alias unity_list_installs='ls -1 /Applications/Unity/Hub/Editor/'
alias unity_print_project_version="cat ProjectSettings/ProjectVersion.txt | grep 'm_EditorVersion:'"
# export UNITY_PACKAGE_CACHE='/Users/butchuc/unity/common_library/PackageCache'


function switch_unity_version(){
    app=$1
    export UNITY="/Applications/Unity/Hub/Editor/${app}/Unity.app/Contents/MacOS/Unity"
    # pass in anything as 2nd paramter to make it not print
    # out the unity info.  this is so we don't get output
    # when loading up the profile.
    if [ ! $2 ];then
        echo $UNITY
        unity --version
    fi
}

function switch_unity_to_project_version(){
    version=`unity_print_project_version | sed "s/m_EditorVersion://" | xargs`
    echo "Project version = $version"
    installed=`unity_list_installs`
    if [[ "$installed" == *"$version"* ]]; then
        echo "Switching"
        switch_unity_version $version
    else
        echo "$version is not installed.  Installed versions:"
        echo $installed
    fi
}


# I could never quite get this to work.  I opted to use environment variables
# instead, but kept it around for reference.
function iterm_var(){
    echo "Setting $1 = $2"
    printf "\033]1337;SetUserVar=%s=%s\007" $1 `echo -n $2 | base64`
}


function unity_here(){
     unity -projectPath $PWD
}

function unity_here_project_version(){
    switch_unity_to_project_version
    unity_here
}


function unity_build(){
    echo "Building to $UNITY_BUILD_PATH"
    echo "  Removing existing build."
    rm -r $UNITY_BUILD_PATH
    echo "  Building..."
    unity -quit -batchmode -projectPath $PWD -buildOSXUniversalPlayer $UNITY_BUILD_PATH -logfile -
    echo "-- Build finished --"
}

function unity_build_then_edit(){
    unity_build
    unity_here
}

function unity_build_run_edit(){
    unity_build
    open $UNITY_BUILD_PATH
    unity_here
}

function unity_clear_package_cache(){
    fnd PackageCache | xargs ls
    fnd PackageCache | xargs rm -r
}

# Note, when using open you cannot tell unity to log to the console since open
# spawns the process and doesn't remain connected.  So this will kick off a tail.
# open is used so that we don't have to know the path to the executable in the
# .app folder.  I'm sure there is a way to figure that out dynamically but this
# works fine.
function unity_run_build(){
    local screen_options="-screen-height 600 -screen-width 800 -screen-fullscreen 0";
    if [ $2 ]; then
        eval "touch $2; open $1 -n --args --logfile $2 $screen_options; tail -f $2"
    else
        eval "open $1 -n --args $screen_options"
    fi
}


function unity_run_x_builds(){
    python3 $ZSHFILES/iterm2_run_in_panes.py "cd ~/temp/unity_builds/;unity_run_build $UNITY_BUILD_PATH log_pane_<x>.txt" $1
}


# To be called from, or passed, the base of a Unity project.  This will check
# for ./Library and ./Library/PackageCache.  If PackageCache does not exist
# then it will be created as a symlink.
function unity_symlink_package_cache(){
    local proj_path=$PWD
    if [ $1 ]; then
       proj_path=$1
    fi

    local library_path="$proj_path/Library"
    local cache_path="$proj_path/Library/PackageCache"

    if [ ! -d $library_path ]; then
        echo "creating $library_path"
        `mkdir $library_path`
    else
        echo "$library_path already exists"
    fi

    if [ ! -d $cache_path ]; then
        echo "symlinking $cache_path -> $UNITY_PACKAGE_CACHE"
        ln -s $UNITY_PACKAGE_CACHE $cache_path
    else
        echo "$cache_path already exists"
        if test -L $cache_path; then
            echo "  - is a symlink"
        else
            echo "  - is NOT a symlink"
        fi
    fi
}

# Clones a url to GIT_TEMP_DIRECTORY as the username in the url
# This then creates a symlink for Library/PackageCache inside
# the cloned directory.
function clone_and_symlink_unity_repo() {
    # this creates and populates $clone_to
    clone_repo_to_temp_as_username $1
    unity_symlink_package_cache $clone_to
}