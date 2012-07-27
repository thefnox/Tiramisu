--Everything about the MySQL database system.
if CAKE.ConVars["SQLEngine"] == "mysqloo" then require("mysqloo") end
if CAKE.ConVars["SQLEngine"] == "tmysql" then require("tmysql") end

CAKE.Database = nil --This is for MySQLOO, don't touch this


function CAKE.DefaultSQLDatabase()
	CAKE.CreateSQLTables()
end

function CAKE.InitializeSQLDatabase() --Initializes the SQL database using the currently selected SQL engine.
	if CAKE.ConVars["SQLEngine"] == "mysqloo" then
		CAKE.Database = mysqloo.connect(CAKE.ConVars["SQLHostname"], CAKE.ConVars["SQLUsername"], CAKE.ConVars["SQLPassword"], CAKE.ConVars["SQLDatabase"], CAKE.ConVars["SQLPort"])
		CAKE.Database.onConnectionFailed = function()
			print("\n[!]Could not initialize database at " .. CAKE.ConVars["SQLHostname"] .. ", defaulting to SQLite...[!]\n")
			CAKE.DefaultSQLDatabase() --We default back to SQLite
		end
		CAKE.Database.onConnected = function()
			print("--Connection to SQL database established-- ("..CAKE.ConVars["SQLHostname"]..")")
			CAKE.CreateSQLTables()
		end
	elseif CAKE.ConVars["SQLEngine"] == "tmysql" then
		CAKE.Database = tmysql.initialize(CAKE.ConVars["SQLHostname"], CAKE.ConVars["SQLUsername"], CAKE.ConVars["SQLPassword"], CAKE.ConVars["SQLDatabase"], CAKE.ConVars["SQLPort"])
		if !CAKE.Database then
			print("\n[!]Could not initialize database at " .. CAKE.ConVars["SQLHostname"] .. ", defaulting to SQLite...[!]\n")
			CAKE.DefaultSQLDatabase() --We default back to SQLite
		else
			print("--Connection to SQL database established-- ("..CAKE.ConVars["SQLHostname"]..")")
			CAKE.CreateSQLTables()
		end
	else --Default to SQLite
		CAKE.DefaultSQLDatabase()
	end
end

function CAKE.CreateSQLTables()

end

function CAKE.Query(querystr, callback) --Makes a query to the database

end

function CAKE.StrEscape( str ) --Escapes a string to avoid SQL injections.
	if CAKE.ConVars["SQLEngine"] == "tmysql" then return tmysql.escape(str) end
	return sql.SQLStr(str)
end