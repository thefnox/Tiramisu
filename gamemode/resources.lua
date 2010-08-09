
-- A simple function to makes sure they got the right extension (so it's not .txt for example)
local function ValidExt(FileName)
    if     -- Materials
        (FileName:find(".vtf$")) or
        (FileName:find(".vmt$")) or
        -- Models
        (FileName:find(".vtx$")) or
        (FileName:find(".mdl$")) or
        (FileName:find(".phy$")) or
		(FileName:find(".lua$")) or
        (FileName:find(".vvd$")) then
        
        return true
    end
    
    return false
end


-- A recursive function to find all the files in models and material folders
local function FindFiles(Dir, Level)
    if (Dir) then
        Files = file.Find("../gamemodes/tiramisu/content/"..Dir.."/*.*")
    else
        Files = file.Find("../gamemodes/tiramisu/content/*.*")
		
		print("-------------------------------------------------")
		print("------- ADDING RESOURCES TO DOWNLOAD LIST -------")
		print("-------------------------------------------------")
    end
    
    Level = Level or 0
    Dir = Dir or ""
    for k,v in pairs(Files) do
        local IsDir = file.IsDir("../gamemodes/tiramisu/content/".. Dir .. "/" .. v)
        if (IsDir) then
            FindFiles(Dir .. "/" .. v, Level + 1)
        else
            if string.match( v, ".lua" ) then 
				AddCSLuaFile( Dir .. "/" .. v )
			else
                resource.AddFile( Dir .. "/" .. v)
            end
        end
    end
end
FindFiles()