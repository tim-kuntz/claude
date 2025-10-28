#!/usr/bin/env bash

# Define source and destination directories
SRC_DIR="./skills"
DEST_DIR="$HOME/.claude/skills"

# Create destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Iterate over each directory in ./skills/
for dir in "$SRC_DIR"/*/; do
  # Get the directory name without path
  name=$(basename "$dir")
  
  # Create the symlink in ~/.claude/skills/
  ln -sfn "$(realpath "$dir")" "$DEST_DIR/$name"
  
  echo "Linked: $DEST_DIR/$name -> $(realpath "$dir")"
done
