# Functions for making ad-hoc backups to Glacier
#
# TODO:
#   * Ignore empty lines in .backupignore
#   * Encrypt gpg
#   * Multi-part upload

function backup-name
  # Generate a time tagged name for a backup
  echo -n (date '+%F')-$argv[1].tgz
end

function backup-exclude
  # Return a list of patterns that should be excluded from a backup.
  for file in (find ~/ -type f -name .backupignore)
    set -l basepath (dirname $file)
    for line in (cat $file)
      switch $line
        case "./*"
          set line (realpath $basepath/$line)
      end
      echo "--exclude=$line"
    end
  end
end

function backup-pack
  # Pack a directory
  set -l file $argv[1]
  set -l dir $argv[2]
  tar (backup-exclude) --exclude='.backupignore' -zcvf ~/backups/$file $dir
end

function backup-upload
  # Upload a backup to Glacier
  set -l file $argv[1]
  aws glacier upload-archive \
    --profile backup \
    --account-id - \
    --vault-name backups \
    --body ~/backups/$file >> ~/backups/completed
end

function backup
  set -l tag $argv[1]
  set -l dir $argv[2]
  set -l file (backup-name $tag)
  backup-pack $file $dir
  backup-upload $file
end
