CLPLUGIN.Name = "Charcreation Menu"
CLPLUGIN.Author = "Matt/Ryaga"

local models = {}
models[ "male" ] = {

	"models/humans/group01/male_01.mdl",
	"models/humans/group01/male_02.mdl",
	"models/humans/group01/male_03.mdl",
	"models/humans/group01/male_04.mdl",
	"models/humans/group01/male_05.mdl",
	"models/humans/group01/male_06.mdl",
	"models/humans/group01/male_07.mdl",
	"models/humans/group01/male_08.mdl",
	"models/humans/group01/male_09.mdl"

}
models[ "female" ] = {

	"models/Humans/Group01/Female_01.mdl",
	"models/Humans/Group01/Female_02.mdl",
	"models/Humans/Group01/Female_03.mdl",
	"models/Humans/Group01/Female_04.mdl",
	"models/Humans/Group01/Female_06.mdl",
	"models/Humans/Group01/Female_07.mdl"

}

local Age = "30"
local Gender = "Male"
local Title1 = "Title1"
local Title2 = "Title2"
local FirstName = "Set Your"
local LastName = "Name"

local function firststep()
	Step1 = vgui.Create( "DFrameTransparent" )
	Step1:SetSize( 675, 410 )
	Step1:SetPos( ScrW() / 2 - Step1:GetWide() / 2, ScrH() / 2 - Step1:GetTall() / 2 )
	Step1:SetTitle( "Create your Character" )
	Step1:SetVisible( true )
	Step1:SetDraggable( true )
	Step1:ShowCloseButton( false )
	Step1:MakePopup()

	local mdlPanel = vgui.Create( "DModelPanel", Step1 )
	mdlPanel:SetSize( 300, 300 )
	mdlPanel:SetPos( 360, 28 )
	mdlPanel:SetAnimSpeed( 0.0 )
	mdlPanel:SetAnimated( false )
	mdlPanel:SetModel( models[ "male" ][1] )
	mdlPanel:SetAmbientLight( Color( 50, 50, 50 ) )
	mdlPanel:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
	mdlPanel:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )
	mdlPanel:SetCamPos( Vector( 50, 0, 50 ) )
	mdlPanel:SetLookAt( Vector( 0, 0, 50 ) )
	mdlPanel:SetFOV( 70 )

	local RotateSlider = vgui.Create("DNumSlider", Step1);
	RotateSlider:SetMax(360);
	RotateSlider:SetMin(0);
	RotateSlider:SetText("Rotate");
	RotateSlider:SetDecimals( 0 );
	RotateSlider:SetWidth(300);
	RotateSlider:SetPos(360, 290);

	function mdlPanel:LayoutEntity(Entity)

		Entity:SetAngles( Angle( 0, RotateSlider:GetValue(), 0) )

	end

	local i = 1;

	local LastMdl = vgui.Create( "DSysButton", Step1 )
	LastMdl:SetPos( 355, 128 )
	LastMdl:SetSize( 30, 30)
	LastMdl:SetType("left");
	LastMdl.DoClick = function()
		i = i - 1;
		
		if(i == 0) then
			i = #models[ string.lower( Gender ) ];
		end
		
		mdlPanel:SetModel(models[ string.lower( Gender ) ][i]);
		
	end

	local NextMdl = vgui.Create( "DSysButton", Step1 )
	NextMdl:SetPos( 635, 128 )
	NextMdl:SetSize( 30,30 )
	NextMdl:SetType("right");
	NextMdl.DoClick = function()

		i = i + 1;

		if(i > #models[ string.lower( Gender ) ]) then
			i = 1;
		end
		
		mdlPanel:SetModel(models[ string.lower( Gender ) ][i]);
		
	end

	NewPanel = vgui.Create( "DPanelList", Step1 )
	NewPanel:SetPos( 5,28 )
	NewPanel:SetSize( 340, 375 )
	NewPanel:SetSpacing( 5 ) -- Spacing between items
	NewPanel:EnableHorizontal( false ) -- Only vertical items
	NewPanel:EnableVerticalScrollbar( false ) -- Allow scrollbar if you exceed the Y axis

	local info = vgui.Create( "DForm" );
	info:SetName("Personal Information");
	info:SetSpacing( 3 )
	info.Paint = function() end
	NewPanel:AddItem(info);

	local label = vgui.Create("DLabel");
	info:AddItem(label);
	label:SetSize(30,25);
	label:SetPos(150, 50);
	label:SetText("First: ");

	local firstname = vgui.Create("DTextEntry");
	info:AddItem(firstname);
	firstname:SetSize(100,25);
	firstname:SetPos(185, 50);
	firstname:SetText(FirstName);

	local label = vgui.Create("DLabel");
	info:AddItem(label);
	label:SetSize(30,25);
	label:SetPos(5, 50);
	label:SetText("Last: ");

	local lastname = vgui.Create("DTextEntry");
	info:AddItem(lastname);
	lastname:SetSize(100,25);
	lastname:SetPos(40, 50);
	lastname:SetText(LastName);

	local label = vgui.Create("DLabel");
	info:AddItem(label);
	label:SetSize(100,25);
	label:SetPos(5, 80);
	label:SetText("Title: ");

	local title = vgui.Create("DTextEntry");
	info:AddItem(title);
	title:SetSize(205, 25);
	title:SetPos(80, 80);
	title:SetText(Title1);

	local label = vgui.Create("DLabel");
	info:AddItem(label);
	label:SetSize(100,25);
	label:SetPos(5, 80);
	label:SetText("Title 2: ");

	local title2 = vgui.Create("DTextEntry");
	info:AddItem(title2);
	title2:SetSize(205, 25);
	title2:SetPos(80, 80);
	title2:SetText(Title2);

	local label = vgui.Create("DLabel");
	info:AddItem(label);
	label:SetSize(30,25);
	label:SetPos(150, 50);
	label:SetText("Gender");

	local MenuButton = vgui.Create("DButton")
	MenuButton:SetText( "Gender" )
	MenuButton:SetPos(25, 50)
	MenuButton:SetSize( 190, 25 )
	MenuButton.DoClick = function ( btn )
		local MenuButtonOptions = DermaMenu()
		MenuButtonOptions:AddOption( "Male", function() 
			Gender = "Male"
			mdlPanel:SetModel( models[ "male" ][1] )
		end)
		MenuButtonOptions:AddOption( "Female", function() 
			Gender = "Female"
			mdlPanel:SetModel( models[ "female" ][1] )
		end )
		MenuButtonOptions:Open()
	end 
	info:AddItem(MenuButton);

	local label = vgui.Create("DLabel");
	info:AddItem(label);
	label:SetSize(30,25);
	label:SetPos(150, 50);
	label:SetText("Age: ");

	local numberwang = vgui.Create( "DNumberWang" )
	info:AddItem(numberwang);
	numberwang:SetSize(30,25);
	numberwang:SetMin( 8 )
	numberwang:SetMax( 89 )
	numberwang:SetDecimals( 0 )

	local GoBackButton = vgui.Create( "DButton", Step1 )
	GoBackButton:SetSize( 150, 40)
	GoBackButton:SetText( "Go back to Selection" )
	GoBackButton:SetPos( 355, 355 )
	GoBackButton.DoClick = function ( btn )
		OpenCharacterMenu()
		Step1:Remove()
		Step1 = nil
	end

	local AcceptButton = vgui.Create( "DButton", Step1 )
	AcceptButton:SetSize( 150, 40)
	AcceptButton:SetText( "Create Character" )
	AcceptButton:SetPos( 515, 355 )
	AcceptButton.DoClick = function ( btn )
		if(firstname:GetValue() == "" ) then
			CAKE.Message("You must enter a first name!", "Error!", "OK", Color( 140, 100, 100))
			return;
		end

		if(numberwang:GetValue() < 1 ) then
			CAKE.Message("You must enter a valid age!", "Error!", "OK", Color( 140, 100, 100))
			return;
		end

		Age = tostring( numberwang:GetValue() )
		Title1 = string.sub(title:GetValue(), 1, 64)
		Title2 = string.sub(title2:GetValue(), 1, 64)
		FirstName = string.sub(firstname:GetValue(), 1, 64)
		LastName = string.sub(lastname:GetValue(), 1, 64)

		LocalPlayer():ConCommand("rp_startcreate");
		LocalPlayer():ConCommand("rp_setmodel \"" .. mdlPanel.Entity:GetModel() .. "\"");
		LocalPlayer():ConCommand("rp_changename \"" .. FirstName .. " " .. LastName .. "\"");
		LocalPlayer():ConCommand("rp_title " .. Title1 );
		LocalPlayer():ConCommand("rp_title2 " .. Title2 );
		LocalPlayer():ConCommand("rp_setage " .. Age )
		LocalPlayer():ConCommand("rp_setgender " .. Gender )
		LocalPlayer().MyModel = ""
		LocalPlayer():ConCommand("rp_finishcreate");

		OpenCharacterMenu()
		Step1:Remove();
		Step1 = nil;
	end
end

function CLPLUGIN.Init()

	CAKE.RegisterCharCreate(firststep)
	
end
