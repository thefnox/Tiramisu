CLPLUGIN.Name = "Vitals Menu"
CLPLUGIN.Author = "F-Nox/Big Bang"



local function OpenVitals()
	PlayerMenu = vgui.Create( "DFrame" )
	PlayerMenu:SetSize( 640, 480 )
	PlayerMenu:SetTitle( "Vitals" )
	PlayerMenu:SetVisible( true )
	PlayerMenu:SetDraggable( true )
	PlayerMenu:ShowCloseButton( true )
	PlayerMenu:SetDeleteOnClose( true )
	PlayerMenu:Center()
	function PlayerMenu:Paint()
	end
	
	local PlayerInfo = vgui.Create( "DPanelList", PlayerMenu )
	PlayerInfo:SetSize( 640, 450 )
	PlayerInfo:SetPos( 0, 23 )
	PlayerInfo:SetPadding(10);
	PlayerInfo:SetSpacing(10);
	PlayerInfo:EnableHorizontal(false);
	
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
	
	local label2 = vgui.Create("DLabel");
	label2:SetText("Title: " .. LocalPlayer():GetNWString("title", ""));
	DataList2:AddItem(label2);
	
	local label3 = vgui.Create("DLabel");
	label3:SetText("Title 2: " .. LocalPlayer():GetNWString("title2", ""));
	DataList2:AddItem(label3);
	
	local label4 = vgui.Create("DLabel");
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
	elseif(hp > 95) then healthstatus = "Healthy";
	elseif(hp > 50 and hp < 95) then healthstatus = "OK";
	elseif(hp > 30 and hp < 50) then healthstatus = "Near Death";
	elseif(hp > 1 and hp < 30) then healthstatus = "Death Imminent"; end
	
	local health = vgui.Create("DLabel");
	health:SetText("Vitals: " .. healthstatus);
	VitalData:AddItem(health);
	
	local Tools = vgui.Create( "DForm" );
	Tools:SetPadding(4);
	Tools:SetAutoSize( false )
	Tools:SetName("Player Tools");
	
	local ToolData = vgui.Create("DPanelList");
	ToolData:SetAutoSize(true)
	ToolData:SetPadding(10);
	ToolData:SetSpacing(4);
	Tools:AddItem(ToolData );
	
	local modellabel = vgui.Create("DLabel");
	modellabel:SetSize(30,25);
	modellabel:SetPos(5, 50);
	modellabel:SetText("Model: ")
	
	local modelname = vgui.Create("DTextEntry");
	modelname:SetSize(450,20);
	modelname:SetPos(390, 50);
	modelname:SetText("");
	
	local permacheck = vgui.Create( "DCheckBoxLabel" )
	permacheck:SetText( "Permanently change your model" )
	
	local specialcheck = vgui.Create( "DCheckBoxLabel" )
	specialcheck:SetText( "Non bipedal/prop/special model" )
	
	local selectedpart = 0
	local bodypart = vgui.Create( "DMultiChoice" )
	bodypart:AddChoice("Whole Body")
	bodypart:AddChoice("Torso/Legs")
	bodypart:AddChoice("Head")
	bodypart:AddChoice("Hands")
	bodypart:ChooseOptionID( 1 )
	function bodypart:OnSelect(index,value,data)
		selectedpart = index - 1
		print( tostring( selectedpart ) )
	end
		
	local settemp = vgui.Create("DButton");
	settemp:SetSize(75, 25);
	settemp:SetText("Change Your Model");
	settemp.DoClick = function ( btn )
		
		if(modelname:GetValue() == "" ) then
			LocalPlayer():PrintMessage(3, "You must enter a model's file path!");
			return;
		end
		 
		local permabool = permacheck:GetChecked(true)
		local permastr = "0"
		local specialbool = specialcheck:GetChecked(true)
		local specialstr = "0"
		if permabool then permastr = "1" end
		if specialbool then specialstr = "1" end
		
		LocalPlayer():ConCommand("rp_changemodel \"" .. modelname:GetValue() .. "\" " .. permastr .. " " .. specialstr .. " " .. tostring(selectedpart));
		
	end
	
	
	ToolData:AddItem(modellabel)
	ToolData:AddItem(modelname)
	ToolData:AddItem(settemp)
	ToolData:AddItem(permacheck)
	ToolData:AddItem(specialcheck)
	ToolData:AddItem(bodypart)
	
	PlayerInfo:AddItem(icdata)
	PlayerInfo:AddItem(vitals)
	PlayerInfo:AddItem(Tools)
end

local function CloseVitals()
	if PlayerMenu then
		PlayerMenu:Remove()
		PlayerMenu = nil
	end
end
CAKE.RegisterMenuTab( "Vitals", OpenVitals, CloseVitals )

function CLPLUGIN.Init()
	
end