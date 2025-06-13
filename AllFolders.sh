#!/bin/sh

# -------------------------
# Script: create_shots.sh
# Purpose: Create shot directories with subfolders for EDIT, Blender, and Nuke
# -------------------------

set -euo pipefail
IFS=$'\n\t'

# -------------------------
# 1) Argument validation check
# -------------------------
if [ "$#" -ne 1 ]; then
    cat <<EOF
Usage: $0 <Number of shots to create>
This number is zero-based - '1' will create 'sh000'.
EOF
    exit 1
fi

shots="$1"

# -------------------------
# 2) Validate that shots is a non-negative integer
# -------------------------
if ! [[ "$shots" =~ ^[0-9]+$ ]]; then
  >&2 echo "Error: shots must be a non-negative integer"
  exit 1
fi
shots=$((shots))


# -------------------------
# 3) Create top-level EDIT directories
# -------------------------
mkdir -p EDIT/{Footage,EXPORTS,Resolve,Thumbnail}

# -------------------------
# 4) Loop to create shot directories
# -------------------------
for (( i=0; i<shots; i++ )); do
    # Generate zero-padded shot directory name
    shot_dir=$(printf "sh%03d" "$i")

    # Arrays for subfolder lists
    blender_subs=(Geo Scenes Renders Sims CameraTracks Textures)
    nuke_subs=(Live_Action Comps Scripts Precomps)

    # Create Blender subfolders
    for sub in "${blender_subs[@]}"; do
        mkdir -p "$shot_dir/Blender/$sub"
    done

    # Create Nuke subfolders
    for sub in "${nuke_subs[@]}"; do
        mkdir -p "$shot_dir/Nuke/$sub"
    done

done

# -------------------------
# 5) Completion message
# -------------------------
# Emoji requires UTF-8 locale and may not render correctly in plain /bin/sh environments
# You can remove the emoji for maximum compatibility:
# echo "Created $shots shot folder(s) successfully."
echo "✅ Created $shots shot folder(s) successfully."
