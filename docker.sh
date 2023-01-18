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
}