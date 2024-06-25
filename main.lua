local UserInputService = game:GetService("UserInputService")

local GUI = Instance.new("ScreenGui")
GUI.Parent = game.CoreGui
local UserInputService = game:GetService("UserInputService")

local opened = false
local numberCommands = 0

-- GUI Building

local ScreenFrame = Instance.new("Frame")
ScreenFrame.Position = UDim2.new(0, 0, 0, 0)
ScreenFrame.Size = UDim2.new(1, 0, 1, 0)
ScreenFrame.BackgroundTransparency = 1
ScreenFrame.Parent = GUI
ScreenFrame.ZIndex = 1

local BlurFrame = Instance.new("Frame")
BlurFrame.Position = UDim2.new(0, 0, 0, 0)
BlurFrame.Size = UDim2.new(1, 0, 1, 100)
BlurFrame.Position = UDim2.new(0, 0, 0, -100)
BlurFrame.BackgroundTransparency = 0.5
BlurFrame.BackgroundColor3 = Color3.new(0.184314, 0.184314, 0.184314)
BlurFrame.Parent = GUI
BlurFrame.ZIndex = 1


local SearchBar = Instance.new("Frame")
SearchBar.Size = UDim2.new(0, 600, 0, 50)
SearchBar.Position = UDim2.new(0.5, -300, 0.3, 0)
SearchBar.BackgroundTransparency = 0
SearchBar.BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)
SearchBar.Parent = GUI
SearchBar.ZIndex = 4

local SearchBarBG = Instance.new("Frame")
SearchBarBG.Size = UDim2.new(0, 620, 0, 70)
SearchBarBG.Position = UDim2.new(0.5, -310, 0.3, -10)
SearchBarBG.BackgroundTransparency = 0
SearchBarBG.BackgroundColor3 = Color3.new(0.133333, 0.133333, 0.133333)
SearchBarBG.Parent = GUI
local SearchBarBGCornerFrame = Instance.new("UICorner")
SearchBarBGCornerFrame.CornerRadius = UDim.new(0.2, 0)
SearchBarBGCornerFrame.Parent = SearchBarBG
SearchBarBG.ZIndex = 3

local CommandText = Instance.new("TextBox")
CommandText.Size = UDim2.new(0.92, 0, 0.9, 0)
CommandText.Position = UDim2.new(0.05, 0, 0, 0)
CommandText.Font = Enum.Font.Code
CommandText.TextSize = 40
CommandText.TextColor3 = Color3.new(1, 1, 1)
CommandText.BackgroundTransparency = 1
CommandText.TextXAlignment = Enum.TextXAlignment.Left
CommandText.Text = ""
CommandText.ZIndex = 5
CommandText.Parent = SearchBar

local CommandLabel = Instance.new("TextLabel")
CommandLabel.Size = UDim2.new(0, 20, 0.9, 0)
CommandLabel.Position = UDim2.new(0, 10, 0, 0)
CommandLabel.Font = Enum.Font.Code
CommandLabel.TextSize = 40
CommandLabel.TextColor3 = Color3.new(1, 1, 1)
CommandLabel.BackgroundTransparency = 1
CommandLabel.Text = ""
CommandLabel.ZIndex = 5
CommandLabel.TextTransparency = 1
CommandLabel.Parent = SearchBar

local blurEffect = Instance.new("BlurEffect")
blurEffect.Size = 0
blurEffect.Parent = game:GetService("Lighting")

-- Commands container builder

local ListContainer = Instance.new("Frame") 
ListContainer.Size = UDim2.new(0, 600, 0, 0)
ListContainer.Position = UDim2.new(0.5, -300, 0.3, 50)
ListContainer.BackgroundColor3 = Color3.new(0.137255, 0.137255, 0.137255)
local ListContainerCornerFrame = Instance.new("UICorner")
ListContainerCornerFrame.CornerRadius = UDim.new(0.2, 0)
ListContainerCornerFrame.Parent = ListContainer
ListContainer.UICorner.CornerRadius = UDim.new(0, 10)
ListContainer.ZIndex = 2
ListContainer.Parent = GUI

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, -20, 1, -20)
ScrollingFrame.Position = UDim2.new(0, 10, 0, 10)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.ZIndex = 3
ScrollingFrame.CanvasSize = UDim2.new(1, -20, 1, -20)
ScrollingFrame.ScrollBarImageColor3 = Color3.new(0.337255, 0.337255, 0.337255)
ScrollingFrame.Parent = GUI

function destroyContent()
	for _, child in pairs(ScrollingFrame:GetChildren()) do
		child:Destroy()
	end
end

local animFramerate = 0.01
local openingTime = 0.2
local closingTime = 0.1

local SearchBarInitSize = UDim2.new(0, 0, 0, 50)
local SearchBarInitPos = UDim2.new(0.5, 0, 0.3, 0)
local SearchBarBGInitSize = UDim2.new(0, 0, 0, 70)
local SearchBarBGInitPos = UDim2.new(0.5, 0, 0.3, -10)
local SearchBarFinalSize = UDim2.new(0, 600, 0, 50)
local SearchBarFinalPos = UDim2.new(0.5, -300, 0.3, 0)
local SearchBarBGFinalSize = UDim2.new(0, 620, 0, 70)
local SearchBarBGFinalPos = UDim2.new(0.5, -310, 0.3, -10)

local success, textChannels = pcall(function()
	return game:GetService("TextChatService").TextChannels
end)

if success then
	print("New chat system detected")
	msg = function(txt) game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(txt) end
else
	print("Old chat system detected")
	msg = function(txt) game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(txt, "All") end
end

--Animations

function Open()
	opened = nil
	

	CommandText.Active = true
	BlurFrame.Transparency = 1
	blurEffect.Size = 0

	CommandText:CaptureFocus()

	for i=0, openingTime/animFramerate do
		local alpha = i / (openingTime / animFramerate)

		BlurFrame.Transparency = 1 - alpha/2
		blurEffect.Size = alpha*30

		CommandLabel.TextTransparency = 1 - alpha

		SearchBar.Size = SearchBarInitSize:Lerp(SearchBarFinalSize, math.sqrt(alpha))
		SearchBarBG.Size = SearchBarBGInitSize:Lerp(SearchBarBGFinalSize, math.sqrt(alpha))

		SearchBar.Position = SearchBarInitPos:Lerp(SearchBarFinalPos, math.sqrt(alpha))
		SearchBarBG.Position = SearchBarBGInitPos:Lerp(SearchBarBGFinalPos, math.sqrt(alpha))

		wait(animFramerate)
	end

	SearchBar.Size = SearchBarFinalSize
	SearchBarBG.Size = SearchBarBGFinalSize

	SearchBar.Position = SearchBarFinalPos
	SearchBarBG.Position = SearchBarBGFinalPos

	opened = true

end

function Close()
	opened = nil

	CommandText:ReleaseFocus()

	for i=0, closingTime/animFramerate do
		local alpha = i / (closingTime / animFramerate)

		BlurFrame.Transparency =  0.5 + alpha/2
		blurEffect.Size = 30 - alpha*30

		CommandLabel.TextTransparency = alpha
		CommandText.TextTransparency = alpha

		SearchBar.Size = SearchBarFinalSize:Lerp(SearchBarInitSize,  (alpha*alpha))
		SearchBarBG.Size = SearchBarBGFinalSize:Lerp(SearchBarBGInitSize,  (alpha*alpha))

		SearchBar.Position = SearchBarFinalPos:Lerp(SearchBarInitPos,  (alpha*alpha))
		SearchBarBG.Position = SearchBarBGFinalPos:Lerp(SearchBarBGInitPos, (alpha*alpha))

		ListContainer.Size = ListContainer.Size:Lerp(UDim2.new(0, 0, 0, 0), alpha*alpha)
		ListContainer.Position = ListContainer.Position:Lerp(UDim2.new(0.5, 0, 0.3, 50), alpha*alpha)
		for _, child in pairs(ScrollingFrame:GetChildren()) do
			child.Size = child.Size:Lerp(UDim2.new(1, 0, 0, 0), alpha*alpha)
		end

		wait(animFramerate)
	end

	SearchBar.Size = SearchBarInitSize
	SearchBarBG.Size = SearchBarBGInitSize
	ListContainer.Size = UDim2.new(0, 600, 0, 0)
	ListContainer.Position = UDim2.new(0.5, -300, 0.3, 50)
	destroyContent()

	SearchBar.Position = SearchBarInitPos
	SearchBarBG.Position = SearchBarBGInitPos

	CommandText.Text = ""
	CommandText.TextTransparency = 0
	SearchBar.Transparency = 1
	CommandText:ReleaseFocus()
	CommandText.Active = false

	opened = false

end


local function onInput(input)
	if input.KeyCode == Enum.KeyCode.Insert then
		if opened then Close() else if opened == false then Open() end end
		print(opened)
	end
end

UserInputService.InputBegan:Connect(onInput)

local function sendCommand(command)
	msg(command)

	spawn(function()
		local gui = script.Parent

		local label = Instance.new("TextLabel")
		label.Text = command
		label.Font = Enum.Font.Code
		label.TextSize = 25
		label.TextColor3 = Color3.new(1, 1, 1)
		label.Size = UDim2.new(0, 200, 0, 25) 
		label.Position = UDim2.new(0.5, -100, 0, 200)
		label.TextXAlignment = Enum.TextXAlignment.Center
		label.BackgroundTransparency = 1
		label.Parent = BlurFrame

		for i=0, openingTime/animFramerate do
			local alpha = i / (openingTime / animFramerate)
			label.Position = UDim2.new(0.5, -100, 0, 200-100*alpha)
			label.TextTransparency = alpha*alpha
			wait(animFramerate)
		end

		label:Destroy()
	end)
end

-- Commands list



local initialPadding = 10
local padding = 10
local frameHeight = 80
local transitionTime = 0.25

local previousSize = 0

local function animCommandsContainer(anim)
	local offset = 0
	if numberCommands == 0 then
		offset = -2*initialPadding
	end

	if anim then
		for i=0, transitionTime/animFramerate do
			local alpha = i / (transitionTime / animFramerate)
			if numberCommands == 0 then
				offset = -2*initialPadding
			end
			if opened then
				ListContainer.Size = ListContainer.Size:Lerp(UDim2.new(0, 600, 0, math.min(2*initialPadding + (frameHeight + padding) * numberCommands + offset, 300)), alpha*alpha)
				ScrollingFrame.CanvasSize = ScrollingFrame.CanvasSize:Lerp(UDim2.new(1, -40, 0, -20+2*initialPadding + (frameHeight + padding) * numberCommands + offset), alpha*alpha)
				wait(animFramerate)
			end
		end
	end
	ListContainer.Size = UDim2.new(0, 600, 0, math.min(2*initialPadding + (frameHeight + padding) * numberCommands + offset, 300))


	ScrollingFrame.CanvasSize =UDim2.new(1, -40, 0, -20+2*initialPadding + (frameHeight + padding) * numberCommands + offset, 300)
end


local function onInputValidation(enterPressed)
	if enterPressed then
		sendCommand(CommandText.Text)
		if opened then Close() end
	end
end

local correspondances = {
	["h"] = "ẖ",
	["i"] = "į",
	["a"] = "ɑ",
	["u"] = "ú",
	["c"] = "с",
	["g"] = "ɡ",
	["n"] = "ṅ",
	["e"] = "e",
	["t"] = "ṭ",
	["l"] = "ɭ",
	["o"] = "ο",
	["d"] = "d",
	["s"] = "s",
	["k"] = "ƙ",
	["w"] = "ẇ"
} 


local function translate(m)
	m = string.lower(m)
	for i, j in pairs(correspondances) do
		m = m:gsub(i, j)
	end
	return(m)
end


CommandText.FocusLost:Connect(onInputValidation)

local textChanging = false

local function onTextChanged()

	if textChanging then return end
	local maxLength = 40

	print(CommandText.Text)
	textChanging = true
	CommandText.Text = translate(CommandText.Text)
	CommandText.CursorPosition = 100
	textChanging = false
	if #CommandText.Text > maxLength then
		CommandText.Text = string.sub(CommandText.Text, 1, maxLength)
	end
end


CommandText.Changed:Connect(onTextChanged)
Close()