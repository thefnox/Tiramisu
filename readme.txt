NOTE: DO NOT DOWNLOAD REPO! IT'S NOT STABLE!

We're working here!

Right, so, changelog.

--GENERAL


* Added stamina. You can disable stamina consumption in configuration.lua

* Modified camera. Thirdperson camera now only follows the player when aiming, therefore allowing freescroll around the character when not moving. Fixed the over the shoulder camera so it's slightly more accurate.

* Bugfixes on the Options menu.

* Added scaling for clothes. You can scale your body, head and hand size easily through the character editor.

* Made running have acceleration, added new running animation. You're now unable to run at full speed while wielding a weapon.

* Re-enabled the option of having your character's body visible in first person.

* Changed the default font.

* Schema color is now entirely modifiable in game through the Options menu.

* Remade the entire HUD. No more portrait circle, no more cheesy 3D stuff.

* Rewrote the chat code. Chat range is now calculated more realistically.

-- SCRIPT

* Rewrote clothing code. The whole thing, including player_part. It should now be readable.

* Rewrote free scroll camera, no longer does it require the mouse to be visible.

* Removed that ugly HiddenButton shit in favor of GUIMousePressed. Right clicking should now be more accurate

* Removed right click shader.

* Added fix for when new fields are added/removed, CAKE.NilFix simply didn't do shit.

* Serverside flashlights

* Bugfixes on the Options menu.

* Moved ALL the configuration options to configuration.lua, including clientside options too, this is to easen up the task of editing tiramisu

* Moved ALL the VGUI and HUD drawing hooks to a single cl_skin.lua file, using derma.Hook. You can now change the way each and every element of the schema looks just by modifying a single file.