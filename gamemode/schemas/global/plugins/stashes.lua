PLUGIN.Name = "Item Stashes"; -- What is the plugin name
PLUGIN.Author = "Ryaga"; -- Author of the plugin
PLUGIN.Description = "Allows you to place random caches of items around your map"; -- The description or purpose of the plugin

CAKE.StashPoints = {}
CAKE.StashItems = {}
CAKE.StashItems.Roll = {}
CAKE.StashItems["Common"] = {}
CAKE.StashItems["Uncommon"] = {}
CAKE.StashItems["Rare"] = {}

for i = 1, 60 do 
	CAKE.StashItems.Roll[i] = "Common"
end

for i = 61, 90 do 
	CAKE.StashItems.Roll[i] = "Uncommon"
end

for i = 91, 100 do 
	CAKE.StashItems.Roll[i] = "Rare"
end

function CAKE.AddStashItem(class,itemrarity)
	if !CAKE.StashItems[itemrarity] then print("No such rarity") return end
	table.insert(CAKE.StashItems[itemrarity], class)
end
	
function CAKE.AddStash(pos, ang)
	map = game.GetMap()
	
	if !CAKE.StashPoints then 
		CAKE.StashPoints = {}
	end
		
	stash = {}
	stash.pos = pos
	stash.ang = ang
		
	table.insert(CAKE.StashPoints, stash)
	CAKE.SaveStashes()
		
end

function CAKE.ClearStashes()
	CAKE.StashPoints = {}
	CAKE.SaveStashes()
end

function CAKE.SaveStashes()
	local gloncomspawns = glon.encode(CAKE.StashPoints)
	file.Write( CAKE.Name .. "/MapInfo/" ..game.GetMap().. "_stashes.txt" , gloncomspawns)
end

function CAKE.StashPointAuto()
	if #CAKE.StashPoints > 0 then
		
		local stash = CAKE.StashPoints[math.random(1,#CAKE.StashPoints)]
		local stashitemroll = CAKE.StashItems.Roll[math.random(1,100)]
		local stashitem = CAKE.StashItems[stashitemroll][math.random(1,#CAKE.StashItems[stashitemroll])]
		if stashitem == "fake" and CAKE.StashItems[stashitemroll][2] then stashitem = CAKE.StashItems[stashitemroll][2] end
		CAKE.CreateItem( stashitem, stash.pos, stash.ang )
		
	end
end

function CAKE.InitStashes()

	if(file.Exists(CAKE.Name .. "/MapInfo/" ..game.GetMap().. "_stashes.txt")) then
	
		local keydspawntable = file.Read(CAKE.Name .. "/MapInfo/" ..game.GetMap().. "_stashes.txt")
		print(keydspawntable)
		CAKE.StashPoints = glon.decode(keydspawntable)
		
	end
	
end

function PLUGIN.Init()
	CAKE.AddStashItem("fake","Common") -- DO NOT REMOVE THIS LINE OR THE LINES FOLLOWING.
	CAKE.AddStashItem("fake","Uncommon") -- THESE ARE SO THAT THE STASH SYSTEM DOES NOT ERROR IF THERE IS NOTHING IN THAT RARITY RANGE.
	CAKE.AddStashItem("fake","Rare") -- THE SCRIPT WILL NOT FUNCTION PROPERLY.
end