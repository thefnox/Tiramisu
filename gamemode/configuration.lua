-- You can change these in the schema definition file as well.

CAKE.ConVars = {  };

CAKE.ConVars[ "DefaultHealth" ] = 100; -- How much health do they start with
CAKE.ConVars[ "WalkSpeed" ] = 125; -- How fast do they walk
CAKE.ConVars[ "RunSpeed" ] = 285; -- How fast do they run
CAKE.ConVars[ "TalkRange" ] = 300; -- This is the range of talking.
CAKE.ConVars[ "SuicideEnabled" ] = false; -- Can players compulsively suicide by using kill
CAKE.ConVars[ "SalaryInterval" ] = "20"; -- How often is salary given ( Minutes ) -- This cannot be changed after it has been set
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
