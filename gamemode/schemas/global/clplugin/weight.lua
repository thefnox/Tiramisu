CLPLUGIN.Name = "Weight System"
CLPLUGIN.Author = "F-Nox/Big Bang"

CAKE.ExtraCargo = 0
ExtraInventory = {}

local function SetAdditionalCargo( um )

	CAKE.ExtraCargo = um:ReadShort()

end
usermessage.Hook( "SetAdditionalCargo", SetAdditionalCargo )

local function ClearExtraInventory( um )
	
	ExtraInventory = {}
end
usermessage.Hook( "ClearExtraInventory", ClearExtraInventory )

local function AddExtraItem( data )

	local itemdata = {}
	itemdata.Name = data:ReadString();
	itemdata.Class = data:ReadString();
	itemdata.Description = data:ReadString();
	itemdata.Model = data:ReadString();
	itemdata.Weight = data:ReadShort()
	
	table.insert(ExtraInventory, itemdata);

end
usermessage.Hook( "AddExtraItem", AddExtraItem )

function CLPLUGIN.Init()
	
end