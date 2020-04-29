# Matchbox shaders for Autodesk Flame
by Bob Maple (bobm-matchbox [at] idolum.com)

All shaders in this collection are licensed under the Creative Commons
Attribution-ShareAlike (CC BY-SA) unless otherwise individually noted.
[https://creativecommons.org/licenses/by-sa/4.0/]


The **COMPILE.py** script will compile and install all the Matchbox and Lightbox shaders into their proper
directories for a specific Flame, Flame Assist or Flare release chosen from a menu.

To use it, put the script into the directory where you extracted the downloaded LOGIK matchbook shaders
(where the `INSTALL.command` and the `shaders` directories are) and execute it instead of INSTALL.command:

```
  python ./COMPILE.py
```

You can optionally create a file called `skip-shaders.cfg` placed in the same directory, containing
a list of shaders you do not wish to compile or install.  Simply list each shader by name (without
any extensions), one per line, and they will be skipped during the install.

You can also optionally create a file called `install-hints.cfg` to configure a subdirectory for
particular shader prefixes to be created for better organization. Example:

```
crok_ = crok
id_ = idolum
```
The above would place all shaders starting with `crok_` into a directory called `crok` and all
shaders starting with `id_` into a directory called `idolum`.
