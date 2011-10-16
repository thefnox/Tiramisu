--NEW FUCKING ANIMATIONS

function GM:HandlePlayerJumping( ply, velocity )
    
    // airwalk more like hl2mp, we airwalk until we have 0 velocity, then it's the jump animation
    // underwater we're alright we airwalking
    if !ply.Jumping and !ply:OnGround() and ply:WaterLevel() <= 0 then
    
        if !ply.GroundTime then
            ply.GroundTime = CurTime()
            
        elseif (CurTime() - ply.GroundTime) > 0 and velocity:Length2D() < 0.5 then
            ply.Jumping = true
            ply.FirstJumpFrame = false
            ply.JumpStartTime = 0
        end
    end
    
    if ply.Jumping then
    
        if ply.FirstJumpFrame then
            ply.FirstJumpFrame = false
            ply:AnimRestartMainSequence()
        end
        
        if ( ply:WaterLevel() >= 2 ) or
            ( (CurTime() - ply.JumpStartTime) > 0.2 and ply:OnGround() ) then
            ply.Jumping = false
            ply.GroundTime = nil
            ply:AnimRestartMainSequence()
        end
        
        if ply.Jumping then
            ply.CalcIdeal = ACT_MP_JUMP
            return true
        end
    end
    
    return false
end

function GM:HandlePlayerDucking( ply, velocity )

    if ply:Crouching() then
        local len2d = velocity:Length2D()
        
        if len2d > 0.5 then
            ply.CalcIdeal = ACT_MP_CROUCHWALK
        else
            ply.CalcIdeal = ACT_MP_CROUCH_IDLE
        end
        
        return true
    end
    
    return false
end

function GM:HandlePlayerNoClipping( ply, velocity )

    if ( false ) then

        if ( ply:GetMoveType() != MOVETYPE_NOCLIP ) then 
            return false 
        end
        
        if ( velocity:Length() > 1000 ) then
            ply.CalcIdeal = ACT_MP_SWIM
        else
            ply.CalcIdeal = ACT_MP_SWIM_IDLE
        end
            
        return true
    end

    return false

end

function GM:HandlePlayerVaulting( ply, velocity )

    if ( velocity:Length() < 1000 ) then return end
    if ( ply:IsOnGround() ) then return end

    ply.CalcIdeal = ACT_MP_SWIM        
    return true

end

function GM:HandlePlayerSwimming( ply, velocity )

    if ( ply:WaterLevel() < 2 ) then 
        ply.InSwim = false
        return false 
    end
    
    if ( velocity:Length2D() > 10 ) then
        ply.CalcIdeal = ACT_MP_SWIM
    else
        ply.CalcIdeal = ACT_MP_SWIM_IDLE
    end
        
    ply.InSwim = true
    return true
    
end

function GM:HandlePlayerDriving( ply )

    if ply:InVehicle() then
        local vehicle = ply:GetVehicle()
        
        if ( vehicle.HandleAnimation != nil ) then
        
            local seq = vehicle:HandleAnimation( ply )
            if ( seq != nil ) then
                ply.CalcSeqOverride = seq
                return true
            end
            
        else
        
            local class = vehicle:GetClass()
            
            if ( class == "prop_vehicle_jeep" ) then
                ply.CalcSeqOverride = ply:LookupSequence( "drive_jeep" )
            elseif ( class == "prop_vehicle_airboat" ) then
                ply.CalcSeqOverride = ply:LookupSequence( "drive_airboat" )
            elseif ( class == "prop_vehicle_prisoner_pod" and vehicle:GetModel() == "models/vehicles/prisoner_pod_inner.mdl" ) then
                // HACK!!
                ply.CalcSeqOverride = ply:LookupSequence( "drive_pd" )
            else
                ply.CalcSeqOverride = ply:LookupSequence( "sit_rollercoaster" )
            end
            
            return true
        end
    end
    
    return false
end

/*---------------------------------------------------------
   Name: gamemode:UpdateAnimation( )
   Desc: Animation updates (pose params etc) should be done here
---------------------------------------------------------*/
function GM:UpdateAnimation( ply, velocity, maxseqgroundspeed )    

    local len = velocity:Length()
    local movement = 1.0
    
    if ( len > 0.2 ) then
            movement =  ( len / maxseqgroundspeed )
    end
    
    rate = math.min( movement, 2 )

    // if we're under water we want to constantly be swimming..
    if ( ply:WaterLevel() >= 2 ) then
        rate = math.max( rate * 0.1, 0.1 )
    elseif ( ply:GetMoveType() == MOVETYPE_NOCLIP ) then 
        rate = len * 0.00001;
    elseif ( !ply:IsOnGround() and len >= 1000 ) then 
        rate = 0.1;
    end
    
    ply:SetPlaybackRate( rate )



    
    if ( ply:InVehicle() ) then
        local Vehicle =  ply:GetVehicle()
        
        // We only need to do this clientside..
        if ( CLIENT ) then
            //
            // This is used for the 'rollercoaster' arms
            //
            local Velocity = Vehicle:GetVelocity()
            ply:SetPoseParameter( "vertical_velocity", Velocity.z * 0.01 ) 

            // Pass the vehicles steer param down to the player
            local steer = Vehicle:GetPoseParameter( "vehicle_steer" )
            steer = steer * 2 - 1 // convert from 0..1 to -1..1
            ply:SetPoseParameter( "vehicle_steer", steer  ) 
        end
        
    end
    
    if ( CLIENT ) then
        GAMEMODE:GrabEarAnimation( ply )
    end
    
end

//
// If you don't want the player to grab his ear in your gamemode then
// just override this.
//
function GM:GrabEarAnimation( ply )    

    ply.ChatGestureWeight = ply.ChatGestureWeight or 0

    if ( ply:IsSpeaking() ) then
        ply.ChatGestureWeight = math.Approach( ply.ChatGestureWeight, 1, FrameTime() * 10.0 );
    else
        ply.ChatGestureWeight = math.Approach( ply.ChatGestureWeight, 0, FrameTime()  * 10.0 );
    end
    
    if ( ply.ChatGestureWeight > 0 ) then
    
        ply:AnimRestartGesture( GESTURE_SLOT_CUSTOM, ACT_GMOD_IN_CHAT )
        ply:AnimSetGestureWeight( GESTURE_SLOT_CUSTOM, ply.ChatGestureWeight )
        
    end

end

function GM:CalcMainActivity( ply, velocity )    

    ply.CalcIdeal = ACT_MP_STAND_IDLE
    ply.CalcSeqOverride = -1
    
    if self:HandlePlayerDriving( ply ) or
        self:HandlePlayerNoClipping( ply, velocity ) or
        self:HandlePlayerVaulting( ply, velocity ) or
        self:HandlePlayerJumping( ply, velocity ) or
        self:HandlePlayerDucking( ply, velocity ) or
        self:HandlePlayerSwimming( ply, velocity ) then
        
    else
        local len2d = velocity:Length2D()
        
        if len2d > 210 then
            ply.CalcIdeal = ACT_MP_RUN
        elseif len2d > 0.5 then
            ply.CalcIdeal = ACT_MP_WALK
        end
    end
    
    // a bit of a hack because we're missing ACTs for a couple holdtypes
    local weapon = ply:GetActiveWeapon()
    
    if ply.CalcIdeal == ACT_MP_CROUCH_IDLE and
        IsValid(weapon) and
        ( weapon:GetHoldType() == "knife" or weapon:GetHoldType() == "melee2" ) then
        
        ply.CalcSeqOverride = ply:LookupSequence("cidle_" .. weapon:GetHoldType())
    end
    

    return ply.CalcIdeal, ply.CalcSeqOverride

end

local IdleActivity = ACT_HL2MP_IDLE
local IdleActivityTranslate = {}
    IdleActivityTranslate [ ACT_MP_STAND_IDLE ]                 = IdleActivity
    IdleActivityTranslate [ ACT_MP_WALK ]                         = IdleActivity+1
    IdleActivityTranslate [ ACT_MP_RUN ]                         = IdleActivity+2
    IdleActivityTranslate [ ACT_MP_CROUCH_IDLE ]                 = IdleActivity+3
    IdleActivityTranslate [ ACT_MP_CROUCHWALK ]                 = IdleActivity+4
    IdleActivityTranslate [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]     = IdleActivity+5
    IdleActivityTranslate [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]    = IdleActivity+5
    IdleActivityTranslate [ ACT_MP_RELOAD_STAND ]                 = IdleActivity+6
    IdleActivityTranslate [ ACT_MP_RELOAD_CROUCH ]                 = IdleActivity+6
    IdleActivityTranslate [ ACT_MP_JUMP ]                         = ACT_HL2MP_JUMP_SLAM
    IdleActivityTranslate [ ACT_MP_SWIM_IDLE ]                     = ACT_MP_SWIM_IDLE
    IdleActivityTranslate [ ACT_MP_SWIM ]                         = ACT_MP_SWIM
    
// it is preferred you return ACT_MP_* in CalcMainActivity, and if you have a specific need to not tranlsate through the weapon do it here
function GM:TranslateActivity( ply, act )

    local act = act
    local newact = ply:TranslateWeaponActivity( act )
    
    // select idle anims if the weapon didn't decide
    if ( act == newact ) then
        return IdleActivityTranslate[ act ]
    end
    
    return newact

end

function GM:DoAnimationEvent( ply, event, data )
    if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
    
        if ply:Crouching() then
            ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_ATTACK_CROUCH_PRIMARYFIRE )
        else
            ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_ATTACK_STAND_PRIMARYFIRE )
        end
        
        return ACT_VM_PRIMARYATTACK
    
    elseif event == PLAYERANIMEVENT_ATTACK_SECONDARY then
    
        // there is no gesture, so just fire off the VM event
        return ACT_VM_SECONDARYATTACK
        
    elseif event == PLAYERANIMEVENT_RELOAD then
    
        if ply:Crouching() then
            ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_CROUCH )
        else
            ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_STAND )
        end
        
        return ACT_INVALID
        
    elseif event == PLAYERANIMEVENT_JUMP then
    
        ply.Jumping = true
        ply.FirstJumpFrame = true
        ply.JumpStartTime = CurTime()
        
        ply:AnimRestartMainSequence()
        
        return ACT_INVALID
        
    elseif event == PLAYERANIMEVENT_CANCEL_RELOAD then
    
        ply:AnimResetGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD )
        
        return ACT_INVALID
    end

    return nil
end