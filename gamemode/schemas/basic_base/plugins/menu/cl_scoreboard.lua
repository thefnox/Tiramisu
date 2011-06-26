CLPLUGIN.Name = "Scoreboard Menu"
CLPLUGIN.Author = "F-Nox/Big Bang"


local function OpenScoreboard()

	PlayerMenu = vgui.Create( "DFrameTransparent" )
	PlayerMenu:SetSize( 640, 480 )
	PlayerMenu:SetTitle( "Scoreboard" )
	PlayerMenu:SetVisible( true )
	PlayerMenu:SetDraggable( true )
	PlayerMenu:ShowCloseButton( true )
	PlayerMenu:SetDeleteOnClose( true )
	PlayerMenu:Center()
	
	Scoreboard = vgui.Create( "DPanelList", PlayerMenu )
	Scoreboard:SetSize( 630, 448 )
	Scoreboard:SetPos( 5, 28 )
	Scoreboard:SetPadding(0);
	Scoreboard:SetSpacing(0);

	-- Let's draw the SCOREBOARD.
	
	for k, v in pairs(player.GetAll()) do
		local DataList = vgui.Create("DPanelList");
		DataList:SetAutoSize( true )
		
		local CollapsableCategory = vgui.Create("DCollapsibleCategory");
		CollapsableCategory:SetExpanded( 0 )
		CollapsableCategory:SetLabel( v:Nick() );
		Scoreboard:AddItem(CollapsableCategory);
		
		local spawnicon = vgui.Create( "SpawnIcon");
		spawnicon:SetModel(v:GetNWString( "model", "models/kleiner.mdl") )
		spawnicon:SetSize( 64, 64 );
		DataList:AddItem(spawnicon);
		
		local DataList2 = vgui.Create( "DPanelList" )
		DataList2:SetAutoSize( true )
		
		local label = vgui.Create("DLabel");
		label:SetText("OOC Name: " .. v:Name());
		DataList2:AddItem(label);

		DataList2:AddItem(MarkupLabel( "Title:" .. v:GetNWString("title"), 620, DataList2 ))
		
		local Divider = vgui.Create("DHorizontalDivider");
		Divider:SetLeft(spawnicon);
		Divider:SetRight(DataList2);
		Divider:SetLeftWidth(64);
		Divider:SetHeight(64);
		
		DataList:AddItem(spawnicon);
		DataList:AddItem(DataList2);
		DataList:AddItem(Divider);
		
		CollapsableCategory:SetContents(DataList);
	end
	

end

local function CloseScoreboard()
	if PlayerMenu then
		PlayerMenu:Remove()
		PlayerMenu = nil
	end
end
CAKE.RegisterMenuTab( "Scoreboard", OpenScoreboard, CloseScoreboard )


function CLPLUGIN.Init()
	
end