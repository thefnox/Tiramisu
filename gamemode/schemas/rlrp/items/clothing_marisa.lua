ITEM.Name = "Marisa Outfit";
ITEM.Class = "clothing_marisa";
ITEM.Description = "Weeaboo";
ITEM.Model = "models/marisa/marisa.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 750;
ITEM.ItemGroup = 2;
ITEM.Flags = {
	"armor;120",
	"shieldratio;0.6",
	"bulletarmor;0.6",
	"explosivearmor;1.3",
	"kineticarmor;0.6",
	"rigweight;medium"
}
ITEM.Content = {
	"materials/models/marisa/body.vmt",
	"materials/models/marisa/body_normal.vtf",
	"materials/models/marisa/bousi.vmt",
	"materials/models/marisa/bousi_normal.vmt",
	"materials/models/marisa/eyeball_l.vmt",
	"materials/models/marisa/eyeball_r.vmt",
	"materials/models/marisa/kami.vmt",
	"materials/models/marisa/kami_normal.vtf",
	"materials/models/marisa/marisa.vmt",
	"materials/models/marisa/mouth.vmt",
	"materials/models/marisa/pupil_l.vmt",
	"materials/models/marisa/pupil_r.vmt",
	"models/marisa/marisa.mdl",
	"models/marisa/marisab.mdl",
	"models/marisa/hat.mdl"
}

function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
