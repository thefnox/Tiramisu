CLPLUGIN.Name = "Clientside Group Utilities"
CLPLUGIN.Author = "FNox"

local function OpenUserAdministrator( userid, name, steamid, online )

end

datastream.Hook( "ReceiveGroup", function( handler, id, encoded, decoded )


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

    local dlist = vgui.CReate( "DListView" )
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

end)

local function OpenGroups()

end

local function CloseGroups()
	if PlayerMenu then
		PlayerMenu:Remove()
		PlayerMenu = nil
	end
end
--CAKE.RegisterMenuTab( "Groups", OpenGroups, CloseGroups )

function CLPLUGIN.Init()

end
