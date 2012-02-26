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

* Added fade to black on death. Remade rp_acceptdeath, it uses a button now, no need to write anything in chat or console.

* Added timer on rp_wakeup, therefore controlling the time you have to spend unconcious to wake up.

* Finally fixed chat breaking after a certain amount of entries have been added to it.

* Made chat channels use the current handler for talking. If you have the OOC channel selected you will talk in OOC, same with PMs

* Added toggleable health regeneration.

* Added right click option Make Into Clothing. Allows you to make clothing out of ragdolls, if they have the adequate skeleton.

* Added right click options for permanent props and for tool trust.

* Made inventory display currently worn items in red.

* Added "Attach To" option to gear items, to allow their placement in bones other than those intended. Items can only be attached in one bone at a time, but any amount of items can be placed in any bone.

* Fixed the camera. It should now strictly rely on the raw mouse feed, not on the AimAngle which is relative to FPS. Performance should be the same irregardless of current framerate.

* Added setpermamodel, to set a player's permanent model, admin only.

* Added swimming and vehicle driving animations.

* Changed some animations around, combine and metro police animations are no longer used.

-- SCRIPT

* Rewrote clothing code. The whole thing, including player_part. It should now be readable.

* Rewrote free scroll camera, no longer does it require the mouse to be visible.

* Removed that ugly HiddenButton shit in favor of GUIMousePressed. Right clicking should now be more accurate

* Removed right click shader.

* Added fix for when new fields are added/removed, CAKE.NilFix simply didn't do shit.

* Serverside flashlights

* Bugfixes on the Options menu.

* Moved ALL the configuration options to configuration.lua, including clientside options too, this is to easen up the task of editing Tiramisu

* Moved ALL the VGUI and HUD drawing hooks to a single cl_skin.lua file, using derma.Hook. You can now change the way each and every element of the schema looks just by modifying a single file.


There's really so much more stuff there that I'm forgetting to add. So why not just go ahead, download the script, and try it!