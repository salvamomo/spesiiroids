# SpESIIroids

A Twin stick shooter for pecadores de la pradera.

This is a Godot port of a game built originally in XNA 3.0 around 2009. The goal of the port was 
to have it work on different operating systems and environments, and to learn the Godot engine 
fundamentals.

The original game was completed in about 9-10 days for a university competition, without having
prior knowledge of game frameworks or game development, and it was my first game ever developed.
As such, you can expect to find elements, both in game mechanics and in graphics and design (just
look at that starting screen!), that are... put softly... not _great_.

Game mechanics have, for the most part, not been upgraded or altered in any way. Only minor changes
have been done to certain sounds and graphics, as a consequence of revamping the game in a different
engine, and to include a few sound effects that didn't make it into the first cut even though they
were planned, due to time restrictions in the competition.

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

## CREDITS

The list of assets and where they come from is below. Unfortunately, having lost the original
CD that contained the README with the sources of the assets used for the game, I'm unable to
point to the exact source of some of them.

### Spaceships

Player ship and most enemy designs were taken from an online blog. For the "level 1" enemy ships,
design were kept as they were. For other levels, they were edited with photoshop to make them look... 
cool? :). Enemy ships for final levels were done by myself, and yes, they're inspired by the Xbox
360 power button, with the Xbox 360 red ring of death making a notorious appearance.

### Sound Effects & Music

Sound effects were taken from free online resource pages. Background music was taken from different
songs I found in an online blog of an Spanish guy called Manuel Mora. His website seems to be down
now, but I've found his Youtube channel where he has some of the songs used in the game:

Manuel Mora Youtube channel: https://www.youtube.com/user/MMiX2k.

Some of the songs used in the game:

- Ant Dance (Hormiguero Remix): https://www.youtube.com/watch?v=DrOMhI9nxAk.
- Bomberman Song: https://www.youtube.com/watch?v=E5Ern_Pftds.
- Synthesized Spot: https://www.youtube.com/watch?v=1Fmdp_ZLb0Q.

### Other assets

All other graphic assets are made from scratch. All the code used in the game, both for the original
version and the new one, with the exception of the particle effects used when destroying enemy ships
on the original. For those, an open-source C# library was used.
