#!/usr/bin/env bash

DEST="$HOME/backups"
KEEP=7
STAMP=$(date +%Y-%m-%d_%H%M)
SOURCES=("$HOME/weather-notifier" "$HOME/health-checker")

mkdir -p "$DEST"

for DIR in "${SOURCES[@]}"; do
  if [ ! -d "$DIR" ]; then
    echo "Skipping $DIR (not found)"
    continue
  fi

  NAME=$(basename "$DIR")
  FILE="$DEST/$NAME-$STAMP.tar.gz"
  tar -czf "$FILE" -C "$(dirname "$DIR")" "$NAME"
  echo "Backed up $NAME -> $FILE"

  ls -t "$DEST/$NAME"-*.tar.gz | tail -n +$((KEEP + 1)) | xargs -r rm --
done

mkdir -p "$HOME/storage/shared/Backups"
cp "$DEST"/*-"$STAMP".tar.gz "$HOME/storage/shared/Backups/"
termux-notification --title "Backup done" --content "Backed up ${#SOURCES[@]} projects"
