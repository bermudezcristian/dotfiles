#!/bin/bash
set -e

PROFILES_PATH="/Users/$USER/Library/Application Support/Firefox/Profiles"

echo "=== Configuring all Firefox profiles for user: $USER ==="
echo

# Iterate over each profile directory
for PROFILE_DIR in "$PROFILES_PATH"/*; do
    if [ -d "$PROFILE_DIR" ]; then
        PROFILE_NAME=$(basename "$PROFILE_DIR")

        # Skip profiles ending in ".default" (but not ".default-release")
        if [[ "$PROFILE_NAME" == *.default ]]; then
            echo "⚠️  Skipping profile: $PROFILE_NAME (ends with .default)"
            continue
        fi

        echo "→ Configuring profile: $PROFILE_NAME"

        # 1. Ensure 'chrome' folder exists
        CHROME_FOLDER="$PROFILE_DIR/chrome"
        mkdir -p "$CHROME_FOLDER"

        # 2. Write userChrome.css safely
        CSS_FILE="$CHROME_FOLDER/userChrome.css"
        cat > "$CSS_FILE" <<'EOF'
#TabsToolbar-customization-target {
    visibility: collapse !important;
}
#TabsToolbar {
    visibility: collapse;
}
EOF
        echo "  - userChrome.css created/overwritten"

        # 3. Update prefs.js with required prefs
        PREFS_FILE="$PROFILE_DIR/prefs.js"
        if [ ! -f "$PREFS_FILE" ]; then
            echo "  - prefs.js not found, skipping preference configuration"
            continue
        fi

        add_pref_if_missing() {
            local key="$1"
            local value="$2"
            if grep -q "$key" "$PREFS_FILE"; then
                echo "  - $key already configured"
            else
                echo "user_pref(\"$key\", $value);" >> "$PREFS_FILE"
                echo "  - Added $key"
            fi
        }

        add_pref_if_missing "toolkit.legacyUserProfileCustomizations.stylesheets" "true"
        add_pref_if_missing "font.name.serif.x-western" "\"MesloLGL Nerd Font\""
        add_pref_if_missing "font.size.variable.x-western" "12"

        echo "✓ Done with $PROFILE_NAME"
        echo
    fi
done

echo "=== All profiles configured successfully ==="
