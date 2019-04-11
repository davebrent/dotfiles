source ~/.config/fish/backup.fish

abbr --add vim "nvim"
abbr --add gs "git status --short"
abbr --add gd "git diff"
abbr --add gg "git graph"

set -x EDITOR vim
set -x VISUAL vim

set -u fish_user_paths ~/.cargo/bin

function s
  grep -Hrn $argv
end

function server
  python -m http.server $argv
end

function vpn-start
  sudo systemctl start wg-quick@wg0
end

function vpn-stop
  sudo systemctl stop wg-quick@wg0
end

function myip
  curl ifconfig.co
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

function reviewboard
  rbt post -g yes \
    --branch (git rev-parse --abbrev-ref HEAD) \
    --bugs-closed (git log -1 | sed -En 's/\s*Jira:\s*DEV-(.*)/DEV-\1/p') \
    --target-groups tech \
    --parent develop \
    --tracking-branch origin/develop \
    --repository (git config --get remote.origin.url)
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

  echo ""
  set -l backup (date --date=(cat $BACKUP_LASTBACKUP))
  echo "Last backup"
  echo "  $backup"

  set -l outdated (pacman -Qu | wc -l)
  set -l installed (pacman -Qe | wc -l)
  echo ""
  echo "Pacman"
  echo "  $installed Packages explicitly installed."
  echo "  $outdated Packages can be updated."

  set -l vms (vm)
  if test -n "$vms"
    echo ""
    echo "Virtualbox" 
    for val in $vms
      set -l name (echo $val | cut -d ' ' -f 1 | tr -d '"')
      echo "  $name"
    end
  end

  set -l tmuxs (tmux ls -F '#S #H #T')
  if test -n "$tmuxs"
    echo ""
    echo "Tmux sessions"
    for val in $tmuxs
      echo "  $val"
    end
  end

  set -l gits (dirty)
  if test -n "$gits"
    echo ""
    echo "Git"
    for repo in $gits
      echo "  $repo"
    end
  end
end
