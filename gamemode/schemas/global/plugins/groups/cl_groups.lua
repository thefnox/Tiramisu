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
            ["canedit"] = false,
            ["canbuy"] = false
        },
        [ "Ranks" ]     = {},
        [ "Description" ] = ""
}

function CAKE.GetRankPermission( name )
    if CAKE.Group and CAKE.Group["Name"] != "none" and CAKE.Group["RankPermissions"] then
        return CAKE.Group["RankPermissions"][name]
    end
    return false
end

local function OpenGroupAdministrator()
    local frame = vgui.Create( "DFrame" )
    frame:SetSize( 500, 378 )
    frame:Center()
    frame:SetTitle( "Group Editing" )
    frame:MakePopup()

    local psheet = vgui.Create( "DPropertySheet", frame )
    psheet:SetSize( 490, 345 )
    psheet:SetPos( 5, 28 )

    local editpanel = vgui.Create( "DPanelList" )
    editpanel:SetSpacing( 20 )
    editpanel:SetPadding( 20  )
    editpanel:EnableVerticalScrollbar( true )

    local textbox = vgui.Create("DTextEntry" )
    textbox:SetValue( CAKE.Group[ "Description" ] )
    textbox:SetMultiline(true)
    textbox:SetSize(300,200)
    editpanel:AddItem( textbox )

    local button = vgui.Create( "DButton" )
    button:SetSize( 100, 30 )
    button:SetText( "Set Description")
    button.DoClick = function()
        RunConsoleCommand( "rp_setgroupfield", "Description", textbox:GetValue())
    end
    editpanel:AddItem( button )

    psheet:AddSheet("Description", editpanel, "gui/silkicons/wrench", false, false, "Editing Group Description")

    local rankpanel = vgui.Create( "DPanelList" )
    rankpanel:SetSpacing( 10 )
    rankpanel:SetPadding( 20 )
    rankpanel:EnableVerticalScrollbar( true )

    local dlist = vgui.Create( "DListView" )
    rankpanel:AddItem( dlist )
    dlist:AddColumn("Formal Name")
    dlist:AddColumn("Handler")
    dlist.OnClickLine = function(parent, line, isselected)
        RunConsoleCommand( "rp_beginrankediting", line:GetValue(2) )
        if frame then
            frame:Remove()
            frame = nil
        end
    end
    for k, v in pairs( CAKE.Group["Ranks"] ) do
        dlist:AddLine( v, k )
    end
    dlist:SetSize( 100, 230 )

    local button = vgui.Create( "DButton" )
    button:SetSize( 100, 30 )
    button:SetText( "Create New Rank")
    button.DoClick = function()
        if frame then
            frame:Remove()
            frame = nil
        end
        local rankframe = vgui.Create( "DFrame" )
        rankframe:SetSize( 250, 300 )
        rankframe:Center()
        rankframe:SetTitle( "Create New Rank" )
        rankframe:MakePopup()

        local panel = vgui.Create( "DPanelList", rankframe )
        panel:SetPos( 5, 28 )
        panel:SetSpacing( 10 )
        panel:SetSize( 240, 267 )

        panel:AddItem( Label( "Handle:" ) )
        local handle = vgui.Create( "DTextEntry" )
        panel:AddItem( handle )

        panel:AddItem( Label( "Formal Name:" ) )
        local formalname = vgui.Create( "DTextEntry" )
        panel:AddItem( formalname )

        local canedit = vgui.Create( "DCheckBoxLabel" )
        canedit:SetText( "Allow this rank to edit the group's configuration")
        panel:AddItem( canedit )

        local cankick = vgui.Create( "DCheckBoxLabel" )
        cankick:SetText( "Allow this rank to kick people from the group")
        panel:AddItem( cankick )

        local canpromote = vgui.Create( "DCheckBoxLabel" )
        canpromote:SetText( "Allow this rank to promote people" )
        panel:AddItem( canpromote )

        local level = vgui.Create( "DNumSlider" )
        level:SetMax( 9 )
        level:SetMin( 0 )
        level:SetDecimals( 0 )
        level:SetText( "Level ( Hierarchy )")
        panel:AddItem( level )

        local accept = vgui.Create( "DButton" )
        accept:SetText( "Create new rank" )
        accept.DoClick = function()
            RunConsoleCommand( "rp_createrank", handle:GetValue(), formalname:GetValue(), level:GetValue(), tonumber( canedit:GetChecked() ), tonumber( cankick:GetChecked() ), tonumber( canpromote:GetChecked() ) )
            if rankframe then
                rankframe:Remove()
                rankframe = nil
            end
        end
        panel:AddItem( accept )
    end
    rankpanel:AddItem( button )

    psheet:AddSheet("Ranks", rankpanel, "gui/silkicons/user", false, false, "Rank Editor")

end

local function OpenUserAdministrator( rank, name, steamid, online )
    local frame = vgui.Create( "DFrame" )
    frame:SetSize( 200, 250 )
    frame:Center()
    frame:SetTitle( "Character info: " .. name )
    frame:MakePopup()

    local panel = vgui.Create( "DPanelList", frame )
    panel:SetSpacing( 10 )
    panel:SetPadding( 5 )
    panel:SetSize( 190, 222 )
    panel:SetPos( 5, 28 )

    local label
    label = vgui.Create( "DLabel" )
    label:SetText( name )
    label:SetFont( "Tiramisu18Font" )
    panel:AddItem( label )

    label = vgui.Create( "DLabel" )
    label:SetText( "Rank: " .. rank )
    panel:AddItem( label )

    label = vgui.Create( "DLabel" )
    label:SetText( "SteamID: " .. steamid )
    panel:AddItem( label )

    label = vgui.Create( "DLabel" )
    label:SetText( "Status: " .. online )
    panel:AddItem( label )

    local kickbutton = vgui.Create( "DButton" )
    kickbutton:SetText( "Kick from group" )
    kickbutton.DoClick = function()
        CAKE.Query( "Are you sure you want to kick " .. name .. "? (Cannot be undone)", "Confirm action",
            "Accept", function() RunConsoleCommand( "rp_kickfromgroup", name ) end, 
            "Cancel", function() end
        )
    end
    panel:AddItem( kickbutton )

    local promotebutton = vgui.Create( "DButton" )
    promotebutton:SetText( "Promote" )
    promotebutton.DoClick = function()
        CAKE.ChoiceRequest( "Confirm Promotion",
        "Select the rank you want to promote " .. name .. " to, then press 'Accept'" ,
        CAKE.Group[ "Ranks" ],
        function( choice ) RunConsoleCommand( "rp_promote", choice ) end,
        function( choice ) end,
        "Accept",
        "Cancel")
    end
    panel:AddItem( promotebutton )

end

datastream.Hook( "ReceiveGroup", function( handler, id, encoded, decoded )

    CAKE.Group = decoded

end )

datastream.Hook( "DisplayRoster", function( handler, id, encoded, decoded )
    
    local frame = vgui.Create( "DFrame" )
    frame:SetSize( 450, 328 )
    frame:Center()
    frame:SetTitle( "Roster Search Results" )
    frame:MakePopup()

    local panel = vgui.Create( "DPanelList", frame )
    panel:SetPos( 5, 28 )
    panel:SetSize( 440, 295 )
    panel:EnableVerticalScrollbar( true )

    if #decoded > 0 then

        local dlist = vgui.Create( "DListView" )

        dlist:AddColumn("Name")
        dlist:AddColumn("SteamID")
        dlist:AddColumn("Rank")
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
            dlist:AddLine( v.Name, v.SteamID, v.Rank ,online )
        end
        dlist:SetSize( 440, 295 )
        panel:AddItem( dlist )

    else
        
        local label = vgui.Create( "DLabel" )
        label:SetText( "No results." )
        label:SetFont( "Tiramisu18Font" )
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
    PlayerMenu = vgui.Create( "DFrame" )
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
        label:SetFont( "Tiramisu18Font")
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
        label:SetWrap( true )
        label:SetSize( 100, 30 )
        panel:AddItem( label )

        button = vgui.Create( "DButton" )
        button:SetText( "Look up members" )
        button.DoClick = function()
            CAKE.StringRequest( "Group Roster Search", "Please enter your search string. Valid search strings are SteamIDs, character names and ranks.", LocalPlayer():Nick(),
            function( entry )
                RunConsoleCommand( "rp_rostersearch", entry )
            end,
            function() end, "Search", "Cancel" )
        end
        panel:AddItem( button )

        if CAKE.GetRankPermission( "canedit" ) then
            button = vgui.Create( "DButton" )
            button:SetText( "Edit Group Settings" )
            button.DoClick = function()
                OpenGroupAdministrator()
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
        label:SetFont( "Tiramisu18Font")
        panel:AddItem( label )

        button = vgui.Create( "DButton" )
        button:SetText( "Create a new group" )
        button.DoClick = function()
            BeginGroupCreation()
            if PlayerMenu then
                PlayerMenu:Remove()
                PlayerMenu = nil
            end
        end
        panel:AddItem( button )

    end

end

function BeginGroupCreation()
    CAKE.StringRequest( "Group Creation Query", "Please enter the name of the group you want to create", "My Group",
    function( entry )
        RunConsoleCommand( "rp_creategroup", entry )
    end,
    function() end, "Create Group", "Cancel" )
end

usermessage.Hook( "DenyGroupCreation", function( um )
    
    BeginGroupCreation()
    CAKE.Message( "Group " .. um:ReadString() .. " already exists! Choose another name.", "Error!", "OK",  Color( 140, 100, 100) )

end)

usermessage.Hook( "EditRank", function( um )
    
    local handle = um:ReadString()
    
    local editframe = vgui.Create( "DFrame" )
    editframe:SetSize( 250, 300 )
    editframe:Center()
    editframe:SetTitle( "Editing rank: " .. handle )
    editframe:MakePopup()

    local panel = vgui.Create( "DPanelList", editframe )
    panel:SetPos( 5, 28 )
    panel:SetSpacing( 10 )
    panel:SetSize( 240, 267 )

    panel:AddItem( Label( "Formal Name:" ) )
    local formalname = vgui.Create( "DTextEntry" )
    formalname:SetValue( um:ReadString() )
    panel:AddItem( formalname )

    local canedit = vgui.Create( "DCheckBoxLabel" )
    canedit:SetText( "Allow this rank to edit the group's configuration")
    canedit:SetValue( tonumber( um:ReadBool() ))
    panel:AddItem( canedit )

    local cankick = vgui.Create( "DCheckBoxLabel" )
    cankick:SetText( "Allow this rank to kick people from the group")
    cankick:SetValue( tonumber( um:ReadBool() ) )
    panel:AddItem( cankick )

    local canpromote = vgui.Create( "DCheckBoxLabel" )
    canpromote:SetText( "Allow this rank to promote people" )
    canpromote:SetValue( tonumber(um:ReadBool()) )
    panel:AddItem( canpromote )

    local defaultrank = vgui.Create( "DCheckBoxLabel" )
    defaultrank:SetText( "Make this the default rank" )
    panel:AddItem( defaultrank )

    local level = vgui.Create( "DNumSlider" )
    level:SetMax( 9 )
    level:SetMin( 0 )
    level:SetValue( um:ReadShort() )
    level:SetDecimals( 0 )
    level:SetText( "Level ( Hierarchy )")
    panel:AddItem( level )

    local accept = vgui.Create( "DButton" )
    accept:SetText( "Finish editing rank" )
    accept.DoClick = function()
        RunConsoleCommand( "rp_editrank", handle, formalname:GetValue(), level:GetValue(), tonumber( canedit:GetChecked() ), tonumber( cankick:GetChecked() ), tonumber( canpromote:GetChecked() ),  tonumber( defaultrank:GetChecked() ) )
        if editframe then
            editframe:Remove()
            editframe = nil
        end
    end
    panel:AddItem( accept )

end)

local function CloseGroups()
	if PlayerMenu then
		PlayerMenu:Remove()
		PlayerMenu = nil
	end
end
function CLPLUGIN.Init()
    CAKE.RegisterMenuTab( "Groups", OpenGroups, CloseGroups )
end
