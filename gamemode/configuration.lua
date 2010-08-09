-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- configuration.lua
-- Set up the script here.
-------------------------------

-- You can change these in the schema definition file as well.

CAKE.ConVars = {  };

CAKE.ConVars[ "DefaultHealth" ] = 100; -- How much health do they start with
CAKE.ConVars[ "WalkSpeed" ] = 125; -- How fast do they walk
CAKE.ConVars[ "RunSpeed" ] = 285; -- How fast do they run
CAKE.ConVars[ "TalkRange" ] = 300; -- This is the range of talking.
CAKE.ConVars[ "SuicideEnabled" ] = "1"; -- Can players compulsively suicide by using kill
CAKE.ConVars[ "SalaryEnabled" ] = "0"; -- Is salary enabled
CAKE.ConVars[ "SalaryInterval" ] = "20"; -- How often is salary given ( Minutes ) -- This cannot be changed after it has been set
CAKE.ConVars[ "Default_Gravgun" ] = "1"; -- Are players banned from the gravity gun when they first start.
CAKE.ConVars[ "Default_Physgun" ] = "1"; -- Are players banned from the physics gun when they first start.
CAKE.ConVars[ "Default_Money" ] = "800"; -- How much money do the characters start out with.
CAKE.ConVars[ "Default_Title" ] = "Citizen"; -- What is their title when they create their character.
CAKE.ConVars[ "Default_Flags" ] = {  }; -- What flags can the character select when it is first made. ( This does not include public flags ) This cannot be setconvar'd
CAKE.ConVars[ "Default_Inventory" ] = {  }; -- What inventory do characters start out with when they are first made. This cannot be setconvar'd
CAKE.ConVars[ "Default_Weapons" ] = {  }; -- What inventory do characters start out with when they are first made. This cannot be setconvar'd
CAKE.ConVars[ "Default_Ammo" ] = {  };
CAKE.ConVars[ "Schema" ] = "bliss"; -- What folder is schema data being loaded from?

CAKE.ConVars[ "CakeVersion" ] = "1.0.4"; -- Don't change this plzkthx. This is for LuaBanana's usage only.
