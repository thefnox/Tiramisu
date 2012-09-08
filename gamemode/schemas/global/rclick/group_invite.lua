RCLICK.Name = "Invite"
RCLICK.SubMenu = "Groups"

function RCLICK.Condition(target)

if target:IsTiraPlayer() and TIRA.GetRankPermission( TIRA.ActiveGroup, "caninvite" ) and target != LocalPlayer() and TIRA.ActiveGroup != "none" then return true end

end

function RCLICK.Click(target,ply)

	target = target:IsTiraPlayer()

	RunConsoleCommand( "rp_sendinvite", TIRA.FormatText( target:SteamID() ) )

end