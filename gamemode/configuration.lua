-- You can change these in the schema definition file as well.

CAKE.ConVars = {  };

CAKE.ConVars[ "DefaultHealth" ] = 100; -- How much health do they start with
CAKE.ConVars[ "WalkSpeed" ] = 100; -- How fast do they walk
CAKE.ConVars[ "RunSpeed" ] = 450; -- How fast do they run
CAKE.ConVars[ "TalkRange" ] = 300; -- This is the range of talking.
CAKE.ConVars[ "SuicideEnabled" ] = false; -- Can players compulsively suicide by using kill
CAKE.ConVars[ "Default_Gravgun" ] = "1"; -- Are players banned from the gravity gun when they first start.
CAKE.ConVars[ "Default_Physgun" ] = "1"; -- Are players banned from the physics gun when they first start.
CAKE.ConVars[ "Default_Money" ] = 800; -- How much money do the characters start out with.
CAKE.ConVars[ "Default_Title" ] = "Citizen"; -- What is their title when they create their character.
CAKE.ConVars[ "Default_Inventory" ] = {  }; -- What inventory do characters start out with when they are first made. This cannot be setconvar'd
CAKE.ConVars[ "Default_Weapons" ] = {  }; -- What inventory do characters start out with when they are first made. This cannot be setconvar'd
CAKE.ConVars[ "Default_Ammo" ] = {  }; --The default ammo table your character will have on spawn.
CAKE.ConVars[ "Default_Clothing" ] = { };--Clothing you can choose on startup
CAKE.ConVars[ "Respawn_Timer" ] = 5 --Time in seconds that it takes for people to be allowed to respawn.
CAKE.ConVars[ "Schema" ] = "hl2rp"; -- What folder is schema data being loaded from?

CAKE.ConVars[ "LoseWeaponsOnDeath" ] = false --Set this to true if you want people to lose their guns once they die.
CAKE.ConVars[ "LoseItemsOnDeath" ] = false --Set this to true if you want people to lose their items once they die. LoseWeaponsOnDeath must be set to true for this to work

CAKE.ConVars[ "Tiramisu" ] = "1.2";

--Stats for the fighting system, plus stamina

CAKE.Stats = {}

CAKE.Stats.Stamina = {}
CAKE.Stats.Stamina.BaseRegenRate = 2 --This is the percentage recovered per second.
CAKE.Stats.Stamina.BaseRunCost = 2 --The amount of stamina consumed per second of running. Set this to 0 to disable it.

--And finally, some clientside stuff.

--VGUI
CAKE.MenuFont = "Yanone Kaffeesatz Regular" -- The default font for the whole schema
CAKE.MenuFont2 = "Yanone Kaffeesatz Bold" -- In case you want a different font for the bigger labels, change this to whatever you want.
CAKE.ChatFont = "ChatFont" -- Main font used in chatting
CAKE.WhisperFont = "DefaultSmallDropShadow" --Font used in whispering.
CAKE.YellFont = "Trebuchet18" --Font used when yelling.
CAKE.BaseColor = Color( 100, 100, 115, 150 ) --The schema's default color. Can be set in game

--Intro
CAKE.UseIntro = true --Set this to false if you want the player to go directly into the character menu when they join
CAKE.IntroText = "Welcome to Tiramisu" -- Character menu and intro text. NOTE, the HL2RP scheme changes this
CAKE.IntroSubtitle = "A ROLEPLAY REVOLUTION" -- Character menu and intro subtitle. If you want this gone just set it to ""

--General
CAKE.Webpage = "http://www.facepunch.com/" --Set this to whatever you want to, it'll be accessible on the "Forums" tab
