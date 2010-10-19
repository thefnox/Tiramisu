CLPLUGIN.Name = "Charcreation Menu"
CLPLUGIN.Author = "Matt/Ryaga"
--Yep, 650 lines of character creation, clientside. Beat that, Tacoscript 2

local function ErrorMessage( msg )
	Derma_Message(msg, "Error!", "OK")
end

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

local selectedrace = ""
local Age = "18"
local Birthplace = "United States of America"
local Height = 150
local Gender = "Male"
local Title1 = "Title1"
local Title2 = "Title2"
local FirstName = "First Name"
local LastName = "Last Name"
local Description = "Set your description"

function firststep()
		      
	      Step2 = vgui.Create( "DFrame" )
	      Step2:SetPos( ScrW() / 2 - 320, ScrH() / 2 - 240 )
	      Step2:SetSize( 700, 450 )
	      Step2:SetTitle( "Step 2" )
	      Step2:SetVisible( true )
	      Step2:SetDraggable( true )
	      Step2:ShowCloseButton( false )
	      Step2:MakePopup()

	      Step2Panel = vgui.Create( "DPanel", Step2 )
	      Step2Panel:SetPos( 2, 23 )
	      Step2Panel:SetSize( 698, 433 )
	      Step2Panel.Paint = function()
		      surface.SetDrawColor( 50, 50, 50, 255 )
		      surface.DrawRect( 0, 0, Step2Panel:GetWide(), Step2Panel:GetTall() )
	      end
	      
	      NewPanel = vgui.Create( "DPanelList", Step2Panel )
	      NewPanel:SetPos( 5,0 )
	      NewPanel:SetSize( 330, 375 )
	      NewPanel:SetSpacing( 5 ) -- Spacing between items
	      NewPanel:EnableHorizontal( false ) -- Only vertical items
	      NewPanel:EnableVerticalScrollbar( false ) -- Allow scrollbar if you exceed the Y axis
	      
	      local info = vgui.Create( "DForm" );
	      info:SetName("Personal Information");
	      info:SetSpacing( 3 )
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
			   end)
			   MenuButtonOptions:AddOption( "Female", function() 
				   Gender = "Female"
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
	      
	      Looks = vgui.Create( "DPanelList", Step2Panel )
	      Looks:SetPos( 343, 0 )
	      Looks:SetSize( 349, 375 )
	      Looks:SetSpacing( 5 ) -- Spacing between items
	      Looks:EnableHorizontal( false ) -- Only vertical items
	      Looks:EnableVerticalScrollbar( true ) -- Allow scrollbar if you exceed the Y axis
	      
	      local appearance = vgui.Create( "DForm" );
	      appearance:SetName("Appearance and Extra");
	      Looks:AddItem(appearance);
	      
	      local label = vgui.Create("DLabel");
	      appearance:AddItem(label);
	      label:SetSize(30,25);
	      label:SetPos(150, 50);
	      label:SetText("Description");
	      
	      local desc = vgui.Create("DTextEntry");
	      appearance:AddItem(desc);
	      desc:SetSize(305, 50);
	      desc:SetMultiline( true )
	      desc:SetPos(80, 80);
	      desc:SetText( Description );
	      
	      local heightlabel = vgui.Create("DLabel");
	      heightlabel:SetSize(30,25);
	      heightlabel:SetPos(150, 50);
	      heightlabel:SetText("No height selected yet." );
	      
	      local HeightSlider = vgui.Create("DNumSlider");
	      HeightSlider:SetMax( 200 );
	      HeightSlider:SetMin( 120 );
	      HeightSlider:SetText("Height");
	      HeightSlider:SetDecimals( 0 );
	      HeightSlider:SetWidth(300);
	      HeightSlider:SetPos(50, 590);
	      appearance:AddItem(HeightSlider);
	      HeightSlider.OnValueChanged = function()
		      local feet = math.floor( HeightSlider:GetValue() / 30 )
		      local fakeinches = HeightSlider:GetValue() - feet * 30
		      heightlabel:SetText("Metric: " .. HeightSlider:GetValue() / 100 .. " meters. Imperial: " .. tostring( feet ) .. "feet " .. tostring( fakeinches / 2.5 ) .. " inches." );
	      end
	      appearance:AddItem(heightlabel);
	      
	      local label = vgui.Create("DLabel");
	      appearance:AddItem(label);
	      label:SetSize(30,25);
	      label:SetPos(150, 50);
	      label:SetText(" ");
	      
	      local label = vgui.Create("DLabel");
	      appearance:AddItem(label);
	      label:SetSize(30,25);
	      label:SetPos(150, 50);
	      label:SetText("Birthplace:");
	      
	      local birthplace = vgui.Create("DTextEntry");
	      appearance:AddItem(birthplace);
	      birthplace:SetSize(205, 25);
	      birthplace:SetPos(80, 80);
	      birthplace:SetText( Birthplace );
	      
	      local AcceptButton = vgui.Create( "DButton", Step2 )
	      AcceptButton:SetSize( 200, 50)
	      AcceptButton:SetText( "Continue to next step" )
	      AcceptButton:SetPos( 425, 380 )
	      AcceptButton.DoClick = function ( btn )	      
		      if(firstname:GetValue() == "" ) then
			      ErrorMessage( "You must enter a first name!" )
			      return;
		      end
		      
		      if(numberwang:GetValue() < 18 ) then
			      ErrorMessage( "You must enter a valid age! (18+)" )
			      return;
		      end

		      if(numberwang:GetValue() > 70 ) then
			      ErrorMessage( "You cannot be that old!" )
			      return;
		      end
		      
		      if(HeightSlider:GetValue() < 1 ) then
			      ErrorMessage( "You must enter a valid height!" )
			      LocalPlayer():PrintMessage(3, "You must enter a valid height!");
			      return;
		      end
		      
		      Age = tostring( numberwang:GetValue() )
		      Birthplace = string.sub(birthplace:GetValue(), 1, 64)
		      Height = HeightSlider:GetValue() 
		      Title1 = string.sub(title:GetValue(), 1, 64)
		      Title2 = string.sub(title2:GetValue(), 1, 64)
		      FirstName = string.sub(firstname:GetValue(), 1, 64)
		      LastName = string.sub(lastname:GetValue(), 1, 64)
		      Description = string.sub( desc:GetValue(), 1, 230 )
		      Step2:Remove();
		      Step2 = nil;
		      secondstep()
	      end

end

function secondstep()
	      // Excuse the shittyness, hotfix.
	      
	      local demmodels = {}
	      demmodels = table.Copy( models[ string.lower( Gender ) ] )
	      
	      Step3 = vgui.Create( "DFrame" )
	      Step3:SetPos( ScrW() / 2 - 320, ScrH() / 2 - 400 )
	      Step3:SetSize( 615, 700 )
	      Step3:SetTitle( "Step 3" )
	      Step3:SetVisible( true )
	      Step3:SetDraggable( true )
	      Step3:ShowCloseButton( false )
	      Step3:MakePopup()
	      
	      ModelWindow = vgui.Create( "DPanel", Step3 )
	      
	      local mdlPanel = vgui.Create( "DModelPanel", ModelWindow )
	      mdlPanel:SetSize( 500, 500 )
	      mdlPanel:SetPos( 50, 60 )
			if demmodels and demmodels[1] then
				mdlPanel:SetModel( demmodels[1] )
			end
	      mdlPanel:SetAnimSpeed( 0.0 )
	      mdlPanel:SetAnimated( false )
	      mdlPanel:SetAmbientLight( Color( 50, 50, 50 ) )
	      mdlPanel:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
	      mdlPanel:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )
	      mdlPanel:SetCamPos( Vector( 50, 0, 50 ) )
	      mdlPanel:SetLookAt( Vector( 0, 0, 50 ) )
	      mdlPanel:SetFOV( 70 )
	      function mdlPanel:Think()
		      SetChosenModel(mdlPanel.Entity:GetModel());
	      end
	      local RotateSlider = vgui.Create("DNumSlider", ModelWindow);
	      RotateSlider:SetMax(360);
	      RotateSlider:SetMin(0);
	      RotateSlider:SetText("Rotate");
	      RotateSlider:SetDecimals( 0 );
	      RotateSlider:SetWidth(500);
	      RotateSlider:SetPos(50, 590);

	      local BodyButton = vgui.Create("DButton", ModelWindow);
	      BodyButton:SetText("Body");
	      BodyButton.DoClick = function()

		      mdlPanel:SetCamPos( Vector( 50, 0, 50) );
		      mdlPanel:SetLookAt( Vector( 0, 0, 50) );
		      mdlPanel:SetFOV( 70 );
		      
	      end
	      BodyButton:SetPos(10, 40);

	      local FaceButton = vgui.Create("DButton", ModelWindow);
	      FaceButton:SetText("Face");
	      FaceButton.DoClick = function()

		      mdlPanel:SetCamPos( Vector( 50, 0, 60) );
		      mdlPanel:SetLookAt( Vector( 0, 0, 60) );
		      mdlPanel:SetFOV( 40 );
		      
	      end
	      FaceButton:SetPos(10, 60);

	      local FarButton = vgui.Create("DButton", ModelWindow);
	      FarButton:SetText("Far");
	      FarButton.DoClick = function()
		      mdlPanel:SetCamPos( Vector( 100, 0, 30) );
		      mdlPanel:SetLookAt( Vector( 0, 0, 30) );
		      mdlPanel:SetFOV( 70 );
		      
	      end
	      FarButton:SetPos(10, 80);

	      function mdlPanel:LayoutEntity(Entity)

		      self:RunAnimation()
		      Entity:SetAngles( Angle( 0, RotateSlider:GetValue(), 0) )
		      
	      end

	      local i = 1;
	      
	      local LastMdl = vgui.Create( "DSysButton", ModelWindow )
	      LastMdl:SetType("left");
	      LastMdl.DoClick = function()
		      i = i - 1;
		      
		      if(i == 0) then
			      i = #demmodels;
		      end
		      
		      mdlPanel:SetModel(demmodels[i]);
		      
	      end

	      LastMdl:SetPos(10, 365);

	      local NextMdl = vgui.Create( "DSysButton", ModelWindow )
	      NextMdl:SetType("right");
	      NextMdl.DoClick = function()

		      i = i + 1;

		      if(i > #demmodels) then
			      i = 1;
		      end
		      
		      mdlPanel:SetModel(demmodels[i]);
		      
	      end
	      NextMdl:SetPos( 545, 365);
	      
	      ModelWindow:SetSize( 615, 640 )
	      ModelWindow:SetPos( 0, 23 )
	      ModelWindow.Paint = function()
		      surface.SetDrawColor( 50, 50, 50, 255 )
		      surface.DrawRect( 0, 0, ModelWindow:GetWide(), ModelWindow:GetTall() )
	      end
	      /*ModelPanel = vgui.Create( "DPanelList", NewCharMenu )
	      ModelPanel:SetPos( 0,23 )
	      ModelPanel:SetSize( 420, 660 )
	      ModelPanel:SetSpacing( 5 ) -- Spacing between items
	      ModelPanel:EnableHorizontal( false ) -- Only vertical items
	      ModelPanel:EnableVerticalScrollbar( true ) -- Allow scrollbar if you exceed the Y axis*/
	      
	      local GoBackButton = vgui.Create( "DButton", Step3 )
	      GoBackButton:SetSize( 150, 40 )
	      GoBackButton:SetText( "Go back to previous step" )
	      GoBackButton:SetPos( 75, 660 )
	      GoBackButton.DoClick = function( btn )
		      secondstep()
		      Step3:Remove();
		      Step3 = nil;
	      end
	      
	      local apply = vgui.Create("DButton", Step3);
	      apply:SetSize(150, 40);
	      apply:SetText("Accept, create character");
	      apply:SetPos( 375, 660 )
	      apply.DoClick = function ( btn )

		      /*if(!table.HasValue(models, ChosenModel)) then
			      LocalPlayer():PrintMessage(3, ChosenModel .. " is not a valid model!");
			      return;
		      end*/
		      
		      LocalPlayer():ConCommand("rp_startcreate");
		      LocalPlayer():ConCommand("rp_setmodel \"" .. ChosenModel .. "\"");
		      LocalPlayer():ConCommand("rp_changename \"" .. FirstName .. " " .. LastName .. "\"");
		      LocalPlayer():ConCommand("rp_title " .. Title1 );
		      LocalPlayer():ConCommand("rp_title2 " .. Title2 );
		      LocalPlayer():ConCommand("rp_setheight " .. tostring(Height / 180 ) );
		      LocalPlayer():ConCommand("rp_setage " .. Age )
		      LocalPlayer():ConCommand("rp_setbirthplace \"" .. Birthplace .. "\"" )
		      LocalPlayer():ConCommand("rp_setgender " .. Gender )
		      LocalPlayer():ConCommand("rp_setdescription \"" .. tostring( Description ) .. "\"" )
		      LocalPlayer().MyModel = ""
		      LocalPlayer():ConCommand("rp_finishcreate");
		      
		      Step3:Remove();
		      Step3 = nil;
		      
	      end
end



function CLPLUGIN.Init()

	CAKE.AddStep(firststep)
	CAKE.AddStep(secondstep)
	
end
