--Everything about the MySQL database system.
if CAKE.ConVars["SQLEngine"] == "mysqloo" then require("mysqloo") end
if CAKE.ConVars["SQLEngine"] == "tmysql" then require("tmysql") end

CAKE.Database = nil --This is for MySQLOO, don't touch this


function CAKE.DefaultSQLDatabase()
	CAKE.ConVars["SQLEngine"] = "sqlite"
	CAKE.CreateSQLTables()
end

function CAKE.InitializeSQLDatabase() --Initializes the SQL database using the currently selected SQL engine.
	print("\nInitializing SQL Database: ")
	if CAKE.ConVars["SQLEngine"] == "mysqloo" then
		CAKE.Database = mysqloo.connect(CAKE.ConVars["SQLHostname"], CAKE.ConVars["SQLUsername"], CAKE.ConVars["SQLPassword"], CAKE.ConVars["SQLDatabase"], CAKE.ConVars["SQLPort"])
		CAKE.Database.onConnectionFailed = function()
			print("\n[!]Could not initialize database at " .. CAKE.ConVars["SQLHostname"] .. ", defaulting to SQLite...[!]\n")
			CAKE.DefaultSQLDatabase() --We default back to SQLite
		end
		CAKE.Database.onConnected = function()
			print("--Connection to SQL database established-- ("..CAKE.ConVars["SQLHostname"]..")\n")
			CAKE.CreateSQLTables()
		end
	elseif CAKE.ConVars["SQLEngine"] == "tmysql" then
		CAKE.Database = tmysql.initialize(CAKE.ConVars["SQLHostname"], CAKE.ConVars["SQLUsername"], CAKE.ConVars["SQLPassword"], CAKE.ConVars["SQLDatabase"], CAKE.ConVars["SQLPort"])
		if !CAKE.Database then
			print("\n[!]Could not initialize database at " .. CAKE.ConVars["SQLHostname"] .. ", defaulting to SQLite...[!]\n")
			CAKE.DefaultSQLDatabase() --We default back to SQLite
		else
			print("--Connection to SQL database established-- ("..CAKE.ConVars["SQLHostname"]..")\n")
			CAKE.CreateSQLTables()
		end
	else --Default to SQLite
		CAKE.DefaultSQLDatabase()
	end
end

function CAKE.CreateSQLTables()
	--Just a little debugging thing, if you want to destroy all tables to generate them again just uncomment the following
	CAKE.Query("DROP TABLE tiramisu_players")
	CAKE.Query("DROP TABLE tiramisu_chars")
	CAKE.Query("DROP TABLE tiramisu_items")
	CAKE.Query("DROP TABLE tiramisu_bans")
	CAKE.Query("DROP TABLE tiramisu_containers")
	CAKE.Query("DROP TABLE tiramisu_groups")
	if CAKE.ConVars["SQLEngine"] == "sqlite" then
		if !sql.TableExists("tiramisu_players") then
			local datastr = ""
			for k, v in pairs(CAKE.PlayerDataFields) do
				datastr = datastr .. k .. " "
				if CAKE.PlayerDataFieldTypes[k] then
					datastr = datastr .. string.lower(CAKE.PlayerDataFieldTypes[k])
				else
					if type(v) == "table" then
						datastr = datastr .. "text"
					elseif type(v) == "string" then
						datastr = datastr .. "text"
					elseif type(v) == "number" then
						datastr = datastr .. "float"
					else --default to bool
						datastr = datastr .. "bit"
					end
				end
				datastr = datastr .. "," 
			end
			datastr = string.sub(datastr, 1, string.len(datastr) - 1 ) --Removing the last comma
			CAKE.Query("CREATE TABLE tiramisu_players ( " .. datastr .. " )")
		end
		if !sql.TableExists("tiramisu_chars") then
			local datastr = "id int NOT NULL PRIMARY KEY,"
			for k, v in pairs(CAKE.CharacterDataFields) do
				datastr = datastr .. k .. " "
				if CAKE.CharacterDataFieldTypes[k] then
					datastr = datastr .. string.lower(CAKE.CharacterDataFieldTypes[k])
				else
					if type(v) == "table" then
						datastr = datastr .. "text"
					elseif type(v) == "string" then
						datastr = datastr .. "text"
					elseif type(v) == "number" then
						datastr = datastr .. "float"
					else --default to bool
						datastr = datastr .. "bit"
					end
				end
				datastr = datastr .. "," 
			end
			datastr = string.sub(datastr, 1, string.len(datastr) - 1 ) --Removing the last comma
			CAKE.Query("CREATE TABLE tiramisu_chars ( " .. datastr .. " )")
		end
		if !sql.TableExists("tiramisu_items") then
			CAKE.Query("CREATE TABLE tiramisu_items ( id int NOT NULL PRIMARY KEY, udata text )")
		end
		if !sql.TableExists("tiramisu_bans") then
			CAKE.Query("CREATE TABLE tiramisu_bans ( steamid varchar(99), bandate int, duration int, date timestamp, admin text )")
		end
	else
		local datastr = ""
		for k, v in pairs(CAKE.PlayerDataFields) do
			datastr = datastr .. k .. " "
			if CAKE.PlayerDataFieldTypes[k] then
				datastr = datastr .. CAKE.PlayerDataFieldTypes[k]
			else
				if type(v) == "table" then
					datastr = datastr .. "TEXT"
				elseif type(v) == "string" then
					datastr = datastr .. "TEXT"
				elseif type(v) == "number" then
					datastr = datastr .. "FLOAT"
				else --default to bool
					datastr = datastr .. "TINYINT"
				end
			end
			datastr = datastr .. "," 
		end
		datastr = string.sub(datastr, 1, string.len(datastr) - 1 ) --Removing the last comma
		CAKE.Query("CREATE TABLE IF NOT EXISTS tiramisu_players ( " .. datastr .. " )")
		datastr = "id INT,"
		for k, v in pairs(CAKE.CharacterDataFields) do
			datastr = datastr .. k .. " "
			if CAKE.CharacterDataFieldTypes[k] then
				datastr = datastr .. CAKE.CharacterDataFieldTypes[k]
			else
				if type(v) == "table" then
					datastr = datastr .. "TEXT"
				elseif type(v) == "string" then
					datastr = datastr .. "TEXT"
				elseif type(v) == "number" then
					datastr = datastr .. "FLOAT"
				else --default to bool
					datastr = datastr .. "TINYINT"
				end
			end
			datastr = datastr .. "," 
		end
		datastr = datastr .. "PRIMARY KEY (`id`)"
		CAKE.Query("CREATE TABLE IF NOT EXISTS tiramisu_chars ( " .. datastr .. " )")
		CAKE.Query("CREATE TABLE IF NOT EXISTS tiramisu_items ( id INT, udata TEXT, PRIMARY KEY (`id`) )")
		CAKE.Query("CREATE TABLE IF NOT EXISTS tiramisu_bans ( steamid VARCHAR(99), bandate INT, duration INT, date TIMESTAMP(), admin TEXT )")
	end
	hook.Call("Tiramisu.CreateSQLTables", GAMEMODE )
end

function CAKE.Query(querystr) --Makes a query to the database
	print(querystr)
	if CAKE.ConVars["SQLEngine"] == "mysqloo" then
		local err = false
		local query = CAKE.Database:query(querystr)
		query.onError = function(query,error) err = error end
		query:start()
		if err then
			print( err )
			return false
		else
			return query:getData()
		end
	elseif CAKE.ConVars["SQLEngine"] == "tmysql" then
		local err = false
		tmysql.query(querystr, function(result, status, error)
			if (result and type(result) == "table" and #result > 0) then
				err = result
			else
				print(error)
			end
		end)
		return err
	else
		local data = sql.Query( querystr )
		if !data then
			print(sql.LastError())
			return false
		end
		return data
	end
end

function CAKE.StrEscape( str ) --Escapes a string to avoid SQL injections.
	if CAKE.ConVars["SQLEngine"] == "tmysql" then return tmysql.escape(str) end
	return sql.SQLStr(str)
end