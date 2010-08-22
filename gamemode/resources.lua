
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

resource.AddFile( "models/Gustavio/alyxanimtree.mdl" )
resource.AddFile( "models/Gustavio/alyxanimtree.vvd" )
resource.AddFile( "models/Gustavio/AlyxAnimTree.phy" )
resource.AddFile( "models/Gustavio/AlyxAnimTree.sw.vtx" )
resource.AddFile( "models/Gustavio/AlyxAnimTree.dx80.vtx" )
resource.AddFile( "models/Gustavio/AlyxAnimTree.dx90.vtx" )
resource.AddFile( "models/Gustavio/AlyxAnimTree.xbox.vtx" )
resource.AddFile( "models/Gustavio/combineanimtree.mdl" )
resource.AddFile( "models/Gustavio/combineanimtree.vvd" )
resource.AddFile( "models/Gustavio/CombineAnimTree.phy" )
resource.AddFile( "models/Gustavio/CombineAnimTree.sw.vtx" )
resource.AddFile( "models/Gustavio/CombineAnimTree.dx80.vtx" )
resource.AddFile( "models/Gustavio/CombineAnimTree.dx90.vtx" )
resource.AddFile( "models/Gustavio/CombineAnimTree.xbox.vtx" )
resource.AddFile( "models/Gustavio/maleanimtree.mdl" )
resource.AddFile( "models/Gustavio/maleanimtree.vvd" )
resource.AddFile( "models/Gustavio/MaleAnimTree.phy" )
resource.AddFile( "models/Gustavio/MaleAnimTree.sw.vtx" )
resource.AddFile( "models/Gustavio/MaleAnimTree.dx80.vtx" )
resource.AddFile( "models/Gustavio/MaleAnimTree.dx90.vtx" )
resource.AddFile( "models/Gustavio/MaleAnimTree.xbox.vtx" )
resource.AddFile( "models/Gustavio/femaleanimtree.mdl" )
resource.AddFile( "models/Gustavio/femaleanimtree.vvd" )
resource.AddFile( "models/Gustavio/FemaleAnimTree.phy" )
resource.AddFile( "models/Gustavio/FemaleAnimTree.sw.vtx" )
resource.AddFile( "models/Gustavio/FemaleAnimTree.dx80.vtx" )
resource.AddFile( "models/Gustavio/FemaleAnimTree.dx90.vtx" )
resource.AddFile( "models/Gustavio/FemaleAnimTree.xbox.vtx" )
resource.AddFile( "models/Gustavio/metroanimtree.mdl" )
resource.AddFile( "models/Gustavio/metroanimtree.vvd" )
resource.AddFile( "models/Gustavio/MetroAnimTree.phy" )
resource.AddFile( "models/Gustavio/MetroAnimTree.sw.vtx" )
resource.AddFile( "models/Gustavio/MetroAnimTree.dx80.vtx" )
resource.AddFile( "models/Gustavio/MetroAnimTree.dx90.vtx" )
resource.AddFile( "models/Gustavio/MetroAnimTree.xbox.vtx" )
resource.AddFile( "materials/models/Bliss/Gustavio/BoneTrees/Translucent.vmt" )
resource.AddFile( "materials/models/Bliss/Gustavio/BoneTrees/Translucent.vtf" )
resource.AddFile( "materials/models/Bliss/Gustavo/BoneTrees/Translucent.vmt" )
resource.AddFile( "materials/models/Bliss/Gustavo/BoneTrees/Translucent.vtf" )
resource.AddFile( "models/Gustavio/barneyanimtree.mdl" )
resource.AddFile( "models/Aviator/aviator.mdl" )
resource.AddFile( "materials/Aviator/Aviator.vtf" )
resource.AddFile( "materials/Aviator/Aviator_envmap.vtf" )