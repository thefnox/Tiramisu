--Same as the RLRP schema's character creation screen, only that this one does not use startout clothing.

local models = {}
models[ "Male" ] = {

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
models[ "Female" ] = {

	"models/Humans/Group01/Female_01.mdl",
	"models/Humans/Group01/Female_02.mdl",
	"models/Humans/Group01/Female_03.mdl",
	"models/Humans/Group01/Female_04.mdl",
	"models/Humans/Group01/Female_06.mdl",
	"models/Humans/Group01/Female_07.mdl"

}

local x, y
local Age = "30"
local Gender = "Male"
local Title1 = "Title1"
local Title2 = "Title2"
local CharName = "Set Your Name"
local SelectedClothing = "none"
local SelectedModel = "models/humans/group01/male_01.mdl"

local function CharacterCreation()

	RunConsoleCommand( "rp_thirdperson", 1 )

	if CharacterMenu then
		local panel = vgui.Create( "DPanelList", CharacterMenu)
		panel:SetSize( 230, 500 )
		panel:SetPos( ScrW() / 2  , ScrH() / 2 - 250 )
		panel:SetPadding( 0 )
		panel:SetSpacing( 5 )
		panel.Paint = function()
			x,y = panel:GetPos()
			if panel.SlideOut then
				panel:SetPos( Lerp( 0.1, x, ScrW() + 500 ) , ScrH() / 2 - 250)
				if x > ScrW() then
					panel:Remove()
					panel = nil
				end
			else
				--panel:SetPos( Lerp( 0.1, x, ScrW() / 2 ) , ScrH() / 2 - 250)
			end
		end

		local label

		label = vgui.Create( "DLabel" )
		label:SetText( "Create your character" )
		label:SetFont( "TiramisuTimeFont" )
		panel:AddItem( label )

		label = vgui.Create( "DLabel" )
		label:SetText( "Name:" )
		panel:AddItem( label )

		local nametext = vgui.Create( "DTextEntry" )
		nametext:SetText( CharName )
		nametext:SetTooltip( "Click to edit" )
		panel:AddItem( nametext )

		label = vgui.Create( "DLabel" )
		label:SetText( "Title:" )
		panel:AddItem( label )

		local titletext = vgui.Create( "DTextEntry" )
		titletext:SetText( Title1 )
		titletext:SetTooltip( "Click to edit" )
		panel:AddItem( titletext )

		local modellist = vgui.Create( "DMultiChoice" )
		for k, v in pairs( models[ Gender ] ) do
			modellist:AddChoice( v )
		end
		modellist.OnSelect = function( panel,index,value )
			RunConsoleCommand( "rp_testclothing", "none", value, SelectedClothing )
			SelectedModel = value
		end
		modellist:ChooseOptionID( 1 )

		local genderlist = vgui.Create( "DMultiChoice" )
		genderlist:AddChoice( "Male" )
		genderlist:AddChoice( "Female" )
		genderlist.OnSelect = function( panel,index,value )
			Gender = value
			RunConsoleCommand( "rp_testclothing", value, models[ value ][1] )
			modellist:Clear()
			for k, v in pairs( models[ Gender ] ) do
				modellist:AddChoice( v )
			end
			SelectedClothing = "none"
			SelectedModel = models[ value ][1]
			modellist:ChooseOptionID( 1 )
		end
		genderlist:ChooseOptionID( 1 )

		label = vgui.Create( "DLabel" )
		label:SetText( "Gender:" )
		panel:AddItem( label )
		panel:AddItem( genderlist )

		label = vgui.Create( "DLabel" )
		label:SetText( "Model:" )
		panel:AddItem( label )
		panel:AddItem( modellist )

		label = vgui.Create( "DLabel" )
		label:SetText( "Age:" )
		panel:AddItem( label )

		local numberwang = vgui.Create( "DNumberWang" )
		numberwang:SetMin( 18 )
		numberwang:SetMax( 89 )
		numberwang:SetValue( 30 )
		numberwang:SetDecimals( 0 )
		numberwang.OnValueChanged = function( panel, value )
			Age = tostring( value )
		end
		panel:AddItem( numberwang )

		gobacklabel = vgui.Create( "DButton", CharacterMenu )
		gobacklabel:SetSize( 80, 26 )
		gobacklabel:SetText( "" )
		gobacklabel:SetPos( (ScrW() / 2 )- 160, ScrH() + 500  )
		gobacklabel.Paint = function() end
		gobacklabel.PaintOver = function()
			draw.SimpleText( "Go Back", "TiramisuTimeFont", 40, 0, Color(255,255,255), TEXT_ALIGN_CENTER )
			x,y = gobacklabel:GetPos()
			if !gobacklabel.SlideOut then
				gobacklabel:SetPos( (ScrW() / 2 )- 160, Lerp( 0.1, y, ScrH() / 2 + 230 ))
			else
				gobacklabel:SetPos( (ScrW() / 2 )- 160, Lerp( 0.1, y, ScrH() + 500  ))
				if y > ScrH() then
					gobacklabel:Remove()
					gobacklabel = nil
				end
			end
		end
		gobacklabel.DoClick = function()
			RunConsoleCommand( "rp_escapecreate" )
			panel.SlideOut = true
			gobacklabel.SlideOut = true
			createlabel.SlideOut = true
			OpenCharacterMenu()
		end

		createlabel = vgui.Create( "DButton", CharacterMenu )
		createlabel:SetSize( 200, 26 )
		createlabel:SetText( "" )
		createlabel:SetPos( ScrW() / 2 + 20, ScrH() + 500  )
		createlabel.Paint = function() end
		createlabel.PaintOver = function()
			draw.SimpleText( "Finish Creation", "TiramisuTimeFont", 70, 0, Color(255,255,255), TEXT_ALIGN_CENTER )
			x,y = createlabel:GetPos()
			if !createlabel.SlideOut then
				createlabel:SetPos( ScrW() / 2 + 20, Lerp( 0.1, y, ScrH() / 2 + 230 ))
			else
				createlabel:SetPos( ScrW() / 2 + 20, Lerp( 0.1, y, ScrH() + 500  ))
				if y > ScrH() then
					createlabel:Remove()
					createlabel = nil
				end
			end
		end
		createlabel.DoClick = function()
			Title1 = string.sub(titletext:GetValue(), 1, 255)
			CharName = string.sub(nametext:GetValue(), 1, 64)

			RunConsoleCommand("rp_startcreate")
			RunConsoleCommand("rp_setmodel", SelectedModel );
			RunConsoleCommand("rp_changename", CharName );
			RunConsoleCommand("rp_title", Title1 );
			RunConsoleCommand("rp_setage", Age )
			RunConsoleCommand("rp_setgender", Gender )
			RunConsoleCommand("rp_setcid")
			RunConsoleCommand( "rp_finishcreate" )
			panel.SlideOut = true
			createlabel.SlideOut = true
			gobacklabel.SlideOut = true
			OpenCharacterMenu()
		end

	end
end
function CLPLUGIN.Init()

	CAKE.RegisterCharCreate(CharacterCreation) --THIS IS IMPORTANT. IF THIS IS NOT THERE THE WHOLE GAMEMODE WILL NOT WORK.
	
end
