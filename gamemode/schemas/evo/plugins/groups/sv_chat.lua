--Broadcasts a message across the server, if group permissions allow it.
local function Broadcast( ply, text )

    -- Check to see if the player's team allows broadcasting
    local group = CAKE.GetCharField( ply, "group" )
    
    if( CAKE.GetGroupFlag( group, "canbroadcast" ) ) then
        
        for k, v in pairs( player.GetAll( ) ) do
        
            CAKE.SendChat( v, "[BROADCAST]: " .. text, "BudgetLabel", "IC" );
            
        end
    
    end
    
    return "";
    
end


--Sends a group only message.
local function Radio( ply, text )

    local players = player.GetAll();
    local heardit = {};
    local group = CAKE.GetCharField( ply, "group" )
    local color = CAKE.GetGroupField( group, "radiocolor" ) or Color( 255, 255, 255 )

    if !ply:IsCharLoaded() then return ""; end
    if !CAKE.GroupExists( group ) then return ""; end

    for _, target in pairs(player.GetAll()) do
        if target:IsCharLoaded() then
            if( CAKE.GetCharField( target, "group" ) == group ) then
                /*
                if v2 != ply then
                    CAKE.AddRadioLine( v2, "[RADIO] " .. ply:Nick() .. ": " .. text, CAKE.GetGroupFlag( group, "radiocolor" ) or Color( 255, 255, 255 ) );
                    else
                    CAKE.AddRadioLine( v2, "[RADIO] " .. ply:Nick() .. ": " .. text, Color( 255, 0, 0 ) );
                        
                    end*/
                datastream.StreamToClients( target, "TiramisuAddToRadio", {
                    ["text"] = "<color=white>[RADIO]</color><color=" .. tostring( color.r ) .. "," .. tostring( color.b ) .. "," .. tostring( color.g ) .. ">" .. ply:Nick() .. "</color><color=white>: " .. text .. "</color>" 
                })
                table.insert(heardit, target);
            end
        end
    end

    for k, v in pairs(players) do
        
        if(!table.HasValue(heardit, v)) then
        
            local range = CAKE.ConVars[ "TalkRange" ]
            
            if( v:EyePos( ):Distance( ply:EyePos( ) ) <= range ) then
            
                CAKE.SendChat( v, ply:Nick() .. ": " .. text, "ChatFont", "IC" );
                
            end
            
        end
        
    end
    
    return "";

end


function PLUGIN.Init( )

    CAKE.ChatCommand( "/bc", Broadcast ); -- Broadcast
    CAKE.ChatCommand( "/r", Radio ); -- Radio
    CAKE.ChatCommand( "/radio", Radio );
end