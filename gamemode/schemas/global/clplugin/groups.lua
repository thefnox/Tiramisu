CLPLUGIN.Name = "Clientside Group Utilities"
CLPLUGIN.Author = "FNox"

CAKE.Group = {
        [ "Name" ]      = "none",
        [ "Type" ]      = "",
        [ "Founder" ]   = "",
        [ "Rank" ]      = "",
        [ "RankPermissions" ] = {
            ["canpromote"] = false,
            ["cankick"] = false,
            ["canedit"] = false
        },
        [ "Description" ] = ""
}

function CAKE.GetRankPermission( name )
    if CAKE.Group and CAKE.Group["Name"] != "none" and CAKE.Group["RankPermissions"] then
        return CAKE.Group["RankPermissions"][name]
    end
    return false
end

local function OpenUserAdministrator( userid, name, steamid, online )

end

datastream.Hook( "ReceiveGroup", function( handler, id, encoded, decoded )

    CAKE.Group = decoded
    PrintTable( CAKE.Group )

end )

datastream.Hook( "DisplayRoster", function( handler, id, encoded, decoded )
    
    local frame = vgui.Create( "DFrameTransparent" )
    frame:SetSize( 450, 328 )
    frame:Center()
    frame:SetTitle( "Roster Search Results" )
    frame:MakePopup()

    local panel = vgui.Create( "DPanelList", frame )
    panel:SetSize( 440, 300 )
    panel:EnableVerticalScrollbar( true )
    panel:SetAutoSize(true)

    if #decoded > 0 then

        local dlist = vgui.Create( "DListView" )
        panel:AddItem( dlist )
        dlist:AddColumn("Name")
        dlist:AddColumn("SteamID")
        dlist:AddColumn("UniqueID")
        dlist:AddColumn("Online?")
        dlist.OnClickLine = function(parent, line, isselected)
            OpenUserAdministrator( line:GetValue(3), line:GetValue(1), line:GetValue(2), line:GetValue(4) )
        end

        local online = ""
        for k, v in pairs( decoded ) do
            if v.Online then
                online = "Online"
            else
                online = "Offline"
            end
            dlist:AddLine( v.Name, v.SteamID, v.Sig ,online )
        end

    else
        
        local label = vgui.Create( "DLabel" )
        label:SetText( "No results." )
        label:SetFont( "TiramisuTimeFont" )
        panel:AddItem( label )

    end

end)

usermessage.Hook( "DisplayInvite",  function( um )
    
    local group = um:ReadString()

    CAKE.Query( "You have been invited to join " .. group, "Group Invite",
        "Accept", function() RunConsoleCommand( "rp_joingroup", group ) end, 
        "Deny", function() print( "Denied invitation to join " .. group ) end
    )
    
end)

local function OpenGroups()
    PlayerMenu = vgui.Create( "DFrameTransparent" )
    PlayerMenu:SetSize( 250, 300 )
    PlayerMenu:Center()
    PlayerMenu:SetTitle( "My Group" )
    PlayerMenu:MakePopup()

    local panel = vgui.Create( "DPanelList", PlayerMenu )
    panel:SetPos( 5, 28 )
    panel:SetSpacing( 10 )
    panel:SetSize( 240, 267 )

    local label
    local button

    if CAKE.Group and CAKE.Group[ "Name" ] != "none" then
        label = vgui.Create( "DLabel" )
        label:SetText( CAKE.Group[ "Name"] )
        label:SetFont( "TiramisuTimeFont")
        panel:AddItem( label )

        label = vgui.Create( "DLabel" )
        label:SetText( "Type of group: " .. CAKE.Group[ "Type"] )
        panel:AddItem( label )

        label = vgui.Create( "DLabel" )
        label:SetText( "Founder: " .. CAKE.Group[ "Founder" ] )
        panel:AddItem( label )

        label = vgui.Create( "DLabel" )
        label:SetText( "Rank: " .. CAKE.Group[ "Rank" ] )
        panel:AddItem( label )

        label = vgui.Create( "DLabel" )
        label:SetText( "Description: " .. CAKE.Group[ "Description" ] )
        panel:AddItem( label )

        button = vgui.Create( "DButton" )
        button:SetText( "Look up members" )
        button.DoClick = function()
        end
        panel:AddItem( button )

        if CAKE.GetRankPermission( "canedit" ) then
            button = vgui.Create( "DButton" )
            button:SetText( "Edit Group Settings" )
            button.DoClick = function()
        end
            panel:AddItem( button )
        end

        button = vgui.Create( "DButton" )
        button:SetText( "Leave Group" )
        button.DoClick = function()
            RunConsoleCommand( "rp_joingroup", "none")
            if PlayerMenu then
                PlayerMenu:Remove()
                PlayerMenu = nil
            end
        end
        panel:AddItem( button )

    else
        label = vgui.Create( "DLabel" )
        label:SetText( "You don't belong to any groups yet!")
        label:SetFont( "TiramisuTimeFont")
        panel:AddItem( label )

        button = vgui.Create( "DButton" )
        button:SetText( "Create a new group" )
        button.DoClick = function()
        end
        panel:AddItem( button )

    end

end

local function CloseGroups()
	if PlayerMenu then
		PlayerMenu:Remove()
		PlayerMenu = nil
	end
end
function CLPLUGIN.Init()
    CAKE.RegisterMenuTab( "Groups", OpenGroups, CloseGroups )
end
