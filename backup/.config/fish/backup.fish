set BACKUP_DIRS ~/Workspace ~/Pictures ~/Documents ~/.gnupg ~/.ssh ~/.aws
set BACKUP_EXCLUDE ~/.config/restic/excludes.txt
set BACKUP_VARS ~/.config/restic/variables.fish

function backup-begin
  source $BACKUP_VARS
end

function backup-end
  set -e RESTIC_REPOSITORY
  set -e RESTIC_PASSWORD_FILE
  set -e AWS_ACCESS_KEY_ID
  set -e AWS_SECRET_ACCESS_KEY
end

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
  for line in (find ~/ -type f -size +250M 2> /dev/null)
    echo "$line"
  end
end

function backup-run
  backup-begin
  mkdir -p (dirname $BACKUP_EXCLUDE)
  backup-excludes | sort | uniq > $BACKUP_EXCLUDE
  restic backup --verbose --exclude-file $BACKUP_EXCLUDE $BACKUP_DIRS
  restic check
  restic forget \
    --prune \
    --keep-daily 7 \
    --keep-weekly 8 \
    --keep-monthly 12 \
    --keep-yearly 3
  restic check
  backup-end
end

function backup-restore
  backup-begin
  restic restore latest --target $argv[1]
  backup-end
end
