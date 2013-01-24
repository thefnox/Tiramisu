RCLICK.Name = "Invite"
RCLICK.SubMenu = "Groups"

function RCLICK.Condition(target)

if target:IsTiraPlayer() and CAKE.GetRankPermission( CAKE.ActiveGroup, "caninvite" ) and target != LocalPlayer() and CAKE.ActiveGroup != "none" then return true end

end

function RCLICK.Click(target,ply)

	target = target:IsTiraPlayer()

	RunConsoleCommand( "rp_sendinvite", CAKE.FormatText( target:SteamID() ) )

end