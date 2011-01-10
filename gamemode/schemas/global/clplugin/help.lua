CLPLUGIN.Name = "Help Menu"
CLPLUGIN.Author = "F-Nox/Big Bang"

local commandtext = [[Hello, and welcome to Tiramisu, a new innovative roleplay experience. We hope you have a good stay on the server you are currently on!

--------------

Tiramisu help.

--Input--

F1- Show this help menu
F2- Inventory
F3- Holster/Unholster weapons ( rp_toggleholster )
F4- Toggle thirdperson
Tab- Main Menu
Tab+Right click on an item/door/player- Context menu

--Chat Commands--

/me - Emote
/y - Yell
/w - Whisper
/ad - Advertice
/event - Start an event ( admin only )
/bc - Broadcast a message ( needs group )
/r - Use the radio ( needs group )
/removehelmet - Removes your current helmet
/pm - Send a personal message
/title - Set your title
/title2 - Set your second title
/?,/anon - Say an anonymous message
// - OOC
.//, [[ - Local OOC
/report - Report something to the currently online admins.

--Console Commands--

rp_toggleholster - Toggles the holstered state on your current weapon
rp_admin help - Admin only help]]

local rpguide = [[
The Basics of RP:

Keep in mind that Tiramisu is a serious roleplay script, and therefore the server you are in probably does not want you to goof around. To have a fun experience, you should keep in mind the following guidelines:

-Always try to act as if you're a character inside the world that is the server you're currently on. Try to immerse into the game; RP is more fun that way.

-If you wouldn't do what you're about to do in real life, you probably shouldn't do it in game.

-Always try to use proper spelling. Avoid using internet emoticons. That way people will understand you better.

-Try to be creative, but don't trample over others' creativity.]]

local abouttext = [[From Cakescript to Tiramisu:

Tiramisu ( which is, btw, a fancy Cake. Pun intended. ) is based off Cakescript G2 ( Thank Luabanana for creating it! ), only modified extensively, to the point that only around 15% of the base code remains totally untouched. There are some notable changes that you should keep in mind while testing features or while editing code, to name a few:

-The animation system required a complete revamp of the way that GMod regularily handles player models. Scripts made for Cakescript G2 that are meant to change a player's model probably don't work anymore.

-On the other hand, this gives you the great benefit of clothes! Aside from just a aesthetic change, clothes bring you the incredible advantage of being able to use ANY AND ALL models using the ValveBiped skeleton ( playermodels, NPCs, even just ragdolls ), without requiring them to be rerrigged with an animation set, and being able to do headhacks in game.

-It is now possible to create new admins without having to reset your server. If you're an admin, simply set them by using rp_admin setrank.

-The new accessories and gear system uses items, not just models from a list, allowing you to do things like hiding slung weapons that match your weapon's class and such.

-OOC Colors! Enter the Options menu to change your color so you can tell who is talking on OOC easier.

-Flags were removed for the way more extensive group system. Groups work by ranks, allowing you to be of a different 'flag' or rank, while having the same benefits than the rest of the group. You can also now create user based groups, while playing.

-Absolutely all VGUI elements have been revamped. We have managed to retain Cakescript's simplicity while adding functionality.

You'll find more about Tiramisu the more you play it, and code on it. Good luck!]]

function OpenHelp()

	if PlayerMenu then
		CloseHelp()
	end

	PlayerMenu = vgui.Create( "DFrameTransparent" )
	PlayerMenu:SetSize( 400, 400 )
	PlayerMenu:Center()
	PlayerMenu:SetTitle( "Help Menu" )
	PlayerMenu:MakePopup()

	local propsheet = vgui.Create( "DPropertySheet", PlayerMenu )
	propsheet:SetPos( 5, 28 )
	propsheet:SetSize( 390, 367 )

	local cpanel = vgui.Create( "DPanelList" )
	cpanel:EnableVerticalScrollbar( true )

	local label = vgui.Create( "DLabel" )
	label:SetText( commandtext )
	label:SetWrap( true )
	label:SetSize( 380, 500 )
	label:SetTextColor( Color( 255, 255, 255, 255 ))
	cpanel:AddItem( label )

	propsheet:AddSheet("Commands", cpanel, "gui/silkicons/user", false, false, "All about player commands");

	local rppanel = vgui.Create( "DPanelList" )
	rppanel:EnableVerticalScrollbar( true )

	local label = vgui.Create( "DLabel" )
	label:SetText( rpguide )
	label:SetWrap( true )
	label:SetSize( 380, 300 )
	label:SetTextColor( Color( 255, 255, 255, 255 ))
	rppanel:AddItem( label )

	propsheet:AddSheet("RP Guide", rppanel, "gui/silkicons/star", false, false, "How to RP and such");

	local apanel = vgui.Create( "DPanelList" )
	apanel:EnableVerticalScrollbar( true )

	local label = vgui.Create( "DLabel" )
	label:SetText( abouttext )
	label:SetWrap( true )
	label:SetSize( 380, 300 )
	label:SetTextColor( Color( 255, 255, 255, 255 ))
	apanel:AddItem( label )

	propsheet:AddSheet("About", apanel, "gui/silkicons/magnifier", false, false, "About Tiramisu and Cakescript");

end

function CloseHelp()
	if PlayerMenu then
		PlayerMenu:Remove()
		PlayerMenu = nil
	end
end
CAKE.RegisterMenuTab( "Help", OpenHelp, CloseHelp )

usermessage.Hook( "showhelpmenu", function( um )
	
	OpenHelp()
	
end)

function CLPLUGIN.Init()
	
end