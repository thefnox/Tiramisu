PLUGIN.Name = "Vehicles"; -- What is the plugin name
PLUGIN.Author = "Ryaga/BadassMC"; -- Author of the plugin
PLUGIN.Description = "Custom Vehicles"; -- The description or purpose of the plugin

local V = { 	
				Name = "Passenger APC", 
				Class = "prop_vehicle_jeep",
				Category = "VU-MOD",
				Author = "F-Nox",
				Information = "Combine APC, With a working passanger seat!",
				Model = "models/Vehicles/combine_apc.mdl",
				AdjustSitPos = Vector(0,0,0),
				HeadLights = {
					Light1 = {Pos = Vector( 0.00, 0.00, 110.00), Ang = Angle(-80, -90, 0)}
				},
				Horn = {Sound = "vu_horn_simple.wav", Pitch = 90},
				Passengers  = { 
					passenger1 = { Pos = Vector(20.00, 30.00, -100.00), Ang = Angle(0,0,0) },
					passenger2 = { Pos = Vector(-20.00, 40.00, -60.00), Ang = Angle(0,0,0) },
				}, -------Set Up passenger seats!
				Customexits = { Vector( 73.90, 6.11, 14.71), Vector(60.00, 72.00, 25.49), Vector(-46.28, 63.85, 23.41) },
				SeatType = "jeep_seat",
				ModView = { FirstPerson = Vector(0,0,0) },
				HideSeats = true, -----Hide the passenger seats?
				KeyValues = {vehiclescript	=	"scripts/vehicles/fixed_apc.txt"}
			}
list.Set( "Vehicles", "Combine APC(VU)", V )