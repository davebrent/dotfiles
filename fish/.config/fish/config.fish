abbr --add vim "nvim"
abbr --add gs "git status --short"
abbr --add gd "git diff"
abbr --add gg "git graph"

set -x EDITOR vim
set -x VISUAL vim

set -u fish_user_paths ~/.cargo/bin ~/.local/bin

set -gx FZF_DEFAULT_COMMAND "rg --iglob '!*.gif' --iglob '!*.png' --files"
set -gx FZF_DEFAULT_OPTS "--color=light"

set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH

function s
  grep -Hrn $argv
end

function server
  python -m http.server $argv
end

function vm
  set cmd $argv[1]
  set name $argv[2]

  if test -n "$cmd" ; test -n "$name"
    if not test -n "$name"
      set cmd "start"
      set name $argv[1]
    end
  else
    set cmd "list"
  end

  set name (echo $name | sed "s/[^ _-]*/\u&/g")

  switch $cmd
    case "list"
      VBoxManage list runningvms
    case "start"
      VBoxManage startvm "$name" --type headless
    case "stop"
      VBoxManage controlvm "$name" poweroff soft
  end
end

function dirty -d "List git repos in a dirty state or with untracked files"
  for dir in (find ~/Workspace -maxdepth 2 -type d)
    pushd $dir
    set -l gitdir (git rev-parse --is-inside-work-tree 2>/dev/null)
    if test -n "$gitdir"
      set -l num (git status --porcelain | wc -l)
      if test "$num" != "0"
        set -l namespace (basename (dirname (pwd)))
        set -l repo (basename (pwd))
        echo "($num) $namespace/$repo"
      end
    end
    popd
  end
end

function fish_prompt
  set -l branch (git rev-parse --abbrev-ref HEAD 2> /dev/null)
  if test -n "$branch"
    set -l bold (set_color --bold)
    set -l normal (set_color normal)
    echo -n "($bold$branch$normal) "
  end
  printf '%s@%s %s%s%s\n$ ' \
    (whoami) \
    (hostname|cut -d . -f 1) \
    (set_color $fish_color_cwd) \
    (basename $PWD) \
    (set_color normal)
end

function fish_user_key_bindings
  fish_vi_key_bindings insert
end

function fish_mode_prompt
  # NOOP - Disable vim mode indicator
end

function fish_greeting
  uname -mrsn
  df -h --output=size,used,avail,pcent,target /home /

  set -l gits (dirty)
  if test -n "$gits"
    echo ""
    echo "Git"
    for repo in $gits
      echo "  $repo"
    end
  end
end
