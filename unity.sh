# Run a build with server mode
# NetcodeForGameObjects.app/Contents/MacOS/NetcodeForGameObjects -mlapi server -logfile -

# Run a build with client mode
# NetcodeForGameObjects.app/Contents/MacOS/NetcodeForGameObjects -mlapi client -logfile -
export UNITY='/Applications/Unity/Hub/Editor/2021.3.8f1/Unity.app/Contents/MacOS/Unity'
alias unity='eval $UNITY'
export UNITY_BUILD_PATH='/Users/butchuc/Builds/TheBuild.app'


function unity_here(){
     unity -projectPath $PWD
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

function unity_run_build(){ 
    if [ $2 ]; then
        eval "open $1 -n --args --logfile $2; tail -f $2"
    else
        eval "open $1 -n"
    fi
    
}