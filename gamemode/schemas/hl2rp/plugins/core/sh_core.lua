TIRA.CityNumber = 17 --This provides a quick way of changing the name of the city employed on the whole script
--Since HL2RP servers seem to think that setting on a city number is a fundamental part of the community.

if SERVER then	
	--With this we disable character creation clothing.
	TIRA.ConVars[ "DefaultClothing" ][ "Male" ] = {}
	TIRA.ConVars[ "DefaultClothing" ][ "Female" ] = {}

	TIRA.AddDataField( 2, "cid", "000000" ) 

end