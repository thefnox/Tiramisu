--Taken from derma_utils, meant to be used with the cute little frames
/*
        Display a simple message box.
        
        CAKE.Message( "Hey Some Text Here!!!", "Message Title (Optional)", "Button Text (Optional)" )
        
*/
function CAKE.Message( strText, strTitle, strButtonText, color )
 
        local Window = vgui.Create( "DFrameTransparent" )
                Window:SetTitle( strTitle or "Message" )
                Window:SetDraggable( false )
                Window:ShowCloseButton( false )
                if color then
                    Window:SetColor( color )
                else
                    Window:SetColor( CAKE.BaseColor )
                end
                
        local InnerPanel = vgui.Create( "DPanel", Window )
        
        local Text = vgui.Create( "DLabel", InnerPanel )
                Text:SetText( strText or "Message Text" )
                Text:SizeToContents()
                Text:SetContentAlignment( 5 )
                Text:SetTextColor( color_white )
                
        local ButtonPanel = vgui.Create( "DPanel", Window )
        ButtonPanel:SetTall( 30 )
                
        local Button = vgui.Create( "DButton", ButtonPanel )
                Button:SetText( strButtonText or "OK" )
                Button:SizeToContents()
                Button:SetTall( 20 )
                Button:SetWide( Button:GetWide() + 20 )
                Button:SetPos( 5, 5 )
                Button.DoClick = function() Window:Close() end
                
        ButtonPanel:SetWide( Button:GetWide() + 10 )
        
        local w, h = Text:GetSize()
        
        Window:SetSize( w + 50, h + 25 + 45 + 10 )
        Window:Center()
        
        InnerPanel:StretchToParent( 5, 25, 5, 45 )
        
        Text:StretchToParent( 5, 5, 5, 5 )      
        
        ButtonPanel:CenterHorizontal()
        ButtonPanel:AlignBottom( 8 )
        
        Window:MakePopup()
 
end


/*
        Ask a question with multiple answers..
        
        CAKE.Query( "Would you like me to punch you right in the face?", "Question!",
                                                "Yesss",        function() MsgN( "Pressed YES!") end, 
                                                "Nope!",        function() MsgN( "Pressed Nope!") end, 
                                                "Cancel",       function() MsgN( "Cancelled!") end )
                
*/
function CAKE.Query( strText, strTitle, ... )
 
        local Window = vgui.Create( "DFrameTransparent" )
                Window:SetTitle( strTitle or "Message Title (First Parameter)" )
                Window:SetDraggable( false )
                Window:ShowCloseButton( false )
                Window:SetColor( Color( 140, 100, 100) )
                
        local InnerPanel = vgui.Create( "DPanel", Window )
        
        local Text = vgui.Create( "DLabel", InnerPanel )
                Text:SetText( strText or "Message Text (Second Parameter)" )
                Text:SizeToContents()
                Text:SetContentAlignment( 5 )
                Text:SetTextColor( color_white )
 
        local ButtonPanel = vgui.Create( "DPanel", Window )
        ButtonPanel:SetTall( 30 )
 
        // Loop through all the options and create buttons for them.
        local NumOptions = 0
        local x = 5
        for k=1, 8, 2 do
                
                if ( arg[k] == nil ) then break end
                
                local Text = arg[k]
                local Func = arg[k+1] or function() end
        
                local Button = vgui.Create( "DButton", ButtonPanel )
                        Button:SetText( Text )
                        Button:SizeToContents()
                        Button:SetTall( 20 )
                        Button:SetWide( Button:GetWide() + 20 )
                        Button.DoClick = function() Window:Close(); Func() end
                        Button:SetPos( x, 5 )
                        
                x = x + Button:GetWide() + 5
                        
                ButtonPanel:SetWide( x ) 
                NumOptions = NumOptions + 1
        
        end
 
        
        local w, h = Text:GetSize()
        
        w = math.max( w, ButtonPanel:GetWide() )
        
        Window:SetSize( w + 50, h + 25 + 45 + 10 )
        Window:Center()
        
        InnerPanel:StretchToParent( 5, 25, 5, 45 )
        
        Text:StretchToParent( 5, 5, 5, 5 )      
        
        ButtonPanel:CenterHorizontal()
        ButtonPanel:AlignBottom( 8 )
        
        Window:MakePopup()
        
        if ( NumOptions == 0 ) then
        
                Window:Close()
                Error( "CAKE.Query: Created Query with no Options!?" )
        
        end
 
end
 
 
/*
        Request a string from the user
        
        CAKE.StringRequest( "Question", 
                                        "What Is Your Favourite Color?", 
                                        "Type your answer here!", 
                                        function( strTextOut ) CAKE.Message( "Your Favourite Color Is: " .. strTextOut ) end,
                                        function( strTextOut ) CAKE.Message( "You pressed Cancel!" ) end,
                                        "Okey Dokey", 
                                        "Cancel" )
        
*/
function CAKE.StringRequest( strTitle, strText, strDefaultText, fnEnter, fnCancel, strButtonText, strButtonCancelText, color )
 
        local Window = vgui.Create( "DFrameTransparent" )
                Window:SetTitle( strTitle or "Message Title (First Parameter)" )
                Window:SetDraggable( false )
                Window:ShowCloseButton( false )
                if color then
                    Window:SetColor( color )
                else
                    Window:SetColor( CAKE.BaseColor )
                end
                
        local InnerPanel = vgui.Create( "DPanel", Window )
        
        local Text = vgui.Create( "DLabel", InnerPanel )
                Text:SetText( strText or "Message Text (Second Parameter)" )
                Text:SizeToContents()
                Text:SetContentAlignment( 5 )
                Text:SetTextColor( color_white )
                
        local TextEntry = vgui.Create( "DTextEntry", InnerPanel )
                TextEntry:SetText( strDefaultText or "" )
                TextEntry.OnEnter = function() Window:Close() fnEnter( TextEntry:GetValue() ) end
                
        local ButtonPanel = vgui.Create( "DPanel", Window )
        ButtonPanel:SetTall( 30 )
                
        local Button = vgui.Create( "DButton", ButtonPanel )
                Button:SetText( strButtonText or "OK" )
                Button:SizeToContents()
                Button:SetTall( 20 )
                Button:SetWide( Button:GetWide() + 20 )
                Button:SetPos( 5, 5 )
                Button.DoClick = function() Window:Close() fnEnter( TextEntry:GetValue() ) end
                
        local ButtonCancel = vgui.Create( "DButton", ButtonPanel )
                ButtonCancel:SetText( strButtonCancelText or "Cancel" )
                ButtonCancel:SizeToContents()
                ButtonCancel:SetTall( 20 )
                ButtonCancel:SetWide( Button:GetWide() + 20 )
                ButtonCancel:SetPos( 5, 5 )
                ButtonCancel.DoClick = function() Window:Close() if ( fnCancel ) then fnCancel( TextEntry:GetValue() ) end end
                ButtonCancel:MoveRightOf( Button, 5 )
                
        ButtonPanel:SetWide( Button:GetWide() + 5 + ButtonCancel:GetWide() + 10 )
        
        local w, h = Text:GetSize()
        w = math.max( w, 400 ) 
        
        Window:SetSize( w + 50, h + 25 + 75 + 10 )
        Window:Center()
        
        InnerPanel:StretchToParent( 5, 25, 5, 45 )
        
        Text:StretchToParent( 5, 5, 5, 35 )     
        
        TextEntry:StretchToParent( 5, nil, 5, nil )
        TextEntry:AlignBottom( 5 )
        
        TextEntry:RequestFocus()
        TextEntry:SelectAllText( true )
        
        ButtonPanel:CenterHorizontal()
        ButtonPanel:AlignBottom( 8 )
        
        Window:MakePopup()
 
end

function CAKE.ChoiceRequest( strTitle, strText, tbl, fnEnter, fnCancel, strButtonText, strButtonCancelText, color )
        
        local choice

        local Window = vgui.Create( "DFrameTransparent" )
                Window:SetTitle( strTitle or "Message Title (First Parameter)" )
                Window:SetDraggable( false )
                Window:ShowCloseButton( false )
                if color then
                    Window:SetColor( color )
                else
                    Window:SetColor( CAKE.BaseColor )
                end
                
        local InnerPanel = vgui.Create( "DPanel", Window )
        
        local Text = vgui.Create( "DLabel", InnerPanel )
                Text:SetText( strText or "Message Text (Second Parameter)" )
                Text:SizeToContents()
                Text:SetContentAlignment( 5 )
                Text:SetTextColor( color_white )
                
        local MultiChoice = vgui.Create( "DMultiChoice", InnerPanel )
                choice = tbl[1]
                for k, v in pairs( tbl ) do
                    MultiChoice:AddChoice( v )
                end
                MultiChoice.OnSelect = function(panel,index,value) choice = value end
                MultiChoice:SizeToContents()
                
        local ButtonPanel = vgui.Create( "DPanel", Window )
        ButtonPanel:SetTall( 30 )
                
        local Button = vgui.Create( "DButton", ButtonPanel )
                Button:SetText( strButtonText or "OK" )
                Button:SizeToContents()
                Button:SetTall( 20 )
                Button:SetWide( Button:GetWide() + 20 )
                Button:SetPos( 5, 5 )
                Button.DoClick = function() Window:Close() fnEnter( MultiChoice:GetValue() ) end
                
        local ButtonCancel = vgui.Create( "DButton", ButtonPanel )
                ButtonCancel:SetText( strButtonCancelText or "Cancel" )
                ButtonCancel:SizeToContents()
                ButtonCancel:SetTall( 20 )
                ButtonCancel:SetWide( Button:GetWide() + 20 )
                ButtonCancel:SetPos( 5, 5 )
                ButtonCancel.DoClick = function() Window:Close() if ( fnCancel ) then fnCancel( choice ) end end
                ButtonCancel:MoveRightOf( Button, 5 )
                
        ButtonPanel:SetWide( Button:GetWide() + 5 + ButtonCancel:GetWide() + 10 )
        
        local w, h = Text:GetSize()
        w = math.max( w, 400 ) 
        
        Window:SetSize( w + 50, h + 25 + 75 + 10 )
        Window:Center()
        
        InnerPanel:StretchToParent( 5, 25, 5, 45 )
        
        Text:StretchToParent( 5, 5, 5, 35 )     
        
        MultiChoice:StretchToParent( 5, nil, 5, nil )
        MultiChoice:AlignBottom( 5 )
        
        ButtonPanel:CenterHorizontal()
        ButtonPanel:AlignBottom( 8 )
        
        Window:MakePopup()
 
end
