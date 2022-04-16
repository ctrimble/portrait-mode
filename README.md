# Portriat Mode

This is a small project to help convert *.heic image files produced by iPhone portrait mode to RGBD jpegs,
so that they can be used in HolloPlayStudio.

The basics of what this project provides:
1. A script for converting *.heic images to RGBD jpegs.
2. An installer that sets up an SMB drop box for processing
   portrait mode photos coming from iPhone.

## Install

This project requires Homebrew to do the setup.

To get this running, clone the repository and execute:

```
install.sh
```

Once complete, you will have an SMB share named 
`PortriatDropBox`.  Whenever *.heic files are placed in this box,
they will be converted into .jpg files compatible with the RGBD
import feature of HoloPlayStudio.  The output directory is
symlinked to the desktop as `HoloPlayStudio Images`.

## Develpment

### Debugging the plist

Open 2 terminals.  In the first, run this command to start watching output:

```
sudo launchctl debug gui/501/com.xiantrimble.convert-portrait-mode  --stdout --stderr
```

In the second terminal, execute this command to fire the job
 
```
launchctl start com.xiantrimble.convert-portrait-mode
```

## Reference

- [I made quick action to convert HEIC photos to rgbd JPEG for looking glass](https://coder-question.com/cq-blog/575236) provided the basic bash script.