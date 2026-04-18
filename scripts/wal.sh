# Expand tilde if Waypaper sends it
WALL_PATH="${1/#\~/$HOME}"

# Run pywal/wallust
wal -i "$WALL_PATH"
