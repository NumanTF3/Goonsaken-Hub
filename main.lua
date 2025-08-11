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
local nameprotectEnabled = false

LocalPlayer.CharacterAdded:Connect(function(char)
	Character = char
	Humanoid = char:WaitForChild("Humanoid")
	Animator = Humanoid:WaitForChild("Animator")
	HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
end)

local function Do1x1x1x1Popups()
	while true do
		if Do1x1PopupsLoop then
			local player = game:GetService("Players").LocalPlayer
			local popups = player.PlayerGui.TemporaryUI:GetChildren()
			
			for _, i in ipairs(popups) do
				if i.Name == "1x1x1x1Popup" then
					local centerX = i.AbsolutePosition.X + (i.AbsoluteSize.X / 2)
					local centerY = i.AbsolutePosition.Y + (i.AbsoluteSize.Y / 2) + 50
					VIM:SendMouseButtonEvent(
						centerX,
						centerY,
						Enum.UserInputType.MouseButton1.Value,
						true,
						player.PlayerGui,
						1
					)
					VIM:SendMouseButtonEvent(
						centerX,
						centerY,
						Enum.UserInputType.MouseButton1.Value,
						false,
						player.PlayerGui,
						1
					)
				end
			end
		end
		task.wait(0.1)
	end
end

local existence
local animTrack
local running = false
local timebetweenpuzzles = 3.5

local MaxRange = 120
local hitboxmodificationEnabled = false

local function ToggleInvis(enabled)
    local character = LocalPlayer.Character or player.CharacterAdded:Wait()
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
                local character = LocalPlayer.Character or player.CharacterAdded:Wait()
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
    local character = LocalPlayer.Character or player.CharacterAdded:Wait()
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
                local character = LocalPlayer.Character or player.CharacterAdded:Wait()
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

local autoBlockTriggerAnims = {
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
local AutoBlockLoop -- will hold the connection

local function getKillerActiveTriggerAnim(killer)
    local hum = killer:FindFirstChildWhichIsA("Humanoid")
    if hum and hum:FindFirstChild("Animator") then
        for _, track in ipairs(hum.Animator:GetPlayingAnimationTracks()) do
            local animId = track.Animation.AnimationId
            for _, id in ipairs(autoBlockTriggerAnims) do
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

local function startAutoBlock(skibiditoilet)
    if skibiditoilet then return end -- Already running

    AutoBlockLoop = RunService.RenderStepped:Connect(function()
        local char = localPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end

        for _, killer in ipairs(workspace.Players.Killers:GetChildren()) do
            if killer:IsA("Model") and killer:FindFirstChild("HumanoidRootPart") then
                local activeAnim = getKillerActiveTriggerAnim(killer)

                if activeAnim then
                    if blockingKillers[killer] ~= activeAnim then
                        if getPunchCharges() == "0" then
                            blockingKillers[killer] = activeAnim
                            local originalCF = char.HumanoidRootPart.CFrame

                            -- Fire block
                            ReplicatedStorage.Modules.Network.RemoteEvent:FireServer("UseActorAbility", "Block")

                            -- Teleport in front of killer
                            local killerHRP = killer.HumanoidRootPart
                            local forwardOffset = killerHRP.CFrame.LookVector * 2
                            char.HumanoidRootPart.CFrame = CFrame.new(killerHRP.Position + forwardOffset)

                            -- Keep teleporting in front until animation ends or punch charge = "1"
                            task.spawn(function()
                                while true do
                                    task.wait(0.05)
                                    if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                        localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(killerHRP.Position + killerHRP.CFrame.LookVector * 2)
                                    end

                                    local charges = getPunchCharges()
                                    if charges == "1" then
                                        if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                            localPlayer.Character.HumanoidRootPart.CFrame = originalCF
                                        end
                                        blockingKillers[killer] = nil
                                        break
                                    end

                                    local currentAnim = getKillerActiveTriggerAnim(killer)
                                    if currentAnim ~= activeAnim then
                                        if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                            localPlayer.Character.HumanoidRootPart.CFrame = originalCF
                                        end
                                        blockingKillers[killer] = nil
                                        break
                                    end
                                end
                            end)
                        end
                    end
                else
                    blockingKillers[killer] = nil
                end
            end
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
			local player = game:GetService("Players").LocalPlayer
			local emotes = player:FindFirstChild("PlayerData")
					and player.PlayerData:FindFirstChild("Equipped")
					and player.PlayerData.Equipped:FindFirstChild("Emotes")
					and player.PlayerData.Equipped.Emotes.Value
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

    local playerRoot = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not playerRoot then return nil end

    local nearestGen = nil
    local nearestDist = math.huge

    for _, gen in pairs(generators) do
        local genRoot = gen:FindFirstChild("HumanoidRootPart") or gen.PrimaryPart
        if genRoot then
            local dist = (genRoot.Position - playerRoot.Position).Magnitude
            if dist < nearestDist then
                nearestDist = dist
                nearestGen = gen
            end
        end
    end

    return nearestGen
end

local function triggerNearestGenerator()
    local gen = findNearestGenerator()
    if gen and gen:FindFirstChild("Remotes") and gen.Remotes:FindFirstChild("RE") then
        task.wait(5)
		gen.Remotes.RE:FireServer()
        print("Triggered generator:", gen.Name)
    else
        print("No generator or remote found!")
    end
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
                                rootPart.CFrame = CFrame.new(rootPart.Position, predictedPos)
                            end
                        end
                    end
                end
            end
        end
    end)
end

-- Disable aimbot function
local function disableAimbot()
    if aimbotConnection then
        aimbotConnection:Disconnect()
        aimbotConnection = nil
    end
end

local COLOR_SURVIVOR = Color3.fromRGB(0, 255, 0)
local COLOR_KILLER = Color3.fromRGB(255, 0, 0)
local COLOR_MEDKIT = Color3.fromRGB(0, 255, 0)
local COLOR_COLA = Color3.fromRGB(0, 150, 255)
local COLOR_GENERATOR = Color3.fromRGB(255, 255, 0)

-- Store all highlights to toggle visibility
local allHighlights = {}

local function setHighlightVisibility(highlight, visible)
    if visible then
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
    else
        highlight.FillTransparency = 1
        highlight.OutlineTransparency = 1
    end
end

-- Player ESP
local PlayersFolder = Workspace:WaitForChild("Players")

local function applyPlayerESP(character, color)
    if not character:IsA("Model") then return end
    if character:FindFirstChild(PLAYER_ESP_NAME) then return end

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
	textLabel.Text = character.Name
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

-- Main loops (preserved)
RunService.Heartbeat:Connect(function()
    local survivors = PlayersFolder:FindFirstChild("Survivors")
    local killers = PlayersFolder:FindFirstChild("Killers")

    if survivors then
        for _, char in ipairs(survivors:GetChildren()) do
            applyPlayerESP(char, COLOR_SURVIVOR)
        end
    end

    if killers then
        for _, char in ipairs(killers:GetChildren()) do
            applyPlayerESP(char, COLOR_KILLER)
        end
    end
end)

-- Item ESP initial scan
for _, tool in ipairs(Workspace:GetDescendants()) do
    highlightToolIfNeeded(tool)
end

-- Item ESP listen for new tools
Workspace.DescendantAdded:Connect(function(descendant)
    highlightToolIfNeeded(descendant)
end)

-- Generator ESP loop (preserved)
RunService.Heartbeat:Connect(function()
    coroutine.wrap(function()
        local mapContainer
        -- maintain chat window behaviour from original
        local ok, textChat = pcall(function() return game:GetService("TextChatService") end)
        if ok and textChat and textChat.ChatWindowConfiguration then
            textChat.ChatWindowConfiguration.Enabled = true
        end

        repeat
            mapContainer = Workspace:FindFirstChild("Map")
            if mapContainer then
                mapContainer = mapContainer:FindFirstChild("Ingame")
                if mapContainer then
                    mapContainer = mapContainer:FindFirstChild("Map")
                end
            end
            task.wait(1)
        until mapContainer

        task.wait(1)

        for _, gen in ipairs(mapContainer:GetChildren()) do
            if gen.Name == "Generator" and gen:IsA("Model") then
                trackGenerator(gen)
            end
        end
    end)()
end)

-- Function to toggle ESP on/off
function ESP:SetEnabled(state)
    ESP.Enabled = state
    for highlight,_ in pairs(allHighlights) do
        setHighlightVisibility(highlight, state)
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

    local function createPlayerRow(player)
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
        button.LayoutOrder = player.UserId
        button.Parent = scrollFrame

        button.MouseButton1Click:Connect(function()
            local timeValue = player:FindFirstChild("PlayerData")
                and player.PlayerData:FindFirstChild("Stats")
                and player.PlayerData.Stats:FindFirstChild("General")
                and player.PlayerData.Stats.General:FindFirstChild("TimePlayed")

            local timeText = timeValue and formatTime(timeValue.Value) or "N/A"
            if setclipboard then
                setclipboard(player.Name .. " - " .. timeText)
            end
        end)

        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not player:IsDescendantOf(Players) then
                button:Destroy()
                if connection then connection:Disconnect() end
                return
            end

            local stats = player:FindFirstChild("PlayerData") and player.PlayerData:FindFirstChild("Stats")
            local general = stats and stats:FindFirstChild("General")
            local killer = stats and stats:FindFirstChild("KillerStats")
            local survivor = stats and stats:FindFirstChild("SurvivorStats")
            local equipped = player:FindFirstChild("PlayerData") and player.PlayerData:FindFirstChild("Equipped")

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
                player.Name,
                timeText,
                sw, sl,
                kw, kl, killCount,
                emoteText
            )
        end)
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            createPlayerRow(player)
        end
    end

    Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer then
            createPlayerRow(player)
        end
    end)

    RunService.RenderStepped:Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
    end)

    return screenGui
end

-- Default toggles and helpers (we will hook these to Rayfield UI)
local toggles = {
    StatsTracker = false,
    ESP = false,
    InfiniteStamina = false,
    AutoRejoinOnKick = true -- default ON as requested
}
local activeConnections = {}
local guiRefs = {}

-- Feature functions reused by GUI callbacks

-- Infinite Stamina logic
local function enableInfiniteStamina()
    local success, StaminaModule = pcall(function()
        return require(game.ReplicatedStorage.Systems.Character.Game.Sprinting)
    end)
    if success and StaminaModule then
        StaminaModule.StaminaLossDisabled = true
        activeConnections.Stamina = RunService.Heartbeat:Connect(function()
            StaminaModule.Stamina = StaminaModule.MaxStamina
            if StaminaModule.StaminaChanged and type(StaminaModule.StaminaChanged.Fire) == "function" then
                StaminaModule.StaminaChanged:Fire()
            end
        end)
    end
end

local function disableInfiniteStamina()
    if activeConnections.Stamina then
        activeConnections.Stamina:Disconnect()
        activeConnections.Stamina = nil
    end
end

-- Goon animation
local function startGoon()
    local player = Players.LocalPlayer
    local animationId = "rbxassetid://72042024"
    if not guiRefs.GoonAnim then guiRefs.GoonAnim = nil end

    local function playGoonAnim()
        local char = player.Character or player.CharacterAdded:Wait()
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
    guiRefs.GoonConnection = player.CharacterAdded:Connect(function()
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
    local player = Players.LocalPlayer
    local animationId = "rbxassetid://181526230"
    local skipTime = 0.2

    if not guiRefs.LayDownAnim then guiRefs.LayDownAnim = nil end

    local function playLayDownAnim()
        local char = player.Character or player.CharacterAdded:Wait()
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
    guiRefs.LayDownConnection = player.CharacterAdded:Connect(function()
        if toggles.LayDown then
            playLayDownAnim()
        end
    end)
end

local function generatorDoAll()
    -- Get fresh character, humanoid, and rootPart each time
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then
        warn("Missing Humanoid or HumanoidRootPart")
        return
    end

    -- Save current position
    local savedPos = rootPart.Position

    local mapFolder = Workspace:FindFirstChild("Map")
    if not mapFolder then
        warn("Map folder not found")
        return
    end
    local ingameMap = mapFolder:FindFirstChild("Ingame")
    if not ingameMap then
        warn("Ingame folder not found")
        return
    end
    local map = ingameMap:FindFirstChild("Map")
    if not map then
        warn("Map not found")
        return
    end

    -- Get all generators
    local generators = {}
    for _, obj in pairs(map:GetChildren()) do
        if obj.Name == "Generator" and obj:IsA("Model") then
            table.insert(generators, obj)
        end
    end

    local function teleport(position)
        rootPart.CFrame = CFrame.new(position + Vector3.new(0, 5, 0))
    end

    local function doGeneratorPuzzles(gen)
        for puzzleNum = 1, 4 do
            local prompt = gen.Main:WaitForChild("Prompt", 1)
            if prompt then
                prompt:InputHoldBegin()
                task.wait(0.5)
                prompt:InputHoldEnd()
            end
            task.wait(timebetweenpuzzles)
            gen.Remotes.RE:FireServer()
        end

        if gen.Remotes:FindFirstChild("RF") then
            gen.Remotes.RF:InvokeServer("leave")
        end
    end

    for _, gen in ipairs(generators) do
        while gen:FindFirstChild("Progress") and gen.Progress.Value ~= 100 do
            teleport(gen:GetModelCFrame().p or (gen.PrimaryPart and gen.PrimaryPart.Position) or gen:GetChildren()[1].Position)
            doGeneratorPuzzles(gen)
            task.wait(1)
        end
    end

    teleport(savedPos)
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
local RayfieldLoaded = false

-- Load Rayfield
local success, Rayfield = pcall(function()
    -- common Rayfield loader; change if you have a different loader string
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)
if success and Rayfield then
    RayfieldLoaded = true
else
    warn("Rayfield failed to load. GUI will not appear.")
end

-- Create Rayfield window & tabs if Rayfield loaded
local Window, PlayerTab, GameTab, MiscTab, BlatantTab
if RayfieldLoaded then
    Window = Rayfield:CreateWindow({
        Name = "Goonsaken Hub by NumanTF2",
        LoadingTitle = "Loading Goonsaken Hub",
        LoadingSubtitle = "by NumanTF2",
        Theme = "Amethyst",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "Goonsaken",
            FileName = "Settings"
        },
        Discord = {
            Enabled = false
        },
        KeySystem = false
    })

    PlayerTab = Window:CreateTab("Player", "circle-user")
    GameTab = Window:CreateTab("Game", "gamepad-2")
    MiscTab = Window:CreateTab("Misc", 4483362458)
    BlatantTab = Window:CreateTab("Blatant", "angry")
end

-- Stats GUI creation now (kept hidden until toggle)
statsGui = createStatsTracker()
statsGui.Enabled = false

-- Hook up Rayfield controls (or fallback behavior if Rayfield didn't load)
if RayfieldLoaded then
    -- Player Tab
    PlayerTab:CreateSlider({
        Name = "Walkspeed",
        Range = {1, 5},
        Increment = 0.1,
        Suffix = "x",
        CurrentValue = 1,
        Flag = "WalkspeedValue",
        Callback = function(value)
            local char = LocalPlayer.Character
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Parent:FindFirstChild("SpeedMultipliers") then
                humanoid.Parent.SpeedMultipliers.Sprinting.Value = value
            end
        end
    })

    PlayerTab:CreateSlider({
        Name = "Jump Power",
        Range = {0, 100},
        Increment = 1,
        Suffix = "",
        CurrentValue = 50,
        Flag = "JumpPowerValue",
        Callback = function(value)
            local char = LocalPlayer.Character
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = value
            end
        end
    })

    PlayerTab:CreateToggle({
        Name = "Goon",
        CurrentValue = false,
        Flag = "GoonToggle",
        Callback = function(state)
            toggles.Goon = state
            if state then
                startGoon()
            else
                stopGoon()
            end
        end
    })

    PlayerTab:CreateToggle({
        Name = "Lay Down",
        CurrentValue = false,
        Flag = "LayDownToggle",
        Callback = function(state)
            toggles.LayDown = state
            if state then
                startLayDown()
            else
                stopLayDown()
            end
        end
    })

    PlayerTab:CreateButton({
        Name = "Frontflip (Key: F)",
        Callback = function()
            if frontflipObj and frontflipObj.Flip then
                frontflipObj.Flip()
            end
        end
    })

    PlayerTab:CreateToggle({
        Name = "Chance Aimbot",
        CurrentValue = false,
        Flag = "AimbotToggle",
        Callback = function(state)
            if state then
                enableAimbot()
            else
                disableAimbot()
            end
        end
    })

    PlayerTab:CreateToggle({
        Name = "Block TP",
        CurrentValue = false,
        Flag = "BlockTPToggle",
        Callback = function(skibiditoilet)
            print(skibiditoilet)
            if skibiditoilet == true then
                startAutoBlock(skibiditoilet)
            end
        end
    })

	PlayerTab:CreateToggle({
        Name = "Invisible",
        CurrentValue = false,
        Flag = "Invis",
        Callback = function(state)
			if state then
				Rayfield:Notify({
   					Title = "Read me!",
   					Content = "The block in the middle of your screen is your player! it is still invisible to others. it is just to guide you where you are.",
    				Duration = 6.5,
    				Image = 4483362458,
				})
			end
            ToggleInvis(state)
        end
    })

    PlayerTab:CreateToggle({
        Name = "Fully Invisible Upon Cloning (007n7)",
        CurrentValue = false,
        Flag = "Invis007n7",
        Callback = function(state)
			if state then
				Rayfield:Notify({
   					Title = "Read me!",
   					Content = "When Cloning, The block in the middle of your screen is your player! it is still invisible to others. it is just to guide you where you are.",
    				Duration = 6.5,
    				Image = 4483362458,
				})
			end
            handleToggle(state)
        end
    })

	PlayerTab:CreateToggle({
		Name = "Hitbox Modifier",
		CurrentValue = false,
		Flag = "hitboxmodifier",
		Callback = function(Value)
			hitboxmodificationEnabled = Value
		end
	})

	PlayerTab:CreateInput({
		Name = "Hitbox Detection Distance",
		PlaceholderText = "120",
		RemoveTextAfterFocusLost = false,
		Flag = "detectionrange",
		Callback = function(Value)
			local num = tonumber(Value)
			if num then
				MaxRange = num
			end
		end
	})
    -- Game Tab
    GameTab:CreateToggle({
        Name = "ESP",
        CurrentValue = false,
        Flag = "ESPToggle",
        Callback = function(state)
            toggles.ESP = state
            ESP:SetEnabled(state)
        end
    })

    GameTab:CreateToggle({
        Name = "Stats Tracker",
        CurrentValue = false,
        Flag = "StatsTrackerToggle",
        Callback = function(state)
            toggles.StatsTracker = state
            if statsGui then
                statsGui.Enabled = state
            end
        end
    })

    GameTab:CreateToggle({
        Name = "Infinite Stamina",
        CurrentValue = false,
        Flag = "InfiniteStaminaToggle",
        Callback = function(state)
            toggles.InfiniteStamina = state
            if state then
                enableInfiniteStamina()
            else
                disableInfiniteStamina()
            end
        end
    })

    -- Auto Rejoin on Kick (default ON)
    GameTab:CreateToggle({
        Name = "Auto Rejoin on Kick",
        CurrentValue = true,
        Flag = "AutoRejoinToggle",
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

    GameTab:CreateButton({
        Name = "Rejoin",
        Callback = function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
        end
    })
    
    GameTab:CreateKeybind({
        Name = "Do Current Puzzle (must be in generator plus one puzzle only)",
        Callback = function()
            triggerNearestGenerator()
        end
    })

    GameTab:CreateToggle({
        Name = "Auto 1x1x1x1 Popups",
        CurrentValue = false,
        Flag = "auto1x1x1x1popups",
        Callback = function(state)
            Do1x1PopupsLoop = state
			if state then
				task.spawn(Do1x1x1x1Popups)
			end
        end
    })
    -- Misc Tab
    MiscTab:CreateButton({
        Name = "Infinite Yield",
        Callback = function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
        end
    })

	MiscTab:CreateToggle({
        Name = "NameProtect (Hides your username)",
        CurrentValue = false,
        Flag = "nameprotect",
        Callback = function(state)
            nameprotectEnabled = state
        end
    })

    MiscTab:CreateKeybind({
        Name = "Emote as Killer",
        CurrentKeybind = "L",
        HoldToInteract = false,
        Flag = "KillerEmoteKeybind",
        Callback = function()
            local existence = PlayerGui:FindFirstChild("KillerEmoteGUI") -- SAFE check
            
            if existence == nil then
                KillerEmoteGUI()
            end
        end
    })

    MiscTab:CreateInput({
        Name = "Play Sound by ID",
        PlaceholderText = "Enter Roblox Sound ID",
        RemoveTextAfterFocusLost = false,
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

    MiscTab:CreateDropdown({
        Name = "Change LMS Song",
        Options = {
			"Burnout",
			"Compass",
			"Vanity",
			"Close To Me",
			"Plead",
			"Creation Of Hatred",
		},
        CurrentOption = {"Burnout"},
		MultipleOptions = false,
        Callback = function(Options)
       		selectedSong = Options[1]
        	print("Selected LMS song:", selectedSong)
		end
	})

	MiscTab:CreateButton({
    	Name = "Replace LMS Song",
    	Callback = function()
    	    print("Waiting for Workspace.Themes.LastSurvivor to exist...")
    	    
    	    -- Wait for the sound object to appear in Workspace
    	    local theme = game.Workspace:WaitForChild("Themes", 99999) -- 60 sec timeout
    	    if not theme then
    	        warn("Theme folder not found in Workspace!")
    	        return
    	    end
	
	        local lastSurvivor = theme:WaitForChild("LastSurvivor", 60)
	        if not lastSurvivor then
	            warn("LastSurvivor sound not found!")
    	        return
    	    end

       	 -- Change song
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

    BlatantTab:CreateButton({
        Name = "Do All Generators",
        Callback = function()
        	generatorDoAll()
        end
    })

	BlatantTab:CreateSlider({
        Name = "Time Between Puzzles",
        Range = {2.5, 6},
        Increment = 0.5,
        Suffix = "",
        CurrentValue = 3.5,
        Flag = "GenSpeedValue",
        Callback = function(value)
			timebetweenpuzzles = value
		end
    })
else
    -- Rayfield not loaded fallback: wire minimal keybinds and defaults
    warn("Rayfield not loaded; GUI controls unavailable. Core features remain active via defaults where possible.")
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

RunService.Heartbeat:Connect(function()
    if not nameprotectEnabled then return end
    for _, lbl in ipairs(game:GetDescendants()) do
        if lbl:IsA("TextLabel") and (lbl.Text:find(Player.Name) or lbl.Text:find(Player.DisplayName)) then
            lbl.Text = lbl.Text:gsub(Player.Name, "Hidden"):gsub(Player.DisplayName, "Hidden")
        end
    end
end)

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

RunService.Heartbeat:Connect(function()
	if PlayersFolder and not ESP.Enabled then
  		for _, obj in ipairs(PlayersFolder:GetDescendants()) do
          	if obj.Name == "PlayerESPBillboard" then
            	obj:Destroy()
            end
        end
    end
end)



