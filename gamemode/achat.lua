/*************************************
Info: aChat custom chatbox.
Author: Averice
URL: http://averice.org
*************************************/

-- We're going to put everything in this, hopefully we won't get conflicting addons. This should work with adminmod chat commands.

-- Clientside first, as this is the most important.
if( CLIENT ) then

	aChat = {}
	
	if CAKE.UseCustomChat:GetBool() then
		aChat.Var = CreateClientConVar("achat_enabled", 1, true, false);
		
		require("glon");
		aChat.Lines = {}
		aChat.Colors = { -- Color our chatbox.
			BorderCol = Color(255,255,255,255);
			InnerCol = Color(0,0,0,255);
			};
		aChat.Defaults = {
			BorderCol = Color(255,255,255,255);
			InnerCol = Color(0,0,0,255);
			Font = "ChatFont";
			}
		aChat.Font = "ChatFont";
		aChat.AddedLines = {}
		
		function aChat:Load()
			if( file.Exists("achat.txt") ) then
				local tab = glon.decode(file.Read("achat.txt"));
				aChat.Colors.BorderCol = tab.Colors.BorderCol;
				aChat.Colors.InnerCol = tab.Colors.InnerCol;
				aChat.Font = tab.Font;
			end
		end
		aChat:Load()
		-- Simple little PANEL for making our chats.
		local PANEL = {}

		function PANEL:Init()
			self.Str = "";
			self.MaxWidth = 0;
			self.Alpha = 255;
		end

		function PANEL:SetWidth(w)
			self.MaxWidth = tonumber(w) or self.MaxWidth;
		end

		function PANEL:SetString(s)
			self.Str = markup.Parse(tostring(s), self.MaxWidth);
		end

		function PANEL:ColorEnhance(alpha)
			self.Alpha = tonumber(alpha)
		end
		function PANEL:Paint()
			self.Str:Draw(2, 0, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, self.Alpha)
		end
		vgui.Register("aChatLine", PANEL, "Panel")
		-- End panel.
		
		local ALPHA_CHAT = 0; -- This will fade he chatbox.
		
		-- Create the chatbox.
		function aChat.createChatBox()
			bCol = aChat.Colors.BorderCol or Color(255,255,255,255);
			iCol = aChat.Colors.InnerCol or Color(0,0,0,255);
			LocalPlayer().LastTime = 1;
		
			-- Border and main frame.
			aChat.ChatBox = vgui.Create("DPanel");
			aChat.ChatBox:SetSize(480,220);
			aChat.ChatBox:SetPos(10, ScrH() - 300);
			aChat.ChatBox:SetVisible(true);
			aChat.ChatBox.Paint = function(self)
				if not( LocalPlayer().aChat ) then
					ALPHA_CHAT = math.Clamp(ALPHA_CHAT-3, 0, 200)
				else
					ALPHA_CHAT = math.Clamp(ALPHA_CHAT+3, 0, 200)
				end
				surface.SetDrawColor(Color(bCol.r, bCol.g, bCol.b, ALPHA_CHAT));
				surface.DrawRect(0, 0, self:GetWide(), self:GetTall());
			end
			
			-- Inside and scrollbar.
			aChat.Inner = vgui.Create("DPanelList", aChat.ChatBox);
			aChat.Inner:SetSize(aChat.ChatBox:GetWide()-4, aChat.ChatBox:GetTall()-4);
			aChat.Inner:SetPos(2,2);
			aChat.Inner:EnableVerticalScrollbar(true)
			aChat.Inner.Paint = function(self)
				surface.SetDrawColor(Color(iCol.r, iCol.g, iCol.b, ALPHA_CHAT))
				surface.DrawRect(0, 0, self:GetWide(), self:GetTall());
			end
				aChat.Inner.VBar.btnDown.Paint = function(self)
					draw.RoundedBox(4, 1, 1, self:GetWide()-2, self:GetTall()-2, Color(bCol.r,bCol.g,bCol.b,ALPHA_CHAT))
					draw.RoundedBox(4, 2, 2, self:GetWide()-4, self:GetTall()-4, Color(iCol.r,iCol.g,iCol.b,ALPHA_CHAT))
					if( ALPHA_CHAT == 0 ) then
						self:SetText("");
					else
						self:SetType("down");
					end
				end
				aChat.Inner.VBar.btnUp.Paint = function(self)
					draw.RoundedBox(4, 1, 1, self:GetWide()-2, self:GetTall()-2, Color(bCol.r,bCol.g,bCol.b,ALPHA_CHAT))
					draw.RoundedBox(4, 2, 2, self:GetWide()-4, self:GetTall()-4, Color(iCol.r,iCol.g,iCol.b,ALPHA_CHAT))
					if( ALPHA_CHAT == 0 ) then
						self:SetText("");
					else
						self:SetType("up");
					end
				end
				aChat.Inner.VBar.btnGrip.Paint = function(self)
					draw.RoundedBox(4, 1, 1, self:GetWide()-2, self:GetTall()-2, Color(bCol.r,bCol.g,bCol.b,ALPHA_CHAT))
					draw.RoundedBox(4, 2, 2, self:GetWide()-4, self:GetTall()-4, Color(iCol.r,iCol.g,iCol.b,ALPHA_CHAT))
				end
				aChat.Inner.VBar.Paint = function(self)
					surface.SetDrawColor(Color(0,0,0,ALPHA_CHAT));
					surface.DrawRect(0, 0, self:GetWide(), self:GetTall());
				end
			
			-- Text entry box.
			aChat.Entry = vgui.Create("DPanel")
			aChat.Entry:SetSize(480, 24);
			aChat.Entry:SetPos(10, ScrH()-80);
			aChat.Entry:SetVisible(false);
			aChat.Entry.Paint = function(self)
				surface.SetDrawColor(Color(bCol.r,bCol.g,bCol.b,ALPHA_CHAT));
				surface.DrawRect(0, 0, self:GetWide(), self:GetTall());
			end
			
			aChat.eText = vgui.Create("DTextEntry", aChat.Entry)
			aChat.eText:SetSize(476,20)
			aChat.eText:SetPos(2,2)
			
			aChat.updateChatBox()
			
		end
		hook.Add("Initialize", "aChatStartUp", aChat.createChatBox)
		
		-- Add our chat lines.
		function aChat.updateChatBox()
			bCol = aChat.Colors.BorderCol or Color(255,255,255,255);
			iCol = aChat.Colors.InnerCol or Color(0,0,0,255);
			if( aChat.AddedLines ) then
				local k,v
				for k,v in pairs(aChat.AddedLines) do
					v:Remove()
				end
			end
			
			local k,v
			for k,v in pairs(aChat.Lines) do
				aChat.AddedLines[k] = vgui.Create("aChatLine");
				aChat.AddedLines[k]:SetWidth(363);
				aChat.AddedLines[k]:SetString(tostring(v));
				aChat.AddedLines[k]:SetSize(363, aChat.AddedLines[k].Str:GetHeight()+2);
				aChat.AddedLines[k].Alpha = 255;
				aChat.AddedLines[k].Think = function(self)
					if( LocalPlayer().LastTime && LocalPlayer().LastTime < CurTime() && !LocalPlayer().aChat ) then
						self.Alpha = math.Clamp(self.Alpha-1, 0, 255);
					else
						self.Alpha = 255;
					end
					self:ColorEnhance(self.Alpha)
				end
				aChat.Inner:AddItem(aChat.AddedLines[k]);
			end
			
			local function MoveScrollBarGrip()
				if( aChat.Inner.VBar ) then
					aChat.Inner.VBar:SetScroll(20000);
				end
			end
			timer.Simple(0.1, MoveScrollBarGrip);
			
		end
		
		function aChat.StartChat()
			if( aChat.Var:GetInt() == 1 ) then
				LocalPlayer().aChat = true;
				aChat.Entry:SetVisible(true);
				aChat.updateChatBox()
				return true;
			end
		end
		hook.Add("StartChat", "aChatStartChat", aChat.StartChat)
		
		function aChat.FinishChat()
			if( aChat.Var:GetInt() == 1 ) then
				LocalPlayer().aChat = false;
				LocalPlayer().LastTime = CurTime()+10;
				aChat.Entry:SetVisible(false);
			end
		end
		hook.Add("FinishChat", "aChatFinishChat", aChat.FinishChat)
		
		function aChat.OnPlayerChat(p, t, teams, dead)
			if( aChat.Var:GetInt() == 1 ) then
				local nick
				local col
				local line
				if( IsValid(p) ) then
					nick = string.gsub(tostring(p:Nick()), "<([/%a]*)=?([^>]*)", " ");
					col = team.GetColor(p:Team());
				else
					nick = "Console";
					col = Color(255,255,255,255);
				end
				if( IsValid(p) && dead && !teams ) then
					nick = "<color=255,255,255,255>[</color><color=255,0,0,255>DEAD</color><color=255,255,255,255>]</color> "..nick;
				end
				if( IsValid(p) && dead && teams ) then
					nick = "<color=255,255,255,255>[</color><color=255,0,0,255>DEAD</color><color=255,255,255,255>][</color><color="..col.r..","..col.g..","..col.b..",255>TEAM</color><color=255,255,255,255>]</color> "..nick;
				elseif( IsValid(p) && !dead && teams ) then
					nick = "<color=255,255,255,255>[</color><color="..col.r..","..col.g..","..col.b..",255>TEAM</color><color=255,255,255,255>]</color> "..nick;
				end
				local used = tostring(t);
				line = "<font="..aChat.Font.."><color="..col.r..","..col.g..","..col.b..",255>"..nick..": </color><color=255,255,255,255>"..(tostring(used)).."</color></font>";
				if( teams && LocalPlayer():Team() == p:Team() ) then
					aChat.AddChatLine(line)
				elseif( !teams ) then
					aChat.AddChatLine(line)
				end
				return ""
			end
		end
		hook.Add("OnPlayerChat", "aChatOnPlayerChat", aChat.OnPlayerChat)
		
		function aChat.AddChatLine(t)
			if not t then return end;
			local text = tostring(t)
			table.insert(aChat.Lines, text);
			aChat.AddSingleLine(t)
			--aChat.updateChatBox()
		end
		
		function aChat.AddSingleLine(t)
			if not t then return end;
			local text = tostring(t)
			local time = CurTime() + 10;
			local num = #aChat.AddedLines + 1;
			aChat.AddedLines[num] = vgui.Create("aChatLine")
			aChat.AddedLines[num]:SetWidth(363);
			aChat.AddedLines[num]:SetString(tostring(text));
			aChat.AddedLines[num]:SetSize(363, aChat.AddedLines[num].Str:GetHeight()+2);
			aChat.AddedLines[num].Alpha = 255;
			aChat.AddedLines[num].Think = function(self)
				if( time < CurTime() ) then
					self.Alpha = math.Clamp(self.Alpha-1, 0, 255);
				else
					self.Alpha = 255;
				end
				self:ColorEnhance(self.Alpha)
			end
			aChat.Inner:AddItem(aChat.AddedLines[num]);
			local function MoveScrollBarGrip()
				if( aChat.Inner.VBar ) then
					aChat.Inner.VBar:SetScroll(20000);
				end
			end
			timer.Simple(0.1, MoveScrollBarGrip);
		end
		
		function aChat.ChatTextChanged(t)
			if( string.len(tostring(t)) > 1000 ) then
				surface.PlaySound("ui/buttonclickrelease.wav");
				return ""
			end
			aChat.eText:SetText(tostring(t))
		end
		hook.Add("ChatTextChanged", "aChatTextChanged", aChat.ChatTextChanged)
		
		-- Overwrite chat.AddText to work with markup.Parse.. Obviously some laupros are going to say there's a better way to do this.
		-- Or even that I shouldn't be using markup.Parse at all.
		local oldAddText = chat.AddText
		function chat.AddText(...)
			if( aChat.Var:GetInt() == 1 ) then
				local pass = {...}
				local color = false;
				local line = "";
				for k,v in pairs(pass) do
					if( type(v) == "table" && color ) then
						pass[k] = "</color><color="..v.r..","..v.g..","..v.b..",255>";
						color = true;
					elseif( type(v) == "table" && !color ) then
						pass[k] = "<color="..v.r..","..v.g..","..v.b..",255>";
						color = true
					elseif( type(v) == "string" && color && !pass[k+1] ) then
						pass[k] = v.."</color>";
					end
				end
				for k,v in pairs(pass) do
					line = "<font="..aChat.Font..">"..line .. v.."</font>" or "<font="..aChat.Font..">"..v.."</font>";
				end
				oldAddText(...) -- For colored console messages I keep the original.
				aChat.AddChatLine(line)
			else
				oldAddText(...)
			end
		end
		
		-- Our simple little menu for color and font changing.
		function aChat.Customize()
		
			if( aChat.Custom ) then
				aChat.Custom:Remove()
			end
			local border = aChat.Colors.BorderCol;
			local inner = aChat.Colors.InnerCol;
			
			aChat.Custom = vgui.Create("DPanel")
			aChat.Custom:SetSize(300, 300)
			aChat.Custom:SetPos(ScrW()/2-100, ScrH()/2-100)
			aChat.Custom.Paint = function(self)
				surface.SetDrawColor(Color(border.r, border.g, border.b ,255))
				surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
				surface.SetDrawColor(Color(inner.r, inner.g, inner.b,255))
				surface.DrawRect(2, 2, self:GetWide()-4, self:GetTall()-4)
			end
			
			aChat.Label = vgui.Create("DLabel", aChat.Custom)
			aChat.Label:SetPos(5,5)
			aChat.Label:SetFont("defaultbold");
			aChat.Label:SetText("aChat Customizer");
			aChat.Label:SizeToContents();
			aChat.Label:SetTextColor(Color(255,255,255,255))
			
			surface.SetFont("defaultbold")
			local x, y = surface.GetTextSize("aChat Customizer")
			local line_length = 300 - (x+41);
			
			local Line = vgui.Create("DPanel", aChat.Custom)
			Line:SetPos(x+10, 12)
			Line:SetSize(line_length, 1)
			Line.Paint = function()
				surface.SetDrawColor(Color(255,255,255,255))
				surface.DrawRect(0, 0, Line:GetWide(), Line:GetTall())
			end
			
			local Close = vgui.Create("DButton", aChat.Custom)
			Close:SetPos(300-21, 5)
			Close:SetSize(16,16)
			Close:SetText("X")
			Close.DoClick = function(self)
				aChat.Custom:Remove()
				gui.EnableScreenClicker(false)
			end
			Close.Inside = false;
			Close.OnCursorEntered = function(self)
				self.Inside = true;
			end
			Close.OnCursorExited = function(self)
				self.Inside = false;
			end
			Close.Paint = function(self)
				draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 255, 255, 255, 255 ) );
				if(self.Inside) then
					draw.RoundedBox( 2, 1, 1, self:GetWide() - 2, self:GetTall() - 2, Color( 255, 0, 0, 255 ) );
					draw.RoundedBox( 2, 1, 1, self:GetWide() - 2, ( self:GetTall() - 2 ) * .33, Color( 255, 70, 70, 255 ) );	
				else
					draw.RoundedBox( 2, 1, 1, self:GetWide() - 2, self:GetTall() - 2, Color( 252, 106, 106, 255 ) );
					draw.RoundedBox( 2, 1, 1, self:GetWide() - 2, ( self:GetTall() - 2 ) * .33, Color( 255, 124, 124, 255 ) );
				end
			end
			
			local bLabel = vgui.Create("DLabel", aChat.Custom)
			bLabel:SetPos(5, 20)
			bLabel:SetText("Border Color");
			bLabel:SetFont("defaultbold");
			bLabel:SetTextColor(Color(255,255,255,255));
			bLabel:SizeToContents()
			
			aChat.bCol = vgui.Create("DColorCircle", aChat.Custom)
			aChat.bCol:SetSize(100,100)
			aChat.bCol:SetPos(5, 40)
			aChat.bCol.Think = function(self)
				border = self:GetRGB() or Color(255,255,255,255);
			end
			
			local iLabel = vgui.Create("DLabel", aChat.Custom)
			iLabel:SetPos(5, 145)
			iLabel:SetText("Inner Color");
			iLabel:SetFont("defaultbold");
			iLabel:SetTextColor(Color(255,255,255,255))
			iLabel:SizeToContents();
			
			aChat.iCol = vgui.Create("DColorCircle", aChat.Custom)
			aChat.iCol:SetSize(100,100)
			aChat.iCol:SetPos(5, 165)
			aChat.iCol.Think = function(self)
				inner = self:GetRGB() or Color(0, 0, 0, 255);
			end
			
			aChat.ButtonReset = vgui.Create("DButton", aChat.Custom)
			aChat.ButtonReset:SetPos(5, 270)
			aChat.ButtonReset:SetSize(100, 20)
			aChat.ButtonReset:SetText("Default")
			aChat.ButtonReset.DoClick = function(self)
				aChat.Colors.BorderCol = aChat.Defaults.BorderCol;
				aChat.Colors.InnerCol = aChat.Defaults.InnerCol;
				aChat.Font = aChat.Defaults.Font;
				aChat:Save()
				aChat.Custom:Remove()
				gui.EnableScreenClicker(false)
			end
			
			aChat.ButtonSave = vgui.Create("DButton", aChat.Custom)
			aChat.ButtonSave:SetPos(110, 270)
			aChat.ButtonSave:SetSize(100, 20)
			aChat.ButtonSave:SetText("Save");
			aChat.ButtonSave.DoClick = function(self)
				aChat.Colors.BorderCol = aChat.bCol:GetRGB() or Color(255,255,255,255);
				aChat.Colors.InnerCol = aChat.iCol:GetRGB() or Color(0,0,0,255);
				aChat.Font = SELFONT or "defaultbold";
				aChat:Save()
			end
			
			local FONTS = {
				"DebugFixed",
				"DebugFixedSmall",
				"DefaultFixedOutline",
				"MenuItem",
				"Default",
				"TabLarge",
				"DefaultBold",
				"DefaultUnderline",
				"DefaultSmall",
				"DefaultSmallDropShadow",
				"DefaultVerySmall",
				"DefaultLarge",
				"UiBold",
				"MenuLarge",
				"ConsoleText",
				"Trebuchet18",
				"Trebuchet19",
				"Trebuchet20",
				"Trebuchet22",
				"Trebuchet24",
				"DefaultFixed",
				"DefaultFixedDropShadow",
				"CloseCaption_Normal",
				"CloseCaption_Bold",
				"ChatFont",
				"TargetID",
				"TargetIDSmall",
				"BudgetLabel"
				}
			
			aChat.FontList = vgui.Create("DPanelList", aChat.Custom)
			aChat.FontList:SetSize(180, 200)
			aChat.FontList:SetPos(110, 30)
			aChat.FontList:EnableVerticalScrollbar(true)
			aChat.FontList.Paint = function(self)
				surface.SetDrawColor(Color(0,0,0,255))
				surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
			end
			
			for k,v in pairs(FONTS) do
				local flab = vgui.Create("DButton")
				flab:SetFont(tostring(v))
				flab:SetText(tostring(v))
				flab:SetSize(180, 20)
				flab.DoClick = function(self)
					SELFONT = tostring(v)
					FontTest:SetFont(tostring(v));
					FontTest:SizeToContents()
				end
				aChat.FontList:AddItem(flab)
			end
			
			FontTest = vgui.Create("DLabel", aChat.Custom)
			FontTest:SetPos(110, 235)
			FontTest:SetSize(180, 20)
			FontTest:SetText("Font Test");
			FontTest:SetFont("defaultbold");
			FontTest:SetTextColor(Color(255,255,255,255));
			
			
			
			gui.EnableScreenClicker(true)
		end
		concommand.Add("achat_custom", aChat.Customize)
		
		function aChat:Save()
			local tab = {}
			tab.Font = aChat.Font or "defaultbold";
			tab.Colors = aChat.Colors or { BorderCol = Color(255,255,255,255), InnerCol = Color(0,0,0,255) };
			local saved = glon.encode(tab)
			file.Write("achat.txt", saved)
		end
	end
end
		

