#!/usr/bin/env zsh

# Function to check for Adobe AIR-related dylibs in .app bundles
check_for_air_dylibs(){
    app_bundle="$1"
    # Check for Adobe AIR dylibs in the app bundle
    if [ -d "$app_bundle" ]; then
        # Use otool to check for linked libraries
        linked_libs=$(otool -L "$app_bundle/Contents/MacOS/"* 2>/dev/null | grep -i "adobeair\|core")
        if [ ! -z "$linked_libs" ]; then
            echo "Adobe AIR related libraries found in: $app_bundle"
            echo "$linked_libs"
        fi
    fi
}

# Main script execution
echo "=== Adobe AIR Application Detection Script (Dylibs) ==="

# Search for applications in the /Applications directory
find /Applications -iname "*.app" | while read -r app; do
    check_for_air_dylibs "$app"
done

echo "=== Detection Complete ==="
