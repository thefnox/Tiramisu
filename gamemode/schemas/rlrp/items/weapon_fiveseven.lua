ITEM.Name = "FN FIVESEVEN 5.7MM Pistol";
ITEM.Class = "weapon_fiveseven";
ITEM.Description = "Semi auto, polygonal rifling, 5.7mm. Some of the very best pistols available.";
ITEM.Model = "models/weapons/w_pist_fiveseven.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 300;
ITEM.ItemGroup = 2;
ITEM.Offset = Vector( 10,-2,-3 )
ITEM.OffsetAngle = Angle( 0,180,-90 )
ITEM.Bone = "right thigh"
ITEM.WeaponType = "small1"

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

	self:Remove();
	
end
