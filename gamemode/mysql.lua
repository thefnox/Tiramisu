--Everything about the MySQL database system.
if TIRA.ConVars["SQLEngine"] == "mysqloo" then require("mysqloo") end

TIRA.Database = nil --This is for MySQLOO, don't touch this

function TIRA.GetTableMaxID( tbl )
	if TIRA.ConVars["SQLEngine"] != "sqlite" then
		local query = TIRA.Query("SELECT MAX(id) AS id FROM " .. tbl )
		if query and query['id'] != nil then
			return tonumber(query['id'] or 0)
		end
	else
		local query = TIRA.Query("SELECT id FROM " .. tbl .. " ORDER BY id DESC LIMIT 1" )
		if query and query[1]['id'] != nil then
			return tonumber(query[1]['id'] or 0)
		end
	end
	return 0
end

function TIRA.GetTableNextID( tbl )
	return TIRA.GetTableMaxID( tbl ) + 1
end


function TIRA.DefaultSQLDatabase()
	TIRA.ConVars["SQLEngine"] = "sqlite"
	TIRA.CreateSQLTables()
end

function TIRA.InitializeSQLDatabase() --Initializes the SQL database using the currently selected SQL engine.
	print("\nInitializing SQL Database: ")
	if TIRA.ConVars["SQLEngine"] == "mysqloo" then
		TIRA.Database = mysqloo.connect(TIRA.ConVars["SQLHostname"], TIRA.ConVars["SQLUsername"], TIRA.ConVars["SQLPassword"], TIRA.ConVars["SQLDatabase"], TIRA.ConVars["SQLPort"])
		TIRA.Database.onConnectionFailed = function()
			print("\n[!]Could not initialize database at " .. TIRA.ConVars["SQLHostname"] .. ", defaulting to SQLite...[!]\n")
			TIRA.DefaultSQLDatabase() --We default back to SQLite
		end
		TIRA.Database.onConnected = function()
			print("--Connection to SQL database established-- ("..TIRA.ConVars["SQLHostname"]..")\n")
			TIRA.CreateSQLTables()
		end
		TIRA.Database:connect()
	else --Default to SQLite
		TIRA.DefaultSQLDatabase()
	end
end

function TIRA.DropSQLTables()
	TIRA.Query("DROP TABLE tiramisu_players")
	TIRA.Query("DROP TABLE tiramisu_chars")
	TIRA.Query("DROP TABLE tiramisu_items")
	TIRA.Query("DROP TABLE tiramisu_bans")
	TIRA.Query("DROP TABLE tiramisu_containers")
	TIRA.Query("DROP TABLE tiramisu_groups")
end

function TIRA.CreateSQLTables()
	--Just a little debugging thing, if you want to destroy all tables to generate them again just uncomment the following

	--TIRA.DropSQLTables()

	if TIRA.ConVars["SQLEngine"] == "sqlite" then
		if !sql.TableExists("tiramisu_players") then
			local datastr = ""
			for k, v in pairs(TIRA.PlayerDataFields) do
				datastr = datastr .. k .. " "
				if TIRA.PlayerDataFieldTypes[k] then
					datastr = datastr .. string.lower(TIRA.PlayerDataFieldTypes[k])
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
			TIRA.Query("CREATE TABLE tiramisu_players ( " .. datastr .. " )")
		end
		if !sql.TableExists("tiramisu_chars") then
			local datastr = "id int NOT NULL PRIMARY KEY,"
			for k, v in pairs(TIRA.CharacterDataFields) do
				datastr = datastr .. k .. " "
				if TIRA.CharacterDataFieldTypes[k] then
					datastr = datastr .. string.lower(TIRA.CharacterDataFieldTypes[k])
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
			TIRA.Query("CREATE TABLE tiramisu_chars ( " .. datastr .. " )")
		end
		if !sql.TableExists("tiramisu_items") then
			TIRA.Query("CREATE TABLE tiramisu_items ( id int NOT NULL PRIMARY KEY, udata text )")
		end
		if !sql.TableExists("tiramisu_bans") then
			TIRA.Query("CREATE TABLE tiramisu_bans ( steamid varchar(99), bandate int, duration int, date timestamp, admin text )")
		end
	else
		local datastr = ""
		for k, v in pairs(TIRA.PlayerDataFields) do
			datastr = datastr .. k .. " "
			if TIRA.PlayerDataFieldTypes[k] then
				datastr = datastr .. TIRA.PlayerDataFieldTypes[k]
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
		TIRA.Query("CREATE TABLE IF NOT EXISTS tiramisu_players ( " .. datastr .. " )")
		datastr = "id INT,"
		for k, v in pairs(TIRA.CharacterDataFields) do
			datastr = datastr .. k .. " "
			if TIRA.CharacterDataFieldTypes[k] then
				datastr = datastr .. TIRA.CharacterDataFieldTypes[k]
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
		TIRA.Query("CREATE TABLE IF NOT EXISTS tiramisu_chars ( " .. datastr .. " )")
		TIRA.Query("CREATE TABLE IF NOT EXISTS tiramisu_items ( id INT, udata TEXT, PRIMARY KEY (`id`) )")
		TIRA.Query("CREATE TABLE IF NOT EXISTS tiramisu_bans ( steamid VARCHAR(99), bandate INT, duration INT, date TIMESTAMP, admin TEXT )")
	end
	hook.Call("Tiramisu.CreateSQLTables", GAMEMODE )
end

function TIRA.ConvertResultsToNice( results, fields )
	//This is because tmysql and mysqloo just return results in a numbered list instead of by fields like sqlite
	local tbl = {}
	for k, v in pairs( results ) do
		tbl[fields[k] or 1] = v
	end
	return tbl
end

function TIRA.GetFieldsFromQuery( query )
	local exp2 = string.Explode(" ", query)
	local exp = string.Explode(",", exp2[2])
	return exp
end

function TIRA.Query(querystr) --Makes a query to the database
	--print(querystr)
	local exp = string.Explode(" ", querystr)
	local querytype = exp[1]
	local fields = TIRA.GetFieldsFromQuery( querystr )
	if TIRA.ConVars["SQLEngine"] == "mysqloo" then
		local err = false
		local query = TIRA.Database:query(querystr)
		query.onError = function(query,error) err = error end
		query:start()
		if err then
			MsgN( err )
			return false
		else
			--PrintTable( query:getData() )
			return query:getData()
		end
	else
		local data = sql.Query( querystr )
		if !data then
			if sql.LastError() then MsgN(sql.LastError()) end
			return false
		end
		--PrintTable( data )
		return data
	end
end

function TIRA.StrEscape( str ) --Escapes a string to avoid SQL injections.
	if TIRA.ConVars["SQLEngine"] == "mysqloo" and type(str) == "string" then return TIRA.Database:escape(str) end
	return sql.SQLStr(str)
end