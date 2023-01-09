alias dkrls='docker container ls'
alias dkrsh='docker exec -it $CONTAINER /bin/sh'

dkr_use(){
    export CONTAINER="$1"
}