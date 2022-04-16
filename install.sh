#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# install homebrew deps
brew bundle --file=- <<EOF
brew 'imagemagick'
EOF

# symlink heif-convert if needed
if ! command -v heif-convert &> /dev/null
then
    ln -s "$(brew --prefix libheif)/bin/heif-convert" /opt/homebrew/bin/heif-convert
fi

LAUNCH_LABEL="com.xiantrimble.convert-portrait-mode"
LAUNCH_FILE="$HOME/Library/LaunchAgents/$LAUNCH_LABEL.plist"

# data directories
DATA_ROOT="$HOME/Library/Application Support/$LAUNCH_LABEL"
DROP_FOLDER="$DATA_ROOT/PortraitDropBox"
CONVERTED_FOLDER="$DATA_ROOT/Converted"
ORIGINALS_FOLDER="$DATA_ROOT/Originals"

mkdir -p "$DROP_FOLDER"
mkdir -p "$CONVERTED_FOLDER"
mkdir -p "$ORIGINALS_FOLDER"

# drop folder processor
PROCESSOR="$SCRIPT_DIR/bin/process-portrait-mode-drop-folder"

touch "$LAUNCH_FILE";
tee "$LAUNCH_FILE" <<EOF > /dev/null
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>$LAUNCH_LABEL</string>
  <key>ProgramArguments</key>
  <array>
    <string>$PROCESSOR</string>
    <string>$DROP_FOLDER</string>
    <string>$CONVERTED_FOLDER</string>
    <string>$ORIGINALS_FOLDER</string>
  </array>
  <key>WatchPaths</key>
  <array>
    <string>$DROP_FOLDER</string>
  </array>
</dict>
</plist>
EOF

tee "$SCRIPT_DIR/test.sh" <<"EOF" > /dev/null
#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

sudo -b launchctl debug gui/501/com.xiantrimble.convert-portrait-mode  --stdout --stderr
pushd "$SCRIPT_DIR/test-images/" > /dev/null
cp * "$HOME/Library/Application Support/com.xiantrimble.convert-portrait-mode/PortraitDropBox"
popd  > /dev/null
EOF

# Share the dropbox over samba
echo "creating shares..."
sudo sharing -r PortraitDropBox
sudo sharing -a "$DROP_FOLDER" -S PortraitDropBox -g 001

# Put aliases to the the converted files and drop box on the desktop
echo "creating desktop aliases..."
ln -sfh "$DROP_FOLDER" "$HOME/Desktop/PortraitDropBox"
ln -sfh "$CONVERTED_FOLDER" "$HOME/Desktop/HoloPlayStudio Images"