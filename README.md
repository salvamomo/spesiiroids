# SpESIIroids

A Twin stick shooter for pecadores de la pradera

## Download

Head over to the [Releases Page](https://github.com/salvamomo/spesiiroids/releases), find the last release 
(the one at the top) and download the file that corresponds to your operating system:

Windows: **spesiiroids-windows.zip**

Linux: **spesiiroids-linux.zip**

MacOS: **spesiiroids-mac.zip**

HTML5 (Any operating system): **spesiiroids-html5.zip**. NOT recommended, as this is mostly exported for
online game hosts or Github Pages. Opening this locally without a web server will not load the game properly
due to CORS browser security policies.

## Running the game

Just unzip the downloaded file, and double click on the executable.

### Running on MacOS

On the current exported version, the game is not signed. If you try to just run the game, you'll be greeted
a popup saying that the app is broken. To avoid that, you have to open a console terminal and run this:

`sudo xattr -rd com.apple.quarantine ~/path/to/the/game.app`

For example, if you downloaded and unzipped it on the Downloads folder:

`sudo xattr -rd com.apple.quarantine ~/Downloads/SpESIIroids.app`

After that, you'll be able to open the game without issues.