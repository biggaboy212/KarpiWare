local version = "4.25"
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/VisualRoblox/Roblox/main/UI-Libraries/Visual%20Command%20UI%20Library/Source.lua', true))()
local ListLibrary = loadstring(game:HttpGet('https://raw.githubusercontent.com/biggaboy212/Utility-Libraries/main/ListLibrary/Source.lua'))()

local Window = Library:CreateWindow({
    Name = 'KarpiWare V4',
    IntroText = 'Proton Utilities | KarpiWare V'..version,
    IntroIcon = 'rbxassetid://0',
    IntroBlur = true,
    IntroBlurIntensity = 15,
    Theme =  Library.Themes.scriptware,
    Position = 'Bottom',
    Draggable = true,
    Prefix = _G.Prefix
})

-- variables
local HttpService = game:GetService("HttpService");
local file = "karpi_ware_settings.txt";
local savedtheme = nil
local others = game:GetService("Players")
local plr1 = others.LocalPlayer
local character = plr1.Character
local humanoid = character.Humanoid
local currentcamera = game.Workspace.CurrentCamera
local espog = false
local esp = false
local lines = false
local target = nil
local foundtarg = nil
local mgogpos = nil
local autofarm = false
local Waypoints = {

}


-- functions
function load()
	print("loading sets")
	if (readfile and isfile and isfile(file)) then
        print('file found, loading settings')
		savedtheme = HttpService:JSONDecode(readfile(file));
		Window:ChangeTheme(savedtheme)
        Window:CreateNotification('KarpiWare', 'Loaded saved theme')
	end
end

function save(tosave)
    print("saving sets")
    local json;
    if (writefile) then
    json = HttpService:JSONEncode(tosave)
    writefile(file, json);
    print("saved sets")
    else
        print("writefile function dosen't exist on this executor")
    end
end

function targetesp(targetplr)
 
 -- services
 local runService = game:GetService("RunService");
 
 -- variables
 local camera = workspace.CurrentCamera;
 local lasttarg = nil
 
 -- functions
 local newVector2, newColor3, draw = Vector2.new, Color3.new, Drawing.new;
 local tan, rad = math.tan, math.rad;
 local round = function(...) local a = {}; for i,v in next, table.pack(...) do a[i] = math.round(v); end return unpack(a); end;
 local wtvp = function(...) local a, b = camera.WorldToViewportPoint(camera, ...) return newVector2(a.X, a.Y), b, a.Z end;
 local wtvptrcrs = camera.WorldToViewportPoint

 local espCache = {};
 local function createEsp(player)
    local drawings = {};
    
    drawings.box = draw("Square");
    drawings.box.Thickness = 2;
    drawings.box.Filled = false;
    drawings.box.Color = Color3.fromRGB(0,255,0);
    drawings.box.Visible = false;
    drawings.box.ZIndex = 2;

    drawings.line = draw("Line")
    drawings.line.Visible = false;
    drawings.line.From = Vector2.new(0, 0);
    drawings.line.To = Vector2.new(1, 1);
    drawings.line.Color = Color3.fromRGB(0,255,0);
    drawings.line.Thickness = 1;
    drawings.line.ZIndex = 2;

    drawings.gui = Instance.new("BillboardGui")
    drawings.gui.ResetOnSpawn = false
    drawings.gui.AlwaysOnTop = true;
    drawings.gui.LightInfluence = 0;
    drawings.gui.Size = UDim2.new(1.75, 0, 1.75, 0);

    drawings.esp = Instance.new("TextLabel",drawings.gui)
    drawings.esp.BackgroundTransparency = 1
    drawings.esp.Text = ""
    drawings.esp.Size = UDim2.new(0.0001, 0.00001, 0.0001, 0.00001);
    drawings.esp.Font = "GothamSemibold"
    drawings.esp.TextSize = 8
    drawings.esp.TextColor3 = Color3.fromRGB(0,255,0) 
 
    espCache[player] = drawings;
 end
 
 local function removeEsp(player)
    if rawget(espCache, player) then
        for _, drawing in next, espCache[player] do
            drawing:Remove();
        end
        espCache[player] = nil;
    end
 end
 
 local function updateEsp(player, esp)
    local character = player and player.Character;
    if character then
        local cframe = character:GetModelCFrame();
        local position, visible, depth = wtvp(cframe.Position);
        esp.box.Visible = visible;
        esp.line.Visible = visible;

        esp.esp.Text = player.Name.." | Health: "..math.round(character:WaitForChild("Humanoid").Health)
        esp.gui.Parent = character.Head

            esp.box.Color = Color3.new(1, 0, 0):Lerp(Color3.new(0, 1, 0), character.Humanoid.Health / character.Humanoid.MaxHealth)
            esp.line.Color = Color3.new(1, 0, 0):Lerp(Color3.new(0, 1, 0), character.Humanoid.Health / character.Humanoid.MaxHealth)
            esp.esp.TextColor3 = Color3.new(1, 0, 0):Lerp(Color3.new(0, 1, 0), character.Humanoid.Health / character.Humanoid.MaxHealth)
 
        if cframe and visible then
            -- box
            local scaleFactor = 1 / (depth * tan(rad(camera.FieldOfView / 2)) * 2) * 1000;
            local width, height = round(4 * scaleFactor, 5 * scaleFactor);
            local x, y = round(position.X, position.Y);
 
            esp.box.Size = newVector2(width, height);
            esp.box.Position = newVector2(round(x - width / 2, y - height / 2));

            -- tracers (copied over from one of my other scripts so some variables from above aren't used)
            if lines == true and visible then
            esp.line.Visible = true;
            esp.line.From = newVector2(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 1)
            esp.line.To = newVector2(position.X, position.Y)
            elseif lines == false then
                esp.line.Visible = false;
            end
        end
    else
        esp.box.Visible = false;
        esp.line.Visible = false;
    end
 end
 
 -- main
        createEsp(targetplr);

 
 runService:BindToRenderStep("esp", Enum.RenderPriority.Camera.Value, function()
    for player, drawings in next, espCache do
        if drawings then
            updateEsp(player, drawings);
        end
    end
if lasttarg == nil then lasttarg = targetplr
elseif lasttarg ~= target then
    removeEsp(lasttarg)
end
 end)
end


load()


Window:AddCommand('ChangeTheme', {'Theme'}, 'Dark, Light, Red, Orange, Purple, Blue', function(Arguments, Speaker)
    if Arguments[1] == "Dark" then
        Window:ChangeTheme('dark')
        save('dark')
    elseif Arguments[1] == "dark" then
        Window:ChangeTheme('dark')
        save('dark')
    elseif Arguments[1] == "Light" then
        Window:ChangeTheme('light')
        save('light')
    elseif Arguments[1] == "Red" then
        Window:ChangeTheme('redandblack')
        save('redandblack')
    elseif Arguments[1] == "Orange" then
        Window:ChangeTheme('kiriot')
        save('kiriot')
    elseif Arguments[1] == "Purple" then
        Window:ChangeTheme('purple')
        save('purple')
    elseif Arguments[1] == "Blue" then
        Window:ChangeTheme('scriptware')
        save('scriptware')
    elseif Arguments[1] == "light" then
        Window:ChangeTheme('light')
        save('light')
    elseif Arguments[1] == "red" then
        Window:ChangeTheme('redandblack')
        save('redandblack')
    elseif Arguments[1] == "orange" then
        Window:ChangeTheme('kiriot')
        save('kiriot')
    elseif Arguments[1] == "purple" then
        Window:ChangeTheme('purple')
        save('purple')
    elseif Arguments[1] == "blue" then
        Window:ChangeTheme('scriptware')
        save('scriptware')
    end
end)


Window:AddCommand('Discord', {}, 'Copies discord link', function(Arguments, Speaker)
    setclipboard("https://discord.gg/sbZNGNVdE9")
    Window:CreateNotification('KarpiWare', 'Copied Discord link')
end)


Window:AddCommand('Version', {}, 'Gets version', function(Arguments, Speaker)
    Window:CreateNotification('KarpiWare', 'Current version: '..version)
end)


Window:AddCommand('Legacy', {}, 'Loads Legacy KW ChatCMDS (not supported)', function(Arguments, Speaker)
   loadstring(game:HttpGet("https://raw.githubusercontent.com/biggaboy212/KarpiWare/main/KarpiWare%20V3%20(ChatCMDS)"))()
end)

Window:AddCommand('ESP', {}, 'Revamped ESP (Load again to disable)', function(Arguments, Speaker)
    -- initially created by 'mickeyrbx', revamped by me
    if esp == false then
        esp = true
        if espog == false then
                -- services
 local runService = game:GetService("RunService");
 
 -- variables
 local camera = workspace.CurrentCamera;
 local lasttarg = nil
 
 -- functions
 local newVector2, newColor3, draw = Vector2.new, Color3.new, Drawing.new;
 local tan, rad = math.tan, math.rad;
 local round = function(...) local a = {}; for i,v in next, table.pack(...) do a[i] = math.round(v); end return unpack(a); end;
 local wtvp = function(...) local a, b = camera.WorldToViewportPoint(camera, ...) return newVector2(a.X, a.Y), b, a.Z end;
 local wtvptrcrs = camera.WorldToViewportPoint

 local espCache = {};
 local function createEsp(player)
    local drawings = {};
    
    drawings.box = draw("Square");
    drawings.box.Thickness = 2;
    drawings.box.Filled = false;
    drawings.box.Color = Color3.fromRGB(0,255,0);
    drawings.box.Visible = false;
    drawings.box.ZIndex = 2;

    drawings.line = draw("Line")
    drawings.line.Visible = false;
    drawings.line.From = Vector2.new(0, 0);
    drawings.line.To = Vector2.new(1, 1);
    drawings.line.Color = Color3.fromRGB(0,255,0);
    drawings.line.Thickness = 1;
    drawings.line.ZIndex = 2;

    drawings.gui = Instance.new("BillboardGui")
    drawings.gui.ResetOnSpawn = false
    drawings.gui.AlwaysOnTop = true;
    drawings.gui.LightInfluence = 0;
    drawings.gui.Size = UDim2.new(1.75, 0, 1.75, 0);

    drawings.esp = Instance.new("TextLabel",drawings.gui)
    drawings.esp.BackgroundTransparency = 1
    drawings.esp.Text = ""
    drawings.esp.Size = UDim2.new(0.0001, 0.00001, 0.0001, 0.00001);
    drawings.esp.Font = "GothamSemibold"
    drawings.esp.TextSize = 8
    drawings.esp.TextColor3 = Color3.fromRGB(0,255,0) 
 
    espCache[player] = drawings;
 end
 
 local function removeEsp(player)
    if rawget(espCache, player) then
        for _, drawing in next, espCache[player] do
            drawing:Remove();
        end
        espCache[player] = nil;
    end
 end
 
 local function updateEsp(player, esp)
    local character = player and player.Character;
    if character then
        local cframe = character:GetModelCFrame();
        local position, visible, depth = wtvp(cframe.Position);
        esp.box.Visible = visible;
        esp.line.Visible = visible;

        esp.esp.Text = player.Name.." | Health: "..math.round(character:WaitForChild("Humanoid").Health)
        esp.gui.Parent = character.Head

            esp.box.Color = Color3.new(1, 0, 0):Lerp(Color3.new(0, 1, 0), character.Humanoid.Health / character.Humanoid.MaxHealth)
            esp.line.Color = Color3.new(1, 0, 0):Lerp(Color3.new(0, 1, 0), character.Humanoid.Health / character.Humanoid.MaxHealth)
            esp.esp.TextColor3 = Color3.new(1, 0, 0):Lerp(Color3.new(0, 1, 0), character.Humanoid.Health / character.Humanoid.MaxHealth)
 
        if cframe and visible then
            -- box
            local scaleFactor = 1 / (depth * tan(rad(camera.FieldOfView / 2)) * 2) * 1000;
            local width, height = round(4 * scaleFactor, 5 * scaleFactor);
            local x, y = round(position.X, position.Y);
 
            esp.box.Size = newVector2(width, height);
            esp.box.Position = newVector2(round(x - width / 2, y - height / 2));

            -- tracers (copied over from one of my other scripts so some variables from above aren't used)
            if lines == true and visible then
            esp.line.Visible = true;
            esp.line.From = newVector2(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 1)
            esp.line.To = newVector2(position.X, position.Y)
            elseif lines == false then
                esp.line.Visible = false;
            end
        end
    else
        esp.box.Visible = false;
        esp.line.Visible = false;
    end
 end
    
    -- main
    for _, player in next, others:GetPlayers() do
        if player ~= plr1 then
            createEsp(player);
        end
     end
     
     others.PlayerAdded:Connect(function(player)
        createEsp(player);
     end);
     
     others.PlayerRemoving:Connect(function(player)
        removeEsp(player);
     end)
   
    
    runService:BindToRenderStep("esp", Enum.RenderPriority.Camera.Value, function()
        if esp == true then
       for player, drawings in next, espCache do
           if drawings then
               updateEsp(player, drawings);
           end
       end
    else 
        for _, player in next, others:GetPlayers() do
            if player ~= plr1 then
                removeEsp(player)
            end
         end
    end
    end)
        end
    elseif esp == true then
        esp = false
    end
 end)

 Window:AddCommand('Tracers', {}, 'Enables/Disables Tracer ESP (Must have ESP Enabled)', function(Arguments, Speaker)
    if lines == false then lines = true elseif lines == true then lines = false end
 end)

-- antislow
Window:AddCommand('AntiSlow', {}, 'Prevents you from being slowed down while in combat or shooting a gun.', function(Arguments, Speaker)
    --// ws antislow
    local mt = getrawmetatable(game)
    local backup
        backup = hookfunction(mt.__newindex, newcclosure(function(self, key, value)
            if key == "WalkSpeed" and value < 16 then
            value = 16
        end
    return backup(self, key, value)
end))
--// jp antislow
    local mt = getrawmetatable(game)
    local backup
        backup = hookfunction(mt.__newindex, newcclosure(function(self, key, value)
            if key == "JumpPower" and value < 50 then
            value = 50
        end
    return backup(self, key, value)
end))
end)

-- equiptool
Window:AddCommand('Equip', {'Tool'}, 'Equips a tool from your inventory, you can equip multiple tools with this', function(Arguments, Speaker)
    plr1.Backpack[Arguments[1]].Parent = character
end)

-- No Reoil
Window:AddCommand('NoRecoil', {}, 'Removes Gun Recoil', function(Arguments, Speaker)
    for i,v in pairs(game:GetService('Workspace'):GetChildren()) do
        if v:IsA('Camera') then
            v:Destroy()
        end
    end
    local Camera2 = Instance.new('Camera',game.Workspace)
    Camera2.Name = 'Camera'
    Camera2.CameraType = 'Custom'
    Camera2.CameraSubject = humanoid
    Camera2.HeadLocked = true
    Camera2.HeadScale = 1
    game.Workspace.CurrentCamera.CameraSubject = character
end)

-- Rejoin
Window:AddCommand('Rejoin', {}, 'Rejoins the game', function(Arguments, Speaker)
    game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
end)


-- double barrel sg pp
Window:AddCommand('Male1', {}, 'Double-Barrel SG | PP', function(Arguments, Speaker)
    local PPname2 = "[Double-Barrel SG]"

    local PPlocation2 = character:WaitForChild(PPname2)
    PPlocation2.GripPos = Vector3.new(1.3,1,-0.3)
end)

-- rpg pp
Window:AddCommand('Male2', {}, 'RPG | PP', function(Arguments, Speaker)
    local PPname2 = "[RPG]"

    local PPlocation2 = character:WaitForChild(PPname2)
    PPlocation2.GripPos = Vector3.new(-0.55,2,-1)
end)

-- bat pp
Window:AddCommand('Male3', {}, 'Bat | PP', function(Arguments, Speaker)
    local PPname2 = "[Bat]"
    local PPlocation2 = character:WaitForChild(PPname2)
    PPlocation2.GripForward = Vector3.new(0,10,0)
    PPlocation2.GripPos = Vector3.new(-2,-0.5,0.3)
end)

-- Curved PP
Window:AddCommand('CurvedMale', {}, 'Get Old Phone from phone store to use this', function(Arguments, Speaker)
    local PPname2 = "[Phone]"
    local PPlocation2 = character:WaitForChild(PPname2)
    print(Vector3.new(PPlocation2.GripPos))
    PPlocation2.GripPos = Vector3.new(-1.85,1.5,1.2)
end)

-- Destroy Seats
Window:AddCommand('AntiSit', {}, 'Destroys all seats in the game', function(Arguments, Speaker)
    for _,a in pairs(workspace:GetDescendants()) do
        if a:IsA("Seat") then
            a:Remove()
        end
    end
end)

-- Show users
Window:AddCommand('ShowNames', {}, 'Shows masked names', function(Arguments, Speaker)
    for i,v in pairs(others:GetChildren()) do
        v:FindFirstChildWhichIsA('Humanoid').DisplayDistanceType = 'Subject'
    end
end)

-- AimView
Window:AddCommand('AimView', {}, 'Not mine | Allows you to see where others are aiming', function(Arguments, Speaker)
    -- // Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- // Vars
local Terrain = Workspace.Terrain
local LocalPlayer = Players.LocalPlayer
local Beams = {}

local Colours = {
    At = ColorSequence.new(Color3.new(123, 123, 123), Color3.new(123, 123, 123)),
    Away = ColorSequence.new(Color3.new(123, 123, 123), Color3.new(123, 123, 123))
}

local function IsBeamHit(Beam, MousePos)
    local Character = LocalPlayer.Character
    local Attachment = Beam.Attachment1

    local Origin = Beam.Attachment0.WorldPosition
    local Direction = MousePos - Origin

    local raycastParms = RaycastParams.new()
    raycastParms.FilterDescendantsInstances = {Character, Workspace.CurrentCamera}
    local RaycastResult = Workspace:Raycast(Origin, Direction * 2, raycastParms)
    if (not RaycastResult) then
        Beam.Color = Colours.Away
        Attachment.WorldPosition = MousePos
        return
    end

    if (Character) then
        Beam.Color = RaycastResult.Instance:IsDescendantOf(Character) and Colours.At or Colours.Away
    end

    Attachment.WorldPosition = RaycastResult.Position
end

local function CreateBeam(Character)
    local Beam = Instance.new("Beam", Character)

    Beam.Attachment0 = Character:WaitForChild("Head"):WaitForChild("FaceCenterAttachment")
    Beam.Enabled = Character:FindFirstChild("GunScript", true) ~= nil

    Beam.Width0 = 0.1
    Beam.Width1 = 0.1

    table.insert(Beams, Beam)

    -- // Return
    return Beam
end

local function OnCharacter(Character)
    if (not Character) then
        return
    end

    local MousePos = Character:WaitForChild("BodyEffects"):WaitForChild("MousePos")

    local Beam = CreateBeam(Character)

    local Attachment = Instance.new("Attachment", Terrain)
    Beam.Attachment1 = Attachment
    IsBeamHit(Beam, MousePos.Value)
    MousePos.Changed:Connect(function()
        IsBeamHit(Beam, MousePos.Value)
    end)

    Character.DescendantAdded:Connect(function(Descendant)
        if (Descendant.Name == "GunScript") then
            Beam.Enabled = true
        end
    end)

    Character.DescendantRemoving:Connect(function(Descendant)
        if (Descendant.Name == "GunScript") then
            Beam.Enabled = false
        end
    end)
end

local function OnPlayer(Player)
    OnCharacter(Player.Character)
    Player.CharacterAdded:Connect(OnCharacter)
end

for _, v in ipairs(Players:GetPlayers()) do
    OnPlayer(v)
end

Players.PlayerAdded:Connect(OnPlayer)
end)

-- Anti AutoKill
Window:AddCommand('AntiAutoKill', {}, 'Prevents people from autokilling you, Reset to stop', function(Arguments, Speaker)
    if game.Workspace:FindFirstChild("AntiAutoKillPart") then
        game.Workspace:FindFirstChild("AntiAutoKillPart"):Destroy()
    end
        game.Workspace.FallenPartsDestroyHeight = -15000
        local part = Instance.new("Part")
            part.Name = "AntiAutoKillPart"
            part.Size = Vector3.new(1000, 10, 1000)
            part.Parent = game.Workspace
            part.Anchored = true
            part.Position = Vector3.new(-897.6600952148438, -650.0717163085938, -709.875732421875)
        character.HumanoidRootPart.CFrame = part.CFrame
end)

-- Cash farm
Window:AddCommand('Autofarm', {}, 'Cash autofarm, rejoin to stop', function(Arguments, Speaker)
-- Revamped

if autofarm == true then -- to stop from lagging
else
    autofarm = true
    local humanoid = character.Humanoid
    local tool = plr1.Backpack.Combat

    local function Collect()
        task.wait(0.5)
        for i, v in ipairs(game.Workspace.Ignored.Drop:GetChildren()) do
            if v.Name == "MoneyDrop" and (v.Position - character.HumanoidRootPart.Position).magnitude <= 20 then
                character.HumanoidRootPart.CFrame = v.CFrame
                fireclickdetector(v.ClickDetector)
                task.wait(0.5)
            end
        end
    end

    local function Start()
            humanoid:EquipTool(tool)
            for i, v in ipairs(game.Workspace.Cashiers:GetChildren()) do
                character.HumanoidRootPart.CFrame = v.Open.CFrame * CFrame.new(0, 0, 2)
                for i = 0, 10 do
                    task.wait(0.5)
                    tool:Activate()
                end
            Collect()
        task.wait(0.5)
    end
    end
    Start()
end
end)

-- ClickTP
Window:AddCommand('ClickTP', {}, 'Teleports you where you hover over (Q)', function(Arguments, Speaker)
local plr = plr1
local hum = plr.Character.HumanoidRootPart
local mouse = plr:GetMouse()
mouse.KeyDown:connect(function(key)
if key == "q" then
if mouse.Target then
hum.CFrame = CFrame.new(mouse.Hit.x, mouse.Hit.y + 5, mouse.Hit.z)
end
end
end)
end)

-- Fly
Window:AddCommand('Fly', {}, 'Allows your character to fly (X)', function(Arguments, Speaker)
    local mouse = plr1:GetMouse()

	if workspace:FindFirstChild("Core") then
		workspace.Core:Destroy()
	end

	local Core = Instance.new("Part")
	Core.Name = "Core"
	Core.Size = Vector3.new(0.05, 0.05, 0.05)

	spawn(function()
		Core.Parent = workspace
		local Weld = Instance.new("Weld", Core)
		Weld.Part0 = Core
		Weld.Part1 = character.LowerTorso
		Weld.C0 = CFrame.new(0, 0, 0)
	end)

	workspace:WaitForChild("Core")

	local torso = workspace.Core
	flying = true
	local speed=10
	local keys={a=false,d=false,w=false,s=false}
	local e1
	local e2
	local function start()
		local pos = Instance.new("BodyPosition",torso)
		local gyro = Instance.new("BodyGyro",torso)
		pos.Name="EPIXPOS"
		pos.maxForce = Vector3.new(math.huge, math.huge, math.huge)
		pos.position = torso.Position
		gyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		gyro.cframe = torso.CFrame
		repeat
			wait()
			humanoid.PlatformStand=true
			local new=gyro.cframe - gyro.cframe.p + pos.position
			if not keys.w and not keys.s and not keys.a and not keys.d then
				speed=5
			end
			if keys.w then
				new = new + workspace.CurrentCamera.CoordinateFrame.lookVector * speed
				speed=speed+0
			end
			if keys.s then
				new = new - workspace.CurrentCamera.CoordinateFrame.lookVector * speed
				speed=speed+0
			end
			if keys.d then
				new = new * CFrame.new(speed,0,0)
				speed=speed+0
			end
			if keys.a then
				new = new * CFrame.new(-speed,0,0)
				speed=speed+0
			end
			if speed>10 then
				speed=5
			end
			pos.position=new.p
			if keys.w then
				gyro.cframe = workspace.CurrentCamera.CoordinateFrame*CFrame.Angles(-math.rad(speed*0),0,0)
			elseif keys.s then
				gyro.cframe = workspace.CurrentCamera.CoordinateFrame*CFrame.Angles(math.rad(speed*0),0,0)
			else
				gyro.cframe = workspace.CurrentCamera.CoordinateFrame
			end
		until flying == false
		if gyro then gyro:Destroy() end
		if pos then pos:Destroy() end
		flying=false
		humanoid.PlatformStand=false
		speed=10
	end
	e1=mouse.KeyDown:connect(function(key)
		if not torso or not torso.Parent then flying=false e1:disconnect() e2:disconnect() return end
		if key=="w" then
			keys.w=true
		elseif key=="s" then
			keys.s=true
		elseif key=="a" then
			keys.a=true
		elseif key=="d" then
			keys.d=true
		elseif key=="x" then
			if flying==true then
				flying=false
			else
				flying=true
				start()
			end
		end
	end)
	e2=mouse.KeyUp:connect(function(key)
		if key=="w" then
			keys.w=false
		elseif key=="s" then
			keys.s=false
		elseif key=="a" then
			keys.a=false
		elseif key=="d" then
			keys.d=false
		end
	end)
	start()
end)


Window:AddCommand('WP', {'WaypointName'}, 'Teleports to a waypoint', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = Waypoints[Arguments[1]]
    Window:CreateNotification('KarpiWare', 'Teleported to '..Arguments[1], 5)
end)


Window:AddCommand('AddWP', {'WaypointName'}, 'Sets a waypoint', function(Arguments, Speaker)
    Waypoints[Arguments[1]] = character.HumanoidRootPart.CFrame
    print(Waypoints[Arguments[1]])
    Window:CreateNotification('KarpiWare', 'Added '..Arguments[1], 5)
end)


Window:AddCommand('RemoveWP', {'WaypointName'}, 'Removes a waypoint', function(Arguments, Speaker)
    Waypoints[Arguments[1]] = nil
    Window:CreateNotification('KarpiWare', 'Removed '..Arguments[1], 5)
end)

Window:AddCommand('Inviskill', {}, 'Hover over to read description, aim at someone and press Z to shoot them (Revolver needed)"', function(Arguments, Speaker)
    local PPname = "[Revolver]"
    local mouse = plr1:GetMouse()
    
    mouse.KeyUp:Connect(function(key)
        if key == "z" then
            local revolver = plr1.Backpack[PPname]
            
            revolver.Parent = character
    
            local PPlocation = character:WaitForChild(PPname)
            PPlocation.GripPos = Vector3.new(-10, -10, 0)
    
            character.Humanoid:UnequipTools()
    
            revolver.Parent = character
            PPlocation:Activate()
    
            character.Humanoid:UnequipTools()
        end
    end)
    
end)


Window:AddCommand('ChatSpy', {}, 'Not Mine | Allows you to view chat messages', function(Arguments, Speaker)
    loadstring(game:HttpGet('https://raw.githubusercontent.com/dehoisted/Chat-Spy/main/source/main.lua'))()
end)


Window:AddCommand('Lock', {}, 'Not Mine | DNS Paid Lock leak', function(Arguments, Speaker)

    getgenv().DNS = {
        General = {
            Notifications = true,
            FOVMode = "PredictionPoint"
        },
        Silent = {
            Main = {
                Enabled = true,
                Mode = "Target",
                Toggle = "C",
                Prediction = 0.12471,
                Parts = {"Head","LowerTorso","UpperTorso"}
            },
            FOV = {
                ShowFOV = true,
                Radius = 40,
                Color = Color3.fromRGB(0, 71, 171),
                Filled = false,
                Transparency = 0.2
            }
        },
        Camlock = {
            Main = {
                Enabled = true,
                Key = "T",
                UnlockKey = "B",
                SmoothLock = true,
                Smoothness = 0.90,
                PredictMovement = true,
                Prediction = 0.37,
                Shake = false,
                ShakeValue = 7,
                Parts = {"UpperTorso"}
            },
            FOV = {
                UseFOV = true,
                ShowFOV = true,
                Radius = 40,
                Color = Color3.fromRGB(0, 71, 171),
                Filled = false,
                Transparency = 0.4
            }
        },
        Tracer = {
            Enabled = false,
            Color = Color3.fromRGB(137, 207, 240),
            Transparency = 0.4,
            Visible = false
        },
        AutoPrediction = { -- the numbers are pings ( this is for silent + Current sets not recommended )
            Enabled = true,
            ping20_30 = 0.12588,
            ping30_40 = 0.11911,
            ping40_50 = 0.12471,
            ping50_60 = 0.12766,
            ping60_70 = 0.12731,
            ping70_80 = 0.12951,
            ping80_90 = 0.13181,
            ping90_100 = 0.138,
            ping100_110 = 0.146,
            ping110_120 = 0.1367,
            ping120_130 = 0.1401,
            ping130_140 = 0.1437,
            ping140_150 = 0.153,
            ping150_160 = 0.1514,
            ping160_170 = 0.1663,
            ping170_180 = 0.1672,
            ping180_190 = 0.1848,
            ping190_200 = 0.1865,
        }
     }

     local function getnamecall()
        if game.PlaceId == 2788229376 then
            return "UpdateMousePos"
        elseif game.PlaceId == 5602055394 or game.PlaceId == 7951883376 then
            return "MousePos"
        elseif game.PlaceId == 9825515356 then
            return "GetMousePos"
        end
     end

     local namecalltype = getnamecall()

     function MainEventLocate()
        for _,v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
            if v.Name == "MainEvent" then
                return v
            end
        end
     end

     local mainevent = MainEventLocate()

     -- // Shorthand
     local uwuDNS = getgenv().DNS
     local uwuMain = uwuDNS.General
     local uwuCamMain = uwuDNS.Camlock.Main
     local uwuCamFOV = uwuDNS.Camlock.FOV
     local uwuSilentMain = uwuDNS.Silent.Main
     local uwuSilentFOV = uwuDNS.Silent.FOV
     local uwuTrace = uwuDNS.Tracer
     local uwuAutoPred = uwuDNS.AutoPrediction

     -- // Optimization
     local vect3 = Vector3.new
     local vect2 = Vector2.new
     local cnew = CFrame.new

     -- // Libraries
     local NotificationHolder = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Module.Lua"))()
     local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Client.Lua"))()

     -- // Services
     local uis = game:GetService("UserInputService")
     local rs = game:GetService("RunService")
     local plrs = game:GetService("Players")
     local ws = game:GetService("Workspace")

     -- // Script Variables
     local CToggle = false
     local lplr = plrs.LocalPlayer
     local CTarget = nil
     local CPart = nil
     local SToggle = false
     local STarget = nil
     local SPart = nil

     -- // Client Variables
     local m = lplr:GetMouse()
     local c = ws.CurrentCamera

     -- // Notification Function
     local function SendNotification(text)
        Notification:Notify(
            {Title = "DNS Rewrite", Description = "pl#0001 - "..text},
            {OutlineColor = Color3.fromRGB(50,76,110),Time = 2, Type = "image"},
            {Image = "http://www.roblox.com/asset/?id=6023426923", ImageColor = Color3.fromRGB(50,76,110)}
        )
     end

     -- // Call notification function
     if uwuMain.Notifications then
        SendNotification("DNS LOCK ")
     end

     -- // Camlock FOV
     local CamlockFOV = Drawing.new("Circle")
     CamlockFOV.Visible = uwuCamFOV.ShowFOV
     CamlockFOV.Thickness = 1
     CamlockFOV.NumSides = 30
     CamlockFOV.Radius = uwuCamFOV.Radius * 3
     CamlockFOV.Color = uwuCamFOV.Color
     CamlockFOV.Filled = uwuCamFOV.Filled
     CamlockFOV.Transparency = uwuCamFOV.Transparency

     --Silent FOV
     local SilentFOV = Drawing.new("Circle")
     SilentFOV.Visible = uwuSilentFOV.ShowFOV
     SilentFOV.Thickness = 1
     SilentFOV.NumSides = 30
     SilentFOV.Radius = uwuSilentFOV.Radius * 3
     SilentFOV.Color = uwuSilentFOV.Color
     SilentFOV.Filled = uwuSilentFOV.Filled
     SilentFOV.Transparency = uwuSilentFOV.Transparency

     --Tracer
     local Line = Drawing.new("Line")
     Line.Color = uwuTrace.Color
     Line.Transparency = uwuTrace.Transparency
     Line.Thickness = 1
     Line.Visible = uwuTrace.Visible

     -- // Script Functions
     local function uwuFindTawget() -- // Find target
        local d, t = math.huge, nil
        for _,v in pairs (plrs:GetPlayers()) do
            local _,os = c:WorldToViewportPoint(v.Character.PrimaryPart.Position)
            if v ~= lplr and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 and v.Character:FindFirstChild("HumanoidRootPart") and os then
                local pos = c:WorldToViewportPoint(v.Character.PrimaryPart.Position)
                local magnitude = (vect2(pos.X, pos.Y) - vect2(m.X, m.Y + 36)).magnitude
                if magnitude < d then
                    t = v
                    d = magnitude
                end
            end
        end
        return t
     end

     local function uwuFindPart() -- // Find aimpart
        local d, p = math.huge, nil
        if CTarget then
            for _,v in pairs(CTarget.Character:GetChildren()) do
                if table.find(uwuCamMain.Parts, v.Name) then
                    local pos = c:WorldToViewportPoint(v.Position)
                    local Magn = (vect2(m.X, m.Y + 36) - vect2(pos.X, pos.Y)).Magnitude
                    if Magn < d then
                        d = Magn
                        p = v
                    end
                end
            end
            return p.Name
        end
     end

     local function uwuFindSilentPart() -- // Find aimpart
        local d, p = math.huge, nil
        if CTarget then
            for _,v in pairs(CTarget.Character:GetChildren()) do
                if table.find(uwuSilentMain.Parts, v.Name) then
                    local pos = c:WorldToViewportPoint(v.Position)
                    local Magn = (vect2(m.X, m.Y + 36) - vect2(pos.X, pos.Y)).Magnitude
                    if Magn < d then
                        d = Magn
                        p = v
                    end
                end
            end
            return p.Name
        end
     end

     local function uwuCheckAnti(targ) -- // Anti-aim detection
        if (targ.Character.HumanoidRootPart.Velocity.Y < -5 and targ.Character.Humanoid:GetState() ~= Enum.HumanoidStateType.Freefall) or targ.Character.HumanoidRootPart.Velocity.Y < -50 then
            return true
        elseif targ and (targ.Character.HumanoidRootPart.Velocity.X > 35 or targ.Character.HumanoidRootPart.Velocity.X < -35) then
            return true
        elseif targ and targ.Character.HumanoidRootPart.Velocity.Y > 60 then
            return true
        elseif targ and (targ.Character.HumanoidRootPart.Velocity.Z > 35 or targ.Character.HumanoidRootPart.Velocity.Z < -35) then
            return true
        else
            return false
        end
     end

     local function InSilentRadiuwus(target, section, fov) -- // Check if player is in the fov
        if target then
            local pos = nil
            if not uwuCheckAnti(target) then
                pos = c:WorldToViewportPoint(target.Character.PrimaryPart.Position + target.Character.PrimaryPart.Velocity * section.Prediction)
            else
                pos = c:WorldToViewportPoint(target.Character.PrimaryPart.Position + ((target.Character.Humanoid.MoveDirection * target.Character.Humanoid.WalkSpeed) * section.Prediction))
            end
            local mag = (vect2(m.X, m.Y + 36) - vect2(pos.X, pos.Y)).Magnitude
            if mag < fov * 3 then
                return true
            else
                return false
            end
        end
     end

     local function Silent()
        if STarget then
            if SPart and InSilentRadiuwus(STarget, uwuSilentMain, SilentFOV.Radius) then
                if not uwuCheckAnti(STarget) then
                    mainevent:FireServer(namecalltype, STarget.Character[SPart].Position + (STarget.Character[SPart].Velocity * uwuSilentMain.Prediction))
                else
                    mainevent:FireServer(namecalltype, STarget.Character[SPart].Position + ((STarget.Character.Humanoid.MoveDirection * STarget.Character.Humanoid.WalkSpeed) * uwuSilentMain.Prediction))
                end
            end
        end
     end


     local function InRadiuwus(target, section, fov) -- // Check if player is in the fov
        if target then
            if uwuCamFOV.UseFOV then
                local pos = nil
                if not uwuCheckAnti(target) then
                    pos = c:WorldToViewportPoint(target.Character.PrimaryPart.Position + target.Character.PrimaryPart.Velocity * section.Prediction)
                else
                    pos = c:WorldToViewportPoint(target.Character.PrimaryPart.Position + ((target.Character.Humanoid.MoveDirection * target.Character.Humanoid.WalkSpeed) * section.Prediction))
                end
                local mag = (vect2(m.X, m.Y + 36) - vect2(pos.X, pos.Y)).Magnitude
                if mag < fov * 3 then
                    return true
                else
                    return false
                end
            else
                return true
            end
        end
     end

     uis.InputBegan:Connect(function(k,t)
        if not t then
            if k.KeyCode == Enum.KeyCode[uwuCamMain.Key:upper()] then
                CToggle = true
                CTarget = uwuFindTawget()
                if uwuMain.Notifications then
                    SendNotification("locked onto "..CTarget.Name)
                end
            elseif k.KeyCode == Enum.KeyCode[uwuCamMain.UnlockKey:upper()] then
                if CToggle then
                    CToggle = false
                    CTarget = nil
                    if uwuMain.Notifications then
                        SendNotification("unlocked")
                    end
                end
            elseif k.KeyCode == Enum.KeyCode[uwuSilentMain.Toggle:upper()] and uwuSilentMain == "Regular" then
                if SToggle then
                    SToggle = false
                    if uwuMain.Notifications then
                        SendNotification("silent disabled")
                    end
                else
                    SToggle = true
                    if uwuMain.Notifications then
                        SendNotification("silent enabled")
                    end
                end
            end
        end
     end)

     rs.RenderStepped:Connect(function()
        if CTarget then
            CPart = uwuFindPart()
            local pos = nil
            local cum = nil
            if CTarget.Character.BodyEffects["K.O"].Value == true or lplr.Character.BodyEffects["K.O"].Value == true then
                CToggle = false
                CTarget = nil
            else
                if uwuCamMain.Shake then
                    if uwuCamMain.PredictMovement then
                        if not uwuCheckAnti(CTarget) then
                            cum = CTarget.Character[CPart].Position + CTarget.Character[CPart].Velocity * uwuCamMain.Prediction + (vect3(
                                math.random(-uwuCamMain.ShakeValue, uwuCamMain.ShakeValue),
                                math.random(-uwuCamMain.ShakeValue, uwuCamMain.ShakeValue),
                                math.random(-uwuCamMain.ShakeValue, uwuCamMain.ShakeValue)
                            ) * 0.1)
                        else
                            cum = CTarget.Character[CPart].Position + ((CTarget.Character.Humanoid.MoveDirection * CTarget.Character.Humanoid.WalkSpeed) * uwuCamMain.Prediction + (vect3(
                                math.random(-uwuCamMain.ShakeValue, uwuCamMain.ShakeValue),
                                math.random(-uwuCamMain.ShakeValue, uwuCamMain.ShakeValue),
                                math.random(-uwuCamMain.ShakeValue, uwuCamMain.ShakeValue)
                            ) * 0.1))
                        end
                        pos = c:WorldToViewportPoint(cum)
                    else
                        cum = CTarget.Character[CPart].Position + (vect3(
                            math.random(-uwuCamMain.ShakeValue, uwuCamMain.ShakeValue),
                            math.random(-uwuCamMain.ShakeValue, uwuCamMain.ShakeValue),
                            math.random(-uwuCamMain.ShakeValue, uwuCamMain.ShakeValue)
                        ) * 0.1)
                        pos = c:WorldToViewportPoint(cum)
                    end
                else
                    if uwuCamMain.PredictMovement then
                        if not uwuCheckAnti(CTarget) then
                            cum = CTarget.Character[CPart].Position + CTarget.Character[CPart].Velocity * uwuCamMain.Prediction
                        else
                            cum = CTarget.Character[CPart].Position + ((CTarget.Character.Humanoid.MoveDirection * CTarget.Character.Humanoid.WalkSpeed) * uwuCamMain.Prediction)
                        end
                        pos = c:WorldToViewportPoint(cum)
                    else
                        cum = CTarget.Character[CPart].Position
                        pos = c:WorldToViewportPoint(cum)
                    end
                end
                if InRadiuwus(CTarget, uwuCamMain, CamlockFOV.Radius) then
                    local main = nil
                    if uwuCamMain.SmoothLock then
                        main = cnew(c.CFrame.p, cum)
                        c.CFrame = c.CFrame:Lerp(main, uwuCamMain.Smoothness, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                    else
                        c.CFrame = cnew(c.CFrame.p, cum)
                    end
                end
                if uwuMain.FOVMode == "Mouse" then
                    if uwuCamFOV.ShowFOV then
                        CamlockFOV.Position = vect2(m.X, m.Y + 36)
                    end
                    if uwuSilentFOV.ShowFOV then
                        SilentFOV.Position = vect2(m.X, m.Y + 36)
                    end
                elseif uwuMain.FOVMode == "PredictionPoint" then
                    if uwuCamFOV.ShowFOV then
                        CamlockFOV.Position = vect2(pos.X, pos.Y)
                    end
                    if uwuSilentFOV.ShowFOV then
                        SilentFOV.Position = vect2(pos.X, pos.Y)
                    end
                end
                if uwuTrace.Enabled then
                    Line.Visible = true
                    Line.From = vect2(m.X, m.Y + 36)
                    Line.To = vect2(pos.X, pos.Y)
                end
            end
        else
            CamlockFOV.Position = vect2(m.X, m.Y + 36)
            SilentFOV.Position = vect2(m.X, m.Y + 36)
            Line.Visible = false
        end
     end)

     lplr.Character.ChildAdded:Connect(function(tool)
        if tool:IsA("Tool") then
            tool.Activated:connect(function()
                if uwuSilentMain.Mode == "Regular" then
                    if SToggle then
                        STarget = uwuFindTawget()
                        if STarget then
                            SPart = uwuFindSilentPart()
                            if SPart then
                                Silent()
                            end
                        end
                    end
                elseif uwuSilentMain.Mode == "Target" then
                    if CToggle then
                        STarget = CTarget
                        if STarget then
                            SPart = uwuFindSilentPart()
                            if SPart then
                                Silent()
                            end
                        end
                    end
                end
            end)
        end
     end)

     lplr.CharacterAdded:Connect(function(char)
        char.ChildAdded:Connect(function(tool)
            tool.Activated:connect(function()
                if uwuSilentMain.Mode == "Regular" then
                    if SToggle then
                        STarget = uwuFindTawget()
                        if STarget then
                            SPart = uwuFindSilentPart()
                            if SPart then
                                Silent()
                            end
                        end
                    end
                elseif uwuSilentMain.Mode == "Target" then
                    if CToggle then
                        STarget = CTarget
                        if STarget then
                            SPart = uwuFindSilentPart()
                            if SPart then
                                Silent()
                            end
                        end
                    end
                end
            end)
        end)
     end)

     --Auto Prediction
     coroutine.resume(coroutine.create(function()
        while true do
            if uwuAutoPred.Enabled then
                local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
                if ping <= 40 then
                    uwuSilentMain.Prediction = uwuAutoPred.ping30_40
                elseif ping <= 50 then
                    uwuSilentMain.Prediction = uwuAutoPred.ping40_50
                elseif ping <= 60 then
                    uwuSilentMain.Prediction = uwuAutoPred.ping50_60
                elseif ping <= 70 then
                    uwuSilentMain.Prediction = uwuAutoPred.ping60_70
                elseif ping <= 80 then
                    uwuSilentMain.Prediction = uwuAutoPred.ping70_80
                elseif ping <= 90 then
                    uwuSilentMain.Prediction = uwuAutoPred.ping80_90
                elseif ping <= 100 then
                    uwuSilentMain.Prediction = uwuAutoPred.ping90_100
                elseif ping <= 110 then
                    uwuSilentMain.Prediction = uwuAutoPred.ping100_110
                elseif ping <= 120 then
                    uwuSilentMain.Prediction = uwuAutoPred.ping110_120
                elseif ping <= 130 then
                    uwuSilentMain.Prediction = uwuAutoPred.ping120_130
                elseif ping <= 140 then
                    uwuSilentMain.Prediction = uwuAutoPred.ping130_140
                elseif ping <= 150 then
                    uwuSilentMain.Prediction = uwuAutoPred.ping140_150
                elseif ping <= 160 then
                    uwuSilentMain.Prediction = uwuAutoPred.ping150_160
                elseif ping <= 170 then
                    uwuSilentMain.Prediction = uwuAutoPred.ping160_170
                elseif ping <= 180 then
                    uwuSilentMain.Prediction = uwuAutoPred.ping170_180
                elseif ping <= 190 then
                    uwuSilentMain.Prediction = uwuAutoPred.ping180_190
                elseif ping <= 200 then
                    uwuSilentMain.Prediction = uwuAutoPred.ping190_200
                end
                task.wait(0.7)
            end
        end
     end))
end)


Window:AddCommand('Playerlist', {}, 'Gives you a playerlist to quickly set a target', function(Arguments, Speaker)
    local Newlist = ListLibrary:CreateList("Player List")
    
    for i,v in pairs(others:GetChildren()) do
        Newlist:CreateListButton(v.DisplayName, true, function()
            target = v
            Window:CreateNotification('KarpiWare', 'Target: '..target.Name, 5)
            targetesp(v)
        end)
    end
end)


Window:AddCommand('TPlist', {}, 'Gives a Teleport List to quickly teleport to places', function(Arguments, Speaker)

local Teleports = {
	["Bank"] = Vector3.new(-447.26019287109375, 23.003671646118164, -283.8965759277344),
	["Police"] = Vector3.new(-265.4961853027344, 21.797977447509766, -116.37294006347656),
	["Boxing"] = Vector3.new(-235.43539428710938, 22.065319061279297, -1121.0645751953125),
	["Military"] = Vector3.new(38.51276397705078, 25.253023147583008, -875.2348022460938),
	["Phone Store"] = Vector3.new(-235.43539428710938, 22.065319061279297, -1121.0645751953125),
	["Fitness"] = Vector3.new(-76.6124267578125, 22.69831657409668, -632.8761596679688),
	["Hospital"] = Vector3.new(105.38876342773438, 22.798017501831055, -483.2912902832031),
	["Food"] = Vector3.new(-325.65826416015625, 23.680667877197266, -293.7251281738281),
	["Skate Park"] = Vector3.new(-850.03955078125, 21.79800796508789, -531.6365356445312),
	["Casino"] = Vector3.new(-864.4593505859375, 21.597980499267578, -101.7231216430664),
	["Club"] = Vector3.new(-262.5336608886719, 22.628089904785156, -453.33203125),
	["School"] = Vector3.new(-652.6968383789062, 21.982521057128906, 306.2254943847656),
	["Uphill Guns"] = Vector3.new(483.9078369140625, 48.06851577758789, -623.272521972656),
	["Downhill Guns"] = Vector3.new(-582.5549926757812, 8.312807083129883, -737.0886840820312),
	["Max Armor"] = Vector3.new(-510.3179626464844, 20.275625228881836, -285.819885253906259),
	["High Medium Armor"] = Vector3.new(-934.0250244140625, -28.14982795715332, 570.5496826171875),
	["Medium Armor"] = Vector3.new(-607.9784545898438, 7.449648857116699, -788.4942626953125),
	["Fire Armor"] = Vector3.new(-504.22802734375, 20.25925636291504, -286.00994873046875),
	["RPG"] = Vector3.new(114.18929290771484, -26.752010345458984, -276.26934814453125),
	["Revolver"] = Vector3.new(-643.6868286132812, 21.748022079467773, -121.32481384277344),
	["Double-Barrel shotgun"] = Vector3.new(23.364553451538086, 25.628028869628906, -834.4078369140625),
	["Tactical Shotgun"] = Vector3.new(23.364553451538086, 25.628028869628906, -834.4078369140625),
	["Rifle"] = Vector3.new(-167.8747100830078, -18.040834426879883, -311.8492431640625),
	["AUG"] = Vector3.new(-273.3023376464844, 52.261661529541016, -216.994140625),
	["Knife"] = Vector3.new(-278.2847900390625, 21.74802017211914, -239.21456909179688),
	["Sledgehammer"] = Vector3.new(-901.64404296875, 21.74802017211914, -296.5692443847656),
	["Bat"] = Vector3.new(-80.242919921875, 21.748022079467773, -293.10821533203125),
	["Pitchfork"] = Vector3.new(250.8275604248047, 21.747995376586914, -28.456567764282227),
	["Shovel"] = Vector3.new(150.86940002441406, 21.747995376586914, 31.57048988342285),
	["StopSign"] = Vector3.new(-225.90127563476562, 21.74802017211914, -81.81007385253906),
	["Tazer"] = Vector3.new(-270.2383728027344, 21.7979793548584, -98.4942855834961),
	["TearGas"] = Vector3.new(98.40107727050781, 25.637149810791016, -891.5840454101562),
	["Lockpick"] = Vector3.new(-264.5516357421875, 21.748022079467773, -238.6057891845703),
	["Key"] = Vector3.new(-271.192138671875, 21.748022079467773, -239.74179077148438),
	["Grenade"] = Vector3.new(108.70999145507812, -26.75200653076172, -273.833251953125),
	["Weights"] = Vector3.new(-55.78539276123047, 22.948291778564453, -654.3751220703125),
	["Lettuce"] = Vector3.new(-81.97262573242188, 22.698314666748047, -632.7714233398438),
	["Anti-bodies"] = Vector3.new(109.00323486328125, 22.798017501831055, -471.5952453613281),
	["Mask"] = Vector3.new(105.38876342773438, 22.798017501831055, -483.2912902832031),
}

   local tplist =  ListLibrary:CreateList("Teleports List")

    for Name,TP in pairs(Teleports) do
        tplist:CreateListButton(Name, true, function()
            character.HumanoidRootPart.CFrame = CFrame.new(TP)
        end)
    end
end)


Window:AddCommand('Target', {'Player'}, 'Sets the target player (Username only)', function(Arguments, Speaker)
    local str = string.gsub(Arguments[1], " ", "")
    local PartialName = str

    local Players = others:GetPlayers()
    foundtarg = false

    for i = 1, #Players do
        local CurrentPlayer = Players[i]
        if string.lower(CurrentPlayer.Name):sub(1, #PartialName) == string.lower(PartialName) then
            target = CurrentPlayer
            foundtarg = true
            Window:CreateNotification('KarpiWare', 'Target: '..target.Name, 5)
            targetesp(CurrentPlayer)
            break
        end
    end

    if not foundtarg then
        Window:CreateNotification('KarpiWare', 'Unable to find target.', 5)
    end
end)


Window:AddCommand('View', {}, 'Sets camerasubject to your target', function(Arguments, Speaker)
    if target == nil then
        Window:CreateNotification('KarpiWare', 'Set your target using SetTarget command first!', 5)
    else
        if others:FindFirstChild(target.Name) then
            currentcamera.CameraSubject = target.Character
        else
            Window:CreateNotification('KarpiWare', 'Unable to find set target', 5)
        end
    end
end)


Window:AddCommand('Unview', {}, 'Sets camerasubject to your player', function(Arguments, Speaker)
    currentcamera.CameraSubject = character
end)


Window:AddCommand('Goto', {}, 'Teleports to set target', function(Arguments, Speaker)
    if target == nil then
        Window:CreateNotification('KarpiWare', 'Set your target using SetTarget command first!', 5)
    else
        if others:FindFirstChild(target.Name) then
            character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0,2,0)
        else
            Window:CreateNotification('KarpiWare', 'Unable to find set target', 5)
        end
    end
end)


Window:AddCommand('GetCash', {}, 'Tells you the set targets cash amount', function(Arguments, Speaker)
    if target == nil then
        Window:CreateNotification('KarpiWare', 'Set your target using SetTarget command first!', 5)
    else
        if others:FindFirstChild(target.Name) then

            local nmb = (function(currency)
                converted = tostring(currency)
                return converted:reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
            end)
            Window:CreateNotification('KarpiWare', 'Cash: '..nmb(target.DataFolder.Currency.Value), 5)

        else
            Window:CreateNotification('KarpiWare', 'Unable to find set target', 5)
        end
    end
end)


Window:AddCommand('SpawnCash', {}, 'Fake spawns cash using moneygun, get moneygun first.', function(Arguments, Speaker)
    local tool = prl1.Backpack["[Money Gun]"]

    humanoid:EquipTool(tool)
    tool:Activate()
    humanoid:UnequipTools(tool)
end)


Window:AddCommand('MoneyGun', {}, 'Teleports to moneygun for SpawnCash Command', function(Arguments, Speaker)
local originalPosition = character.HumanoidRootPart.CFrame

character.HumanoidRootPart.CFrame = CFrame.new(-883.099976, 18.7245655, -129.749939)
task.wait(5)
character.HumanoidRootPart.CFrame = originalPosition
end)


Window:AddCommand('CombatPhone', {}, 'Need Phone and Bat | Kill people with a phone', function(Arguments, Speaker)
    local backpack = plr1.Backpack
    local characterItems = {
        FakeItem = "[Phone]",
        Hit = "[Bat]",
    }
    
    backpack[characterItems.FakeItem].Parent = character
    backpack[characterItems.Hit].Parent = character
    
    local PPlocation = character:WaitForChild(characterItems.Hit)
    PPlocation.GripPos = Vector3.new(-100, -100, -100)
    wait()
    
    character[characterItems.FakeItem].Parent = backpack
    character[characterItems.Hit].Parent = backpack
    wait()
    
    backpack[characterItems.FakeItem].Parent = character
    backpack[characterItems.Hit].Parent = character
    
    PPlocation = character:WaitForChild(characterItems.Hit)
    PPlocation.GripPos = Vector3.new(-100, -100, 100)
end)


Window:AddCommand('CombatFlowers', {}, 'Need Flowers and Bat | Kill people with flowers', function(Arguments, Speaker)
    local backpack = plr1.Backpack
    local characterItems = {
        FakeItem = "[FlowersTool]",
        Hit = "[Bat]",
    }
    
    backpack[characterItems.FakeItem].Parent = character
    backpack[characterItems.Hit].Parent = character
    
    local PPname = characterItems.Hit
    local PPlocation = character:WaitForChild(PPname)
    PPlocation.GripPos = Vector3.new(-100, -100, -100)
    wait()
    
    character[characterItems.FakeItem].Parent = backpack
    character[characterItems.Hit].Parent = backpack
    wait()
    
    backpack[characterItems.FakeItem].Parent = character
    backpack[characterItems.Hit].Parent = character
    
    PPlocation = character:WaitForChild(PPname)
    PPlocation.GripPos = Vector3.new(-100, -100, 100)
end)


Window:AddCommand('CombatChicken', {}, 'Kill People with chicken', function(Arguments, Speaker)
    local backpack = plr1.Backpack
    local characterItems = {
        FakeItem = "[Chicken]",
        Hit = "[Bat]",
    }
    
    backpack[characterItems.FakeItem].Parent = character
    backpack[characterItems.Hit].Parent = character
    
    local PPname = characterItems.Hit
    local PPlocation = character:WaitForChild(PPname)
    PPlocation.GripPos = Vector3.new(-100, -100, -100)
    wait()
    
    character[characterItems.FakeItem].Parent = backpack
    character[characterItems.Hit].Parent = backpack
    wait()
    
    backpack[characterItems.FakeItem].Parent = character
    backpack[characterItems.Hit].Parent = character
    
    PPlocation = character:WaitForChild(PPname)
    PPlocation.GripPos = Vector3.new(-100, -100, 100)
end)


-- Teleports
Window:AddCommand('Panic', {}, 'Teleports you to a Safe spot', function(Arguments, Speaker)
    character.Character.HumanoidRootPart.CFrame = CFrame.new(196.7130584716797, -7.202033042907715, 204.46034240722656)
end)


Window:AddCommand('Bank', {}, 'Teleports to Bank', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(-447.26019287109375, 23.003671646118164, -283.8965759277344)
end)


Window:AddCommand('Police', {}, 'Teleports to Police station', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(-265.4961853027344, 21.797977447509766, -116.37294006347656)
end)


Window:AddCommand('Boxing', {}, 'Teleports to Boxing', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(-235.43539428710938, 22.065319061279297, -1121.0645751953125)
end)


Window:AddCommand('Military', {}, 'Teleports to Military', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(38.51276397705078, 25.253023147583008, -875.2348022460938)
end)


Window:AddCommand('PhoneStore', {}, 'Teleports to Phone Store', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(-235.43539428710938, 22.065319061279297, -1121.0645751953125)
end)


Window:AddCommand('Fitness', {}, 'Teleports to Fitness', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(-76.6124267578125, 22.69831657409668, -632.8761596679688)
end)


Window:AddCommand('Hospital', {}, 'Teleports to Hospital', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(105.38876342773438, 22.798017501831055, -483.2912902832031)
end)


Window:AddCommand('Joses', {}, 'Teleports to Joses', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(583.9660034179688, 51.05943298339844, -479.64508056640625)
end)


Window:AddCommand('Food', {}, 'Teleports to Food', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(-325.65826416015625, 23.680667877197266, -293.7251281738281)
end)


Window:AddCommand('SkatePark', {}, 'Teleports to Skate Park', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(-850.03955078125, 21.79800796508789, -531.6365356445312)
end)


Window:AddCommand('Casino', {}, 'Teleports to Casino', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(-864.4593505859375, 21.597980499267578, -101.7231216430664)
end)


Window:AddCommand('Club', {}, 'Teleports to Club', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(-262.5336608886719, 22.628089904785156, -453.33203125)
end)


Window:AddCommand('School', {}, 'Teleports to School', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(-652.6968383789062, 21.982521057128906, 306.2254943847656)
end)


Window:AddCommand('UphillGuns', {}, 'Teleports to Uphill Guns', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(483.9078369140625, 48.06851577758789, -623.2725219726562)
end)


Window:AddCommand('DownhillGuns', {}, 'Teleports to Downhill Guns', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(-582.5549926757812, 8.312807083129883, -737.0886840820312)
end)


Window:AddCommand('MaxArmor', {}, 'Teleports to Max Armor', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(-510.3179626464844, 20.275625228881836, -285.819885253906259)
end)


Window:AddCommand('HighMediumArmor', {}, 'Teleports to High Medium Armor', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(-934.0250244140625, -28.14982795715332, 570.5496826171875)
end)


Window:AddCommand('MediumArmor', {}, 'Teleports to Medium Armor', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(-607.9784545898438, 7.449648857116699, -788.4942626953125)
end)


Window:AddCommand('FireArmor', {}, 'Teleports to Fire Armor', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(-504.22802734375, 20.25925636291504, -286.00994873046875)
end)


Window:AddCommand('RPG', {}, 'Teleports to RPG', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(114.18929290771484, -26.752010345458984, -276.26934814453125)
end)


Window:AddCommand('Revolver', {}, 'Teleports to Revolver', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(-643.6868286132812, 21.748022079467773, -121.32481384277344)
end)


Window:AddCommand('DBshotgun', {}, 'Teleports to DBshotgun', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(23.364553451538086, 25.628028869628906, -834.4078369140625)
end)


Window:AddCommand('TacShotgun', {}, 'Teleports to Tactical Shotgun', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(23.364553451538086, 25.628028869628906, -834.4078369140625)
end)


Window:AddCommand('Rifle', {}, 'Teleports to Rifle', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(-167.8747100830078, -18.040834426879883, -311.8492431640625)
end)


Window:AddCommand('AUG', {}, 'Teleports to AUG', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(-273.3023376464844, 52.261661529541016, -216.994140625)
end)


Window:AddCommand('Knife', {}, 'Teleports to Knife', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(-278.2847900390625, 21.74802017211914, -239.21456909179688)
end)


Window:AddCommand('Sledgehammer', {}, 'Teleports to Sledgehammer', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(-901.64404296875, 21.74802017211914, -296.5692443847656)
end)


Window:AddCommand('Bat', {}, 'Teleports to Bat', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(-80.242919921875, 21.748022079467773, -293.10821533203125)
end)


Window:AddCommand('Pitchfork', {}, 'Teleports to Pitchfork', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(250.8275604248047, 21.747995376586914, -28.456567764282227)
end)


Window:AddCommand('Shovel', {}, 'Teleports to Shovel', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(150.86940002441406, 21.747995376586914, 31.57048988342285)
end)


Window:AddCommand('StopSign', {}, 'Teleports to StopSign', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(-225.90127563476562, 21.74802017211914, -81.81007385253906)
end)


Window:AddCommand('Tazer', {}, 'Teleports to Tazer', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(-270.2383728027344, 21.7979793548584, -98.4942855834961)
end)


Window:AddCommand('TearGas', {}, 'Teleports to TearGas', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(98.40107727050781, 25.637149810791016, -891.5840454101562)
end)


Window:AddCommand('Lockpick', {}, 'Teleports to Lockpick', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(-264.5516357421875, 21.748022079467773, -238.6057891845703)
end)


Window:AddCommand('Key', {}, 'Teleports to Key', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(-271.192138671875, 21.748022079467773, -239.74179077148438)
end)


Window:AddCommand('Grenade', {}, 'Teleports to Grenade', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(108.70999145507812, -26.75200653076172, -273.833251953125)
end)


Window:AddCommand('Weights', {}, 'Teleports to Weights', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(-55.78539276123047, 22.948291778564453, -654.3751220703125)
end)


Window:AddCommand('Lettuce', {}, 'Teleports to Lettuce', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(-81.97262573242188, 22.698314666748047, -632.7714233398438)
end)


Window:AddCommand('Antibodies', {}, 'Teleports to Antibodies', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(109.00323486328125, 22.798017501831055, -471.5952453613281)
end)


Window:AddCommand('Mask', {}, 'Teleports to Mask', function(Arguments, Speaker)
    character.HumanoidRootPart.CFrame = CFrame.new(107.610595703125, 22.798015594482422, -486.6477966308594)
end)
