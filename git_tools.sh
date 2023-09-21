#!/bin/bash
git config --global pager.branch false

export GIT_EXTERNAL_DIFF=$ZSHFILES/bin/git_external_diff

alias gitcod='git checkout .'
alias gpo='git push origin HEAD'
alias gitkey='eval "$(ssh-agent -s)";ssh-add ~/.ssh/git_rsa'

alias hide_git='git config oh-my-zsh.hide-info 1'
alias show_git='git config oh-my-zsh.hide-info 0'
alias git_temp_here='export GIT_TEMP_DIRECTORY=`pwd`;echo $GIT_TEMP_DIRECTORY'

#----------------------
#git
#----------------------
alias gitinfo='
echo "Remotes";
echo "-------";
git remote -v;
echo
echo "Branches";
echo "-------";
git branch;
echo
echo "Status"
echo "-------";
git status'

func branch_file(){
  local branch_name=$1
  local file_name=$2

  eval "git show ${branch_name}:${file_name} > ${file_name}"
}


# Opens the github page for the current git repository in your browser
# git@github.com:jasonneylon/dotfiles.git
# https://github.com/jasonneylon/dotfiles/
function gh() {
  local remote='origin'
  if [ $1 ]; then
    remote=$1
  fi

  giturl=$(git config --get remote.$remote.url)
  echo $giturl
  if [[ "$giturl" == "" ]]
    then
     echo "Not a git repository or no remote.origin.url set"
     return 1;
  fi

  giturl=${giturl/git\@github\.com\:/https://github.com/}
  giturl=${giturl/git\@github\.build\.ge\.com\:/https://github\.build\.ge\.com/}
  giturl=${giturl/\.git/\/tree/}
  branch="$(git symbolic-ref HEAD 2>/dev/null)" ||
  branch="(unnamed branch)"     # detached HEAD
  branch=${branch##refs/heads/}
  giturl=$giturl$branch

  `open $giturl`
}

function gh_new_issue(){
  giturl=$(git config --get remote.origin.url)
  giturl=${giturl/\.git/\/issues\/new/}
  `open $giturl`
}

function gh_issues(){
  giturl=$(git config --get remote.origin.url)
  giturl=${giturl/\.git/\/issues/}
  `open $giturl`

}

function origin_to_upstream(){
  `git remote remove upstream`
  `git remote rename origin upstream`
  `git remote add origin $1`
  echo `git remote -v`
}

function upstream_to_origin(){
  `git remote remove origin`
  `git remote rename upstream origin`
  echo `git remote -v`
}

function master_diff(){
  local file=''

  if [[ $1 ]]; then
    file=`find ./ -iname "$1"`
    match_count=`find ./ -iname "$1" | wc -l`
    echo $match_count
    if [ "$match_count" -eq "1" ]; then
      git diff master $file
    else
      git diff master "*$1*"
    fi
  else
    git diff master
  fi

}


func clone_repo_as_username(){
    local repo=$1
    local dest=$PWD
    if [ $2 ]; then
      dest=$2
    fi

    local username=$(echo $repo | cut -d/ -f4 )
    # local reponame=$(echo $repo | cut -d/ -f5 | cut -d. -f1)
    # $clone_to must not be local.  It is used outside of this method.
    # See clone_and_symlink_unity_repo
    clone_to=$dest/$username

    echo "Cloning $repo to $dest"
    echo $username

    mkdir -p $dest
    git clone $repo $clone_to
}


function clone_repo_to_temp_as_username(){
  local repo=$1
  if [ ! $1 ];then
    echo "Enter URL"
    read repo
  fi

  clone_repo_as_username $repo $GIT_TEMP_DIRECTORY
}


function run_on_all_git_dirs(){
  local did_change=false
  for dir in $PWD/*;
  do
    if [ -d "$dir" ]; then
      cd $dir
      did_change=true

      # make sure current directory is a git directory
      if git rev-parse --git-dir > /dev/null 2>&1; then
        echo "----  $dir  ----"
        eval $1
      fi
    fi
  done

  if [ "$did_change" = true ]; then
    cd ..
  else
    echo "No directories found"
  fi
}


function git_default_branch(){
  git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'
}


# commit_before_date '2023-9-18 21:59:00'
# Seems to have odd behavior if you do not specify h:m.  It was finding a commit
# at around 7:00 am when there was a commit at 6:00 and 22:58 if the time was
# left off.  So either use 21:59:00 or 0:01:00 of the NEXT day.
#
# Check results with something like:
#     git rev-list -n 10 --date-order --pretty='  %ci %h' main
function commit_before_date(){
    local date=$1

    local branch='change this'
    if [ $2 ];then
      branch=$2
    else
      branch=$(git_default_branch)
    fi

  git rev-list -n 1 --first-parent --before=\"$date\" $branch\
}


# https://stackoverflow.com/questions/6990484/how-to-checkout-in-git-by-date
function checkout_before_date(){
    #git checkout `git rev-list -n 1 --first-parent --before="2009-07-27 13:37" master`
    local cmd="git -c advice.detachedHead=false checkout $(commit_before_date $1 $2)"
    # echo $cmd
    eval $cmd

    git_show_hash_in_history
}


function checkout_all_before_date(){
  run_on_all_git_dirs "checkout_before_date '$1' '$2'"
}


function checkout_all_default_branch(){
  run_on_all_git_dirs 'git checkout $(git_default_branch)'
}


function git_list_commits_by_date(){
  git rev-list --date-order --pretty='  %ci    %h' $(git_default_branch)
}


function git_show_hash_in_history(){
    local default_hash=`git rev-parse $(git_default_branch)`
    local cur_hash=`git rev-parse HEAD`
    if [ "$default_hash" = "$cur_hash" ]; then
      echo "Same as $(git_default_branch)"
    else
      git_list_commits_by_date | grep -n --color -E -B 4 -A 5 "$cur_hash"
    fi;
}