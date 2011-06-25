RCLICK.Name = "Promote"

function RCLICK.Condition(target)

if target:IsPlayer() and CAKE.GetRankPermission( "canpromote" ) then return true end

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