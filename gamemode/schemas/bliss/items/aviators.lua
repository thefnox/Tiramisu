ITEM.Name = "Aviator Glasses";
ITEM.Class = "aviators";
ITEM.Description = "Cool Glasses for cool people";
ITEM.Model = "models/Aviator/aviator.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 50;
ITEM.ItemGroup = 1;
ITEM.Offset = Vector( 1.5,-3,0 )
ITEM.OffsetAngle = Angle( -180,100,90 )
ITEM.Bone = "head"
ITEM.Scale = Vector( 0.95,0.95,0.95 )

function ITEM:Drop(ply)
	ply:ConCommand("rp_removegear head");
end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	ply:ConCommand("rp_setgear aviators");
	ply:GiveItem( "aviators" )
	self:Remove();

end
