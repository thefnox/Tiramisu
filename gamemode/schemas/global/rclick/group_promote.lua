RCLICK.Name = "Promote"
RCLICK.SubMenu = "Groups"

function RCLICK.Condition(target)

if ValidEntity( target) and target:IsPlayer() and target != LocalPlayer() and CAKE.GetRankPermission( "canpromote" ) and CAKE.ActiveGroup != "none" then return true end

end

function RCLICK.Click(target,ply)

	CAKE.ChoiceRequest( "Confirm Promotion",
	"Select the rank you want to promote " .. target:Nick() .. " to, then press 'Accept'" ,
	CAKE.Group[ "Ranks" ],
		function( choice ) RunConsoleCommand( "rp_promote", choice ) end,
	function( choice ) end,
	"Accept",
	"Cancel")

end