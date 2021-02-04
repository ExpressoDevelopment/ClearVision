-- Hud Main File
HUDConfig = {}
include("config.lua")

-- Register used Fonts
surface.CreateFont("WordFont", {
    font = "Arial",
    size = 20,
    weight = 1000,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false,
} )

surface.CreateFont("WordFontSmall", {
    font = "Arial",
    size = 15,
    weight = 750,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false,
} )

surface.CreateFont("WordFontSmall2", {
    font = "Arial",
    size = 18,
    weight = 750,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false,
} )

surface.CreateFont( "TitleFont", {
	font = "CloseCaption_Bold",
	size = 40,
	weight = 1500, 
	blursize = 0, 
	scanlines = 0, 
	antialias = true, 
	underline = false, 
	italic = false, 
	strikeout = false, 
	symbol = false, 
	rotary = false, 
	shadow = false, 
	additive = false, 
	outline = false,
} )


-- Pre Load Images for hud
local backplate = Material( "canvas/backplate.png" )
local AmmoBackplate = Material( "canvas/AmmoBackplate.png")

local WarrentStatus = Material( "icons/Warrent.png" )
local GunLicense = Material( "icons/IDCard.png" )
local HealthIcon = Material( "icons/HeartIcon.png" )
local ShieldIcon = Material( "icons/ArmorIcon.png" )
local CashIcon = Material( "icons/CashIcon.png" )
local SallaryIcon = Material( "icons/SallaryIcon.png" )
local JobIcon = Material( "icons/JobIcon.png" )
local PlayerGroupIcon = Material( "icons/PlayerGroupIcon.png" )
local AmmoIcon = Material( "icons/AmmoIcon.png" )

-- Variables used throughout 
-- Setting Max Values for the Lerp smoothing
if IsValid( LocalPlayer() ) then
    smoothHealth = LocalPlayer():GetMaxHealth()
else 
    smoothHealth = 100
end
local smoothArmour = 100

-- Needed functions to draw elements --
---------------------------------------
local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

local PANEL = {}
	local cos, sin, rad = math.cos, math.sin, math.rad

	AccessorFunc( PANEL, "m_masksize", "MaskSize", FORCE_NUMBER )

	function PANEL:Init()
		self.Avatar = vgui.Create("AvatarImage", self)
		self.Avatar:SetPaintedManually(true)
		self:SetMaskSize( 24 )
	end

	function PANEL:PerformLayout()
		self.Avatar:SetSize(self:GetWide(), self:GetTall())
	end

	function PANEL:SetPlayer( id )
		self.Avatar:SetPlayer( id, self:GetWide() )
	end

	function PANEL:Paint(w, h)
		render.ClearStencil() -- some people are so messy
		render.SetStencilEnable(true)

		render.SetStencilWriteMask( 1 )
		render.SetStencilTestMask( 1 )

		render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
		render.SetStencilPassOperation( STENCILOPERATION_ZERO )
		render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
		render.SetStencilReferenceValue( 1 )
		
		local _m = self.m_masksize
		
		local circle, t = {}, 0
		for i = 1, 360 do
			t = rad(i*720)/720
			circle[i] = { x = w/2 + cos(t)*_m, y = h/2 + sin(t)*_m }
		end
		draw.NoTexture()
		surface.SetDrawColor(color_white)
		surface.DrawPoly(circle)

		render.SetStencilFailOperation( STENCILOPERATION_ZERO )
		render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
		render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
		render.SetStencilReferenceValue( 1 )

		self.Avatar:SetPaintedManually(false)
		self.Avatar:PaintManual()
		self.Avatar:SetPaintedManually(true)

		render.SetStencilEnable(false)
		render.ClearStencil() -- you're welcome, bitch.
    end

function draw.Circle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is needed for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end
vgui.Register("AvatarCircleMask", PANEL)
local AvatarThing = vgui.Create( "AvatarCircleMask", DermaPanel)



--                     Completed                      --
--------------------------------------------------------






-- Functions Used to draw specific segmants of the hud --
---------------------------------------------------------

--         Draw Main hud DarkRP elements         --
---------------------------------------------------

-- Draw Main Hud --

function DrawPlayerHud() -- Used to draw the elements for the player info display

    surface.SetMaterial( backplate )
    surface.SetDrawColor( 255, 255, 255 )
    surface.DrawTexturedRect( 10, ScrH() - 174, 406, 164 )

    if LocalPlayer():getDarkRPVar("HasGunlicense") then
        surface.SetMaterial( GunLicense )
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.DrawTexturedRect( 45, ScrH() - 44, 35, 22 )
    else
        surface.SetMaterial( GunLicense )
        surface.SetDrawColor( 255, 255, 255, 75 )
        surface.DrawTexturedRect( 45, ScrH() - 44, 35, 22 )
    end

    if LocalPlayer():getDarkRPVar("wanted") then
        surface.SetMaterial( WarrentStatus )
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.DrawTexturedRect( 85, ScrH() - 48, 32, 32 )
    else
        surface.SetMaterial( WarrentStatus )
        surface.SetDrawColor( 255, 255, 255, 75 )
        surface.DrawTexturedRect( 85, ScrH() - 48, 32, 32 )
    end

    smoothHealth = Lerp(0.05, smoothHealth, math.Clamp(LocalPlayer():Health(), 0, 100))
    smoothArmour = Lerp(0.05, smoothArmour, math.Clamp(LocalPlayer():Armor(), 0, 100))
   

   -- Personalised Avatar
    surface.SetDrawColor( 0, 0, 0, 255)
	draw.NoTexture()
    draw.Circle( 30+55, ScrH() - 105, 57, 150 )
	AvatarThing:SetPos( 30, ScrH() - 160 )
	AvatarThing:SetSize( 110, 110 )
	AvatarThing:SetPlayer( LocalPlayer() )
	AvatarThing:SetMaskSize( 110 / 2 )

    
    -- Health Black Bar
    surface.SetDrawColor( 0, 0, 0, 255 )
    draw.NoTexture()
    surface.DrawTexturedRectRotated(190, ScrH() - 80, 133, 21, 63)

    -- Health Bar
    surface.SetDrawColor( 255, 0, 0, 255 )
    draw.NoTexture()
    surface.DrawTexturedRectRotated(190, ScrH() - 80, smoothHealth * 1.3, 18, 63)
    
    surface.SetMaterial( HealthIcon )
    surface.SetDrawColor( 255, 255, 255, 255 )
    surface.DrawTexturedRect( 215, ScrH() - 167, 19, 19 )

    healthpercent = Lerp(0.5, smoothHealth, math.Clamp(LocalPlayer():Health(), 0, 100))
    armourpercent = Lerp(0.5, smoothArmour, math.Clamp(LocalPlayer():Armor(), 0, 100))

    -- Complictaed as fuck for no reason  rotated text what the fuck is wrong with gmod like wtf just fucking uss css uggghhh
    local angle = -63;
        cam.StartOrthoView(0, 0, ScrW(), ScrH())
            cam.Start2D()
                local matrix = Matrix();
                matrix:SetTranslation(Vector(155, ScrH() - 30, 0));
                matrix:SetAngles(Angle(0, angle, 0));           
                render.PushFilterMag(TEXFILTER.ANISOTROPIC);
                render.PushFilterMin(TEXFILTER.ANISOTROPIC);
                    cam.PushModelMatrix(matrix)
                        DisableClipping(true);
                            draw.SimpleText(math.Round(healthpercent, 0).."%", "WordFont", 0 , 0 , Color(255, 255, 255, 255));
                        DisableClipping(false);
                    cam.PopModelMatrix();
                render.PopFilterMag();
                render.PopFilterMin();
            cam.End2D();
        cam.EndOrthoView();

    -- Armour Black Bar
    surface.SetDrawColor( 0, 0, 0, 255 )
    draw.NoTexture()
    surface.DrawTexturedRectRotated(220, ScrH() - 80, 133, 21, 63)

    -- Armour Bar
    surface.SetDrawColor( 0, 255, 255, 255 )
    draw.NoTexture()
    surface.DrawTexturedRectRotated(220, ScrH() - 80, smoothArmour * 1.3, 18, 63)
    
    surface.SetMaterial( ShieldIcon )
    surface.SetDrawColor( 255, 255, 255, 255 )
    surface.DrawTexturedRect( 243, ScrH() - 167, 20, 20 )

    -- Complictaed as fuck for no reason  rotated text what the fuck is wrong with gmod like wtf just fucking uss css uggghhh
    local angle = -63;
        cam.StartOrthoView(0, 0, ScrW(), ScrH())
            cam.Start2D()
                local matrix = Matrix();
                matrix:SetTranslation(Vector(185, ScrH() - 30, 0));
                matrix:SetAngles(Angle(0, angle, 0));           
                render.PushFilterMag(TEXFILTER.ANISOTROPIC);
                render.PushFilterMin(TEXFILTER.ANISOTROPIC);
                    cam.PushModelMatrix(matrix)
                        DisableClipping(true);
                            draw.SimpleText(math.Round(armourpercent, 0).."%", "WordFont", 0 , 0 , Color(255, 255, 255, 255));
                        DisableClipping(false);
                    cam.PopModelMatrix();
                render.PopFilterMag();
                render.PopFilterMin();
            cam.End2D();
        cam.EndOrthoView();

    -- DarkRP Components --
    -----------------------


    -- Name
    -- Name String Identifier, If Name is langer than 15 characters, it will remove last few characters and add ...
    if string.len(LocalPlayer():Nick()) > 15 then
        name = LocalPlayer():Nick()
        if string.len(LocalPlayer():Nick()) > 20 then
            name = name:sub(1, -8)
        else
            name = name:sub(1, -5)
        end
        draw.SimpleText(name.."...","WordFont", 370 + 30,ScrH() - 165, Color(0,0,0), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)  
    else
        draw.SimpleText(LocalPlayer():Nick(),"WordFont", 370 + 30,ScrH() - 165, Color(0,0,0), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)  
    end
    surface.SetDrawColor( 138, 138, 138, 255 )
    surface.DrawLine(265, ScrH() - 145, 400, ScrH() - 145)


    -- Salary
    draw.SimpleText("$".. LocalPlayer():getDarkRPVar("salary"), "WordFont", 340 + 30,ScrH() - 125, Color(0,0,0), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
    -- surface.SetDrawColor( 138, 138, 138, 255 )
    -- surface.DrawLine(310, ScrH() - 105, 400, ScrH() - 105)
    surface.SetMaterial( SallaryIcon )
    surface.SetDrawColor( 255, 255, 255, 255 )
    surface.DrawTexturedRect( 380, ScrH() - 126, 20, 20 )


    -- Cash
    draw.SimpleText("$".. LocalPlayer():getDarkRPVar("money"), "WordFont", 340 + 30,ScrH() - 95, Color(0,0,0), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
    -- surface.SetDrawColor( 138, 138, 138, 255 )
    -- surface.DrawLine(285, ScrH() - 75, 400, ScrH() - 75)
    surface.SetMaterial( CashIcon )
    surface.SetDrawColor( 255, 255, 255, 255 )
    surface.DrawTexturedRect( 380, ScrH() - 96, 20, 20 )


    -- Job
    if string.len(LocalPlayer():getDarkRPVar("job")) > 20 then
        job = LocalPlayer():getDarkRPVar("job")
        if string.len(job) > 20 then
            job = job:sub(1, -6)
        else
            job = job:sub(1, -3)
        end
        draw.SimpleText(job.."...","WordFont", 340 + 30, ScrH() - 65, Color(0,0,0), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)  
    else
        draw.SimpleText(LocalPlayer():getDarkRPVar("job"), "WordFont", 340 + 30,ScrH() - 65, Color(0,0,0), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)  
    end
    -- draw.SimpleText(LocalPlayer():getDarkRPVar("job"), "WordFont", 340 + 30,ScrH() - 65, Color(0,0,0), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
    -- surface.SetDrawColor( 138, 138, 138, 255 )
    -- surface.DrawLine(260, ScrH() - 45, 400, ScrH() - 45)
    surface.SetMaterial( JobIcon )
    surface.SetDrawColor( 255, 255, 255, 255 )
    surface.DrawTexturedRect( 378, ScrH() - 66, 26, 18 )


    -- Player Group
    if has_value(HUDConfig.StaffRanks, LocalPlayer():GetUserGroup()) then group = "Staff"
    elseif has_value(HUDConfig.DoantorRanks, LocalPlayer():GetUserGroup()) then group = "Donator"
    else group = "Player" end
    draw.SimpleText(group, "WordFont", 340 + 30, ScrH() - 35, Color(0,0,0), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
    -- surface.SetDrawColor( 138, 138, 138, 255 )
    -- surface.DrawLine(285, ScrH() - 75, 400, ScrH() - 75)

    surface.SetMaterial( PlayerGroupIcon )
    surface.SetDrawColor( 255, 255, 255, 255 )
    surface.DrawTexturedRect( 383, ScrH() - 35, 15, 15 )

end

--                   Draw Ammo Hud                  --
------------------------------------------------------

function DrawAmmoHud() -- Used to display current ammo

    if not LocalPlayer():HasWeapon("keys") then return end
    if LocalPlayer():Alive() then


        check = LocalPlayer():GetActiveWeapon():GetClass()
        //print(check)

        if check == "weapon_physgun" or check == "weapon_physcannon" or check == "gmod_tool" or check == "gmod_camera" or check == "none" then return
        else

            surface.SetMaterial( AmmoBackplate ) -- Used to draw Backplate for elements to sit on
            surface.SetDrawColor( 255, 255, 255, 255 )
            surface.DrawTexturedRect( ScrW() - 150, ScrH() - 65, 135, 55 )

            surface.SetMaterial( AmmoIcon ) -- Ammo Icon displayed in grey zone
            surface.SetDrawColor( 255, 255, 255, 255 )
            surface.DrawTexturedRect( ScrW() - 135, ScrH() - 55, 26, 30 )

            ammo_in_clip = math.Clamp(LocalPlayer():GetActiveWeapon():Clip1(), 0, 999)
            ammo_in_reserve = math.Clamp(LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType()), 0, 999)

            draw.SimpleText(ammo_in_clip.."/"..ammo_in_reserve, "WordFont", ScrW() - 85, ScrH() - 47, Color(0, 0, 0))
        end
    end

end


------------------------------------------------------------




--                    DarkRP Elements                     --
------------------------------------------------------------




--                       Job Agenda                       --
local function DrawHudAgenda()
 
local agendaText

    local shoulddraw = hook.Call("HUDShouldDraw", GAMEMODE, "DrawHudAgenda")
 
    if shoulddraw then 
        local agenda = LocalPlayer():getAgendaTable()
 
        if not agenda then return end
        
            agendaText = agendaText or DarkRP.textWrap((LocalPlayer():getDarkRPVar("agenda") or "No agenda set."):gsub("//", "\n"):gsub("\\n", "\n"), "DarkRPHUD1", 400)

            if agendaText == "No agenda set." or agendaText == "" then
                if agendaText != "" then agendaText = agendaText else agendaText = "NO AGENDA SET." end
                draw.RoundedBox(10, 14, 30, 215, 35, Color(255, 255, 255, 150))
                draw.RoundedBox( 0, 14, 10, 215, 30, Color(118, 118, 118, 255))
                draw.SimpleText( string.upper( agenda.Title ), "WordFont", 45, 25, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT ,1 )
                draw.DrawNonParsedText( ( agendaText ), "WordFontSmall2", 50, 42, Color( 69, 69, 69, 255 ),  TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            else
                draw.RoundedBox(10, 14, 30, 465, 90, Color(255, 255, 255, 150))
                draw.RoundedBox( 0, 14, 10, 465, 30, Color(118, 118, 118, 255))
                draw.SimpleText( string.upper( agenda.Title ), "WordFont", 175, 25, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT ,1 )
                draw.DrawNonParsedText( ( agendaText ), "WordFontSmall2", 40, 25, Color( 69, 69, 69, 255 ),  TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)    
            end       
    end
end

hook.Add("DarkRPVarChanged", "agendaHUD", function(ply, var, _, new)
 
    if ply ~= LocalPlayer() then return end
    if var == "agenda" and new then
        agendaText = DarkRP.textWrap(new:gsub("//", "\n"):gsub("\\n", "\n"), "DarkRPHUD1", 500)
    else
        agendaText = "No Agenda Set"
    end
 
end)  



--                      Lockdown                    --
local function DrawLockDown()
        local shoulddraw = hook.Call("HUDShouldDraw", GAMEMODE, "DrawLockDown")
	
	    if shoulddraw then

            local LockdownText = HUDConfig.LockdownText
            local LockdownPulse = 0
    
        
            if GetGlobalBool("DarkRP_LockDown") then

                draw.RoundedBox(10, ScrW() / 2 - (617 / 2), 30, 617, 35, Color(255, 255, 255, 150))
                draw.RoundedBox( 0, ScrW() / 2 - (617 / 2 ), 10, 617 + 1, 30, Color(153, 98, 98, 255))

                draw.SimpleText( "LOCKDOWN" , "WordFont",  ScrW() / 2,  17, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER )
                draw.SimpleText( string.upper(LockdownText), "WordFont",  ScrW() / 2 - 300, 45, Color( 69, 69, 69 ), TEXT_ALIGN_LEFT )
            end
	 
        end
end


--                     Arrested                   --
local function DrawArrested()

    if LocalPlayer():getDarkRPVar("Arrested") then

        if !timer.Exists( "JailTimer" ) then 
            timer.Create( "JailTimer", 1, GAMEMODE.Config.jailtimer or 120, function() end )
        end
        print(timer.RepsLeft("JailTimer"))

        draw.RoundedBox(10, ScrW() / 2 - (392 / 2), ScrH() / 10 + 20, 392, 35, Color(255,255,255))
        draw.RoundedBox(0, ScrW() / 2 - (392 / 2), ScrH() / 10, 392, 30, Color(118, 118, 118, 255))
        
        draw.SimpleText("ARRESTED", "WordFont", ScrW() / 2, ScrH() / 10 + 5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

        draw.SimpleText("You have been arrested. Time left: " .. tostring(timer.RepsLeft( "JailTimer" )) .. " seconds!","WordFont",ScrW()/2,ScrH() / 10 + 32,Color( 69, 69, 69, 255 ),TEXT_ALIGN_CENTER )

    end
end

--           Player Info Above Head          --

local function DrawEntityDisplay()
 
        local shootPos = LocalPlayer():GetShootPos()
        local aimVec = LocalPlayer():GetAimVector()
 
        for k, ply in pairs(players or player.GetAll()) do
                if not ply:Alive() or ply == LocalPlayer() then continue end
                local hisPos = ply:GetShootPos()
                if ply:getDarkRPVar("wanted") then wanted = true else wanted = false end
 
                if GAMEMODE.Config.globalshow then
                        DrawPlayerInfo(ply)
                -- Draw when you're (almost) looking at him
                elseif not GAMEMODE.Config.globalshow and hisPos:DistToSqr(shootPos) < 25000 then
                        local pos = hisPos - shootPos
                        local unitPos = pos:GetNormalized()
                        if unitPos:Dot(aimVec) > 0.95 then
                                local trace = util.QuickTrace(shootPos, pos, LocalPlayer())
                                if trace.Hit and trace.Entity ~= ply then return end
                                DrawPlayerInfo(ply)
                        end
                end
        end
 
        local tr = LocalPlayer():GetEyeTrace()
 
        if IsValid(tr.Entity) and tr.Entity:isKeysOwnable() and tr.Entity:GetPos():Distance(LocalPlayer():GetPos()) < 200 then
                tr.Entity:drawOwnableInfo()
        end
end





--             Draw3DOnDoor          --

local TitleColor = Color( 255, 255, 255, 255 )
local TitleOutlineColor = Color( 0, 0, 0, 200 )

local OwnerColor = Color( 255, 255, 255, 255 )
local OwnerOutlineColor = Color( 0, 0, 0, 200 )

local CoownerColor = Color( 255, 255, 255, 255 )
local CoownerOutlineColor = Color( 0, 0, 0, 200 )

local AllowedGroupsColor = Color( 255, 255, 255, 255 )
local AllowedGroupsOutlineColor = Color( 0, 0, 0, 200 )

local PurchaseColor = Color( 255, 255, 255, 255 )
local PurchaseOutlineColor = Color( 0, 0, 0, 255 )

local DrawDistance = 250

local doorInfo = {}

local function CalculateAlpha( time, dur, sa, ea, start )
	time = time - (start or 0)

	if time < 0 then return sa end	
	if time > dur then return ea end

	return sa + ((math.sin( (time / dur) * (math.pi / 2) )^2) * (ea - sa))
end

local function SetColorAlpha( col, mul )
	return Color( col.r, col.g, col.b, col.a * mul )
end

local function isDoor( door )
    if door.isDoor and door.isKeysOwnable then return door:isDoor() and door:isKeysOwnable() end
end

local function isOwnable( door )
	if door.getKeysNonOwnable then return door:getKeysNonOwnable() != true end
end

local function getTitle( door )
	if door.getKeysTitle then return door:getKeysTitle() end
end

local function getOwner( door )
	if door.getDoorOwner then
		local owner = door:getDoorOwner()
		if IsValid( owner ) then return owner end
	end
end

local function getCoowners( door )
	local owner = getOwner( door )
	local coents = {}

	if door.isKeysOwnedBy then
		for _, ply in pairs( player.GetAll() ) do
			if door:isKeysOwnedBy( ply ) and ply != owner then table.insert( coents, ply ) end
		end
	end

	return coents
end

local function isAllowedToCoown( door, ply )
	if door.isKeysAllowedToOwn and door.isKeysOwnedBy then return door:isKeysAllowedToOwn( ply ) and !door:isKeysOwnedBy( ply )end
end

local function getAllowedGroupNames( door )
	local ret = {}

	if door.getKeysDoorGroup and door:getKeysDoorGroup() then table.insert( ret, door:getKeysDoorGroup() )
	elseif door.getKeysDoorTeams then
		for tid in pairs( door:getKeysDoorTeams() or {} ) do
			local tname = team.GetName( tid )

			if tname then table.insert( ret, tname ) end
		end
    end
	return ret
end


hook.Add( "HUDDrawDoorData", "clearvision_overide", function( door )
	if isDoor( door ) and isOwnable( door ) then return true end
end )

function DrawDoorHud()
    if HUDConfig.DoorText == true then
    for _, door in pairs( ents.GetAll() ) do
            if !isDoor( door ) or !isOwnable( door ) then continue end

            local dinfo = doorInfo[door]

            if !dinfo then
                dinfo = {
                    coownCollapsed = true
                }

                local dimens = door:OBBMaxs() - door:OBBMins()
                local center = door:OBBCenter()
                local min, j 

                for i=1, 3 do
                    if !min or dimens[i] <= min then
                        j = i
                        min = dimens[i]
                    end
                end

                local norm = Vector()
                norm[j] = 1

                local lang = Angle( 0, norm:Angle().y + 90, 90 )

                if door:GetClass() == "prop_door_rotating" then
                    dinfo.lpos = Vector( center.x, center.y, 30 ) + lang:Up() * (min / 6)
                else
                    dinfo.lpos = center + Vector( 0, 0, 20 ) + lang:Up() * ((min / 2) - 0.1)
                end
                
                dinfo.lang = lang

                doorInfo[door] = dinfo
            end

            local dist = door:GetPos():Distance( LocalPlayer():GetShootPos() )

            if dist <= DrawDistance then
                dinfo.viewStart = dinfo.viewStart or CurTime()

                local title = getTitle( door )
                local owner = getOwner( door )
                local coowners = getCoowners( door ) or {}
                local allowedgroups = getAllowedGroupNames( door )

                local lpos, lang = Vector(), Angle()
                lpos:Set( dinfo.lpos )
                lang:Set( dinfo.lang )

                local ang = door:LocalToWorldAngles( lang )
                local dot = ang:Up():Dot( 
                    LocalPlayer():GetShootPos() - door:WorldSpaceCenter()
                )

                if dot < 0 then
                    lang:RotateAroundAxis( lang:Right(), 180 )
                    lpos = lpos - (2 * lpos * -lang:Up())
                    ang = door:LocalToWorldAngles( lang )
                end

                local pos = door:LocalToWorld( lpos )
                local scale = 0.14

                local vst = dinfo.viewStart
                local ct = CurTime()

                cam.Start3D2D( pos, ang, scale )
                    local admul = math.cos( (dist / DrawDistance) * (math.pi / 2) )^2
                    local amul = CalculateAlpha( ct, 0.75, 0, 1, vst ) * admul

                    if #allowedgroups < 1 then

                        draw.SimpleTextOutlined(owner and (title or "Private Property") or "Unowned","TitleFont",0, 10,SetColorAlpha( TitleColor, amul ),TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM,1, SetColorAlpha( TitleOutlineColor, amul ))
                        
                        if owner then

                            amul = CalculateAlpha( ct, 0.75, 0, 1, vst + 0.35 ) * admul
                            draw.SimpleTextOutlined(owner:Nick(),"TitleFont",0, 50,SetColorAlpha( OwnerColor, amul ),TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM,1, SetColorAlpha( OwnerOutlineColor, amul ))

                            if #coowners > 0 then
                                if !dinfo.coownCollapsed then
                                    local conames = {}

                                    for i=1, #coowners do
                                        table.insert( conames, coowners[i]:Nick() )
                                    end

                                    table.sort( conames )

                                    for i=1, #conames do
                                        amul = CalculateAlpha( ct, 0.75, 0, 1, dinfo.coownExpandStart + 0.2*i ) * admul

                                        draw.SimpleTextOutlined(conames[i],"TitleFont",0, 60 + 25*i,SetColorAlpha( CoownerColor, amul ),TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM,1, SetColorAlpha( CoownerOutlineColor, amul ))
                                    end
                                else
                                    amul = CalculateAlpha( ct, 1, 0, 1, vst + 1.0 ) * admul

                                    local whitpos = util.IntersectRayWithPlane( 
                                        LocalPlayer():GetShootPos(), LocalPlayer():GetAimVector(),
                                        pos, ang:Up()
                                    )
                                    local cy = 0
                                    local cactive = false

                                    if whitpos and LocalPlayer():GetEyeTrace().Entity == door then
                                        local hitpos = door:WorldToLocal( whitpos ) - lpos

                                        cy = -hitpos.z / scale
                                        cactive = true
                                    end

                                    if (ct - vst) >= 2 and cactive and cy >= 80 and cy <= 80 + 25 then
                                        dinfo.coownExpandRequestStart = dinfo.coownExpandRequestStart or CurTime()

                                        if CurTime() - dinfo.coownExpandRequestStart >= 0.75 then
                                            dinfo.coownCollapsed = false
                                            dinfo.coownExpandStart = CurTime()
                                            dinfo.coownExpandRequestStart = nil
                                        end

                                        amul = CalculateAlpha( ct, 0.75, 1, 0, dinfo.coownExpandRequestStart ) * admul --fade out
                                    else
                                        dinfo.coownExpandRequestStart = nil
                                    end

                                    draw.SimpleTextOutlined("And " .. #coowners .. " other(s)","TitleFont",0, 80,SetColorAlpha( CoownerColor, amul ),TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM,1, SetColorAlpha( CoownerOutlineColor, amul ))
                                end
                            end
                        else
                            draw.SimpleTextOutlined( "Press F2 to buy", "WordFont", 0, 45, SetColorAlpha( TitleColor, amul ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, SetColorAlpha( TitleOutlineColor, amul ))
                        end
                    else
                        for i=1, #allowedgroups do
                            amul = CalculateAlpha( ct, 0.75, 0, 1, vst + 0.2*i ) * admul
                            draw.SimpleTextOutlined(allowedgroups[i], "TitleFont", 0, 50 + 30*(i-1), SetColorAlpha( AllowedGroupsColor, amul ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, SetColorAlpha( AllowedGroupsOutlineColor, amul ))
                        end
                    end
                cam.End3D2D()
            else
                dinfo.viewStart = nil
                dinfo.coownCollapsed = true
            end
        end
    end
end

hook.Add( "PostDrawTranslucentRenderables", "clearvision_drawdisplay", DrawDoorHud)



function DrawPlayerInfo(ply)
        local pos = ply:EyePos()

        pos.z = pos.z + 10 -- The position we want is a bit above the position of the eyes
        pos = pos:ToScreen()
        pos.y = pos.y - 50 -- Move the text up a few pixels to compensate for the height of the text

        if has_value(HUDConfig.StaffRanks, ply:GetUserGroup()) then group = "Staff"
        elseif has_value(HUDConfig.DoantorRanks, ply:GetUserGroup()) then group = "Donator"
        else group = "Player" end

        if HUDConfig.ShowPlayerGunLicense == true or HUDConfig.ShowPlayerWanted == true then
            if wanted then
                // Functionality for outline to turn red
                draw.RoundedBoxEx(40, pos.x-(275/2), pos.y - 25, 275, 75, Color(245, 245, 245,255), false, true, true, true)
            else
                draw.RoundedBoxEx(40, pos.x-(275/2), pos.y - 25, 275, 75, Color(245, 245, 245,255), false, true, true, true)
        end
            
            surface.SetDrawColor(0, 0, 0, 255)
            surface.DrawLine(pos.x-110, pos.y + 13, pos.x + 75, pos.y + 13)
            draw.SimpleText(group, "WordFontSmall", pos.x + 75, pos.y + 21, Color(0,0,0), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
        else
            if wanted then
                // Functionality for outline to turn red
                draw.RoundedBoxEx(40, pos.x-(250/2), pos.y - 25, 250, 75, Color(245, 245, 245,255), false, true, true, true)
            else 
                draw.RoundedBoxEx(40, pos.x-(250/2), pos.y - 25, 250, 75, Color(245, 245, 245,255), false, true, true, true)
        end

            surface.SetDrawColor(0, 0, 0, 255)
            surface.DrawLine(pos.x-110, pos.y + 13, pos.x + 110, pos.y + 13)
            draw.SimpleText(group, "WordFontSmall", pos.x + 110, pos.y + 21, Color(0,0,0), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
        end

        if HUDConfig.ShowPlayerGunLicense == true or HUDConfig.ShowPlayerWanted == true then
            if wanted then
                -- surface.SetDrawColor( Color( 255, 0, 0, 255 ) )
                -- surface.DrawOutlinedRect( pos.x - 110, pos.y - 10, 186, 24 )
                draw.DrawNonParsedText(ply:Nick(), "DarkRPHUD2", pos.x - 10, pos.y - 10, Color(255, 0, 0, 255), 1, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            else
                draw.DrawNonParsedText(ply:Nick(), "DarkRPHUD2", pos.x - 10, pos.y - 10, Color(0, 0, 0, 255), 1, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            end
        else
            if wanted then
                -- surface.SetDrawColor( Color( 255, 0, 0, 255 ) )
                -- surface.DrawOutlinedRect( pos.x - 110, pos.y - 10, 221, 24 )
                draw.DrawNonParsedText(ply:Nick(), "DarkRPHUD2", pos.x - 0, pos.y - 10, Color(255, 0, 0, 255), 1, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            else
                draw.DrawNonParsedText(ply:Nick(), "DarkRPHUD2", pos.x - 0, pos.y - 10, Color(0, 0, 0, 255), 1, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            end
        end
 
        if GAMEMODE.Config.showjob then
                local teamname = team.GetName(ply:Team())
                draw.DrawNonParsedText(ply:getDarkRPVar("job") or teamname, "DarkRPHUD2", pos.x - 80, pos.y + 20, team.GetColor(ply:Team()), 1)
        end

        

        if HUDConfig.ShowPlayerGunLicense == true then
            if ply:getDarkRPVar("HasGunlicense") then
                    surface.SetMaterial(GunLicense)
                    surface.SetDrawColor(255,255,255,255)
                    surface.DrawTexturedRect(pos.x + 80, pos.y - 15, 35, 22)
                else
                    surface.SetMaterial(GunLicense)
                    surface.SetDrawColor(255,255,255,75)
                    surface.DrawTexturedRect(pos.x + 80, pos.y - 15, 35, 22)
            end
        end

        if HUDConfig.ShowPlayerWanted == true then
            if ply:getDarkRPVar("wanted") then
                    surface.SetMaterial( WarrentStatus )
                    surface.SetDrawColor( 255, 0, 0, 255 )
                    surface.DrawTexturedRect(pos.x + 82, pos.y + 15, 32, 32)
                else
                    surface.SetMaterial( WarrentStatus )
                    surface.SetDrawColor( 255, 255, 255, 75 )
                    surface.DrawTexturedRect(pos.x + 82, pos.y + 15, 32, 32)
            end
        end
end



function DrawHud()

    if not IsValid(LocalPlayer()) then return end
    
    -- Custom
    DrawAmmoHud()
    DrawHudAgenda()
    DrawLockDown()
    DrawArrested()
    DrawEntityDisplay()

    -- Default
    DrawPlayerHud()



end
hook.Add("HUDPaint", "DrawClearVisionHud", DrawHud)


local HideElementsTable = {
 
    ["DarkRP_HUD"]              = true,
    ["DarkRP_EntityDisplay"]    = true,
    ["DarkRP_ZombieInfo"]       = false,
    ["DarkRP_LocalPlayerHUD"]   = true,
    ["DarkRP_Hungermod"]        = true,
    ["DarkRP_Agenda"]           = true,
    ["DarkRP_LockdownHUD"]      = true,
    ["CHudHealth"]              = true,
    ["CHudBattery"]             = true,
    ["CHudAmmo"]                = true,
    ["CHudSecondaryAmmo"]       = true,
 
}
 
local function HideElements( ele )
    if HideElementsTable[ ele ] then
        return false
    end
end
hook.Add( "HUDShouldDraw", "HideElements", HideElements )