RCLICK.Name = "Make an item"

function RCLICK.Condition(target)

	if target:GetClass() == "prop_physics" and LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) > 0 then return true end

end

function RCLICK.Click(target,ply)

	CAKE.StringRequest( "Item Conversion", "Enter the name you want to give to the new item.", target:GetModel(), function( text )
		ply:ConCommand("rp_admin converttoitem " .. target:EntIndex() .. " \"" .. text .. "\"" )
	end,
	function() end, "Accept", "Cancel")

end