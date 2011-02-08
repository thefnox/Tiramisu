CLPLUGIN.Name = "Character Menu"
CLPLUGIN.Author = "F-Nox/Big Bang"

/*local frame = vgui.Create( "DFrame" )
frame:SetSize( ScrW(), ScrH() )
frame:Center()
frame:SetTitle( "" )
frame.Paint = function()

Derma_DrawBackgroundBlur( frame, 0 )

end
frame:MakePopup()

local titlelabel = vgui.Create( "DLabel", frame )
titlelabel:SetText( "Welcome to Tiramisu" )
titlelabel:SetFont( "TiramisuTitlesFont" )
titlelabel:SizeToContents()
titlelabel:SetPos( ScrW() / 2 - titlelabel:GetWide() / 2, 0 )
local x, y
titlelabel.PaintOver = function()
	x,y = titlelabel:GetPos()
	titlelabel:SetPos( x, Lerp( 0.15, y, 100 ))
end

local model = vgui.Create( "PlayerPanel", frame )
model:SetSize( 500, 500 )
model:SetPos( ScrW() / 2 - 250, ScrH() / 2 - 250 )
model:StartDraw()
*/


local function OpenCharacter()

	PlayerMenu = vgui.Create( "DFrameTransparent" )
	--PlayerMenu:SetPos( ScrW() / 2 - 320, ScrH() / 2 - 240 )
	PlayerMenu:NoClipping( false );
	PlayerMenu:SetSize( 640, 480 )
	PlayerMenu:SetTitle( "Characters" )
	PlayerMenu:SetBackgroundBlur( true )
	PlayerMenu:SetVisible( true )
	PlayerMenu:SetDraggable( true )
	PlayerMenu:ShowCloseButton( true )
	PlayerMenu:SetDeleteOnClose( true )
	PlayerMenu:Center()
	PlayerMenu:MakePopup()
	
	CharPanel = vgui.Create( "DPanelList", PlayerMenu )
	CharPanel:SetSize( 630,448 )
	CharPanel:SetPos( 5, 28 )
	CharPanel:SetPadding(20);
	CharPanel:SetSpacing(10);
	CharPanel:EnableVerticalScrollbar();
	CharPanel:EnableHorizontal(false);

	local label = vgui.Create("DLabel");
	label:SetText("Click your character to select it");
	CharPanel:AddItem(label);
	
	local widthnshit = 600
	local numberofchars = table.getn( ExistingChars )
	local modelnumber = {}
	
	local function AddCharacterModel( n, model )
		
		local mdlpanel = modelnumber[n]
		
		mdlpanel = vgui.Create( "DModelPanel" )
		mdlpanel:SetSize( 200, 180 )
		mdlpanel:SetModel( model )
		mdlpanel:SetAnimSpeed( 0.0 )
		mdlpanel:SetAnimated( false )
		mdlpanel:SetAmbientLight( Color( 50, 50, 50 ) )
		mdlpanel:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
		mdlpanel:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )
		mdlpanel:SetCamPos( Vector( 100, 0, 40 ) )
		mdlpanel:SetLookAt( Vector( 0, 0, 40 ) )
		mdlpanel:SetFOV( 70 )

		mdlpanel.PaintOver = function()
			surface.SetTextColor(Color(255,255,255,255));
			surface.SetFont("Trebuchet18");
			surface.SetTextPos( surface.GetTextSize(ExistingChars[n]['name']) , 0);
			surface.DrawText(ExistingChars[n]['name'])
		end
		
		function mdlpanel:OnMousePressed()
			local Options = DermaMenu()
			Options:AddOption("Select Character", function() 
				LocalPlayer():ConCommand("rp_selectchar " .. n);
				LocalPlayer().MyModel = ""
				PlayerMenu:Remove();
				PlayerMenu = nil;
				CAKE.MenuOpen = false
			end )
			Options:AddOption("Delete Character", function() 
				LocalPlayer():ConCommand("rp_confirmremoval " .. n);
				PlayerMenu:Remove();
				PlayerMenu = nil;
			end )
			Options:Open()
		end

		function mdlpanel:LayoutEntity(Entity)

			self:RunAnimation();
			
		end
		function InitAnim()
		
			if(mdlpanel.Entity) then		
				local iSeq = mdlpanel.Entity:LookupSequence( "idle_angry" );
				mdlpanel.Entity:ResetSequence(iSeq);
			
			end
			
		end
		
		InitAnim()
		CharPanel:AddItem(mdlpanel);
	
	end
	
	
	for k, v in pairs(ExistingChars) do
		if v then
			AddCharacterModel( k, v['model'] )
		end
	end
	
	local newchar = vgui.Create("DButton");
	newchar:SetSize(100, 25);
	newchar:SetText("New Character");
	newchar.DoClick = function ( btn )
		CAKE.NextStep()
		PlayerMenu:Remove();
		PlayerMenu = nil;
	end
	CharPanel:AddItem( newchar )

end

local function CloseCharacter()
	if PlayerMenu then
		PlayerMenu:Remove()
		PlayerMenu = nil
	end
end
CAKE.RegisterMenuTab( "Characters", OpenCharacter, CloseCharacter )

function CLPLUGIN.Init()
	
end