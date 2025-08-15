local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RNG = Random.new()
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Animator = Humanoid:WaitForChild("Animator")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Do1x1PopupsLoop = false
local AntiSlow = false
local hubLoaded = false
local timeforonegen = 2.5
local loopgen = false
local autofixgenerator = false
local infinitestamina
local ChargeSpeedLoop = false
local GuestChargeSpeed = 2.833
local nameprotect = false
-- Throttled task runner
local function runEvery(interval, fn)
    task.spawn(function()
        while true do
            local ok, err = pcall(fn)
            if not ok then warn("[runEvery]", err) end
            task.wait(interval)
        end
    end)
end

-- Simple connection bucket so we can clean up safely if needed
local Connections = {}
local function track(conn) table.insert(Connections, conn); return conn end
local function disconnectAll()
    for i, c in ipairs(Connections) do
        if c and c.Disconnect then pcall(function() c:Disconnect() end) end
        Connections[i] = nil
    end
end


local executor = getgenv().identifyexecutor and getgenv().identifyexecutor() or "RobloxClientApp"

local function checkRequireSupport()
    local dummyModule = Instance.new("ModuleScript")
    dummyModule.Source = "return true"
	dummyModule.Parent = game:GetService("ReplicatedStorage")
    
    local success, result = pcall(function()
        return require(dummyModule)
    end)

    requireSupported = success and result == true
    dummyModule:Destroy()
end

local function fireproximityprompt(Obj, Amount, Skip)
    if Obj.ClassName == "ProximityPrompt" then 
        Amount = Amount or 1
        local PromptTime = Obj.HoldDuration
        if Skip then 
            Obj.HoldDuration = 0
        end
        for i = 1, Amount do 
            Obj:InputHoldBegin()
            if not Skip then 
                wait(Obj.HoldDuration)
            end
            Obj:InputHoldEnd()
        end
        Obj.HoldDuration = PromptTime
    else 
        error("userdata<ProximityPrompt> expected")
    end
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function NameProtect()
	if nameprotect == false then
		return
	end
	local gui = LocalPlayer.PlayerGui
	if not gui then return end

	-- 1️⃣ TemporaryUI.PlayerInfo.CurrentSurvivors -> Username
	local currentSurvivors = gui:FindFirstChild("TemporaryUI") 
		and gui.TemporaryUI:FindFirstChild("PlayerInfo") 
		and gui.TemporaryUI.PlayerInfo:FindFirstChild("CurrentSurvivors")
	if currentSurvivors then
		for _, v in pairs(currentSurvivors:GetDescendants()) do
			if v:IsA("TextLabel") and v.Name == "Username" then
				v.Text = "Protected"
			end
		end
	end

	-- 2️⃣ TemporaryUI -> any TextLabel named "Title 3"
	local tempUI = gui:FindFirstChild("TemporaryUI")
	if tempUI then
		for _, v in pairs(tempUI:GetDescendants()) do
			if v:IsA("TextLabel") and v.Name == "Title3" then
				v.Text = "Protected"
			end
		end
	end

	-- 3️⃣ MainUI.PlayerListHolder.Contents.Players -> Username
	local mainPlayers = gui:FindFirstChild("MainUI") 
		and gui.MainUI:FindFirstChild("PlayerListHolder") 
		and gui.MainUI.PlayerListHolder:FindFirstChild("Contents") 
		and gui.MainUI.PlayerListHolder.Contents:FindFirstChild("Players")
	if mainPlayers then
		for _, v in pairs(mainPlayers:GetDescendants()) do
			if v:IsA("TextLabel") and v.Name == "Username" then
				v.Text = "Protected"
			end
		end
	end

	-- 4️⃣ TemporaryUI -> PlayerName / PlayerUsername text labels matching LocalPlayer usernames
	if tempUI then
		for _, v in pairs(tempUI:GetDescendants()) do
			if v:IsA("TextLabel") and (v.Name == "PlayerName" or v.Name == "PlayerUsername") then
				for _, plr in pairs(Players:GetPlayers()) do
					if v.Text == plr.Name then
						v.Text = "Protected"
						v.Text = "@Protected" -- optional
					end
				end
			end
		end
	end

	-- 5️⃣ Workspace.Players.Spectating -> humanoids, set DisplayDistanceType to None
	local spectatingFolder = workspace:FindFirstChild("Players") 
		and workspace.Players:FindFirstChild("Spectating")
	if spectatingFolder then
		for _, char in pairs(spectatingFolder:GetChildren()) do
			local humanoid = char:FindFirstChildWhichIsA("Humanoid")
			if humanoid then
				humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
			end
		end
	end

	-- 6️⃣ ImageLabels named after LocalPlayers
	for _, plr in pairs(Players:GetPlayers()) do
		local imgLabel = gui:FindFirstChild(plr.Name, true) -- recursive
		if imgLabel and imgLabel:IsA("ImageLabel") then
			local basicInfo = imgLabel:FindFirstChild("BasicInfo")
			if basicInfo then
				local nameLabel = basicInfo:FindFirstChild("PlayerName")
				if nameLabel and nameLabel:IsA("TextLabel") then
					nameLabel.Text = "Protected"
				end
				local usernameLabel = basicInfo:FindFirstChild("PlayerUsername")
				if usernameLabel and usernameLabel:IsA("TextLabel") then
					usernameLabel.Text = "Protected"
				end
			end
		end
	end

	-- 7️⃣ MainUI.Spectate -> Username
	local spectateUI = gui:FindFirstChild("MainUI") 
		and gui.MainUI:FindFirstChild("Spectate")
	if spectateUI then
		for _, v in pairs(spectateUI:GetDescendants()) do
			if v:IsA("TextLabel") and v.Name == "Username" then
				v.Text = "Protected"
			end
		end
	end

	-- 8️⃣ EndScreen -> ChosenValue.Title
	local chosenTitle = gui:FindFirstChild("EndScreen")
		and gui.EndScreen:FindFirstChild("Main")
		and gui.EndScreen.Main:FindFirstChild("PlayerStats")
		and gui.EndScreen.Main.PlayerStats:FindFirstChild("Header")
		and gui.EndScreen.Main.PlayerStats.Header:FindFirstChild("PlayerDropdown")
		and gui.EndScreen.Main.PlayerStats.Header.PlayerDropdown:FindFirstChild("DropdownFrame")
		and gui.EndScreen.Main.PlayerStats.Header.PlayerDropdown.DropdownFrame:FindFirstChild("ChosenValue")
		and gui.EndScreen.Main.PlayerStats.Header.PlayerDropdown.DropdownFrame.ChosenValue:FindFirstChild("Title")

	if chosenTitle and chosenTitle:IsA("TextLabel") then
		chosenTitle.Text = "Protected"
	end

	-- 9️⃣ EndScreen.WinnerTitle.Usernames
	local winnerUsernames = gui:FindFirstChild("EndScreen")
		and gui.EndScreen:FindFirstChild("WinnerTitle")
		and gui.EndScreen.WinnerTitle:FindFirstChild("Usernames")
	if winnerUsernames and winnerUsernames:IsA("TextLabel") then
		winnerUsernames.Text = "Protected"
	end
end

local multiplierNames = {
    "FallSlowness",
    "Medkit",
    "BloxyColaItem",
	"GuestBlocking",
	"BeheadAbility",
	"GuestChargeEnded"
}

-- Function to check and force multipliers
local function enforceMultipliers()
    local character = LocalPlayer.Character
    if not character then return end

    local speedMultipliers = character:FindFirstChild("SpeedMultipliers")
    if not speedMultipliers then return end

    for _, name in ipairs(multiplierNames) do
        local mult = speedMultipliers:FindFirstChild(name)
        if mult then
            mult.Value = 1
        end
    end
end

local function GuestChargeCustomSpeed()
    local character = LocalPlayer.Character
    if not character then return end

    local speedMultipliers = character:FindFirstChild("SpeedMultipliers")
    if not speedMultipliers then return end

    local mult = speedMultipliers:FindFirstChild("Guest1337Charge")
    if mult then
         mult.Value = GuestChargeSpeed
    end
end

local function firetouchinterest(totouch, whattotouchwith,nilvalue)
    pcall(function()
        local clone = totouch:Clone()
        local orgpos = totouch.CFrame
        totouch.CFrame = whattotouchwith.CFrame
        wait(0.5)
        totouch.CFrame = orgpos
        clone:Destroy()
    end)
end

LocalPlayer.CharacterAdded:Connect(function(char)
	Character = char
	Humanoid = char:WaitForChild("Humanoid")
	Animator = Humanoid:WaitForChild("Animator")
	HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
end)

local function checkAndSetSlowStatus()
    if AntiSlow == false then
        return
    end

	local Character = LocalPlayer.Character
	local Humanoid = Character:WaitForChild("Humanoid")
    if not Character then return end

    local speedMultipliers = Character:FindFirstChild("SpeedMultipliers")
    if not speedMultipliers then return end

    local slowedStatus = speedMultipliers:FindFirstChild("SlowedStatus")
    if not slowedStatus or not slowedStatus:IsA("NumberValue") then return end

    slowedStatus.Value = 1

    local fovMultipliers = character:FindFirstChild("FOVMultipliers")
    if not fovMultipliers then return end

    local fovSlowedStatus = fovMultipliers:FindFirstChild("SlowedStatus")
    if not fovSlowedStatus or not fovSlowedStatus:IsA("NumberValue") then return end

    fovSlowedStatus.Value = 1

    -- Remove Slowness UI if it exists
    local LocalPlayerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
    if LocalPlayerGui then
        local mainUI = LocalPlayerGui:FindFirstChild("MainUI")
        if mainUI then
            local statusContainer = mainUI:FindFirstChild("StatusContainer")
            if statusContainer then
                local slownessUI = statusContainer:FindFirstChild("Slowness")
                if slownessUI then
                    slownessUI.Visible = false
                end
            end
        end
    end
end

-- VirtualInputManager once (it was used but never defined)
local VIM = game:GetService("VirtualInputManager")

local function Do1x1x1x1Popups()
    runEvery(0.5, function()
        if not Do1x1PopupsLoop then return end
        local LocalPlayer = Players.LocalPlayer
        local tempUI = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("TemporaryUI")
        if not tempUI then return end

        for _, gui in ipairs(tempUI:GetChildren()) do
            if gui.Name == "1x1x1x1Popup" and gui:IsA("GuiObject") then
                local cx = gui.AbsolutePosition.X + (gui.AbsoluteSize.X / 2)
                local cy = gui.AbsolutePosition.Y + (gui.AbsoluteSize.Y / 2) + 50
                VIM:SendMouseButtonEvent(cx, cy, Enum.UserInputType.MouseButton1.Value, true, LocalPlayer.PlayerGui, 1)
                VIM:SendMouseButtonEvent(cx, cy, Enum.UserInputType.MouseButton1.Value, false, LocalPlayer.PlayerGui, 1)
            end
        end
    end)
end

local existence
local animTrack
local running = false
local timebetweenpuzzles = 3

local MaxRange = 120
local hitboxmodificationEnabled = false

local function ToggleInvis(enabled)
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = humanoid
    end

    if enabled then
        running = true
        spawn(function()
            while running do
                local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if not humanoid then return end
                print("got humanoid")

                local animator = humanoid:FindFirstChildOfClass("Animator")
                if not animator then
                    animator = Instance.new("Animator")
                    animator.Parent = humanoid
                end

                if true then
                    if not animTrack or not animTrack.IsPlaying then
                        local animation = Instance.new("Animation")
                        animation.AnimationId = "rbxassetid://75804462760596"
                        animTrack = animator:LoadAnimation(animation)
                        animTrack.Looped = true
                        animTrack:Play()
                        animTrack:AdjustSpeed(0)
                        humanoid.Parent.HumanoidRootPart.Transparency = 0.4
                    end
                else
                    if animTrack and animTrack.IsPlaying then
                        animTrack:Stop()
                        animTrack = nil
                        humanoid.Parent.HumanoidRootPart.Transparency = 1
                    end
                end
                wait(0.5)
            end
        end)
    else
        running = false
        if animTrack and animTrack.IsPlaying then
            animTrack:Stop()
            animTrack = nil
            humanoid.Parent.HumanoidRootPart.Transparency = 1
        end
    end
end

local function handleToggle(enabled)
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = humanoid
    end

    if enabled then
        running = true
        spawn(function()
            while running do
                local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if not humanoid then return end

                local animator = humanoid:FindFirstChildOfClass("Animator")
                if not animator then
                    animator = Instance.new("Animator")
                    animator.Parent = humanoid
                end
                
                local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
                if torso and torso.Transparency ~= 0 then
                    if not animTrack or not animTrack.IsPlaying then
                        local animation = Instance.new("Animation")
                        animation.AnimationId = "rbxassetid://75804462760596"
                        animTrack = animator:LoadAnimation(animation)
                        animTrack.Looped = true
                        animTrack:Play()
                        animTrack:AdjustSpeed(0)
						humanoid.Parent.HumanoidRootPart.Transparency = 0.4
                    end
                else
                    if animTrack and animTrack.IsPlaying then
                        animTrack:Stop()
                        animTrack = nil
						humanoid.Parent.HumanoidRootPart.Transparency = 1
                    end
                end
                wait(0.5)
            end
        end)
    else
        running = false
        if animTrack and animTrack.IsPlaying then
            animTrack:Stop()
            animTrack = nil
			humanoid.Parent.HumanoidRootPart.Transparency = 1
        end
    end
end

local LMSSongs = {
    ["Burnout"] = "rbxassetid://130101085745481",
    ["Compass"] = "rbxassetid://127298326178102",
    ["Vanity"] = "rbxassetid://137266220091579",
    ["Close To Me"] = "rbxassetid://90022574613230",
    ["Plead"] = "rbxassetid://80564889711353",
    ["Creation Of Hatred"] = "rbxassetid://115884097233860",
}

local GuestSettingsTriggerAnims = {
    "126830014841198", "126355327951215", "121086746534252", "18885909645",
    "98456918873918", "105458270463374", "83829782357897", "125403313786645",
    "118298475669935", "82113744478546", "70371667919898", "99135633258223",
    "97167027849946", "109230267448394", "139835501033932", "126896426760253",
    "109667959938617", "126681776859538", "129976080405072", "121293883585738",
    "81639435858902", "137314737492715", "92173139187970", "106847695270773"
}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = Players.LocalPlayer

local blockingKillers = {}
local GuestSettingsLoop -- will hold the connection

local function getKillerActiveTriggerAnim(killer)
    local hum = killer:FindFirstChildWhichIsA("Humanoid")
    if hum and hum:FindFirstChild("Animator") then
        for _, track in ipairs(hum.Animator:GetPlayingAnimationTracks()) do
            local animId = track.Animation.AnimationId
            for _, id in ipairs(GuestSettingsTriggerAnims) do
                if string.find(animId, id) then
                    return animId
                end
            end
        end
    end
    return nil
end

local function getPunchCharges()
    local guiObj = localPlayer.PlayerGui:FindFirstChild("MainUI")
    if guiObj then
        local abilityContainer = guiObj:FindFirstChild("AbilityContainer", true)
        if abilityContainer and abilityContainer:FindFirstChild("Punch") then
            local punchObj = abilityContainer.Punch:FindFirstChild("Charges")
            if punchObj then
                return tostring(punchObj.Text)
            end
        end
    end
    return nil
end

local function startBlockTp(state)
    if state then return end -- Already running

    GuestSettingsLoop = RunService.RenderStepped:Connect(function()
        local char = localPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end

        for _, killer in ipairs(workspace.Players.Killers:GetChildren()) do
            if not (killer:IsA("Model") and killer:FindFirstChild("HumanoidRootPart")) then
                blockingKillers[killer] = nil
                continue
            end

            local activeAnim = getKillerActiveTriggerAnim(killer)
            if not activeAnim then
                blockingKillers[killer] = nil
                continue
            end

            if blockingKillers[killer] == activeAnim or getPunchCharges() ~= "0" then
                continue
            end

            -- Mark killer as blocking
            blockingKillers[killer] = activeAnim
            local originalCF = char.HumanoidRootPart.CFrame

            -- Fire block
            ReplicatedStorage.Modules.Network.RemoteEvent:FireServer("UseActorAbility", "Block")

            -- Teleport in front of killer
            local killerHRP = killer.HumanoidRootPart
            local function teleportInFront()
                char.HumanoidRootPart.CFrame = CFrame.new(killerHRP.Position + killerHRP.CFrame.LookVector * 2)
            end
            teleportInFront()

            -- Keep teleporting until animation ends or punch charge = "1"
            task.spawn(function()
                while true do
                    task.wait(0.05)
                    if not (localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")) then break end

                    teleportInFront()

                    local charges = getPunchCharges()
                    local currentAnim = getKillerActiveTriggerAnim(killer)
                    if charges == "1" or currentAnim ~= activeAnim then
                        -- Restore original position
                        if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            localPlayer.Character.HumanoidRootPart.CFrame = originalCF
                        end
                        blockingKillers[killer] = nil
                        break
                    end
                end
            end)
        end
    end)
end

local selectedSong = "Burnout" -- default

local soundPlayer = Instance.new("Sound")
soundPlayer.Name = "GoonsakenHub_Sound"
soundPlayer.Parent = Workspace
soundPlayer.Looped = false
soundPlayer.Volume = 5

if true == true then
	function KillerEmoteGUI()
		local KillerEmoteGUI = Instance.new("ScreenGui", PlayerGui)
		local Holder = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local LogoUIC = Instance.new("UICorner")
		local Bwah = Instance.new("UIAspectRatioConstraint")
		local WhereTheButtons = Instance.new("Frame")
		local _1 = Instance.new("Frame")
		local TextButton1 = Instance.new("TextButton")
		local Front1 = Instance.new("ImageLabel")
		local UIC111 = Instance.new("UICorner")
		local Background1 = Instance.new("ImageLabel")
		local UIC11 = Instance.new("UICorner")
		local UIC1 = Instance.new("UICorner")
		local _2 = Instance.new("Frame")
		local TextButton2 = Instance.new("TextButton")
		local Front2 = Instance.new("ImageLabel")
		local UIC222 = Instance.new("UICorner")
		local Background2 = Instance.new("ImageLabel")
		local UIC22 = Instance.new("UICorner")
		local UIC2 = Instance.new("UICorner")
		local _3 = Instance.new("Frame")
		local TextButton3 = Instance.new("TextButton")
		local Front3 = Instance.new("ImageLabel")
		local UIC333 = Instance.new("UICorner")
		local Background3 = Instance.new("ImageLabel")
		local UIC33 = Instance.new("UICorner")
		local UIC3 = Instance.new("UICorner")
		local _4 = Instance.new("Frame")
		local TextButton4 = Instance.new("TextButton")
		local Front4 = Instance.new("ImageLabel")
		local UIC444 = Instance.new("UICorner")
		local Background4 = Instance.new("ImageLabel")
		local UIC44 = Instance.new("UICorner")
		local UIC4 = Instance.new("UICorner")
		local _5 = Instance.new("Frame")
		local TextButton5 = Instance.new("TextButton")
		local Front5 = Instance.new("ImageLabel")
		local UIC555 = Instance.new("UICorner")
		local Background5 = Instance.new("ImageLabel")
		local UIC55 = Instance.new("UICorner")
		local UIC5 = Instance.new("UICorner")
		local _6 = Instance.new("Frame")
		local TextButton6 = Instance.new("TextButton")
		local Front6 = Instance.new("ImageLabel")
		local UIC666 = Instance.new("UICorner")
		local Background6 = Instance.new("ImageLabel")
		local UIC66 = Instance.new("UICorner")
		local UIC6 = Instance.new("UICorner")
		local _7 = Instance.new("Frame")
		local TextButton7 = Instance.new("TextButton")
		local Front7 = Instance.new("ImageLabel")
		local UIC777 = Instance.new("UICorner")
		local Background7 = Instance.new("ImageLabel")
		local UIC77 = Instance.new("UICorner")
		local UIC7 = Instance.new("UICorner")
		local _8 = Instance.new("Frame")
		local TextButton8 = Instance.new("TextButton")
		local Front8 = Instance.new("ImageLabel")
		local UIC888 = Instance.new("UICorner")
		local Background8 = Instance.new("ImageLabel")
		local UIC88 = Instance.new("UICorner")
		local UIC8 = Instance.new("UICorner")
		local ListingLayouts = Instance.new("UIListLayout")
		local WhereButtonPadding = Instance.new("UIPadding")
		local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
		local Name = Instance.new("Frame")
		local NameTextbox = Instance.new("TextLabel")
		local NameUIT = Instance.new("UITextSizeConstraint")
		local NameUIC = Instance.new("UICorner")

		--Properties:

		KillerEmoteGUI.Name = "KillerEmoteGUI"
		KillerEmoteGUI.Parent = PlayerGui
		KillerEmoteGUI.ResetOnSpawn = false

		Holder.Name = "Holder"
		Holder.Parent = KillerEmoteGUI
		Holder.AnchorPoint = Vector2.new(0.5, 0.5)
		Holder.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		Holder.BackgroundTransparency = 0.250
		Holder.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Holder.BorderSizePixel = 0
		Holder.LayoutOrder = 1
		Holder.Position = UDim2.new(0.5, 0, 0.6, 0)
		Holder.Size = UDim2.new(0, 0, 0, 0)
		Holder.SizeConstraint = Enum.SizeConstraint.RelativeXY
		UICorner.Parent = Holder

		WhereTheButtons.Name = "WhereTheButtons"
		WhereTheButtons.Parent = Holder
		WhereTheButtons.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		WhereTheButtons.BackgroundTransparency = 1.000
		WhereTheButtons.BorderColor3 = Color3.fromRGB(0, 0, 0)
		WhereTheButtons.BorderSizePixel = 0
		WhereTheButtons.Size = UDim2.new(1, -40, 1, 0)

		_1.Name = "1"
		_1.Parent = WhereTheButtons
		_1.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		_1.BackgroundTransparency = 0.700
		_1.BorderColor3 = Color3.fromRGB(0, 0, 0)
		_1.BorderSizePixel = 0
		_1.LayoutOrder = 1
		_1.Size = UDim2.new(0.125, 0, 1, 0)
		_1.ZIndex = 2

		TextButton1.Name = "TextButton1"
		TextButton1.Parent = _1
		TextButton1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextButton1.BackgroundTransparency = 1.000
		TextButton1.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextButton1.BorderSizePixel = 0
		TextButton1.Size = UDim2.new(1, 0, 1, 0)
		TextButton1.ZIndex = 3
		TextButton1.Font = Enum.Font.FredokaOne
		TextButton1.Text = ""
		TextButton1.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextButton1.TextScaled = true
		TextButton1.TextSize = 10.000
		TextButton1.TextWrapped = true

		Front1.Name = "Front1"
		Front1.Parent = TextButton1
		Front1.AnchorPoint = Vector2.new(0.5, 0.5)
		Front1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Front1.BackgroundTransparency = 1.000
		Front1.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Front1.BorderSizePixel = 0
		Front1.Position = UDim2.new(0.5, 0, 0.5, 0)
		Front1.Size = UDim2.new(0.899999976, 0, 0.899999976, 0)
		Front1.SizeConstraint = Enum.SizeConstraint.RelativeXX
		Front1.ZIndex = 4
		Front1.Image = "rbxassetid://112068843495830"

		UIC111.Name = "UIC111"
		UIC111.Parent = Front1

		Background1.Name = "Background1"
		Background1.Parent = TextButton1
		Background1.AnchorPoint = Vector2.new(0.5, 0.5)
		Background1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Background1.BackgroundTransparency = 1.000
		Background1.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Background1.BorderSizePixel = 0
		Background1.Position = UDim2.new(0.5, 0, 0.5, 0)
		Background1.Size = UDim2.new(0.800000012, 0, 0.800000012, 0)
		Background1.SizeConstraint = Enum.SizeConstraint.RelativeXX
		Background1.ZIndex = 3
		Background1.Image = "rbxassetid://138110752460865"

		UIC11.Name = "UIC11"
		UIC11.Parent = Background1

		UIC1.Name = "UIC1"
		UIC1.Parent = _1

		_2.Name = "2"
		_2.Parent = WhereTheButtons
		_2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		_2.BackgroundTransparency = 0.700
		_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
		_2.BorderSizePixel = 0
		_2.LayoutOrder = 2
		_2.Size = UDim2.new(0.125, 0, 1, 0)
		_2.ZIndex = 2

		TextButton2.Name = "TextButton2"
		TextButton2.Parent = _2
		TextButton2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextButton2.BackgroundTransparency = 1.000
		TextButton2.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextButton2.BorderSizePixel = 0
		TextButton2.Size = UDim2.new(1, 0, 1, 0)
		TextButton2.ZIndex = 3
		TextButton2.Font = Enum.Font.FredokaOne
		TextButton2.Text = ""
		TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextButton2.TextScaled = true
		TextButton2.TextSize = 10.000
		TextButton2.TextWrapped = true

		Front2.Name = "Front2"
		Front2.Parent = TextButton2
		Front2.AnchorPoint = Vector2.new(0.5, 0.5)
		Front2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Front2.BackgroundTransparency = 1.000
		Front2.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Front2.BorderSizePixel = 0
		Front2.Position = UDim2.new(0.5, 0, 0.5, 0)
		Front2.Size = UDim2.new(0.899999976, 0, 0.899999976, 0)
		Front2.SizeConstraint = Enum.SizeConstraint.RelativeXX
		Front2.ZIndex = 4
		Front2.Image = "rbxassetid://112068843495830"

		UIC222.Name = "UIC222"
		UIC222.Parent = Front2

		Background2.Name = "Background2"
		Background2.Parent = TextButton2
		Background2.AnchorPoint = Vector2.new(0.5, 0.5)
		Background2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Background2.BackgroundTransparency = 1.000
		Background2.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Background2.BorderSizePixel = 0
		Background2.Position = UDim2.new(0.5, 0, 0.5, 0)
		Background2.Size = UDim2.new(0.800000012, 0, 0.800000012, 0)
		Background2.SizeConstraint = Enum.SizeConstraint.RelativeXX
		Background2.ZIndex = 3
		Background2.Image = "rbxassetid://138110752460865"

		UIC22.Name = "UIC22"
		UIC22.Parent = Background2

		UIC2.Name = "UIC2"
		UIC2.Parent = _2

		_3.Name = "3"
		_3.Parent = WhereTheButtons
		_3.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		_3.BackgroundTransparency = 0.700
		_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
		_3.BorderSizePixel = 0
		_3.LayoutOrder = 3
		_3.Size = UDim2.new(0.125, 0, 1, 0)
		_3.ZIndex = 2

		TextButton3.Name = "TextButton3"
		TextButton3.Parent = _3
		TextButton3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextButton3.BackgroundTransparency = 1.000
		TextButton3.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextButton3.BorderSizePixel = 0
		TextButton3.Size = UDim2.new(1, 0, 1, 0)
		TextButton3.ZIndex = 3
		TextButton3.Font = Enum.Font.FredokaOne
		TextButton3.Text = ""
		TextButton3.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextButton3.TextScaled = true
		TextButton3.TextSize = 10.000
		TextButton3.TextWrapped = true

		Front3.Name = "Front3"
		Front3.Parent = TextButton3
		Front3.AnchorPoint = Vector2.new(0.5, 0.5)
		Front3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Front3.BackgroundTransparency = 1.000
		Front3.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Front3.BorderSizePixel = 0
		Front3.Position = UDim2.new(0.5, 0, 0.5, 0)
		Front3.Size = UDim2.new(0.899999976, 0, 0.899999976, 0)
		Front3.SizeConstraint = Enum.SizeConstraint.RelativeXX
		Front3.ZIndex = 4
		Front3.Image = "rbxassetid://112068843495830"

		UIC333.Name = "UIC333"
		UIC333.Parent = Front3

		Background3.Name = "Background3"
		Background3.Parent = TextButton3
		Background3.AnchorPoint = Vector2.new(0.5, 0.5)
		Background3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Background3.BackgroundTransparency = 1.000
		Background3.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Background3.BorderSizePixel = 0
		Background3.Position = UDim2.new(0.5, 0, 0.5, 0)
		Background3.Size = UDim2.new(0.800000012, 0, 0.800000012, 0)
		Background3.SizeConstraint = Enum.SizeConstraint.RelativeXX
		Background3.ZIndex = 3
		Background3.Image = "rbxassetid://138110752460865"

		UIC33.Name = "UIC33"
		UIC33.Parent = Background3

		UIC3.Name = "UIC3"
		UIC3.Parent = _3

		_4.Name = "4"
		_4.Parent = WhereTheButtons
		_4.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		_4.BackgroundTransparency = 0.700
		_4.BorderColor3 = Color3.fromRGB(0, 0, 0)
		_4.BorderSizePixel = 0
		_4.LayoutOrder = 4
		_4.Size = UDim2.new(0.125, 0, 1, 0)
		_4.ZIndex = 2

		TextButton4.Name = "TextButton4"
		TextButton4.Parent = _4
		TextButton4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextButton4.BackgroundTransparency = 1.000
		TextButton4.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextButton4.BorderSizePixel = 0
		TextButton4.Size = UDim2.new(1, 0, 1, 0)
		TextButton4.ZIndex = 3
		TextButton4.Font = Enum.Font.FredokaOne
		TextButton4.Text = ""
		TextButton4.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextButton4.TextScaled = true
		TextButton4.TextSize = 10.000
		TextButton4.TextWrapped = true

		Front4.Name = "Front4"
		Front4.Parent = TextButton4
		Front4.AnchorPoint = Vector2.new(0.5, 0.5)
		Front4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Front4.BackgroundTransparency = 1.000
		Front4.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Front4.BorderSizePixel = 0
		Front4.Position = UDim2.new(0.5, 0, 0.5, 0)
		Front4.Size = UDim2.new(0.899999976, 0, 0.899999976, 0)
		Front4.SizeConstraint = Enum.SizeConstraint.RelativeXX
		Front4.ZIndex = 4
		Front4.Image = "rbxassetid://112068843495830"

		UIC444.Name = "UIC444"
		UIC444.Parent = Front4

		Background4.Name = "Background4"
		Background4.Parent = TextButton4
		Background4.AnchorPoint = Vector2.new(0.5, 0.5)
		Background4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Background4.BackgroundTransparency = 1.000
		Background4.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Background4.BorderSizePixel = 0
		Background4.Position = UDim2.new(0.5, 0, 0.5, 0)
		Background4.Size = UDim2.new(0.800000012, 0, 0.800000012, 0)
		Background4.SizeConstraint = Enum.SizeConstraint.RelativeXX
		Background4.ZIndex = 3
		Background4.Image = "rbxassetid://138110752460865"

		UIC44.Name = "UIC44"
		UIC44.Parent = Background4

		UIC4.Name = "UIC4"
		UIC4.Parent = _4

		_5.Name = "5"
		_5.Parent = WhereTheButtons
		_5.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		_5.BackgroundTransparency = 0.700
		_5.BorderColor3 = Color3.fromRGB(0, 0, 0)
		_5.BorderSizePixel = 0
		_5.LayoutOrder = 5
		_5.Size = UDim2.new(0.125, 0, 1, 0)
		_5.ZIndex = 2

		TextButton5.Name = "TextButton5"
		TextButton5.Parent = _5
		TextButton5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextButton5.BackgroundTransparency = 1.000
		TextButton5.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextButton5.BorderSizePixel = 0
		TextButton5.Size = UDim2.new(1, 0, 1, 0)
		TextButton5.ZIndex = 3
		TextButton5.Font = Enum.Font.FredokaOne
		TextButton5.Text = ""
		TextButton5.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextButton5.TextScaled = true
		TextButton5.TextSize = 10.000
		TextButton5.TextWrapped = true

		Front5.Name = "Front5"
		Front5.Parent = TextButton5
		Front5.AnchorPoint = Vector2.new(0.5, 0.5)
		Front5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Front5.BackgroundTransparency = 1.000
		Front5.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Front5.BorderSizePixel = 0
		Front5.Position = UDim2.new(0.5, 0, 0.5, 0)
		Front5.Size = UDim2.new(0.899999976, 0, 0.899999976, 0)
		Front5.SizeConstraint = Enum.SizeConstraint.RelativeXX
		Front5.ZIndex = 4
		Front5.Image = "rbxassetid://112068843495830"

		UIC555.Name = "UIC555"
		UIC555.Parent = Front5

		Background5.Name = "Background5"
		Background5.Parent = TextButton5
		Background5.AnchorPoint = Vector2.new(0.5, 0.5)
		Background5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Background5.BackgroundTransparency = 1.000
		Background5.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Background5.BorderSizePixel = 0
		Background5.Position = UDim2.new(0.5, 0, 0.5, 0)
		Background5.Size = UDim2.new(0.800000012, 0, 0.800000012, 0)
		Background5.SizeConstraint = Enum.SizeConstraint.RelativeXX
		Background5.ZIndex = 3
		Background5.Image = "rbxassetid://138110752460865"

		UIC55.Name = "UIC55"
		UIC55.Parent = Background5

		UIC5.Name = "UIC5"
		UIC5.Parent = _5

		_6.Name = "6"
		_6.Parent = WhereTheButtons
		_6.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		_6.BackgroundTransparency = 0.700
		_6.BorderColor3 = Color3.fromRGB(0, 0, 0)
		_6.BorderSizePixel = 0
		_6.LayoutOrder = 6
		_6.Size = UDim2.new(0.125, 0, 1, 0)
		_6.ZIndex = 2

		TextButton6.Name = "TextButton6"
		TextButton6.Parent = _6
		TextButton6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextButton6.BackgroundTransparency = 1.000
		TextButton6.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextButton6.BorderSizePixel = 0
		TextButton6.Size = UDim2.new(1, 0, 1, 0)
		TextButton6.ZIndex = 3
		TextButton6.Font = Enum.Font.FredokaOne
		TextButton6.Text = ""
		TextButton6.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextButton6.TextScaled = true
		TextButton6.TextSize = 10.000
		TextButton6.TextWrapped = true

		Front6.Name = "Front6"
		Front6.Parent = TextButton6
		Front6.AnchorPoint = Vector2.new(0.5, 0.5)
		Front6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Front6.BackgroundTransparency = 1.000
		Front6.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Front6.BorderSizePixel = 0
		Front6.Position = UDim2.new(0.5, 0, 0.5, 0)
		Front6.Size = UDim2.new(0.899999976, 0, 0.899999976, 0)
		Front6.SizeConstraint = Enum.SizeConstraint.RelativeXX
		Front6.ZIndex = 4
		Front6.Image = "rbxassetid://112068843495830"

		UIC666.Name = "UIC666"
		UIC666.Parent = Front6

		Background6.Name = "Background6"
		Background6.Parent = TextButton6
		Background6.AnchorPoint = Vector2.new(0.5, 0.5)
		Background6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Background6.BackgroundTransparency = 1.000
		Background6.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Background6.BorderSizePixel = 0
		Background6.Position = UDim2.new(0.5, 0, 0.5, 0)
		Background6.Size = UDim2.new(0.800000012, 0, 0.800000012, 0)
		Background6.SizeConstraint = Enum.SizeConstraint.RelativeXX
		Background6.ZIndex = 3
		Background6.Image = "rbxassetid://138110752460865"

		UIC66.Name = "UIC66"
		UIC66.Parent = Background6

		UIC6.Name = "UIC6"
		UIC6.Parent = _6

		_7.Name = "7"
		_7.Parent = WhereTheButtons
		_7.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		_7.BackgroundTransparency = 0.700
		_7.BorderColor3 = Color3.fromRGB(0, 0, 0)
		_7.BorderSizePixel = 0
		_7.LayoutOrder = 7
		_7.Size = UDim2.new(0.125, 0, 1, 0)
		_7.ZIndex = 2

		TextButton7.Name = "TextButton7"
		TextButton7.Parent = _7
		TextButton7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextButton7.BackgroundTransparency = 1.000
		TextButton7.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextButton7.BorderSizePixel = 0
		TextButton7.Size = UDim2.new(1, 0, 1, 0)
		TextButton7.ZIndex = 3
		TextButton7.Font = Enum.Font.FredokaOne
		TextButton7.Text = ""
		TextButton7.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextButton7.TextScaled = true
		TextButton7.TextSize = 10.000
		TextButton7.TextWrapped = true

		Front7.Name = "Front7"
		Front7.Parent = TextButton7
		Front7.AnchorPoint = Vector2.new(0.5, 0.5)
		Front7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Front7.BackgroundTransparency = 1.000
		Front7.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Front7.BorderSizePixel = 0
		Front7.Position = UDim2.new(0.5, 0, 0.5, 0)
		Front7.Size = UDim2.new(0.899999976, 0, 0.899999976, 0)
		Front7.SizeConstraint = Enum.SizeConstraint.RelativeXX
		Front7.ZIndex = 4
		Front7.Image = "rbxassetid://112068843495830"

		UIC777.Name = "UIC777"
		UIC777.Parent = Front7

		Background7.Name = "Background7"
		Background7.Parent = TextButton7
		Background7.AnchorPoint = Vector2.new(0.5, 0.5)
		Background7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Background7.BackgroundTransparency = 1.000
		Background7.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Background7.BorderSizePixel = 0
		Background7.Position = UDim2.new(0.5, 0, 0.5, 0)
		Background7.Size = UDim2.new(0.800000012, 0, 0.800000012, 0)
		Background7.SizeConstraint = Enum.SizeConstraint.RelativeXX
		Background7.ZIndex = 3
		Background7.Image = "rbxassetid://138110752460865"

		UIC77.Name = "UIC77"
		UIC77.Parent = Background7

		UIC7.Name = "UIC7"
		UIC7.Parent = _7

		_8.Name = "8"
		_8.Parent = WhereTheButtons
		_8.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		_8.BackgroundTransparency = 0.700
		_8.BorderColor3 = Color3.fromRGB(0, 0, 0)
		_8.BorderSizePixel = 0
		_8.LayoutOrder = 8
		_8.Size = UDim2.new(0.125, 0, 1, 0)
		_8.ZIndex = 2

		TextButton8.Name = "TextButton8"
		TextButton8.Parent = _8
		TextButton8.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextButton8.BackgroundTransparency = 1.000
		TextButton8.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextButton8.BorderSizePixel = 0
		TextButton8.Size = UDim2.new(1, 0, 1, 0)
		TextButton8.ZIndex = 3
		TextButton8.Font = Enum.Font.FredokaOne
		TextButton8.Text = ""
		TextButton8.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextButton8.TextScaled = true
		TextButton8.TextSize = 10.000
		TextButton8.TextWrapped = true

		Front8.Name = "Front8"
		Front8.Parent = TextButton8
		Front8.AnchorPoint = Vector2.new(0.5, 0.5)
		Front8.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Front8.BackgroundTransparency = 1.000
		Front8.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Front8.BorderSizePixel = 0
		Front8.Position = UDim2.new(0.5, 0, 0.5, 0)
		Front8.Size = UDim2.new(0.899999976, 0, 0.899999976, 0)
		Front8.SizeConstraint = Enum.SizeConstraint.RelativeXX
		Front8.ZIndex = 4
		Front8.Image = "rbxassetid://112068843495830"

		UIC888.Name = "UIC888"
		UIC888.Parent = Front8

		Background8.Name = "Background8"
		Background8.Parent = TextButton8
		Background8.AnchorPoint = Vector2.new(0.5, 0.5)
		Background8.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Background8.BackgroundTransparency = 1.000
		Background8.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Background8.BorderSizePixel = 0
		Background8.Position = UDim2.new(0.5, 0, 0.5, 0)
		Background8.Size = UDim2.new(0.800000012, 0, 0.800000012, 0)
		Background8.SizeConstraint = Enum.SizeConstraint.RelativeXX
		Background8.ZIndex = 3
		Background8.Image = "rbxassetid://138110752460865"

		UIC88.Name = "UIC88"
		UIC88.Parent = Background8

		UIC8.Name = "UIC8"
		UIC8.Parent = _8

		ListingLayouts.Name = "ListingLayouts"
		ListingLayouts.Parent = WhereTheButtons
		ListingLayouts.FillDirection = Enum.FillDirection.Horizontal
		ListingLayouts.SortOrder = Enum.SortOrder.LayoutOrder
		ListingLayouts.VerticalAlignment = Enum.VerticalAlignment.Center
		ListingLayouts.HorizontalAlignment = Enum.HorizontalAlignment.Left
		ListingLayouts.Padding = UDim.new(0, 5)

		WhereButtonPadding.Name = "WhereButtonPadding"
		WhereButtonPadding.Parent = WhereTheButtons
		WhereButtonPadding.PaddingBottom = UDim.new(0, 5)
		WhereButtonPadding.PaddingLeft = UDim.new(0, 5)
		WhereButtonPadding.PaddingRight = UDim.new(0, 5)
		WhereButtonPadding.PaddingTop = UDim.new(0, 5)

		UIAspectRatioConstraint.Parent = Holder
		UIAspectRatioConstraint.AspectRatio = 9.000

		Name.Name = "Name"
		Name.Parent = Holder
		Name.AnchorPoint = Vector2.new(0.5, 1)
		Name.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		Name.BackgroundTransparency = 0.250
		Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Name.BorderSizePixel = 0
		Name.Position = UDim2.new(0.5, 0, 1.29999995, 5)
		Name.Size = UDim2.new(1, 0, 0.300000012, 0)

		NameTextbox.Name = "NameTextbox"
		NameTextbox.Parent = Name
		NameTextbox.AnchorPoint = Vector2.new(0.5, 0.5)
		NameTextbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		NameTextbox.BackgroundTransparency = 1.000
		NameTextbox.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NameTextbox.BorderSizePixel = 0
		NameTextbox.Position = UDim2.new(0.5, 0, 0.5, 0)
		NameTextbox.Size = UDim2.new(1, 0, 1, 0)
		NameTextbox.Font = Enum.Font.FredokaOne
		NameTextbox.Text = "Some Emote Name"
		NameTextbox.TextColor3 = Color3.fromRGB(255, 255, 255)
		NameTextbox.TextScaled = true
		NameTextbox.TextSize = 14.000
		NameTextbox.TextWrapped = true

		NameUIT.Name = "NameUIT"
		NameUIT.Parent = NameTextbox
		NameUIT.MaxTextSize = 30
		NameUIT.MinTextSize = 10

		NameUIC.Name = "NameUIC"
		NameUIC.Parent = Name

		local Images = {
			{ name = "Locked", renderImage = "rbxassetid://103241825392940" },
			{ name = "LethalCompany", renderImage = "rbxassetid://89769371017185" },
			{ name = "Headbanger", renderImage = "rbxassetid://126222345373558" },
			{ name = "SoRetro", renderImage = "rbxassetid://129885437120707" },
			{ name = "AICatDance", renderImage = "rbxassetid://93387041641721" },
			{ name = "SubjectThree", renderImage = "rbxassetid://83639505456623" },
			{ name = "Subterfuge", renderImage = "rbxassetid://71165177698139" },
			{ name = "Griddy", renderImage = "rbxassetid://71748174857033" },
			{ name = "Prince", renderImage = "rbxassetid://125197961882771" },
			{ name = "MissTheQuiet", renderImage = "rbxassetid://86125219137797" },
			{ name = "Hero", renderImage = "rbxassetid://78969991165860" },
			{ name = "PYT", renderImage = "rbxassetid://121927033287000" },
			{ name = "Wait", renderImage = "rbxassetid://106561882302009" },
			{ name = "No", renderImage = "rbxassetid://101973569734115" },
			{ name = "Konton", renderImage = "rbxassetid://135343313057075" },
			{ name = "TickTock", renderImage = "rbxassetid://112068843495830" },
			{ name = "Dio", renderImage = "rbxassetid://78716828045407" },
			{ name = "Shucks", renderImage = "rbxassetid://139634009593796" },
			{ name = "ThePhone", renderImage = "rbxassetid://91657126735088" },
			{ name = "Skeleton", renderImage = "rbxassetid://94678300716216" },
			{ name = "Insanity", renderImage = "rbxassetid://79579234154217" },
			{ name = "HakariDance", renderImage = "rbxassetid://124587965197013" },
			{ name = "SillyBilly", renderImage = "rbxassetid://96660516353249" },
			{ name = "Hotdog", renderImage = "rbxassetid://70514684116327" },
			{ name = "DistractionDance", renderImage = "rbxassetid://110811886859354" },
			{ name = "CaliforniaGirls", renderImage = "rbxassetid://127260772788474" },
			{ name = "AolGuy", renderImage = "rbxassetid://81493512531467" },
			{ name = "Eggrolled", renderImage = "rbxassetid://75402218293560" },
			{ name = "BagUp", renderImage = "rbxassetid://135883870615399" },
			{ name = "Poisoned", renderImage = "rbxassetid://92399495788269" },
			{ name = "Wave", renderImage = "rbxassetid://132063131763271" },
		}

		local buttons = {
			TextButton1,
			TextButton2,
			TextButton3,
			TextButton4,
			TextButton5,
			TextButton6,
			TextButton7,
			TextButton8,
		}

		local function GetEmoteList()
			local LocalPlayer = game:GetService("Players").LocalPlayer
			local emotes = LocalPlayer:FindFirstChild("PlayerData")
					and LocalPlayer.PlayerData:FindFirstChild("Equipped")
					and LocalPlayer.PlayerData.Equipped:FindFirstChild("Emotes")
					and LocalPlayer.PlayerData.Equipped.Emotes.Value
				or ""
			local emoteList = {}
			for i, emote in ipairs(string.split(emotes, "|")) do
				local EmoteImage = ""
				for _, image in ipairs(Images) do
					if image.name == emote then
						EmoteImage = image.renderImage
						break
					end
				end
				table.insert(emoteList, { index = i, name = emote, renderImage = EmoteImage })
			end
			return emoteList
		end

		local emoteList = GetEmoteList()

		local function SetImages()
			for i, button in ipairs(buttons) do
				local emote = emoteList[i]
				if emote and emote.renderImage ~= "" then
					button:FindFirstChild("Front" .. i).Image = emote.renderImage
				else
					button.Text = ""
					for _, child in ipairs(button:GetChildren()) do
						if child:IsA("ImageLabel") then
							child:Destroy()
						end
					end
				end
			end
		end

		SetImages()

		for i, button in ipairs(buttons) do
			button.MouseEnter:Connect(function()
				local emote = emoteList[i]
				if emote and emote.name ~= "" then
					NameTextbox.Text = emote.name
				end
			end)
		end

		local TweenService = game:GetService("TweenService")

		local Blur = Instance.new("BlurEffect", game:GetService("Lighting"))
		Blur.Size = 0
		Blur.Name = "EmoteBlur"

		local tweenInfoBlur = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)
		local tweenBlur = TweenService:Create(Blur, tweenInfoBlur, { Size = 0 })
		tweenBlur:Play()

		local tweeninfoholdersize = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)
		local tweenholdersize =
			TweenService:Create(Holder, tweeninfoholdersize, { Size = UDim2.new(0.8 * 0.8, 0, 0.15 * 0.8, 0) })
		tweenholdersize:Play()

		for i, button in ipairs(buttons) do
			button.Activated:Connect(function()
				local PlayThingText = emoteList[i].name

				local ohString1 = "PlayEmote"
				local ohString2 = "Animations"
				local ohString3 = "TickTock"
				game:GetService("ReplicatedStorage").Modules.Network.RemoteEvent
					:FireServer(ohString1, ohString2, PlayThingText)

				local TweenService = game:GetService("TweenService")

				local originalSize = Holder.Size
				local DestinationSize = UDim2.new(0, 0, 0, 0)

				local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)
				local tween = TweenService:Create(Holder, tweenInfo, { Size = DestinationSize })
				local tweenblurinfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)
				local tweenblur = TweenService:Create(Blur, tweenblurinfo, { Size = 0 })

				tweenblur:Play()
				tween:Play()
				task.wait(0.25)
				KillerEmoteGUI:Destroy()
			end)
		end
	end
end

local ThemeOptions = {
   ["Default"] = "Default",
   ["Amber Glow"] = "AmberGlow",
   ["Amethyst"] = "Amethyst",
   ["Bloom"] = "Bloom",
   ["Dark Blue"] = "DarkBlue",
   ["Green"] = "Green",
   ["Light"] = "Light",
   ["Ocean"] = "Ocean",
   ["Serenity"] = "Serenity"
}

local timeAhead = 0.2

-- Prevent duplicate hub (if still present from other runs)
local existingGui = PlayerGui:FindFirstChild("GoonsakenHub")
if existingGui then
    existingGui:Destroy()
end

-- Preserve original logic variables
local statsGui
local ESP = {}
ESP.Enabled = false

local PLAYER_ESP_NAME = "PlayerESP"
local ITEM_ESP_NAME = "ToolESPHighlight"
local GENERATOR_ESP_NAME = "GeneratorESP"
local TRAPSANDSPIKES_ESP_NAME = "TrapsandSpikesESP"

local aimbotConnection

local function findNearestGenerator()
    local mapFolder = Workspace:FindFirstChild("Map")
    if not mapFolder then return nil end
    local ingameMap = mapFolder:FindFirstChild("Ingame")
    if not ingameMap then return nil end
    local map = ingameMap:FindFirstChild("Map")
    if not map then return nil end

    local generators = {}
    for _, obj in pairs(map:GetChildren()) do
        if obj.Name == "Generator" and obj:IsA("Model") then
            table.insert(generators, obj)
        end
    end

    if #generators == 0 then return nil end

    local LocalPlayerRoot = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not LocalPlayerRoot then return nil end

    local nearestGen = nil
    local nearestDist = math.huge

    for _, gen in pairs(generators) do
        local genRoot = gen:FindFirstChild("HumanoidRootPart") or gen.PrimaryPart
        if genRoot then
            local dist = (genRoot.Position - LocalPlayerRoot.Position).Magnitude
            if dist < nearestDist then
                nearestDist = dist
                nearestGen = gen
            end
        end
    end

    return nearestGen
end

local function findNearestValidGenerator()
    local map = workspace:FindFirstChild("Map")
    if not map then return nil end
    local ingame = map:FindFirstChild("Ingame")
    if not ingame then return nil end
    local container = ingame:FindFirstChild("Map")
    if not container then return nil end

    local nearest
    local shortestDist = math.huge
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    for _, gen in ipairs(container:GetDescendants()) do
        if gen.Name == "Generator" and gen:IsA("Model") and gen:FindFirstChild("Progress") and gen.Progress.Value < 100 then
            local dist = (gen.PrimaryPart.Position - root.Position).Magnitude
            if dist < shortestDist then
                shortestDist = dist
                nearest = gen
            end
        end
    end

    return nearest
end

local function triggerNearestGenerator(shouldLoop)
    local PuzzleUI = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("PuzzleUI", 9999)
    local MapFolder = workspace:FindFirstChild("Map")
        and workspace.Map:FindFirstChild("Ingame")
        and workspace.Map.Ingame:FindFirstChild("Map")
    if not MapFolder then
        warn("Map folder not found")
        return
    end

    task.spawn(function()
        loopgen = true
        while shouldLoop do
            task.wait(timeforonegen + math.random() * 0.5) -- wait first with slight randomness

            local closestGenerator, closestDistance = nil, math.huge
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not root then break end
            local LocalPlayerPosition = root.Position

            for _, gen in ipairs(MapFolder:GetChildren()) do
                if gen.Name == "Generator" and gen:FindFirstChild("Progress") and gen.Progress.Value < 100 then
                    local distance = (gen.PrimaryPart and gen.PrimaryPart.Position or gen:GetModelCFrame().p - LocalPlayerPosition).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestGenerator = gen
                    end
                end
            end

            if closestGenerator and closestGenerator:FindFirstChild("Remotes") and closestGenerator.Remotes:FindFirstChild("RE") then
                closestGenerator.Remotes.RE:FireServer()
                print("Fired generator:", closestGenerator.Name)
            else
                -- No valid generator left
                break
            end
        end
        loopgen = false
        print("Generator loop ended")
    end)
end
-- Enable aimbot function
local function enableAimbot()
    local previousPos = nil
    local deltaTime = 0.03

    aimbotConnection = RunService.Heartbeat:Connect(function()
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Parent then
            local flintlock = humanoid.Parent:FindFirstChild("Flintlock")
            if flintlock and flintlock.Transparency == 0 then
                local killersFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Killers")
                if killersFolder then
                    for _, killerModel in pairs(killersFolder:GetChildren()) do
                        if killerModel:IsA("Model") and killerModel:FindFirstChild("HumanoidRootPart") then
                            local hrp = killerModel.HumanoidRootPart
                            local currentPos = hrp.Position
                            local velocity = Vector3.new(0, 0, 0)

                            if previousPos then
                                velocity = (currentPos - previousPos) / deltaTime
                            end
                            previousPos = currentPos

                            local predictedPos = currentPos + velocity * timeAhead

                            local rootPart = character:FindFirstChild("HumanoidRootPart")
                            if rootPart then
								if humanoid then
									humanoid.AutoRotate = false
								end
                                rootPart.CFrame = CFrame.new(rootPart.Position, predictedPos)
                            end
                        end
                    end
                end
			else
				if humanoid then
					humanoid.AutoRotate = true
				end
			end        
		end	
    end)
end

-- Disable aimbot function
local function disableAimbot()
    if aimbotConnection then
		local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.AutoRotate = true
		end
        aimbotConnection:Disconnect()
        aimbotConnection = nil
    end
end

local COLOR_SURVIVOR = Color3.fromRGB(0, 255, 0)
local COLOR_KILLER = Color3.fromRGB(255, 0, 0)
local COLOR_TRAPSANDSPIKES = Color3.fromRGB(255, 0, 0)
local COLOR_MEDKIT = Color3.fromRGB(0, 255, 0)
local COLOR_COLA = Color3.fromRGB(0, 150, 255)
local COLOR_GENERATOR = Color3.fromRGB(255, 255, 0)

-- Store all highlights to toggle visibility
local allHighlights = {}

local function setHighlightVisibility(highlight, visible)
    if visible then
        highlight.FillTransparency = 0.8
        highlight.OutlineTransparency = 0
    else
        highlight.FillTransparency = 1
        highlight.OutlineTransparency = 1
    end
end

-- Player ESP
local PlayersFolder = Workspace:WaitForChild("Players")

local function applyTrapsandSpikesESP(color)
    local ingameFolder = workspace:FindFirstChild("Map") 
        and workspace.Map:FindFirstChild("Ingame")
    if not ingameFolder then
        warn("Ingame folder not found in Workspace.Map")
        return
    end

    -- Recursive function to search inside a model for a part named "Hook1"
    local function hasHook1(obj)
        for _, child in ipairs(obj:GetDescendants()) do
            if child:IsA("BasePart") and child.Name == "Hook1" then
                return true
            end
        end
        return false
    end

    -- Function to create a unique highlight if it doesn't already exist
    local function ensureHighlight(target)
        if not target:FindFirstChild("TrapsandSpikesESP") then
            local hl = Instance.new("Highlight")
            hl.Name = TRAPSANDSPIKES_ESP_NAME
            hl.FillColor = color or Color3.fromRGB(255, 0, 0) -- default bright red
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.OutlineTransparency = 0
            hl.FillTransparency = 0.8
            hl.Adornee = target
            hl.Parent = target

            -- Add to global highlights table
            allHighlights[hl] = true
        end
    end

    -- Scan through all descendants in Ingame
    for _, obj in ipairs(ingameFolder:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            if obj.Name == "Spike" or obj.Name == "SubspaceTripmine" then
                ensureHighlight(obj)

            elseif obj.Name == "Shadow" then
                -- Set transparency to 0 for shadow parts
                if obj:IsA("BasePart") then
                    obj.Transparency = 0
                elseif obj:IsA("Model") then
                    for _, part in ipairs(obj:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Transparency = 0
                        end
                    end
                end
                ensureHighlight(obj)
            elseif hasHook1(obj) then
                ensureHighlight(obj)
            elseif typeof(obj.Name) == "string" and string.find(obj.Name, "RespawnLocation") then
                if obj:IsA("BasePart") then
                    obj.Transparency = 0
                elseif obj:IsA("Model") then
                    for _, part in ipairs(obj:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Transparency = 0
                        end
                    end
                end
                ensureHighlight(obj)
			end
        end
    end
end

local function applyPlayerESP(character, color)
    if not character:IsA("Model") then return end
	if not game.Players:GetPlayerFromCharacter(character) then return end
    if character:FindFirstChild(PLAYER_ESP_NAME) then return end

	if character == LocalPlayer.Character then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = PLAYER_ESP_NAME
    highlight.FillColor = color
    highlight.Adornee = character
    highlight.Parent = character

	local billboard = Instance.new("BillboardGui", character:WaitForChild("Head"))
	billboard.Name = "PlayerESPBillboard"
	billboard.Size = UDim2.new(0, 100, 0, 50)
	billboard.StudsOffset = Vector3.new(0, 2, 0)
	local textLabel = Instance.new("TextLabel", billboard)
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.Text = "(" .. tostring(character.Name) .. ") " .. tostring(character:GetAttribute("Username")) 
	textLabel.TextColor3 = Color3.new(1, 1, 1)
	textLabel.TextStrokeTransparency = 0
	textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
	billboard.AlwaysOnTop = true
	textLabel.BackgroundTransparency = 1
    -- Set initial visibility
    setHighlightVisibility(highlight, ESP.Enabled)
    allHighlights[highlight] = true

    -- Remove old Highlight if exists
    if character:FindFirstChild("Highlight") then
        character.Highlight:Destroy()
    end
end

-- Item ESP
local function applyItemHighlight(tool, color)
    if not tool:FindFirstChild(ITEM_ESP_NAME) then
        local highlight = Instance.new("Highlight")
        highlight.Name = ITEM_ESP_NAME
        highlight.Adornee = tool
        highlight.FillColor = color
        highlight.OutlineColor = Color3.new(1, 1, 1)
        highlight.Parent = tool

        -- Set initial visibility
        setHighlightVisibility(highlight, ESP.Enabled)
        allHighlights[highlight] = true
    end
end

local function highlightToolIfNeeded(tool)
    if tool:IsA("Tool") then
        if tool.Name == "Medkit" then
            applyItemHighlight(tool, COLOR_MEDKIT)
        elseif tool.Name == "BloxyCola" or tool.Name == "Cola" then
            applyItemHighlight(tool, COLOR_COLA)
        end
    end
end

-- Generator ESP
local function addGeneratorHighlight(model)
    if model:FindFirstChild(GENERATOR_ESP_NAME) then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = GENERATOR_ESP_NAME
    highlight.FillColor = COLOR_GENERATOR
    highlight.Adornee = model
    highlight.Parent = model

    -- Set initial visibility
    setHighlightVisibility(highlight, ESP.Enabled)
    allHighlights[highlight] = true
end

local function removeGeneratorHighlight(model)
    local existing = model:FindFirstChild(GENERATOR_ESP_NAME)
    if existing then
        allHighlights[existing] = nil
        existing:Destroy()
    end
end

local function trackGenerator(generator)
    local progress = generator:FindFirstChild("Progress")
    local instances = generator:FindFirstChild("Instances")

    if not progress or not instances then return end

    local genModel = instances:FindFirstChild("Generator")
    if not genModel or not genModel:IsA("Model") then return end

    if progress.Value < 100 then
        addGeneratorHighlight(genModel)
    else
        removeGeneratorHighlight(genModel)
    end

    progress:GetPropertyChangedSignal("Value"):Connect(function()
        if progress.Value >= 100 then
            removeGeneratorHighlight(genModel)
        else
            addGeneratorHighlight(genModel)
        end
    end)
end

local function trackGeneratorsInFolder(folder)
    if not folder then return end
    for _, gen in ipairs(folder:GetDescendants()) do
        if gen.Name == "Generator" and gen:IsA("Model") then
            trackGenerator(gen)
        end
    end
end

-- Listen for Map creation / reload
workspace.ChildAdded:Connect(function(child)
    if child.Name == "Map" then
        task.wait(1)
        local ingame = child:FindFirstChild("Ingame")
        local mapContainer = ingame and ingame:FindFirstChild("Map")
        if mapContainer then
            trackGeneratorsInFolder(mapContainer)
        end
    end
end)

-- Also listen for new generators being added mid-game
workspace.DescendantAdded:Connect(function(obj)
    if obj.Name == "Generator" and obj:IsA("Model") then
        trackGenerator(obj)
    end
end)

runEvery(0.5, function()
    local survivors = PlayersFolder:FindFirstChild("Survivors")
    if survivors then
        for _, char in ipairs(survivors:GetChildren()) do
            applyPlayerESP(char, COLOR_SURVIVOR)
        end
    end

    local killers = PlayersFolder:FindFirstChild("Killers")
    if killers then
        for _, char in ipairs(killers:GetChildren()) do
            applyPlayerESP(char, COLOR_KILLER)
        end
    end

    -- This one used to scan the entire map each frame — now every 0.5s
    applyTrapsandSpikesESP(COLOR_TRAPSANDSPIKES)
end)

-- Item ESP initial scan
for _, tool in ipairs(Workspace:GetDescendants()) do
    highlightToolIfNeeded(tool)
end

-- Item ESP listen for new tools
task.spawn(function()
    task.wait(0.5)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        highlightToolIfNeeded(obj)
    end
end)

track(Workspace.DescendantAdded:Connect(highlightToolIfNeeded))

-- Generator ESP loop (preserved)
-- Find map once (with retries), then track generators, plus a 0.5s poll for *new* generators
task.spawn(function()
    local mapContainer
    repeat
        local mapRoot = Workspace:FindFirstChild("Map")
        local ingame = mapRoot and mapRoot:FindFirstChild("Ingame")
        mapContainer = ingame and ingame:FindFirstChild("Map")
        task.wait(0.5)
    until mapContainer

    -- initial pass
    for _, gen in ipairs(mapContainer:GetChildren()) do
        if gen.Name == "Generator" and gen:IsA("Model") then
            trackGenerator(gen)  -- your existing function (it adds/removes a Highlight and binds to Progress)
        end
    end

    -- watch for new generators appearing in-session (throttled)
    for _, gen in ipairs(mapContainer:GetChildren()) do
    	if gen.Name == "Generator" and gen:IsA("Model") and not gen:FindFirstChild(GENERATOR_ESP_NAME) then
    	    trackGenerator(gen)
        end
    end
end)

-- Function to toggle ESP on/off
function ESP:SetEnabled(state)
    ESP.Enabled = state
    for highlight,_ in pairs(allHighlights) do
        setHighlightVisibility(highlight, state)
    end
	local LocalPlayersFolder = game.Workspace:FindFirstChild("Players")
    if LocalPlayersFolder then
        for _, LocalPlayerType in pairs(LocalPlayersFolder:GetChildren()) do -- Survivors, Killers folders etc.
            for _, char in pairs(LocalPlayerType:GetChildren()) do
                local billboard = char:FindFirstChild("PlayerESPBillboard", true) -- recursive search
                if billboard then
                    billboard.Enabled = state
                end
            end
        end
    end
end

-- Stats tracker UI creation (unchanged)
local function createStatsTracker()
    -- Remove existing GUI if any
    local existingGui = PlayerGui:FindFirstChild("TimePlayedGUI")
    if existingGui then
        existingGui:Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TimePlayedGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui
    screenGui.Enabled = false -- start hidden

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 500, 0, 500)
    mainFrame.Position = UDim2.new(0, 100, 0, 100)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Text = "🎮 Player Stats Tracker"
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 20
    title.Parent = mainFrame

    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, 0, 1, -30)
    scrollFrame.Position = UDim2.new(0, 0, 0, 30)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.Parent = mainFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = scrollFrame

    local function formatTime(seconds)
        local days = math.floor(seconds / 86400)
        seconds = seconds % 86400
        local hours = math.floor(seconds / 3600)
        seconds = seconds % 3600
        local minutes = math.floor(seconds / 60)
        seconds = seconds % 60
        return string.format("%dd %02dh %02dm %02ds", days, hours, minutes, seconds)
    end

    local function createPlayerRow(LocalPlayer)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -10, 0, 100)
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        button.TextColor3 = Color3.new(1, 1, 1)
        button.Font = Enum.Font.SourceSans
        button.TextSize = 16
        button.Text = "Loading..."
        button.TextWrapped = true
        button.TextXAlignment = Enum.TextXAlignment.Left
        button.AutoButtonColor = true
        button.LayoutOrder = LocalPlayer.UserId
        button.Parent = scrollFrame

        button.MouseButton1Click:Connect(function()
            local timeValue = LocalPlayer:FindFirstChild("PlayerData")
                and LocalPlayer.PlayerData:FindFirstChild("Stats")
                and LocalPlayer.PlayerData.Stats:FindFirstChild("General")
                and LocalPlayer.PlayerData.Stats.General:FindFirstChild("TimePlayed")

            local timeText = timeValue and formatTime(timeValue.Value) or "N/A"
            if setclipboard then
                setclipboard(LocalPlayer.Name .. " - " .. timeText)
            end
        end)

        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not LocalPlayer:IsDescendantOf(Players) then
                button:Destroy()
                if connection then connection:Disconnect() end
                return
            end

            local stats = LocalPlayer:FindFirstChild("PlayerData") and LocalPlayer.PlayerData:FindFirstChild("Stats")
            local general = stats and stats:FindFirstChild("General")
            local killer = stats and stats:FindFirstChild("KillerStats")
            local survivor = stats and stats:FindFirstChild("SurvivorStats")
            local equipped = LocalPlayer:FindFirstChild("PlayerData") and LocalPlayer.PlayerData:FindFirstChild("Equipped")

            local timePlayed = general and general:FindFirstChild("TimePlayed")
            local killerWins = killer and killer:FindFirstChild("KillerWins")
            local killerLosses = killer and killer:FindFirstChild("KillerLosses")
            local survivorWins = survivor and survivor:FindFirstChild("SurvivorWins")
            local survivorLosses = survivor and survivor:FindFirstChild("SurvivorLosses")
            local kills = killer and killer:FindFirstChild("Kills")
            local emotes = equipped and equipped:FindFirstChild("Emotes")

            local timeText = timePlayed and formatTime(timePlayed.Value) or "N/A"
            local kw = killerWins and killerWins.Value or "N/A"
            local kl = killerLosses and killerLosses.Value or "N/A"
            local sw = survivorWins and survivorWins.Value or "N/A"
            local sl = survivorLosses and survivorLosses.Value or "N/A"
            local killCount = kills and kills.Value or "N/A"
            local emoteText = emotes and emotes.Value or "None"

            button.Text = string.format(
                "%s\nTime Played: %s\nSurvivor Wins: %s | Losses: %s\nKiller Wins: %s | Losses: %s | Kills: %s\nEmotes: %s",
                LocalPlayer.Name,
                timeText,
                sw, sl,
                kw, kl, killCount,
                emoteText
            )
        end)
    end

    for _, LocalPlayer in ipairs(Players:GetPlayers()) do
        if LocalPlayer ~= LocalPlayer then
            createPlayerRow(LocalPlayer)
        end
    end

    Players.PlayerAdded:Connect(function(LocalPlayer)
        if LocalPlayer ~= LocalPlayer then
            createPlayerRow(LocalPlayer)
        end
    end)

    RunService.RenderStepped:Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
    end)

    return screenGui
end

-- Default toggles and helpers (we will hook these to Fluent UI)
local toggles = {
    StatsTracker = false,
    ESP = false,
    infiniteStamina = false,
    AutoRejoinOnKick = true -- default ON as requested
}
local activeConnections = {}
local guiRefs = {}

-- Feature functions reused by GUI callbacks

-- Anim Ids
local GuestSettingsTriggerAnims = {
    "126830014841198", "126355327951215", "121086746534252", "18885909645",
    "98456918873918", "105458270463374", "83829782357897", "125403313786645",
    "118298475669935", "82113744478546", "70371667919898", "99135633258223",
    "97167027849946", "109230267448394", "139835501033932", "126896426760253",
    "109667959938617", "126681776859538", "129976080405072", "121293883585738",
    "81639435858902", "137314737492715",
    "92173139187970"
}

-- State Variables
local GuestSettingsOn = false
local strictRangeOn = false
local looseFacing = true
local detectionRange = 18

local predictiveBlockOn = false
local detectionRange = 10
local edgeKillerDelay = 3
local killerInRangeSince = nil
local predictiveCooldown = 0

local GuestSettingsOn = false
local flingPunchOn = false
local flingPower = 10000
local hiddenfling = false
local aimPunch = false

local customBlockEnabled = false
local customBlockAnimId = ""
local customPunchEnabled = false
local customPunchAnimId = ""

local infiniteStamina = false

local lastBlockTime = 0
local lastPunchTime = 0
local lastBlockTpTime = 0

local blockAnimIds = {
"72722244508749",
"96959123077498"
}
local punchAnimIds = {
"87259391926321"
}

local customChargeEnabled = false
local customChargeAnimId = ""
local chargeAnimIds = { "106014898528300" }

-- Goon animation
local function startGoon()
    local LocalPlayer = Players.LocalPlayer
    local animationId = "rbxassetid://72042024"
    if not guiRefs.GoonAnim then guiRefs.GoonAnim = nil end

    local function playGoonAnim()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end

        local animation = Instance.new("Animation")
        animation.AnimationId = animationId
        local animTrack = humanoid:LoadAnimation(animation)
        animTrack.Looped = true
        animTrack:Play()
        guiRefs.GoonAnim = animTrack
    end

    playGoonAnim()
    guiRefs.GoonConnection = LocalPlayer.CharacterAdded:Connect(function()
        if toggles.Goon then
            playGoonAnim()
        end
    end)
end

local function stopGoon()
    if guiRefs.GoonAnim then
        guiRefs.GoonAnim:Stop()
        guiRefs.GoonAnim = nil
    end
    if guiRefs.GoonConnection then
        guiRefs.GoonConnection:Disconnect()
        guiRefs.GoonConnection = nil
    end
end

-- LayDown animation
local function startLayDown()
    local LocalPlayer = Players.LocalPlayer
    local animationId = "rbxassetid://181526230"
    local skipTime = 0.2

    if not guiRefs.LayDownAnim then guiRefs.LayDownAnim = nil end

    local function playLayDownAnim()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end

        local animation = Instance.new("Animation")
        animation.AnimationId = animationId
        local animTrack = humanoid:LoadAnimation(animation)
        animTrack.Looped = true
        animTrack:Play()
        animTrack.TimePosition = skipTime
        guiRefs.LayDownAnim = animTrack
    end

    playLayDownAnim()
    guiRefs.LayDownConnection = LocalPlayer.CharacterAdded:Connect(function()
        if toggles.LayDown then
            playLayDownAnim()
        end
    end)
end

local function generatorDoAll()
    local LocalPlayer = game.Players.LocalPlayer
    local Workspace = game.Workspace

    local function findGenerators()
        local mapFolder = Workspace:FindFirstChild("Map")
        local ingameMap = mapFolder and mapFolder:FindFirstChild("Ingame")
        local map = ingameMap and ingameMap:FindFirstChild("Map")
        local generators = {}

        if map then
            for _, gen in ipairs(map:GetChildren()) do
                if gen.Name == "Generator" and gen:IsA("Model") and gen:FindFirstChild("Progress") and gen.Progress.Value < 100 then
                    -- Check if any LocalPlayers are within 25 studs of generator's Main part
                    local LocalPlayersNearby = false
                    for _, LocalPlayer in ipairs(game.Players:GetPlayers()) do
                        local char = LocalPlayer.Character
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        if hrp and gen:FindFirstChild("Main") then
                            local dist = (hrp.Position - gen.Main.Position).Magnitude
                            if dist < 25 then
                                LocalPlayersNearby = true
                                break
                            end
                        end
                    end

                    if not LocalPlayersNearby then
                        table.insert(generators, gen)
                    end
                end
            end
        end

        return generators
    end

    -- Save current LocalPlayer position to return later
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local lastPosition = humanoidRootPart.CFrame

    -- Main loop: keep working generators until none left
    while true do
        local generators = findGenerators()
        if #generators == 0 then
            break
        end

        for _, gen in ipairs(generators) do
            if gen:FindFirstChild("Main") and gen:FindFirstChild("Remotes") and gen.Remotes:FindFirstChild("RE") and gen.Remotes:FindFirstChild("RF") then
                -- Compute direction to face generator cube (if it exists)
				local generatorPosition = gen.Positions.Center.Position
				local generatorDirection

				if gen.Instances.Generator:FindFirstChild("Cube") and gen.Instances.Generator.Cube:IsA("BasePart") then
					local cubePos = gen.Instances.Generator.Cube.Position
					generatorDirection = (cubePos - generatorPosition).Unit
				else
					generatorDirection = Vector3.new(0, 0, 1) -- fallback direction forward
				end

				-- Teleport LocalPlayer to generator, facing the cube (or forward)
				humanoidRootPart.CFrame = CFrame.new(
					generatorPosition + Vector3.new(0, 0.5, 0),
					generatorPosition + Vector3.new(generatorDirection.X, 0, generatorDirection.Z)
				)

                task.wait(timebetweenpuzzles / 2) -- adjust wait time as needed

                -- Fire the proximity prompt
                local prompt = gen.Main:FindFirstChildOfClass("ProximityPrompt")
                if not prompt then
                    prompt = gen.Main:FindFirstChild("Prompt")
                end
                if prompt then
                    fireproximityprompt(prompt, 1, false)
                else
                    warn("No prompt found on generator:", gen.Name)
                end

                -- Fire the remote server call multiple times (6 times as in your example)
                for _ = 1, 6 do
                    task.wait(2.5)
                    gen.Remotes.RE:FireServer()
                end

                task.wait(timebetweenpuzzles / 5) -- small delay before leaving

                -- Invoke the "leave" remote
                gen.Remotes.RF:InvokeServer("leave")
            end
        end
    end

    -- Return LocalPlayer to original position
    humanoidRootPart.CFrame = lastPosition
end

local function stopLayDown()
    if guiRefs.LayDownAnim then
        guiRefs.LayDownAnim:Stop()
        guiRefs.LayDownAnim = nil
    end
    if guiRefs.LayDownConnection then
        guiRefs.LayDownConnection:Disconnect()
        guiRefs.LayDownConnection = nil
    end
end

-- Frontflip implementation (preserved)
local function createFrontflip()
    return function()
        local sausageHolder
        pcall(function()
            sausageHolder = game.CoreGui.TopBarApp.TopBarApp.UnibarLeftFrame.UnibarMenu["2"]
        end)

        if not sausageHolder then
            -- If TopBar isn't available, skip creating the button but still provide the flip on keypress.
        end

        local FlipCooldown
        local function FortniteFlips()
            if FlipCooldown then
                return
            end

            FlipCooldown = true
            local character = game:GetService("Players").LocalPlayer.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
            if not hrp or not humanoid then
                FlipCooldown = false
                return
            end
            local savedTracks = {}

            if animator then
                for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                    savedTracks[#savedTracks + 1] = { track = track, time = track.TimePosition }
                    track:Stop(0)
                end
            end

            humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)

            local duration = 0.45
            local steps = 120
            local startCFrame = hrp.CFrame
            local forwardVector = startCFrame.LookVector
            local upVector = Vector3.new(0, 1, 0)
            task.spawn(function()
                local startTime = tick()
                for i = 1, steps do
                    local t = i / steps
                    local height = 4 * (t - t ^ 2) * 10
                    local nextPos = startCFrame.Position + forwardVector * (35 * t) + upVector * height
                    local rotation = startCFrame.Rotation * CFrame.Angles(-math.rad(i * (360 / steps)), 0, 0)

                    hrp.CFrame = CFrame.new(nextPos) * rotation
                    local elapsedTime = tick() - startTime
                    local expectedTime = (duration / steps) * i
                    local waitTime = expectedTime - elapsedTime
                    if waitTime > 0 then
                        task.wait(waitTime)
                    end
                end

                hrp.CFrame = CFrame.new(startCFrame.Position + forwardVector * 35) * startCFrame.Rotation
                humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
                humanoid:ChangeState(Enum.HumanoidStateType.Running)

                if animator then
                    for _, data in ipairs(savedTracks) do
                        local track = data.track
                        track:Play()
                        track.TimePosition = data.time
                    end
                end
                task.wait(0.25)
                FlipCooldown = false
            end)
        end

        -- keybind F
        UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
            if gameProcessedEvent then return end
            local focused = UserInputService:GetFocusedTextBox()
            if focused then return end
            if input.KeyCode == Enum.KeyCode.F then
                FortniteFlips()
            end
        end)

        return {
            Flip = FortniteFlips,
            SausageHolder = sausageHolder
        }
    end
end

local frontflipObj = createFrontflip()()

-- Active UI references
local FluentLoaded = false

-- Load Fluent
local success, Fluent = pcall(function()
    -- common Fluent loader; change if you have a different loader string
    return loadstring(game:HttpGet('https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua'))()
end)
if success and Fluent then
    FluentLoaded = true
else
    warn("Fluent failed to load. GUI will not appear.")
end

local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Create Fluent window & tabs if Fluent loaded
local Window, Tabs, Player, Game, Misc, Blatant, GuestSettings, CustomAnimations, Discord, Settings
if FluentLoaded then
    Window = Fluent:CreateWindow({
    	Title = "Goonsaken Hub",
    	SubTitle = "v3.0.7",
    	TabWidth = 160,
    	Size = UDim2.fromOffset(580, 460),
    	Theme = "Dark",
    	MinimizeKeyBind = Enum.KeyCode.K
	})

	Tabs = {
   		Player = Window:AddTab({ Title = "Player", Icon = "lucide-circle-user" }),
   		Game = Window:AddTab({ Title = "Game", Icon = "lucide-gamepad-2" }),
   		Misc = Window:AddTab({ Title = "Misc", Icon = "lucide-anvil" }),
   		Blatant = Window:AddTab({ Title = "Blatant", Icon = "lucide-angry" }),
   		GuestSettings = Window:AddTab({ Title = "Guest 1337 Specific", Icon = "lucide-leaf" }),
   		CustomAnimations = Window:AddTab({ Title = "Custom Animations", Icon = "lucide-person-standing" }),
		Discord = Window:AddTab({ Title = "Discord Server", Icon = "lucide-settings" }),
		Settings = Window:AddTab({ Title = "Settings", Icon = "lucide-settings" })
	}

	SaveManager:SetLibrary(Fluent)
	InterfaceManager:SetLibrary(Fluent)
	SaveManager:IgnoreThemeSettings()
	SaveManager:SetIgnoreIndexes({})
	InterfaceManager:SetFolder("GoonsakenHub")
	SaveManager:SetFolder("GoonsakenHub/Configs")
	InterfaceManager:BuildInterfaceSection(Tabs.Settings)
	SaveManager:BuildConfigSection(Tabs.Settings)

	Fluent:Notify({
		Title = "Loading...",
		Content = "the little goon minions are loading goonsaken hub!!!",
		Duration = 5,
		Image = "ban",
	})
end

local GuestSettingsOn = false
local strictRangeOn = false
local looseFacing = true
local detectionRange = 18

local predictiveBlockOn = false
local detectionRange = 10
local edgeKillerDelay = 3
local killerInRangeSince = nil
local predictiveCooldown = 0

local GuestSettingsOn = false
local flingPunchOn = false
local flingPower = 10000
local hiddenfling = false
local aimPunch = false

local customBlockEnabled = false
local customBlockAnimId = ""
local customPunchEnabled = false
local customPunchAnimId = ""

local infiniteStamina = false

local lastBlockTime = 0
local lastPunchTime = 0
local lastBlockTpTime = 0

local blockAnimIds = {
"72722244508749",
"96959123077498"
}
local punchAnimIds = {
"87259391926321"
}

local customChargeEnabled = false
local customChargeAnimId = ""
local chargeAnimIds = { "106014898528300" }

-- Stats GUI creation now (kept hidden until toggle)
statsGui = createStatsTracker()
statsGui.Enabled = false

-- Hook up Fluent controls (or fallback behavior if Fluent didn't load)
if FluentLoaded then
    -- Player Tab (Fluent version)
    Tabs.Player:AddSlider("Walkspeed", {
        Title = "Walkspeed",
        Default = 1,
        Min = 1,
        Max = 5,
        Rounding = 1,
        Suffix = "x",
        Callback = function(value)
            local char = LocalPlayer.Character
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Parent:FindFirstChild("SpeedMultipliers") then
                humanoid.Parent.SpeedMultipliers.Sprinting.Value = value
            end
        end
    })

    Tabs.Player:AddSlider("JumpPower", {
        Title = "Jump Power",
        Default = 50,
        Min = 0,
        Max = 100,
        Rounding = 0,
        Callback = function(value)
            local char = LocalPlayer.Character
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = value
            end
        end
    })

    Tabs.Player:AddToggle("Goon", {
        Title = "Goon",
        Default = false,
        Callback = function(state)
            toggles.Goon = state
            if state then
                startGoon()
            else
                stopGoon()
            end
        end
    })

    Tabs.Player:AddToggle("LayDown", {
        Title = "Lay Down",
        Default = false,
        Callback = function(state)
            toggles.LayDown = state
            if state then
                startLayDown()
            else
                stopLayDown()
            end
        end
    })

    Tabs.Player:AddButton({
        Title = "Frontflip (Key: F) (Credit to Fartsaken)",
        Callback = function()
            if frontflipObj and frontflipObj.Flip then
                frontflipObj.Flip()
            end
        end
    })

    Tabs.Player:AddToggle("AntiSlowness", {
        Title = "Anti Slowness",
        Default = false,
        Callback = function(state)
            AntiSlow = state
        end
    })

    Tabs.Player:AddButton({
        Title = "Auto 404 Parry",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/NumanTF3/auto-404-parry/refs/heads/main/main.lua"))()
        end
    })

    Tabs.Player:AddButton({
        Title = "Auto Raging Pace Parry",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/NumanTF3/auto-raging-pace/refs/heads/main/main.lua"))()
        end
    })

    Tabs.Player:AddToggle("ChanceAimbot", {
        Title = "Chance Aimbot",
        Default = false,
        Callback = function(state)
            if state then
                enableAimbot()
            else
                disableAimbot()
            end
        end
    })

	Tabs.Player:AddSlider("ChanceAimbotPredictionValue", {
        Title = "Chance Aimbot Prediction Value",
        Default = 0.2,
        Min = 0.1,
        Max = 2,
        Rounding = 1,
        Callback = function(value)
			timeAhead = value
        end
    })

    Tabs.Player:AddButton({
        Title = "Ultra Instinct (auto dodge killer)",
        Callback = function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/NumanTF3/forsaken-ultra-instinct/refs/heads/main/main.lua'))()
        end
    })

    Tabs.Player:AddButton({
        Title = "Auto Two Time Backstab and Aimbot",
        Callback = function()
			setclipboard("https://discord.gg/ETTV2g8kxS")
			Fluent:Notify({
    			Title = "TwoTime Auto Backstab",
    			Content = "Made by skibisaken. Discord link copied to clipboard!",
    			Duration = 8
			})
            loadstring(game:HttpGet('https://raw.githubusercontent.com/NumanTF3/two-time-backstab/refs/heads/main/main.lua'))()
        end
    })

    Tabs.Player:AddToggle("Invisible", {
        Title = "Invisible",
        Default = false,
        Callback = function(state)
            if state then
                Fluent:Notify({
                    Title = "Read me!",
                    Content = "The block in the middle of your screen is your LocalPlayer! it is still invisible to others. it is just to guide you where you are.",
                    Duration = 6.5,
                    Image = "lucide-leaf",
                })
            end
            ToggleInvis(state)
        end
    })

    Tabs.Player:AddToggle("Invis007n7", {
        Title = "Fully Invisible Upon Cloning (007n7)",
        Default = false,
        Callback = function(state)
            if state then
                Fluent:Notify({
                    Title = "Read me!",
                    Content = "When Cloning, The block in the middle of your screen is your LocalPlayer! it is still invisible to others. it is just to guide you where you are.",
                    Duration = 6.5,
                    Image = "lucide-leaf",
                })
            end
            handleToggle(state)
        end
    })

    Tabs.Player:AddToggle("HitboxModifier", {
        Title = "Hitbox Modifier (Credit to IYRE Reach Script)",
        Default = false,
        Callback = function(Value)
            hitboxmodificationEnabled = Value
        end
    })

    Tabs.Player:AddInput("HitboxDetectionDistance", {
        Title = "Hitbox Detection Distance",
        Default = "120",
        Placeholder = "120",
        Numeric = true,
        Callback = function(Value)
            local num = tonumber(Value)
            if num then
                MaxRange = num
            end
        end
    })

    --------------------------------------------------------------------------
    -- Game Tab
    --------------------------------------------------------------------------
    Tabs.Game:AddToggle("ESPToggle", {
        Title = "ESP",
        Default = false,
        Callback = function(state)
            toggles.ESP = state
            ESP:SetEnabled(state)
        end
    })

    Tabs.Game:AddToggle("StatsTrackerToggle", {
        Title = "Stats Tracker",
        Default = false,
        Callback = function(state)
            toggles.StatsTracker = state
            if statsGui then
                statsGui.Enabled = state
            end
        end
    })
	
    Tabs.Game:AddToggle("InfiniteStamina", {
        Title = "Infinite Stamina (ONLY WORKS ON SOME EXECUTORS)",
        Default = false,
        Callback = function(value)
            infinitestamina = value
			task.spawn(function()
            	while infinitestamina do
            	    local Sprinting = game:GetService("ReplicatedStorage").Systems.Character.Game.Sprinting
            	    local stamina = require(Sprinting)
            	    stamina.StaminaLossDisabled = true
            	    task.wait(0.5) -- adjust to avoid unnecessary performance hit
            	end

	            -- Restore default when turned off
    	        local Sprinting = game:GetService("ReplicatedStorage").Systems.Character.Game.Sprinting
    	        local stamina = require(Sprinting)
    	        stamina.StaminaLossDisabled = false
    	    end)
    	end
	})
	
    -- Auto Rejoin on Kick (default ON)
    Tabs.Game:AddToggle("AutoRejoinToggle", {
        Title = "Auto Rejoin on Kick",
        Default = true,
        Callback = function(state)
            toggles.AutoRejoinOnKick = state
            if state then
                if not activeConnections.AutoRejoin then
                    activeConnections.AutoRejoin = GuiService.ErrorMessageChanged:Connect(function(msg)
                        if msg and msg ~= "" then
                            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
                        end
                    end)
                end
            else
                if activeConnections.AutoRejoin then
                    activeConnections.AutoRejoin:Disconnect()
                    activeConnections.AutoRejoin = nil
                end
            end
        end
    })

    Tabs.Game:AddButton({
        Title = "Rejoin",
        Callback = function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
        end
    })
    
    Tabs.Game:AddToggle("autofixgen", {
        Title = "Auto Fix Generator (must be in generator)",
		Default = false,
        Callback = function(state)
			triggerNearestGenerator(state)
        end
    })

	Tabs.Game:AddSlider("OneGenSpeedValue", {
        Title = "Do Current Generator Speed",
        Default = 2.5,
        Min = 2.5,
        Max = 10,
        Rounding = 1,
        Callback = function(value)
            timeforonegen = value
        end
    })

    Tabs.Game:AddToggle("auto1x1x1x1popups", {
        Title = "Auto 1x1x1x1 Popups",
        Default = false,
        Callback = function(state)
            Do1x1PopupsLoop = state
            if state then
                task.spawn(Do1x1x1x1Popups)
            end
        end
    })
    
    --------------------------------------------------------------------------
    -- Misc Tab
    --------------------------------------------------------------------------
    Tabs.Misc:AddButton({
        Title = "Infinite Yield",
        Callback = function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
        end
    })

    Tabs.Misc:AddToggle("NameProtect", {
        Title = "NameProtect (Hides yours and everyone's username)",
        Default = false,
        Callback = function(state)
            nameprotect = state
        end
    })

    Tabs.Misc:AddKeybind("KillerEmoteKeybind", {
        Title = "Emote as Killer (Credit to Fartsaken)",
        Mode = "Always",
        Default = "L",
        Callback = function()
            local existence = PlayerGui:FindFirstChild("KillerEmoteGUI") -- SAFE check
            if existence == nil then
                KillerEmoteGUI()
            end
        end
    })

    Tabs.Misc:AddToggle("SettingsVideo", {
		Title = "ONE MORE GAME! when you pause the game",
		Default = false,
		Callback = function(state)
			if state then
				-- === Config ===
				local folderPath = "GoonsakenHub/Assets"
				local fileName = "onemoregame.webm"
				local fullPath = folderPath .. "/" .. fileName
				local videoUrl = "https://raw.githubusercontent.com/NumanTF3/Goonsaken-Hub/refs/heads/main/onemoregame.webm"

				-- Ensure folder exists
				if not isfolder("GoonsakenHub") then makefolder("GoonsakenHub") end
				if not isfolder(folderPath) then makefolder(folderPath) end

				-- Download if missing
				if not isfile(fullPath) then
					Fluent:Notify({
						Title = "Video Loader",
						Content = "Downloading video asset...",
						Duration = 5
					})

					local request = (syn and syn.request) or http_request or request
					if not request then error("Executor does not support HTTP requests.") end

					local response = request({
						Url = videoUrl,
						Method = "GET"
					})

					if response.Success and response.Body then
						writefile(fullPath, response.Body)
						Fluent:Notify({
							Title = "Video Loader",
							Content = "Video downloaded successfully!",
							Duration = 5
						})
					else
						Fluent:Notify({
							Title = "Video Loader",
							Content = "Failed to download video.",
							Duration = 5
						})
						return
					end
				else
					Fluent:Notify({
						Title = "Video Loader",
						Content = "Using cached video.",
						Duration = 5
					})
				end

				-- Asset for VideoFrame
				local videoAsset = getcustomasset(fullPath)
				local CoreGui = game:GetService("CoreGui")
				local SettingsShield = CoreGui:WaitForChild("RobloxGui")
					:WaitForChild("SettingsClippingShield")
					:WaitForChild("SettingsShield")

				local videoGui

				local function createVideo()
					if videoGui then return end
					videoGui = Instance.new("ScreenGui")
					videoGui.IgnoreGuiInset = true
					videoGui.ResetOnSpawn = false
					videoGui.Parent = PlayerGui

					local videoFrame = Instance.new("VideoFrame", videoGui)
					videoFrame.Name = "BackVideo"
					videoFrame.Size = UDim2.new(1, 0, 1, 0)
					videoFrame.Position = UDim2.new(0, 0, 0, 0)
					videoFrame.BackgroundTransparency = 1
					videoFrame.Video = videoAsset
					videoFrame.Looped = true
					videoFrame.Volume = 3
					videoFrame:Play()
				end

				local function removeVideo()
					if videoGui then
						videoGui:Destroy()
						videoGui = nil
					end
				end

				-- Monitor
				_G.SettingsVideoLoop = task.spawn(function()
					local wasVisible = SettingsShield.Visible
					while state do
						local isVisible = SettingsShield.Visible
						if isVisible and not wasVisible then
							createVideo()
						elseif not isVisible and wasVisible then
							removeVideo()
						end
						wasVisible = isVisible
						task.wait(0.1)
					end
					removeVideo()
				end)

			else
				if _G.SettingsVideoLoop then
					task.cancel(_G.SettingsVideoLoop)
					_G.SettingsVideoLoop = nil
				end
			end
		end
	})

    Tabs.Misc:AddInput("PlaySoundByID", {
        Title = "Play Sound by ID",
        Placeholder = "Enter Roblox Sound ID",
        Numeric = true,
        Callback = function(input)
            local id = tonumber(input)
            if id then
                soundPlayer.SoundId = "rbxassetid://" .. id
                soundPlayer:Play()
            else
                warn("Invalid Sound ID: " .. tostring(input))
            end
        end
    })

    Tabs.Misc:AddDropdown("ChangeLMSSong", {
        Title = "Change LMS Song",
        Values = {
            "Burnout", "Compass", "Vanity", "Close To Me", "Plead",
            "Creation Of Hatred"
        },
        Multi = false,
        Default = 1,
        Callback = function(Value)
            selectedSong = Value
            print("Selected LMS song:", selectedSong)
        end
    })

    Tabs.Misc:AddButton({
        Title = "Replace LMS Song",
        Callback = function()
            print("Waiting for Workspace.Themes.LastSurvivor to exist...")
            local theme = game.Workspace:WaitForChild("Themes", 99999)
            if not theme then return end
            local lastSurvivor = theme:WaitForChild("LastSurvivor", 60)
            if not lastSurvivor then return end
            local songId = LMSSongs[selectedSong]
            if songId then
                lastSurvivor.SoundId = songId
                lastSurvivor:Play()
                print("Changed LMS song to:", selectedSong)
            else
                warn("Invalid song name:", tostring(selectedSong))
            end
        end
    })
    --------------------------------------------------------------------------
    -- Blatant Tab
    --------------------------------------------------------------------------
    Tabs.Blatant:AddButton({
        Title = "Do All Generators",
        Callback = function()
            generatorDoAll()
        end
    })

    Tabs.Blatant:AddSlider("GenSpeedValue", {
        Title = "Do All Generator Speed",
        Default = 3,
        Min = 3,
        Max = 10,
        Rounding = 1,
        Callback = function(value)
            timebetweenpuzzles = value
        end
    })

    --------------------------------------------------------------------------
    -- Auto Block Tab
    --------------------------------------------------------------------------
	Tabs.GuestSettings:AddParagraph({
        Title = "Credit To Skibisaken",
        Content = "this entire tab is from the skibisaken script so join their discord at https://discord.gg/ETTV2g8kxS"
    })

	Tabs.GuestSettings:AddToggle("ChargeSpeedToggle", {
        Title = "Custom Charge Speed",
        Default = false,
        Callback = function(Value)
            ChargeSpeedLoop = Value
        end
    })

	Tabs.GuestSettings:AddSlider("GuestChargeSpeed", {
        Title = "Charge Speed (changes ur guest charging speed)",
        Default = 2.833,
        Min = 2.833,
        Max = 15,
        Rounding = 1,
        Callback = function(Value)
            GuestChargeSpeed = Value
        end
    })

    Tabs.GuestSettings:AddToggle("GuestSettingsToggle", {
        Title = "Auto Block",
        Default = false,
        Callback = function(Value)
            GuestSettingsOn = Value
        end
    })

    Tabs.GuestSettings:AddToggle("StrictRangeToggle", {
        Title = "Strict Range",
        Default = false,
        Callback = function(Value)
            strictRangeOn = Value
        end
    })

    Tabs.GuestSettings:AddDropdown("FacingCheckDropdown", {
        Title = "Facing Check",
        Values = { "Loose", "Strict" },
        Multi = false,
        Default = "Loose",
        Callback = function(Option)
            looseFacing = Option == "Loose"
        end
    })

    Tabs.GuestSettings:AddInput("DetectionRangeInput", {
        Title = "Detection Range",
        Placeholder = "18",
        Numeric = true,
        Callback = function(Text)
            detectionRange = tonumber(Text) or detectionRange
        end
    })

    Tabs.GuestSettings:AddParagraph({
        Title = "⚠️ Warning",
        Content = "plz do not use blocktp with fake block or disaster strucks"
    })

    Tabs.GuestSettings:AddParagraph({
        Title = "",
        Content = "increase range so block tp works better (30 studs recommended)"
    })

    Tabs.GuestSettings:AddToggle("BlockTPToggle", {
        Title = "Block TP",
        Default = false,
        Callback = function(Value)
            blockTPEnabled = Value
        end
    })

    --------------------------------------------------------------------------
    -- Predictive Auto Block Tab
    --------------------------------------------------------------------------
    Tabs.GuestSettings:AddToggle("PredictiveBlockToggle", {
        Title = "Predictive Auto Block",
        Default = false,
        Callback = function(Value)
            predictiveBlockOn = Value
        end
    })

    Tabs.GuestSettings:AddInput("PredictiveDetectionRange", {
        Title = "Detection Range",
        Placeholder = "10",
        Numeric = true,
        Callback = function(text)
            local num = tonumber(text)
            if num then
                detectionRange = num
            end
        end
    })

    Tabs.GuestSettings:AddSlider("EdgeKillerSlider", {
        Title = "Edge Killer",
        Default = 3,
        Min = 0,
        Max = 7,
        Rounding = 1,
        Callback = function(val)
            edgeKillerDelay = val
        end
    })

	Tabs.GuestSettings:AddParagraph({
        Title = "Edge Killer",
        Content = "How many seconds until it blocks (to counter smartass LocalPlayers) (resets when killer gets out of range)"
    })

    --------------------------------------------------------------------------
    -- Fake Block Tab
    --------------------------------------------------------------------------
    Tabs.GuestSettings:AddButton({
        Title = "Load Fake Block",
        Callback = function()
            pcall(function()
                local fakeGui = PlayerGui:FindFirstChild("FakeBlockGui")
                if not fakeGui then
                    local success, result = pcall(function()
                        return loadstring(game:HttpGet("https://pastebin.com/raw/ztnYv27k"))()
                    end)
                    if not success then
                        warn("❌ Failed to load Fake Block GUI:", result)
                    end
                else
                    fakeGui.Enabled = true
                    print("✅ Fake Block GUI enabled")
                end
            end)
        end
    })

    --------------------------------------------------------------------------
    -- Auto Punch Tab
    --------------------------------------------------------------------------
    Tabs.GuestSettings:AddToggle("GuestSettingsToggle", {
        Title = "Auto Punch",
        Default = false,
        Callback = function(Value)
            GuestSettingsOn = Value
        end
    })

    Tabs.GuestSettings:AddToggle("FlingPunchToggle", {
        Title = "Fling Punch",
        Default = false,
        Callback = function(Value)
            flingPunchOn = Value
        end
    })

    Tabs.GuestSettings:AddToggle("PunchAimbotToggle", {
        Title = "Punch Aimbot",
        Default = false,
        Callback = function(Value)
            aimPunch = Value
        end
    })

    local predictionValue = 4
    Tabs.GuestSettings:AddSlider("AimPredictionSlider", {
        Title = "Aim Prediction",
        Default = predictionValue,
        Min = 0,
        Max = 10,
        Rounding = 1,
        Suffix = "studs",
        Callback = function(Value)
            predictionValue = Value
        end
    })

    Tabs.GuestSettings:AddSlider("FlingPowerSlider", {
        Title = "Fling Power",
        Default = 10000,
        Min = 5000,
        Max = 50000000000000,
        Rounding = 0,
        Callback = function(Value)
            flingPower = Value
        end
    })

    --------------------------------------------------------------------------
    -- Custom Animations Tab
    --------------------------------------------------------------------------
    Tabs.CustomAnimations:AddInput("CustomBlockAnim", {
        Title = "Custom Block Animation",
        Placeholder = "AnimationId",
        Callback = function(Text)
            customBlockAnimId = Text
        end
    })

    Tabs.CustomAnimations:AddToggle("EnableCustomBlockAnim", {
        Title = "Enable Custom Block Animation",
        Default = false,
        Callback = function(Value)
            customBlockEnabled = Value
        end
    })

    Tabs.CustomAnimations:AddInput("CustomPunchAnim", {
        Title = "Custom Punch Animation",
        Placeholder = "AnimationId",
        Callback = function(Text)
            customPunchAnimId = Text
        end
    })

    Tabs.CustomAnimations:AddToggle("EnableCustomPunchAnim", {
        Title = "Enable Custom Punch Animation",
        Default = false,
        Callback = function(Value)
            customPunchEnabled = Value
        end
    })

    Tabs.CustomAnimations:AddInput("ChargeAnimID", {
        Title = "Charge Animation ID",
        Placeholder = "Put animation ID here",
        Callback = function(input)
            customChargeAnimId = input
        end
    })

    Tabs.CustomAnimations:AddToggle("EnableCustomChargeAnim", {
        Title = "Custom Charge Animation",
        Default = false,
        Callback = function(value)
            customChargeEnabled = value
        end
    })

	Tabs.Discord:AddButton({
        Title = "Copy Discord Invite Link",
        Callback = function()
			setclipboard("https://discord.gg/aXNagEYb2f")
			Fluent:Notify({
    			Title = "Copied Discord Invite Link!",
    			Content = "Discord link copied to clipboard!",
    			Duration = 8
			})
        end
    })
else
	-- Fluent not loaded fallback: wire minimal keybinds and defaults
    warn("Fluent not loaded; GUI controls unavailable. Core features remain active via defaults where possible.")
end

-- Ensure AutoRejoin default ON (original script created a connection by default)
if not activeConnections.AutoRejoin and toggles.AutoRejoinOnKick then
    activeConnections.AutoRejoin = GuiService.ErrorMessageChanged:Connect(function(msg)
        if msg and msg ~= "" then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
        end
    end)
end

-- Initially disable ESP visuals (kept behavior)
ESP:SetEnabled(false)

print("Goonsaken Hub by NumanTF2")

local AttackAnimations = {
	"rbxassetid://131430497821198", "rbxassetid://83829782357897", "rbxassetid://126830014841198",
	"rbxassetid://126355327951215", "rbxassetid://121086746534252", "rbxassetid://105458270463374",
	"rbxassetid://127172483138092", "rbxassetid://18885919947", "rbxassetid://18885909645",
	"rbxassetid://87259391926321", "rbxassetid://106014898528300", "rbxassetid://86545133269813",
	"rbxassetid://89448354637442", "rbxassetid://90499469533503", "rbxassetid://116618003477002",
	"rbxassetid://106086955212611", "rbxassetid://107640065977686", "rbxassetid://77124578197357",
	"rbxassetid://101771617803133", "rbxassetid://134958187822107", "rbxassetid://111313169447787",
	"rbxassetid://71685573690338", "rbxassetid://129843313690921", "rbxassetid://97623143664485",
	"rbxassetid://136007065400978", "rbxassetid://86096387000557", "rbxassetid://108807732150251",
	"rbxassetid://138040001965654", "rbxassetid://73502073176819", "rbxassetid://86709774283672",
	"rbxassetid://140703210927645", "rbxassetid://96173857867228", "rbxassetid://121255898612475",
	"rbxassetid://98031287364865", "rbxassetid://119462383658044", "rbxassetid://77448521277146",
	"rbxassetid://103741352379819", "rbxassetid://131696603025265", "rbxassetid://122503338277352",
	"rbxassetid://97648548303678", "rbxassetid://94162446513587", "rbxassetid://84426150435898",
	"rbxassetid://93069721274110", "rbxassetid://114620047310688", "rbxassetid://97433060861952",
	"rbxassetid://82183356141401", "rbxassetid://100592913030351", "rbxassetid://121293883585738",
	"rbxassetid://70447634862911", "rbxassetid://92173139187970", "rbxassetid://106847695270773",
	"rbxassetid://125403313786645", "rbxassetid://81639435858902", "rbxassetid://137314737492715",
	"rbxassetid://120112897026015", "rbxassetid://82113744478546", "rbxassetid://118298475669935",
	"rbxassetid://126681776859538", "rbxassetid://129976080405072", "rbxassetid://109667959938617",
	"rbxassetid://74707328554358", "rbxassetid://133336594357903", "rbxassetid://86204001129974",
	"rbxassetid://124243639579224", "rbxassetid://70371667919898", "rbxassetid://131543461321709",
	"rbxassetid://136323728355613", "rbxassetid://109230267448394"
}

-- Helpers
local function fireRemoteBlock()
	local args = {"UseActorAbility", "Block"}
	ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
end

local function isFacing(localRoot, targetRoot)
    if not facingCheckEnabled then
        return true
    end
    if not localRoot or not targetRoot then
        return false
    end

    local offset = localRoot.Position - targetRoot.Position
    if offset.Magnitude == 0 then
        return false -- same position, can't determine facing
    end

    local dir = offset.Unit
    local dot = targetRoot.CFrame.LookVector:Dot(dir)

    if looseFacing then
        return dot > -0.3
    else
        return dot > 0
    end
end

local function playCustomAnim(animId, isPunch)
    if not Humanoid then
        warn("Humanoid missing")
        return
    end

    if not animId or animId == "" then
        warn("No animation ID provided")
        return
    end

    local now = tick()
    local lastTime = isPunch and lastPunchTime or lastBlockTime
    if now - lastTime < 1 then
        return
    end

    -- Stop other known anims
    for _, track in ipairs(Humanoid:GetPlayingAnimationTracks()) do
        local animNum = tostring(track.Animation.AnimationId):match("%d+")
        if table.find(isPunch and punchAnimIds or blockAnimIds, animNum) then
            track:Stop()
        end
    end

    -- Create and load the animation
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://" .. animId

    local success, track = pcall(function()
        return Humanoid:LoadAnimation(anim)
    end)

    if success and track then
        print("✅ Playing custom " .. (isPunch and "punch" or "block") .. " animation:", animId)
        track:Play()
        if isPunch then
            lastPunchTime = now
        else
            lastBlockTime = now
        end
    else
        warn("❌ Failed to load or play custom animation: " .. animId)
    end
end

track(runEvery(0.1, function()
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local Humanoid = Character:FindFirstChild("Humanoid") or Character:WaitForChild("Humanoid")
    local Animator = Humanoid:FindFirstChild("Animator") or Humanoid:WaitForChild("Animator")
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") or Character:WaitForChild("HumanoidRootPart")
end)

coroutine.wrap(function()
    local hrp, c, vel, movel = nil, nil, nil, 0.1
    while true do
        RunService.Heartbeat:Wait()
        if hiddenfling then
            while hiddenfling and not (c and c.Parent and hrp and hrp.Parent) do
                RunService.Heartbeat:Wait()
                c = LocalPlayer.Character
                hrp = c and c:FindFirstChild("HumanoidRootPart")
            end
            if hiddenfling then
                vel = hrp.Velocity
                hrp.Velocity = vel * flingPower + Vector3.new(0, flingPower, 0)
                RunService.RenderStepped:Wait()
                hrp.Velocity = vel
                RunService.Stepped:Wait()
                hrp.Velocity = vel + Vector3.new(0, movel, 0)
                movel = movel * -1
            end
        end
    end
end)()

-- auto block loop
RunService.RenderStepped:Connect(function()
    local myChar = LocalPlayer.Character
    if not myChar then return end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    Humanoid = myChar:FindFirstChildOfClass("Humanoid")
        -- Auto Block: Trigger block if a valid animation is played by a killer
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= lp and plr.Character then
			if not game.Players:GetPlayerFromCharacter(plr.Character) then return end
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local animTracks = hum and hum:FindFirstChildOfClass("Animator") and hum:FindFirstChildOfClass("Animator"):GetPlayingAnimationTracks()

            if hrp and myRoot and (hrp.Position - myRoot.Position).Magnitude <= detectionRange then
                for _, track in ipairs(animTracks or {}) do
                    local id = tostring(track.Animation.AnimationId):match("%d+")
                    if table.find(GuestSettingsTriggerAnims, id) then
                        if GuestSettingsOn and (not strictRangeOn or (hrp.Position - myRoot.Position).Magnitude <= detectionRange) then
                            if isFacing(myRoot, hrp) then
                                fireRemoteBlock()
                                if customBlockEnabled and customBlockAnimId ~= "" then
                                    playCustomAnim(customBlockAnimId, false)
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    -- Detect if LocalPlayer is playing a block animation, and blockTP is enabled
    if blockTPEnabled and Humanoid and tick() - lastBlockTpTime >= 5 then
        for _, track in ipairs(Humanoid:GetPlayingAnimationTracks()) do
            local animId = tostring(track.Animation.AnimationId):match("%d+")
            if animId == "72722244508749" or animId == "96959123077498" then
                local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if myRoot then
                    local killers = {"c00lkidd", "Jason", "JohnDoe", "1x1x1x1", "Noli"}
                    for _, name in ipairs(killers) do
                        local killer = workspace:FindFirstChild("Players")
                            and workspace.Players:FindFirstChild("Killers")
                            and workspace.Players.Killers:FindFirstChild(name)

						if not game.Players:GetPlayerFromCharacter(killer) then return end

                        if killer and killer:FindFirstChild("HumanoidRootPart") then
                            lastBlockTpTime = tick()

                            task.spawn(function()
                                local startTime = tick()
                                while tick() - startTime < 0.5 do
                                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                        local myRoot = LocalPlayer.Character.HumanoidRootPart
                                        local targetHRP = killer.HumanoidRootPart
                                        local direction = targetHRP.CFrame.LookVector
                                        local tpPosition = targetHRP.Position + direction * 6
                                        myRoot.CFrame = CFrame.new(tpPosition)
                                    end
                                    task.wait()
                                end
                            end)

                            break
                        end
                    end
                end
                break
            end
        end
    end

    -- Predictive Auto Block: Check killer range and time
    if predictiveBlockOn and tick() > predictiveCooldown then
        local killersFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Killers")
        local myChar = LocalPlayer.Character
        local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local myHum = myChar and myChar:FindFirstChild("Humanoid")

        if killersFolder and myHRP and myHum then
            local killerInRange = false

            for _, killer in ipairs(killersFolder:GetChildren()) do
	            if not game.Players:GetPlayerFromCharacter(killer) then
                	continue
            	end
                local hrp = killer:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (myHRP.Position - hrp.Position).Magnitude
                    if dist <= detectionRange then
                        killerInRange = true
                        break
                    end
                end
            end

            -- Handle killer entering range
            if killerInRange then
                if not killerInRangeSince then
                    killerInRangeSince = tick()  -- Start the timer when the killer enters the range
                elseif tick() - killerInRangeSince >= edgeKillerDelay then
                    -- Block if the killer has stayed in range long enough
                    fireRemoteBlock()
                    predictiveCooldown = tick() + 2  -- Set cooldown to avoid blocking too quickly again
                    killerInRangeSince = nil  -- Reset the timer
                end
            else
                killerInRangeSince = nil  -- Reset timer if the killer leaves range
            end
        end
    end



    -- Auto Punch
    if GuestSettingsOn then
        local gui = PlayerGui:FindFirstChild("MainUI")
        local punchBtn = gui and gui:FindFirstChild("AbilityContainer") and gui.AbilityContainer:FindFirstChild("Punch")
        local charges = punchBtn and punchBtn:FindFirstChild("Charges")

        if charges and charges.Text == "1" then
            local killerNames = {"c00lkidd", "Jason", "JohnDoe", "1x1x1x1", "Noli"}
            for _, name in ipairs(killerNames) do
                local killer = workspace:FindFirstChild("Players")
                    and workspace.Players:FindFirstChild("Killers")
                    and workspace.Players.Killers:FindFirstChild(name)

				if not game.Players:GetPlayerFromCharacter(killer) then return end

                if killer and killer:FindFirstChild("HumanoidRootPart") then
                    local root = killer.HumanoidRootPart
                    local myChar = LocalPlayer.Character
                    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                    if root and myRoot and (root.Position - myRoot.Position).Magnitude <= 10 then
						
                        -- Aim Punch: Constant look at killer with prediction
						if aimPunch then
							local humanoid = myChar:FindFirstChild("Humanoid")
							if humanoid then
								humanoid.AutoRotate = false
							end

							task.spawn(function()
								local start = tick()
								while tick() - start < 2 do
									local myRootNow = myChar:FindFirstChild("HumanoidRootPart")
									local targetRoot = root 
										and root.Parent 
										and root.Parent:FindFirstChild("HumanoidRootPart")

									if myRootNow and targetRoot then
										local predictedPos = targetRoot.Position + (targetRoot.CFrame.LookVector * predictionValue)
										myRootNow.CFrame = CFrame.lookAt(
											myRootNow.Position, 
											predictedPos
										)
									end
									task.wait()
								end

								if humanoid and humanoid.Parent then
									humanoid.AutoRotate = true
								end
							end)
						end

                        -- Trigger punch GUI button
                        for _, conn in ipairs(getconnections(punchBtn.MouseButton1Click)) do
                            pcall(function()
                                conn:Fire()
                            end)
                        end

                        -- Fling Punch: Constant TP 2 studs in front of killer for 1 second
                        if flingPunchOn then
                            hiddenfling = true
                            local targetHRP = root
                            task.spawn(function()
                                local start = tick()
                                while tick() - start < 1 do
                                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and targetHRP and targetHRP.Parent then
                                        local frontPos = targetHRP.Position + (targetHRP.CFrame.LookVector * 2)
                                        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(frontPos, targetHRP.Position)
                                    end
                                    task.wait()
                                end
                                hiddenfling = false
                            end)
                        end

                        -- Play custom punch animation if enabled
                        if customPunchEnabled and customPunchAnimId ~= "" then
                            playCustomAnim(customPunchAnimId, true)
                        end

                        break -- Only punch one killer per frame
                    end
                end
            end
        end
    end

end)

-- Cooldown tracking for each replacement type
local lastReplaceTime = {
    block = 0,
    punch = 0,
    charge = 0,
}

-- Continuous custom animation replacer (runs forever if toggled on)
task.spawn(function()
    while true do
        RunService.Heartbeat:Wait()

        local char = LocalPlayer.Character
        if not char then continue end

        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
        if not animator then continue end

        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            local animId = tostring(track.Animation.AnimationId):match("%d+")

            -- Block animation replacement
            if customBlockEnabled and customBlockAnimId ~= "" and table.find(blockAnimIds, animId) then
                if tick() - lastReplaceTime.block >= 3 then
                    lastReplaceTime.block = tick()
                    track:Stop()
                    local newAnim = Instance.new("Animation")
                    newAnim.AnimationId = "rbxassetid://" .. customBlockAnimId
                    local newTrack = animator:LoadAnimation(newAnim)
                    newTrack:Play()
                    break
                end
            end

            -- Punch animation replacement
            if customPunchEnabled and customPunchAnimId ~= "" and table.find(punchAnimIds, animId) then
                if tick() - lastReplaceTime.punch >= 3 then
                    lastReplaceTime.punch = tick()
                    track:Stop()
                    local newAnim = Instance.new("Animation")
                    newAnim.AnimationId = "rbxassetid://" .. customPunchAnimId
                    local newTrack = animator:LoadAnimation(newAnim)
                    newTrack:Play()
                    break
                end
            end

            -- Charge animation replacement
            if customChargeEnabled and customChargeAnimId ~= "" and table.find(chargeAnimIds, animId) then
                if tick() - lastReplaceTime.charge >= 3 then
                    lastReplaceTime.charge = tick()
                    track:Stop()
                    local newAnim = Instance.new("Animation")
                    newAnim.AnimationId = "rbxassetid://" .. customChargeAnimId
                    local newTrack = animator:LoadAnimation(newAnim)
                    newTrack:Play()
                    break
                end
            end
        end
    end
end)

--// Hitbox ride logic
RunService.Heartbeat:Connect(function()
	if not hitboxmodificationEnabled then return end
	if not HumanoidRootPart then return end

	local playing = false
	for _, track in ipairs(Humanoid:GetPlayingAnimationTracks()) do
		if table.find(AttackAnimations, track.Animation.AnimationId)
			and (track.TimePosition / track.Length < 0.75) then
			playing = true
			break
		end
	end

	if not playing then return end

	local Target
	local NearestDist = MaxRange

	local function scanGroup(group)
		for _, obj in ipairs(group) do
			if obj == Character or not obj:FindFirstChild("HumanoidRootPart") then continue end
			local dist = (obj.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude
			if dist < NearestDist then
				NearestDist = dist
				Target = obj
			end
		end
	end

	scanGroup(workspace.Players:GetDescendants())
	local npcs = workspace:FindFirstChild("Map", true) and workspace.Map:FindFirstChild("NPCs", true)
	if npcs then
		scanGroup(npcs:GetChildren())
	end

	if not Target then return end

	local ping = LocalPlayer:GetNetworkPing()
	local randomOffset = Vector3.new(RNG:NextNumber(-1.5, 1.5), 0, RNG:NextNumber(-1.5, 1.5))
	local predicted = Target.HumanoidRootPart.Position + randomOffset + (Target.HumanoidRootPart.Velocity * (ping * 1.25))
	local neededVelocity = (predicted - HumanoidRootPart.Position) / (ping * 2)

	local oldVelocity = HumanoidRootPart.Velocity
	HumanoidRootPart.Velocity = neededVelocity
	RunService.RenderStepped:Wait()
	HumanoidRootPart.Velocity = oldVelocity
end)

track(runEvery(0.05, function()
    if AntiSlow then
        checkAndSetSlowStatus()
        enforceMultipliers()
    end
end)

-- Select the first tab on load
Window:SelectTab("Player")

-- Notify when loaded
Fluent:Notify({
    Title = "Goonsaken Hub",
    Content = "time to goon!!!",
    Duration = 8
})

Fluent:Notify({
    Title = "IMPORTANT!!!",
    Content = "Go to Settings, click minimize keybind and then click the cat button top left and save it as a config along with ur other cheat settings and autoload it!!! otherwise no toggling gui",
    Duration = 15
})


local hubLoaded = true

local toggleHolder = game.CoreGui.TopBarApp.TopBarApp.UnibarLeftFrame.UnibarMenu["2"]
local originalSize = toggleHolder.Size.X.Offset
local sSize = UDim2.new(0, originalSize + 48, 0, toggleHolder.Size.Y.Offset)

-- Create button frame inside toggleHolder
local buttonFrame = Instance.new("Frame")
buttonFrame.Size = UDim2.new(0, 48, 0, 44)
buttonFrame.BackgroundTransparency = 1
buttonFrame.BorderSizePixel = 0
buttonFrame.Position = UDim2.new(0, toggleHolder.Size.X.Offset - 48, 0, 0)
buttonFrame.Parent = toggleHolder

-- Create the image button inside buttonFrame
local imageButton = Instance.new("ImageButton")
imageButton.BackgroundTransparency = 1
imageButton.BorderSizePixel = 0
imageButton.Size = UDim2.new(0, 36, 0, 36)
imageButton.AnchorPoint = Vector2.new(0.5, 0.5)
imageButton.Position = UDim2.new(0.5, 0, 0.5, 0)
imageButton.Image = "http://www.roblox.com/asset/?id=10385136549"  -- Your icon ID here
imageButton.Parent = buttonFrame

-- Function to toggle Goonsaken Hub GUI frame visibility
local function toggleGoonsakenHub()
	VIM:SendKeyEvent(true, Enum.KeyCode.L, false, game)
	task.wait(0.1)
	VIM:SendKeyEvent(false, Enum.KeyCode.L, false, game)
end


-- Connect button activation to toggle function
imageButton.Activated:Connect(toggleGoonsakenHub)

-- Adjust toggleHolder size and button position every frame (to keep in sync)
while task.wait(0.03) do
    toggleHolder.Size = sSize
    buttonFrame.Position = UDim2.new(0, toggleHolder.Size.X.Offset - 48, 0, 0)
end

SaveManager:LoadAutoloadConfig()

track(runEvery(0.05, function()
	if ChargeSpeedLoop == true then
		GuestChargeCustomSpeed()
	end
end)

local Sprinting
local stamina

track(runEvery(0.1, function()
    if infinitestamina and not Sprinting and not stamina then
        Sprinting = game:GetService("ReplicatedStorage").Systems.Character.Game.Sprinting
        stamina = require(Sprinting)
    end

    if infinitestamina and stamina then
        stamina.StaminaLossDisabled = true
    elseif Sprinting and stamina then
        stamina.StaminaLossDisabled = false
    end
end)

RunService.RenderStepped:Connect(NameProtect)






