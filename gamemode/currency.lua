CAKE.CurrencyData = {  };

function CAKE.LoadCurrency( schema, filename )

	local path = "schemas/" .. schema .. "/currency/" .. filename;
	
	CURRENCY = {  };
	
	include( path );
	
	PrintTable( CURRENCY )
	
	CAKE.CurrencyData[ CURRENCY.Name ] = CURRENCY;
	
end