CAKE.CityNumber = 17 --This provides a quick way of changing the name of the city employed on the whole script
--Since HL2RP servers seem to think that setting on a city number is a fundamental part of the community.

if SERVER then	
	--With this we disable character creation clothing.
	CAKE.ConVars[ "DefaultClothing" ][ "Male" ] = {}
	CAKE.ConVars[ "DefaultClothing" ][ "Female" ] = {}

end