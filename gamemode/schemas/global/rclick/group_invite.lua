RCLICK.Name = "Invite"

function RCLICK.Condition(target)

if target:IsPlayer() and CAKE.GetRankPermission( "canpromote" ) and target != LocalPlayer() then return true end

end

function RCLICK.Click(target,ply)

	RunConsoleCommand( "rp_sendinvite", target:Nick() )

end