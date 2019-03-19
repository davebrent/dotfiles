set BACKUP_DIRS    ~/Workspace ~/Pictures ~/Documents
set BACKUP_EXCLUDE ~/.config/restic/excludes.txt

set -g -x RESTIC_REPOSITORY ~/.local/share/restic
set -g -x RESTIC_PASSWORD_FILE ~/Workspace/davebrent/secrets/restic/password.txt

function backup-excludes
  for file in (find ~/ -type f -name .backupignore)
    set -l basepath (dirname $file)
    for line in (cat $file)
      switch $line
        case "./*"
          set line (realpath $basepath/$line)
      end
      echo "$line"
    end
  end
end

function backup-run
  backup-excludes | sort | uniq > $BACKUP_EXCLUDE
  restic backup --exclude-file $BACKUP_EXCLUDE $BACKUP_DIRS
  restic check --read-data
end
