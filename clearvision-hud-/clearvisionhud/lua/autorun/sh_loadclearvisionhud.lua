if SERVER then
    resource.AddFile("materials/canvas/backplate.png")
    resource.AddFile("materials/canvas/AmmoBackplate.png")

    resource.AddFile("materials/icons/HeartIcon.png")
    resource.AddFile("materials/icons/IDCard.png")
    resource.AddFile("materials/icons/ArmorIcon.png")
    resource.AddFile("materials/icons/Warrent.png")
    resource.AddFile( "materials/icons/CashIcon.png" )
    resource.AddFile( "materials/icons/SallaryIcon.png" )
    resource.AddFile( "materials/icons/JobIcon.png" )
    resource.AddFile( "materials/icons/PlayerGroupIcon.png" )
    resource.AddFile( "materials/icons/AmmoIcon.png" )


    AddCSLuaFile("clearvisionhud/clearvisionhud.lua")
    AddCSLuaFile("clearvisionhud/config.lua")

else
    include("clearvisionhud/clearvisionhud.lua")
end