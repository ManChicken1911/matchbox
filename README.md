# Matchbox shaders for Autodesk Flame
by Bob Maple (bobm-matchbox [at] idolum.com)

All shaders in this collection are licensed under the Creative Commons
Attribution-ShareAlike (CC BY-SA) unless otherwise individually noted.
[https://creativecommons.org/licenses/by-sa/4.0/]


The **COMPILE-2016.command** and **COMPILE-2017.command** scripts will compile and install all the Matchbox
and Lightbox shaders into their proper directories for release 2016 or 2017 respectively of
Flame, Flame Assist, and Flare.  To use them, put the correct version of the script into the directory where you
extracted the downloaded LOGIK matchbook shaders (where the `INSTALL.command` and the `shaders` directories are)
and execute it instead of INSTALL.command.  You may need to set it to be executable first:

```
  chmod +x ./COMPILE-2016.command
```
You can optionally create a file called `skip-shaders.cfg` placed in the same directory, containing
a list of shaders you do not wish to compile or install.  Simply list each shader by name (without
any extensions), one per line, and they should be shown in blue and skipped during the install.
