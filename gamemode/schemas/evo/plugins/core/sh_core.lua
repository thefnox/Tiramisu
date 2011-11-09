CAKE.CityNumber = 17 --This provides a quick way of changing the name of the city employed on the whole script
--Since HL2RP servers seem to think that setting on a city number is a fundamental part of the community.

if SERVER then	

	--With this we disable character creation clothing.
	CAKE.ConVars[ "Default_Clothing" ][ "Male" ] = {}
	CAKE.ConVars[ "Default_Clothing" ][ "Female" ] = {}

	--Currency data.
	CURRENCY = {}
	CURRENCY.Name        = "Credits";
	CURRENCY.Slang       = "credit"
	CURRENCY.Abr         = "Credits"
	CAKE.RegisterCurrency( CURRENCY )

	CAKE.AddDataField( 2, "cid", "000000" ); 

else
	
	ConversionTable = {}
	--Basically this is used to add some helpful information about each buy group. That way you can see on what category does the item actually belong, instead of using a number.
	ConversionTable[1] = {}
	ConversionTable[1].Name = "General"
	ConversionTable[1].Desc = "Foodstuffs, groceries, all combine legal."
	ConversionTable[1].Icon = "gui/silkicons/star"

	ConversionTable[2] = {}
	ConversionTable[2].Name = "Black Market"
	ConversionTable[2].Desc = "Weapons, drugs, and more weapons. All Combine illegal for your pleasure."
	ConversionTable[2].Icon = "gui/silkicons/bomb"

	ConversionTable[3] = {}
	ConversionTable[3].Name = "Medical"
	ConversionTable[3].Desc = "Everything that is good for your health."
	ConversionTable[3].Icon = "gui/silkicons/heart"

end