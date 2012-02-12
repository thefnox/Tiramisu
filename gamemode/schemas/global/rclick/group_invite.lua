RCLICK.Name = "Invite"
RCLICK.SubMenu = "Groups"

function RCLICK.Condition(target)

if target:IsPlayer() and CAKE.GetRankPermission( "caninvite" ) and target != LocalPlayer() and CAKE.ActiveGroup != "none" then return true end

end

function RCLICK.Click(target,ply)

	RunConsoleCommand( "rp_sendinvite", CAKE.FormatText( target:SteamID() ) )

end