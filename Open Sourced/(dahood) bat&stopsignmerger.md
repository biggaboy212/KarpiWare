-- created by brady, need bat and stopsign for this to work

local toolname = "[Bat]"
  local toolname2 = "[StopSign]"

local plr = game:GetService'Players'.LocalPlayer
plr.Backpack[toolname].Parent = plr.Character
plr.Backpack[toolname2].Parent = plr.Character

local toollocation2 = game.Players.LocalPlayer.Character:WaitForChild(toolname2)
toollocation2.GripPos = Vector3.new(6,-0.1,0)

local toollocation = game.Players.LocalPlayer.Character:WaitForChild(toolname)
toollocation.GripPos = Vector3.new(0,-1,0)