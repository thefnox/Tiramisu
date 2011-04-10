

CAKE.ContextEnabled = false;

local function ToggleThirdperson( um )

	if CAKE.Thirdperson:GetBool() then
		RunConsoleCommand( "rp_thirdperson", "0" )
	else
		RunConsoleCommand( "rp_thirdperson", "1" )
	end

end
usermessage.Hook( "togglethirdperson", ToggleThirdperson)

local function ToggleInventory( um )

	CAKE.SetActiveTab( "Inventory" )

end
usermessage.Hook( "toggleinventory", ToggleInventory)

function GM:PlayerBindPress( ply, bind, pressed )

	if( LocalPlayer( ):GetNWInt( "charactercreate" ) == 1 ) then
	
		if( bind == "+forward" or bind == "+back" or bind == "+moveleft" or bind == "+moveright" or bind == "+jump" or bind == "+duck" ) then return true; end -- Disable ALL movement keys.
	
	end

end

local params = {
	["$basetexture"] = "tiramisu/tabbutton2",
	["$translucent"] = 1,
	["$color"] = "{" .. CAKE.BaseColor.r .. " " .. CAKE.BaseColor.g .. " " .. CAKE.BaseColor.b .. "}"
}
local tabmaterial = CreateMaterial("TabMaterial","UnlitGeneric",params);

function GM:ScoreboardShow( )

	CAKE.ContextEnabled = true;
	CAKE.MenuOpen = true
	gui.EnableScreenClicker( true )
	HiddenButton:SetVisible( true );

	if QuickMenu then
		QuickMenu:Remove()
		Quickmenu = nil
	end

	QuickMenu = vgui.Create("DFrame");
	QuickMenu:SetSize( 260, 400 )
	QuickMenu:SetPos( ScrW() + 130, 200 )
	QuickMenu:SetTitle( "" )
	QuickMenu:SetDraggable( false ) -- Draggable by mouse?
	QuickMenu:ShowCloseButton( false ) -- Show the close button?
	QuickMenu.Paint = function() end

	local lastpos = 0
	for k, v in pairs( CAKE.MenuTabs ) do
		lastpos = lastpos + 30
		local label = vgui.Create( "DImageButton", QuickMenu )
		label.m_Image:SetMaterial( tabmaterial )
		label:SetSize( 256, 28 )
		label.DoClick = function()
			CAKE.SetActiveTab(k)
		end
		label.Paint = function() end
		label.PaintOver = function()
			draw.DrawText(k, "TiramisuTabsFont", 80, 8, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
		end
		label:SetPos( 5, lastpos)
		label:SetExpensiveShadow( 1, Color( 10, 10, 10, 255 ) )
	end

	/*

	VitalsMenu = vgui.Create( "DFrame" )
	VitalsMenu:SetSize( 340, 230 )
	VitalsMenu:SetTitle( "" )
	VitalsMenu:SetVisible( true )
	VitalsMenu:SetDraggable( false )
	VitalsMenu:ShowCloseButton( false )
	VitalsMenu:SetDeleteOnClose( true )
	VitalsMenu:SetPos( -340, 200 )
	VitalsMenu.Paint = function()
	end

	local PlayerInfo = vgui.Create( "DPanelList", VitalsMenu )
	PlayerInfo:SetSize( 240, 200 )
	PlayerInfo:SetPos( 0, 23 )
	PlayerInfo:SetPadding(10);
	PlayerInfo:SetSpacing(10);
	PlayerInfo:EnableHorizontal(false);
	function PlayerInfo:Paint()
	end

	local icdata = vgui.Create( "DForm" );
	icdata:SetPadding(4);
	icdata:SetName(LocalPlayer():Nick() or "");

	local FullData = vgui.Create("DPanelList");
	FullData:SetSize(0, 84);
	FullData:SetPadding(10);

	local DataList = vgui.Create("DPanelList");
	DataList:SetSize(0, 64);

	local spawnicon = vgui.Create( "SpawnIcon");
	spawnicon:SetModel(LocalPlayer():GetNWString( "model", LocalPlayer():GetModel()) );
	spawnicon:SetSize( 64, 64 );
	DataList:AddItem(spawnicon);

	local DataList2 = vgui.Create( "DPanelList" )

	local label2 = vgui.Create("MarkupLabel");
	label2:SetMaxWidth( 140 )
	label2:SetText("Title: " .. LocalPlayer():GetNWString("title", ""));
	DataList2:AddItem(label2);

	local label4 = vgui.Create("MarkupLabel");
	label4:SetText( CurrencyTable.name .. ": " .. LocalPlayer():GetNWString("money", "0" ));
	DataList2:AddItem(label4);

	local Divider = vgui.Create("DHorizontalDivider");
	Divider:SetLeft(spawnicon);
	Divider:SetRight(DataList2);
	Divider:SetLeftWidth(64);
	Divider:SetHeight(64);

	DataList:AddItem(spawnicon);
	DataList:AddItem(DataList2);
	DataList:AddItem(Divider);

	FullData:AddItem(DataList)

	icdata:AddItem(FullData)

	local vitals = vgui.Create( "DForm" );
	vitals:SetPadding(4);
	vitals:SetName("Vital Signs");

	local VitalData = vgui.Create("DPanelList");
	VitalData:SetAutoSize(true)
	VitalData:SetPadding(10);
	vitals:AddItem(VitalData);

	local healthstatus = ""
	local hp = LocalPlayer():Health();

	if(!LocalPlayer():Alive()) then healthstatus = "Dead";
	elseif(hp > 95) then healthstatus = "<color=green>Healthy</color>";
	elseif(hp > 50 and hp < 95) then healthstatus = "OK";
	elseif(hp > 30 and hp < 50) then healthstatus = "<color=ltred>Near Death</color>";
	elseif(hp > 1 and hp < 30) then healthstatus = "<color=red>Death Imminent</color>"; end

	local health = vgui.Create("MarkupLabel");
	health:SetText("Vitals: " .. healthstatus);
	health:SetMaxWidth( 200 )
	VitalData:AddItem(health);

	PlayerInfo:AddItem(icdata)
	PlayerInfo:AddItem(vitals)
	*/
	local posx, posy
	timer.Create( "quickmenuscrolltimer", 0.01, 0, function()
		if QuickMenu then
			posx, posy = QuickMenu:GetPos( )
			QuickMenu:SetPos( Lerp( 0.2, posx, ScrW() - 128 ), 200 )
		else
			timer.Destroy( "quickmenuscrolltimer" )
		end
	end )
	
end

function GM:ScoreboardHide( )

	CAKE.MenuOpen = false
	CAKE.ContextEnabled = false;
	gui.EnableScreenClicker( false );
	if HiddenButton then
		HiddenButton:SetVisible( false );
	end

	local posx, posy
	if QuickMenu then
		QuickMenu:Remove()
		QuickMenu = nil
	end
	if VitalsMenu then
		VitalsMenu:Remove()
		VitalsMenu = nil
	end
	
end