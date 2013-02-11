util.AddNetworkString( "Tiramisu.GetLookAt" )

net.Receive("Tiramisu.GetLookAt", function(len, ply)
	local ang = net.ReadAngle()
	ply:SetNWAngle("tiramisulookat", ang)
end)