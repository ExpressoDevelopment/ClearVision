-- Add all ULX Staff ranks to the list below.
-- Used to display "Staff" on the users hud and on the above player info if player's group matches on of the groups below.
-- Make sure to use always add a `,` at the end of the line and NO `,` on the last line as seen bellow 
HUDConfig.StaffRanks = {
    "owner",
    "superadmin",
    "moderator"
}

-- Add all ULX Donator ranks to the list below.
-- Used to display "Donator" on the users hud and on the above player info if player's group matches on of the groups below.
-- Make sure to use always add a `,` at the end of the line and NO ``, on the last line as seen bellow 
HUDConfig.DoantorRanks = {
    "donator",
    "donator2",
    "supporter"
}

-- Message displayed in the center of the screen when mayor initiates the lockdown.
HUDConfig.LockdownText = "LOCK DOWN INITIATED, PLEASE RETURN TO YOUR HOMES IMMEDIATELY!"

-- Used to display player's license and wanted status over their head.
-- Set to FALSE to remove. Set to TRUE to add it
-- https://imgur.com/0tvg7Hc vs https://imgur.com/a/SPJEjzL
HUDConfig.ShowPlayerWanted = true 
HUDConfig.ShowPlayerGunLicense = true

-- Used to display the 3d text on doors which replaces the default darkrp version.
-- Set to TRUE to enable and set to FALSE to disable.
HUDConfig.DoorText = true