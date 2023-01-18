<<<<<<< HEAD
alias dkrls='docker container ls'
alias dkrsh='docker exec -it $CONTAINER /bin/sh'

dkr_use(){
    export CONTAINER="$1"
=======
# ------------------------------------------------------------------------------
# Convenience wrappers around docker.rb
# ------------------------------------------------------------------------------

alias dkrls="ruby $ZSHFILES/docker.rb ls"

dkrsh(){
    local cmd="ruby $ZSHFILES/docker.rb sh $1"
    eval ${cmd}
}

dkruse(){
    local cmd="ruby $ZSHFILES/docker.rb use $1"
    eval ${cmd}
>>>>>>> master
}