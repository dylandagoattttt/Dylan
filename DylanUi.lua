local ui_options = {
	main_color = Color3.fromRGB(41, 74, 122),
	min_size = Vector2.new(400, 300),
	toggle_key = Enum.KeyCode.RightShift,
	can_resize = true,
}

do
	local imgui = game:GetService("CoreGui"):FindFirstChild("imgui")
	if imgui then imgui:Destroy() end
end

local imgui = Instance.new("ScreenGui")
imgui.Name = "imgui"
imgui.ResetOnSpawn = false
imgui.IgnoreGuiInset = true

local cloneref = cloneref and cloneref or function(...) return ... end
local CoreGui = cloneref(game:GetService("CoreGui"))
imgui.Parent = gethui and gethui() or (CoreGui or game.Players.LocalPlayer:WaitForChild("PlayerGui"))

-- Prefabs container
local prefabs = Instance.new("Frame")
prefabs.Name = "Prefabs"
prefabs.Parent = imgui
prefabs.BackgroundColor3 = Color3.new(1, 1, 1)
prefabs.Size = UDim2.new(0, 100, 0, 100)
prefabs.Visible = false

-- Helper function to apply Concept UI styling
local function StyleElement(element, cornerRadius)
	cornerRadius = cornerRadius or 8
	
	-- Add UICorner
	local existingCorner = element:FindFirstChildWhichIsA("UICorner")
	if existingCorner then existingCorner:Destroy() end
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, cornerRadius)
	corner.Parent = element
	
	-- Add UIStroke
	local stroke = Instance.new("UIStroke")
	stroke.Name = "ConceptStroke"
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Thickness = 1.5
	stroke.Transparency = 0.5
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = element
	
	-- Add UIGradient
	local gradient = Instance.new("UIGradient")
	gradient.Name = "ConceptGradient"
	gradient.Rotation = 90
	gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0.00, Color3.fromRGB(110, 45, 220)),
		ColorSequenceKeypoint.new(0.45, Color3.fromRGB(176, 96, 244)),
		ColorSequenceKeypoint.new(1.00, Color3.fromRGB(236, 198, 255))
	}
	gradient.Parent = element
	
	-- Add Marble Texture
	local marble = Instance.new("ImageLabel")
	marble.Name = "MarbleTexture"
	marble.Size = UDim2.fromScale(1, 1)
	marble.BackgroundTransparency = 1
	marble.BorderSizePixel = 0
	marble.Image = "rbxassetid://133709037992585"
	marble.ImageTransparency = 0.7
	marble.ScaleType = Enum.ScaleType.Stretch
	marble.ZIndex = 0
	marble.Parent = element
	local marbleCorner = Instance.new("UICorner")
	marbleCorner.CornerRadius = UDim.new(0, cornerRadius)
	marbleCorner.Parent = marble
end

-- Create all prefabs with Concept UI styling

-- Label Prefab
local label = Instance.new("TextLabel")
label.Name = "Label"
label.Parent = prefabs
label.BackgroundColor3 = Color3.new(1, 1, 1)
label.BackgroundTransparency = 1
label.Size = UDim2.new(0, 200, 0, 20)
label.Font = Enum.Font.GothamSemibold
label.Text = "Hello, world 123"
label.TextColor3 = Color3.new(1, 1, 1)
label.TextSize = 14
label.TextXAlignment = Enum.TextXAlignment.Left

-- Window Prefab
local window = Instance.new("Frame")
window.Name = "Window"
window.Parent = prefabs
window.Active = true
window.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
window.BackgroundTransparency = 0.15
window.ClipsDescendants = true
window.Position = UDim2.new(0, 20, 0, 20)
window.Selectable = true
window.Size = UDim2.new(0, 200, 0, 200)
window.BorderSizePixel = 0
StyleElement(window, 12)

-- Resizer
local resizer = Instance.new("Frame")
resizer.Name = "Resizer"
resizer.Parent = window
resizer.Active = true
resizer.BackgroundColor3 = Color3.new(1, 1, 1)
resizer.BackgroundTransparency = 1
resizer.BorderSizePixel = 0
resizer.Position = UDim2.new(1, -20, 1, -20)
resizer.Size = UDim2.new(0, 20, 0, 20)

-- Bar (Title bar)
local bar = Instance.new("Frame")
bar.Name = "Bar"
bar.Parent = window
bar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
bar.BackgroundTransparency = 0.85
bar.BorderSizePixel = 0
bar.Size = UDim2.new(1, 0, 0, 30)
bar.ZIndex = 5
Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 12)

-- Toggle button
local toggle = Instance.new("ImageButton")
toggle.Name = "Toggle"
toggle.Parent = bar
toggle.BackgroundColor3 = Color3.new(1, 1, 1)
toggle.BackgroundTransparency = 1
toggle.Position = UDim2.new(0, 8, 0.5, -10)
toggle.Size = UDim2.new(0, 20, 0, 20)
toggle.ZIndex = 6
toggle.Image = "rbxassetid://4731371541"
toggle.ImageColor3 = Color3.fromRGB(255, 255, 255)

-- Base (bottom of bar)
local base = Instance.new("Frame")
base.Name = "Base"
base.Parent = bar
base.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
base.BackgroundTransparency = 0.7
base.BorderSizePixel = 0
base.Position = UDim2.new(0, 0, 0.8, 0)
base.Size = UDim2.new(1, 0, 0, 2)
base.ZIndex = 5

-- Top of bar
local top = Instance.new("Frame")
top.Name = "Top"
top.Parent = bar
top.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
top.BackgroundTransparency = 0.7
top.Position = UDim2.new(0, 0, 0, -2)
top.Size = UDim2.new(1, 0, 0, 2)
top.ZIndex = 5

-- Tabs container
local tabs = Instance.new("Frame")
tabs.Name = "Tabs"
tabs.Parent = window
tabs.BackgroundColor3 = Color3.new(1, 1, 1)
tabs.BackgroundTransparency = 1
tabs.Position = UDim2.new(0, 15, 0, 60)
tabs.Size = UDim2.new(1, -30, 1, -60)

-- Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Parent = window
titleLabel.BackgroundColor3 = Color3.new(1, 1, 1)
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 35, 0, 3)
titleLabel.Size = UDim2.new(0, 200, 0, 20)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "Gamer Time"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Tab Selection background
local tabSelection = Instance.new("Frame")
tabSelection.Name = "TabSelection"
tabSelection.Parent = window
tabSelection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
tabSelection.BackgroundTransparency = 0.92
tabSelection.Position = UDim2.new(0, 15, 0, 35)
tabSelection.Size = UDim2.new(1, -30, 0, 28)
tabSelection.Visible = false
tabSelection.ZIndex = 2
Instance.new("UICorner", tabSelection).CornerRadius = UDim.new(0, 8)

-- Tab Buttons container
local tabButtons = Instance.new("Frame")
tabButtons.Name = "TabButtons"
tabButtons.Parent = tabSelection
tabButtons.BackgroundColor3 = Color3.new(1, 1, 1)
tabButtons.BackgroundTransparency = 1
tabButtons.Size = UDim2.new(1, 0, 1, 0)
tabButtons.ZIndex = 3

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Parent = tabButtons
uiListLayout.FillDirection = Enum.FillDirection.Horizontal
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Padding = UDim.new(0, 4)

-- Split frame under tabs
local frame = Instance.new("Frame")
frame.Name = "Frame"
frame.Parent = tabSelection
frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
frame.BackgroundTransparency = 0.5
frame.BorderSizePixel = 0
frame.Position = UDim2.new(0, 0, 1, 0)
frame.Size = UDim2.new(1, 0, 0, 2)

-- Tab Prefab
local tab = Instance.new("Frame")
tab.Name = "Tab"
tab.Parent = prefabs
tab.BackgroundColor3 = Color3.new(1, 1, 1)
tab.BackgroundTransparency = 1
tab.Size = UDim2.new(1, 0, 1, 0)
tab.Visible = false

local uiListLayout2 = Instance.new("UIListLayout")
uiListLayout2.Parent = tab
uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout2.Padding = UDim.new(0, 6)

-- TextBox Prefab
local textBox = Instance.new("TextBox")
textBox.Parent = prefabs
textBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
textBox.BackgroundTransparency = 0.85
textBox.BorderSizePixel = 0
textBox.Size = UDim2.new(1, 0, 0, 28)
textBox.ZIndex = 2
textBox.Font = Enum.Font.GothamSemibold
textBox.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
textBox.PlaceholderText = "Input Text"
textBox.Text = ""
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.TextSize = 14
Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 8)

-- TextBox Roundify (kept for compatibility)
local textBoxRoundify4px = Instance.new("ImageLabel")
textBoxRoundify4px.Name = "TextBox_Roundify_4px"
textBoxRoundify4px.Parent = textBox
textBoxRoundify4px.BackgroundColor3 = Color3.new(1, 1, 1)
textBoxRoundify4px.BackgroundTransparency = 1
textBoxRoundify4px.Size = UDim2.new(1, 0, 1, 0)
textBoxRoundify4px.Visible = false

-- Slider Prefab
local slider = Instance.new("Frame")
slider.Name = "Slider"
slider.Parent = prefabs
slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
slider.BackgroundTransparency = 0.85
slider.Size = UDim2.new(1, 0, 0, 24)
slider.BorderSizePixel = 0
Instance.new("UICorner", slider).CornerRadius = UDim.new(0, 8)

local sliderTitle = Instance.new("TextLabel")
sliderTitle.Name = "Title"
sliderTitle.Parent = slider
sliderTitle.BackgroundColor3 = Color3.new(1, 1, 1)
sliderTitle.BackgroundTransparency = 1
sliderTitle.Position = UDim2.new(0.5, 0, 0.5, -10)
sliderTitle.Size = UDim2.new(0, 0, 0, 20)
sliderTitle.ZIndex = 3
sliderTitle.Font = Enum.Font.GothamBold
sliderTitle.Text = "Slider"
sliderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
sliderTitle.TextSize = 12

local indicator = Instance.new("Frame")
indicator.Name = "Indicator"
indicator.Parent = slider
indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
indicator.BackgroundTransparency = 0.5
indicator.BorderSizePixel = 0
indicator.Size = UDim2.new(0, 0, 0, 24)
indicator.ZIndex = 2
Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 8)

local sliderValue = Instance.new("TextLabel")
sliderValue.Name = "Value"
sliderValue.Parent = slider
sliderValue.BackgroundColor3 = Color3.new(1, 1, 1)
sliderValue.BackgroundTransparency = 1
sliderValue.Position = UDim2.new(1, -55, 0.5, -10)
sliderValue.Size = UDim2.new(0, 50, 0, 20)
sliderValue.ZIndex = 3
sliderValue.Font = Enum.Font.GothamBold
sliderValue.Text = "0"
sliderValue.TextColor3 = Color3.fromRGB(255, 255, 255)
sliderValue.TextSize = 13

-- Slider brackets
local textLabel = Instance.new("TextLabel")
textLabel.Parent = slider
textLabel.BackgroundColor3 = Color3.new(1, 1, 1)
textLabel.BackgroundTransparency = 1
textLabel.Position = UDim2.new(1, -20, -0.75, 0)
textLabel.Size = UDim2.new(0, 26, 0, 50)
textLabel.Font = Enum.Font.GothamBold
textLabel.Text = "]"
textLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
textLabel.TextSize = 14

local textLabel2 = Instance.new("TextLabel")
textLabel2.Parent = slider
textLabel2.BackgroundColor3 = Color3.new(1, 1, 1)
textLabel2.BackgroundTransparency = 1
textLabel2.Position = UDim2.new(1, -65, -0.75, 0)
textLabel2.Size = UDim2.new(0, 26, 0, 50)
textLabel2.Font = Enum.Font.GothamBold
textLabel2.Text = "["
textLabel2.TextColor3 = Color3.fromRGB(200, 200, 200)
textLabel2.TextSize = 14

-- Circle for ripple effect
local circle = Instance.new("ImageLabel")
circle.Name = "Circle"
circle.Parent = prefabs
circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
circle.BackgroundTransparency = 0.3
circle.Image = "rbxassetid://266543268"
circle.Visible = false

local uiListLayout3 = Instance.new("UIListLayout")
uiListLayout3.Parent = prefabs
uiListLayout3.FillDirection = Enum.FillDirection.Horizontal
uiListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout3.Padding = UDim.new(0, 20)

-- Dropdown Prefab
local dropdown = Instance.new("TextButton")
dropdown.Name = "Dropdown"
dropdown.Parent = prefabs
dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
dropdown.BackgroundTransparency = 0.85
dropdown.BorderSizePixel = 0
dropdown.Size = UDim2.new(1, 0, 0, 28)
dropdown.ZIndex = 2
dropdown.Font = Enum.Font.GothamBold
dropdown.Text = " Dropdown"
dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
dropdown.TextSize = 14
dropdown.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 8)

local dropdownIndicator = Instance.new("ImageLabel")
dropdownIndicator.Name = "Indicator"
dropdownIndicator.Parent = dropdown
dropdownIndicator.BackgroundColor3 = Color3.new(1, 1, 1)
dropdownIndicator.BackgroundTransparency = 1
dropdownIndicator.Position = UDim2.new(0.9, -10, 0.1, 0)
dropdownIndicator.Rotation = -90
dropdownIndicator.Size = UDim2.new(0, 15, 0, 15)
dropdownIndicator.ZIndex = 3
dropdownIndicator.Image = "rbxassetid://4744658743"
dropdownIndicator.ImageColor3 = Color3.fromRGB(255, 255, 255)

local dropdownBox = Instance.new("ImageButton")
dropdownBox.Name = "Box"
dropdownBox.Parent = dropdown
dropdownBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
dropdownBox.BackgroundTransparency = 0.85
dropdownBox.Position = UDim2.new(0, 0, 0, 32)
dropdownBox.Size = UDim2.new(1, 0, 0, 0)
dropdownBox.ZIndex = 4
dropdownBox.AutoButtonColor = false
Instance.new("UICorner", dropdownBox).CornerRadius = UDim.new(0, 8)

local dropdownObjects = Instance.new("ScrollingFrame")
dropdownObjects.Name = "Objects"
dropdownObjects.Parent = dropdownBox
dropdownObjects.BackgroundColor3 = Color3.new(1, 1, 1)
dropdownObjects.BackgroundTransparency = 1
dropdownObjects.BorderSizePixel = 0
dropdownObjects.Size = UDim2.new(1, 0, 1, 0)
dropdownObjects.ZIndex = 4
dropdownObjects.CanvasSize = UDim2.new(0, 0, 0, 0)
dropdownObjects.ScrollBarThickness = 4

local uiListLayout4 = Instance.new("UIListLayout")
uiListLayout4.Parent = dropdownObjects
uiListLayout4.SortOrder = Enum.SortOrder.LayoutOrder

-- Dropdown Roundify (kept hidden for compatibility)
local textButtonRoundify4px = Instance.new("ImageLabel")
textButtonRoundify4px.Name = "TextButton_Roundify_4px"
textButtonRoundify4px.Parent = dropdown
textButtonRoundify4px.BackgroundColor3 = Color3.new(1, 1, 1)
textButtonRoundify4px.BackgroundTransparency = 1
textButtonRoundify4px.Size = UDim2.new(1, 0, 1, 0)
textButtonRoundify4px.Visible = false

-- Tab Button Prefab
local tabButton = Instance.new("TextButton")
tabButton.Name = "TabButton"
tabButton.Parent = prefabs
tabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
tabButton.BackgroundTransparency = 0.85
tabButton.BorderSizePixel = 0
tabButton.Size = UDim2.new(0, 71, 0, 24)
tabButton.ZIndex = 3
tabButton.Font = Enum.Font.GothamSemibold
tabButton.Text = "Test tab"
tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
tabButton.TextSize = 14
Instance.new("UICorner", tabButton).CornerRadius = UDim.new(0, 6)

local textButtonRoundify4px_2 = Instance.new("ImageLabel")
textButtonRoundify4px_2.Name = "TextButton_Roundify_4px"
textButtonRoundify4px_2.Parent = tabButton
textButtonRoundify4px_2.BackgroundColor3 = Color3.new(1, 1, 1)
textButtonRoundify4px_2.BackgroundTransparency = 1
textButtonRoundify4px_2.Size = UDim2.new(1, 0, 1, 0)
textButtonRoundify4px_2.Visible = false

-- Folder Prefab
local folder = Instance.new("Frame")
folder.Name = "Folder"
folder.Parent = prefabs
folder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
folder.BackgroundTransparency = 0.85
folder.Size = UDim2.new(1, 0, 0, 24)
folder.BorderSizePixel = 0
Instance.new("UICorner", folder).CornerRadius = UDim.new(0, 8)

local button = Instance.new("TextButton")
button.Name = "Button"
button.Parent = folder
button.BackgroundColor3 = Color3.new(1, 1, 1)
button.BackgroundTransparency = 1
button.BorderSizePixel = 0
button.Size = UDim2.new(1, 0, 0, 24)
button.ZIndex = 2
button.Font = Enum.Font.GothamSemibold
button.Text = " Folder"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 14
button.TextXAlignment = Enum.TextXAlignment.Left

local textButtonRoundify4px_3 = Instance.new("ImageLabel")
textButtonRoundify4px_3.Name = "TextButton_Roundify_4px"
textButtonRoundify4px_3.Parent = button
textButtonRoundify4px_3.BackgroundColor3 = Color3.new(1, 1, 1)
textButtonRoundify4px_3.BackgroundTransparency = 1
textButtonRoundify4px_3.Size = UDim2.new(1, 0, 1, 0)
textButtonRoundify4px_3.Visible = false

local toggle2 = Instance.new("ImageLabel")
toggle2.Name = "Toggle"
toggle2.Parent = button
toggle2.BackgroundColor3 = Color3.new(1, 1, 1)
toggle2.BackgroundTransparency = 1
toggle2.Position = UDim2.new(0, 5, 0.5, -10)
toggle2.Size = UDim2.new(0, 20, 0, 20)
toggle2.ZIndex = 3
toggle2.Image = "rbxassetid://4731371541"
toggle2.ImageColor3 = Color3.fromRGB(255, 255, 255)

local objects2 = Instance.new("Frame")
objects2.Name = "Objects"
objects2.Parent = folder
objects2.BackgroundColor3 = Color3.new(1, 1, 1)
objects2.BackgroundTransparency = 1
objects2.Position = UDim2.new(0, 10, 0, 28)
objects2.Size = UDim2.new(1, -10, 1, -28)
objects2.Visible = false

local uiListLayout5 = Instance.new("UIListLayout")
uiListLayout5.Parent = objects2
uiListLayout5.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout5.Padding = UDim.new(0, 4)

-- Horizontal Alignment Prefab
local horizontalAlignment = Instance.new("Frame")
horizontalAlignment.Name = "HorizontalAlignment"
horizontalAlignment.Parent = prefabs
horizontalAlignment.BackgroundColor3 = Color3.new(1, 1, 1)
horizontalAlignment.BackgroundTransparency = 1
horizontalAlignment.Size = UDim2.new(1, 0, 0, 28)

local uiListLayout6 = Instance.new("UIListLayout")
uiListLayout6.Parent = horizontalAlignment
uiListLayout6.FillDirection = Enum.FillDirection.Horizontal
uiListLayout6.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout6.Padding = UDim.new(0, 6)

-- Console Prefab
local console = Instance.new("Frame")
console.Name = "Console"
console.Parent = prefabs
console.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
console.BackgroundTransparency = 0.85
console.Size = UDim2.new(1, 0, 0, 200)
console.BorderSizePixel = 0
Instance.new("UICorner", console).CornerRadius = UDim.new(0, 8)

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Parent = console
scrollingFrame.BackgroundColor3 = Color3.new(1, 1, 1)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.BorderSizePixel = 0
scrollingFrame.Size = UDim2.new(1, 0, 1, 1)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.ScrollBarThickness = 4

local source = Instance.new("TextBox")
source.Name = "Source"
source.Parent = scrollingFrame
source.BackgroundColor3 = Color3.new(1, 1, 1)
source.BackgroundTransparency = 1
source.Position = UDim2.new(0, 40, 0, 0)
source.Size = UDim2.new(1, -40, 0, 10000)
source.ZIndex = 3
source.ClearTextOnFocus = false
source.Font = Enum.Font.Code
source.MultiLine = true
source.PlaceholderColor3 = Color3.new(0.8, 0.8, 0.8)
source.Text = ""
source.TextColor3 = Color3.fromRGB(255, 255, 255)
source.TextSize = 15
source.TextStrokeColor3 = Color3.new(1, 1, 1)
source.TextWrapped = true
source.TextXAlignment = Enum.TextXAlignment.Left
source.TextYAlignment = Enum.TextYAlignment.Top

-- Syntax highlighting labels
local commentsLabel = Instance.new("TextLabel")
commentsLabel.Name = "Comments"
commentsLabel.Parent = source
commentsLabel.BackgroundColor3 = Color3.new(1, 1, 1)
commentsLabel.BackgroundTransparency = 1
commentsLabel.Size = UDim2.new(1, 0, 1, 0)
commentsLabel.ZIndex = 5
commentsLabel.Font = Enum.Font.Code
commentsLabel.Text = ""
commentsLabel.TextColor3 = Color3.fromRGB(59, 200, 59)
commentsLabel.TextSize = 15
commentsLabel.TextXAlignment = Enum.TextXAlignment.Left
commentsLabel.TextYAlignment = Enum.TextYAlignment.Top

local globalsLabel = Instance.new("TextLabel")
globalsLabel.Name = "Globals"
globalsLabel.Parent = source
globalsLabel.BackgroundColor3 = Color3.new(1, 1, 1)
globalsLabel.BackgroundTransparency = 1
globalsLabel.Size = UDim2.new(1, 0, 1, 0)
globalsLabel.ZIndex = 5
globalsLabel.Font = Enum.Font.Code
globalsLabel.Text = ""
globalsLabel.TextColor3 = Color3.fromRGB(132, 214, 247)
globalsLabel.TextSize = 15
globalsLabel.TextXAlignment = Enum.TextXAlignment.Left
globalsLabel.TextYAlignment = Enum.TextYAlignment.Top

local keywordsLabel = Instance.new("TextLabel")
keywordsLabel.Name = "Keywords"
keywordsLabel.Parent = source
keywordsLabel.BackgroundColor3 = Color3.new(1, 1, 1)
keywordsLabel.BackgroundTransparency = 1
keywordsLabel.Size = UDim2.new(1, 0, 1, 0)
keywordsLabel.ZIndex = 5
keywordsLabel.Font = Enum.Font.Code
keywordsLabel.Text = ""
keywordsLabel.TextColor3 = Color3.fromRGB(248, 109, 124)
keywordsLabel.TextSize = 15
keywordsLabel.TextXAlignment = Enum.TextXAlignment.Left
keywordsLabel.TextYAlignment = Enum.TextYAlignment.Top

local remoteHighlight = Instance.new("TextLabel")
remoteHighlight.Name = "RemoteHighlight"
remoteHighlight.Parent = source
remoteHighlight.BackgroundColor3 = Color3.new(1, 1, 1)
remoteHighlight.BackgroundTransparency = 1
remoteHighlight.Size = UDim2.new(1, 0, 1, 0)
remoteHighlight.ZIndex = 5
remoteHighlight.Font = Enum.Font.Code
remoteHighlight.Text = ""
remoteHighlight.TextColor3 = Color3.fromRGB(0, 145, 255)
remoteHighlight.TextSize = 15
remoteHighlight.TextXAlignment = Enum.TextXAlignment.Left
remoteHighlight.TextYAlignment = Enum.TextYAlignment.Top

local stringsLabel = Instance.new("TextLabel")
stringsLabel.Name = "Strings"
stringsLabel.Parent = source
stringsLabel.BackgroundColor3 = Color3.new(1, 1, 1)
stringsLabel.BackgroundTransparency = 1
stringsLabel.Size = UDim2.new(1, 0, 1, 0)
stringsLabel.ZIndex = 5
stringsLabel.Font = Enum.Font.Code
stringsLabel.Text = ""
stringsLabel.TextColor3 = Color3.fromRGB(173, 241, 149)
stringsLabel.TextSize = 15
stringsLabel.TextXAlignment = Enum.TextXAlignment.Left
stringsLabel.TextYAlignment = Enum.TextYAlignment.Top

local tokensLabel = Instance.new("TextLabel")
tokensLabel.Name = "Tokens"
tokensLabel.Parent = source
tokensLabel.BackgroundColor3 = Color3.new(1, 1, 1)
tokensLabel.BackgroundTransparency = 1
tokensLabel.Size = UDim2.new(1, 0, 1, 0)
tokensLabel.ZIndex = 5
tokensLabel.Font = Enum.Font.Code
tokensLabel.Text = ""
tokensLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
tokensLabel.TextSize = 15
tokensLabel.TextXAlignment = Enum.TextXAlignment.Left
tokensLabel.TextYAlignment = Enum.TextYAlignment.Top

local numbersLabel = Instance.new("TextLabel")
numbersLabel.Name = "Numbers"
numbersLabel.Parent = source
numbersLabel.BackgroundColor3 = Color3.new(1, 1, 1)
numbersLabel.BackgroundTransparency = 1
numbersLabel.Size = UDim2.new(1, 0, 1, 0)
numbersLabel.ZIndex = 4
numbersLabel.Font = Enum.Font.Code
numbersLabel.Text = ""
numbersLabel.TextColor3 = Color3.fromRGB(255, 198, 0)
numbersLabel.TextSize = 15
numbersLabel.TextXAlignment = Enum.TextXAlignment.Left
numbersLabel.TextYAlignment = Enum.TextYAlignment.Top

local infoLabel = Instance.new("TextLabel")
infoLabel.Name = "Info"
infoLabel.Parent = source
infoLabel.BackgroundColor3 = Color3.new(1, 1, 1)
infoLabel.BackgroundTransparency = 1
infoLabel.Size = UDim2.new(1, 0, 1, 0)
infoLabel.ZIndex = 5
infoLabel.Font = Enum.Font.Code
infoLabel.Text = ""
infoLabel.TextColor3 = Color3.fromRGB(0, 162, 255)
infoLabel.TextSize = 15
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextYAlignment = Enum.TextYAlignment.Top

local linesLabel = Instance.new("TextLabel")
linesLabel.Name = "Lines"
linesLabel.Parent = scrollingFrame
linesLabel.BackgroundColor3 = Color3.new(1, 1, 1)
linesLabel.BackgroundTransparency = 1
linesLabel.BorderSizePixel = 0
linesLabel.Size = UDim2.new(0, 40, 0, 10000)
linesLabel.ZIndex = 4
linesLabel.Font = Enum.Font.Code
linesLabel.Text = "1\n"
linesLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
linesLabel.TextSize = 15
linesLabel.TextWrapped = true
linesLabel.TextYAlignment = Enum.TextYAlignment.Top

-- ColorPicker Prefab
local colorPicker = Instance.new("Frame")
colorPicker.Name = "ColorPicker"
colorPicker.Parent = prefabs
colorPicker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
colorPicker.BackgroundTransparency = 0.85
colorPicker.Size = UDim2.new(0, 180, 0, 110)
colorPicker.BorderSizePixel = 0
Instance.new("UICorner", colorPicker).CornerRadius = UDim.new(0, 8)

local palette = Instance.new("ImageLabel")
palette.Name = "Palette"
palette.Parent = colorPicker
palette.BackgroundColor3 = Color3.new(1, 1, 1)
palette.BackgroundTransparency = 1
palette.Position = UDim2.new(0.05, 0, 0.05, 0)
palette.Size = UDim2.new(0, 100, 0, 100)
palette.Image = "rbxassetid://698052001"
palette.ScaleType = Enum.ScaleType.Slice
palette.SliceCenter = Rect.new(4, 4, 4, 4)

local indicator3 = Instance.new("Frame")
indicator3.Name = "Indicator"
indicator3.Parent = palette
indicator3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
indicator3.BackgroundTransparency = 0.5
indicator3.BorderSizePixel = 0
indicator3.Size = UDim2.new(0, 5, 0, 5)
indicator3.ZIndex = 2
Instance.new("UICorner", indicator3).CornerRadius = UDim.new(1, 0)

local sample = Instance.new("Frame")
sample.Name = "Sample"
sample.Parent = colorPicker
sample.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
sample.Position = UDim2.new(0.8, 0, 0.05, 0)
sample.Size = UDim2.new(0, 25, 0, 25)
sample.BorderSizePixel = 0
Instance.new("UICorner", sample).CornerRadius = UDim.new(0, 6)

local saturation = Instance.new("ImageLabel")
saturation.Name = "Saturation"
saturation.Parent = colorPicker
saturation.BackgroundColor3 = Color3.new(1, 1, 1)
saturation.Position = UDim2.new(0.65, 0, 0.05, 0)
saturation.Size = UDim2.new(0, 15, 0, 100)
saturation.Image = "rbxassetid://3641079629"

local indicator4 = Instance.new("Frame")
indicator4.Name = "Indicator"
indicator4.Parent = saturation
indicator4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
indicator4.BorderSizePixel = 0
indicator4.Size = UDim2.new(0, 20, 0, 2)
indicator4.ZIndex = 2

-- Switch Prefab
local switchButton = Instance.new("TextButton")
switchButton.Name = "Switch"
switchButton.Parent = prefabs
switchButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
switchButton.BackgroundTransparency = 0.85
switchButton.BorderSizePixel = 0
switchButton.Size = UDim2.new(0, 22, 0, 22)
switchButton.ZIndex = 2
switchButton.Font = Enum.Font.Gotham
switchButton.Text = ""
switchButton.TextColor3 = Color3.fromRGB(255, 255, 255)
switchButton.TextSize = 18
Instance.new("UICorner", switchButton).CornerRadius = UDim.new(0, 6)

local textButtonRoundify4px_4 = Instance.new("ImageLabel")
textButtonRoundify4px_4.Name = "TextButton_Roundify_4px"
textButtonRoundify4px_4.Parent = switchButton
textButtonRoundify4px_4.BackgroundColor3 = Color3.new(1, 1, 1)
textButtonRoundify4px_4.BackgroundTransparency = 1
textButtonRoundify4px_4.Size = UDim2.new(1, 0, 1, 0)
textButtonRoundify4px_4.Visible = false

local title3Label = Instance.new("TextLabel")
title3Label.Name = "Title"
title3Label.Parent = switchButton
title3Label.BackgroundColor3 = Color3.new(1, 1, 1)
title3Label.BackgroundTransparency = 1
title3Label.Position = UDim2.new(1.2, 0, 0, 0)
title3Label.Size = UDim2.new(0, 20, 0, 22)
title3Label.Font = Enum.Font.GothamSemibold
title3Label.Text = "Switch"
title3Label.TextColor3 = Color3.fromRGB(255, 255, 255)
title3Label.TextSize = 14
title3Label.TextXAlignment = Enum.TextXAlignment.Left

-- Button Prefab (standalone)
local button2 = Instance.new("TextButton")
button2.Name = "Button"
button2.Parent = prefabs
button2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
button2.BackgroundTransparency = 0.85
button2.BorderSizePixel = 0
button2.Size = UDim2.new(0, 120, 0, 28)
button2.ZIndex = 2
button2.Font = Enum.Font.GothamSemibold
button2.Text = "Button"
button2.TextColor3 = Color3.fromRGB(255, 255, 255)
button2.TextSize = 14
button2.ClipsDescendants = true
Instance.new("UICorner", button2).CornerRadius = UDim.new(0, 8)

local textButtonRoundify4px_5 = Instance.new("ImageLabel")
textButtonRoundify4px_5.Name = "TextButton_Roundify_4px"
textButtonRoundify4px_5.Parent = button2
textButtonRoundify4px_5.BackgroundColor3 = Color3.new(1, 1, 1)
textButtonRoundify4px_5.BackgroundTransparency = 1
textButtonRoundify4px_5.Size = UDim2.new(1, 0, 1, 0)
textButtonRoundify4px_5.Visible = false

-- Dropdown Button Prefab
local dropdownButton = Instance.new("TextButton")
dropdownButton.Name = "DropdownButton"
dropdownButton.Parent = prefabs
dropdownButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
dropdownButton.BackgroundTransparency = 0.9
dropdownButton.BorderSizePixel = 0
dropdownButton.Size = UDim2.new(1, 0, 0, 22)
dropdownButton.ZIndex = 4
dropdownButton.Font = Enum.Font.GothamBold
dropdownButton.Text = " Button"
dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
dropdownButton.TextSize = 14
dropdownButton.TextXAlignment = Enum.TextXAlignment.Left

-- Keybind Prefab
local keybind = Instance.new("Frame")
keybind.Name = "Keybind"
keybind.Parent = prefabs
keybind.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
keybind.BackgroundTransparency = 0.85
keybind.Size = UDim2.new(1, 0, 0, 28)
keybind.BorderSizePixel = 0
Instance.new("UICorner", keybind).CornerRadius = UDim.new(0, 8)

local title4Label = Instance.new("TextLabel")
title4Label.Name = "Title"
title4Label.Parent = keybind
title4Label.BackgroundColor3 = Color3.new(1, 1, 1)
title4Label.BackgroundTransparency = 1
title4Label.Size = UDim2.new(0, 0, 1, 0)
title4Label.Font = Enum.Font.GothamBold
title4Label.Text = " Keybind"
title4Label.TextColor3 = Color3.fromRGB(255, 255, 255)
title4Label.TextSize = 14
title4Label.TextXAlignment = Enum.TextXAlignment.Left

local inputButton = Instance.new("TextButton")
inputButton.Name = "Input"
inputButton.Parent = keybind
inputButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
inputButton.BackgroundTransparency = 0.75
inputButton.BorderSizePixel = 0
inputButton.Position = UDim2.new(1, -85, 0, 2)
inputButton.Size = UDim2.new(0, 80, 1, -4)
inputButton.ZIndex = 3
inputButton.Font = Enum.Font.GothamSemibold
inputButton.Text = "RShift"
inputButton.TextColor3 = Color3.fromRGB(255, 255, 255)
inputButton.TextSize = 12
inputButton.TextWrapped = true
Instance.new("UICorner", inputButton).CornerRadius = UDim.new(0, 6)

local inputRoundify4px = Instance.new("ImageLabel")
inputRoundify4px.Name = "Input_Roundify_4px"
inputRoundify4px.Parent = inputButton
inputRoundify4px.BackgroundColor3 = Color3.new(1, 1, 1)
inputRoundify4px.BackgroundTransparency = 1
inputRoundify4px.Size = UDim2.new(1, 0, 1, 0)
inputRoundify4px.Visible = false

-- Windows Container
local windowsFrame = Instance.new("Frame")
windowsFrame.Name = "Windows"
windowsFrame.Parent = imgui
windowsFrame.BackgroundColor3 = Color3.new(1, 1, 1)
windowsFrame.BackgroundTransparency = 1
windowsFrame.Size = UDim2.new(1, 0, 1, 0)

--[[ Script ]]--
local root = imgui
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RS = game:GetService("RunService")
local ps = game:GetService("Players")
local p = ps.LocalPlayer
local mouse = p:GetMouse()
local Prefabs = prefabs
local Windows = windowsFrame
local checks = {
	["binding"] = false,
}

UIS.InputBegan:Connect(function(input, gameProcessed)
	if input.KeyCode == ((typeof(ui_options.toggle_key) == "EnumItem") and ui_options.toggle_key or Enum.KeyCode.RightShift) then
		if root then
			if not checks.binding and root.Enabled ~= nil then
				root.Enabled = not root.Enabled
			end
		end
	end
end)

local function Resize(part, new, _delay)
	_delay = _delay or 0.5
	local tweenInfo = TweenInfo.new(_delay, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(part, tweenInfo, new)
	tween:Play()
end

local function rgbtohsv(r, g, b)
	r, g, b = r / 255, g / 255, b / 255
	local max, min = math.max(r, g, b), math.min(r, g, b)
	local h, s, v
	v = max
	local d = max - min
	if max == 0 then
		s = 0
	else
		s = d / max
	end
	if max == min then
		h = 0
	else
		if max == r then
			h = (g - b) / d
			if g < b then
				h = h + 6
			end
		elseif max == g then
			h = (b - r) / d + 2
		elseif max == b then
			h = (r - g) / d + 4
		end
		h = h / 6
	end
	return h, s, v
end

local function hasprop(object, prop)
	local a, b = pcall(function()
		return object[tostring(prop)]
	end)
	if a then
		return b
	end
end

local function gNameLen(obj)
	return obj.TextBounds.X + 25
end

local function gMouse()
	return Vector2.new(UIS:GetMouseLocation().X + 1, UIS:GetMouseLocation().Y - 35)
end

local function ripple(button, x, y)
	spawn(function()
		button.ClipsDescendants = true
		local circleClone = prefabs:FindFirstChild("Circle"):Clone()
		circleClone.Visible = true
		circleClone.Parent = button
		circleClone.ZIndex = 1000
		local new_x = x - circleClone.AbsolutePosition.X
		local new_y = y - circleClone.AbsolutePosition.Y
		circleClone.Position = UDim2.new(0, new_x, 0, new_y)
		local size = 0
		if button.AbsoluteSize.X > button.AbsoluteSize.Y then
			size = button.AbsoluteSize.X * 1.5
		elseif button.AbsoluteSize.X < button.AbsoluteSize.Y then
			size = button.AbsoluteSize.Y * 1.5
		elseif button.AbsoluteSize.X == button.AbsoluteSize.Y then
			size = button.AbsoluteSize.X * 1.5
		end
		circleClone:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, -size / 2, 0.5, -size / 2), "Out", "Quad", 0.5, false, nil)
		Resize(circleClone, {ImageTransparency = 1}, 0.5)
		wait(0.5)
		circleClone:Destroy()
	end)
end

local windows = 0
local library = {}

local function format_windows()
	local ull = prefabs:FindFirstChild("UIListLayout"):Clone()
	ull.Parent = windowsFrame
	local data = {}
	for i, v in pairs(windowsFrame:GetChildren()) do
		if not (v:IsA("UIListLayout")) then
			data[v] = v.AbsolutePosition
		end
	end
	ull:Destroy()
	for i, v in pairs(data) do
		i.Position = UDim2.new(0, v.X, 0, v.Y)
	end
end

function library:FormatWindows()
	format_windows()
end

function library:AddWindow(title, options)
	windows = windows + 1
	local dropdown_open = false
	title = tostring(title or "New Window")
	options = (typeof(options) == "table") and options or ui_options
	options.tween_time = 0.1

	local Window = prefabs:FindFirstChild("Window"):Clone()
	StyleElement(Window, 12)
	Window.Parent = windowsFrame
	Window:FindFirstChild("Bar"):FindFirstChild("Title").Text = title
	Window.Size = UDim2.new(0, options.min_size.X, 0, options.min_size.Y)
	Window.ZIndex = Window.ZIndex + (windows * 10)

	local Resizer = Window:WaitForChild("Resizer")
	local window_data = {}
	Window.Draggable = true

	do -- Resize Window
		local oldIcon = mouse.Icon
		local Entered = false
		Resizer.MouseEnter:Connect(function()
			Window.Draggable = false
			if options.can_resize then
				oldIcon = mouse.Icon
			end
			Entered = true
		end)
		Resizer.MouseLeave:Connect(function()
			Entered = false
			if options.can_resize then
				mouse.Icon = oldIcon
			end
			Window.Draggable = true
		end)
		local Held = false
		UIS.InputBegan:Connect(function(inputObject)
			if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
				Held = true
				spawn(function()
					if Entered and Resizer.Active and options.can_resize then
						while Held and Resizer.Active do
							local mouse_location = gMouse()
							local x = mouse_location.X - Window.AbsolutePosition.X
							local y = mouse_location.Y - Window.AbsolutePosition.Y
							if x >= options.min_size.X and y >= options.min_size.Y then
								Resize(Window, {Size = UDim2.new(0, x, 0, y)}, options.tween_time)
							elseif x >= options.min_size.X then
								Resize(Window, {Size = UDim2.new(0, x, 0, options.min_size.Y)}, options.tween_time)
							elseif y >= options.min_size.Y then
								Resize(Window, {Size = UDim2.new(0, options.min_size.X, 0, y)}, options.tween_time)
							else
								Resize(Window, {Size = UDim2.new(0, options.min_size.X, 0, options.min_size.Y)}, options.tween_time)
							end
							RS.Heartbeat:Wait()
						end
					end
				end)
			end
		end)
		UIS.InputEnded:Connect(function(inputObject)
			if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
				Held = false
			end
		end)
	end

	do -- [Open / Close] Window
		local open_close = Window:FindFirstChild("Bar"):FindFirstChild("Toggle")
		local open = true
		local canopen = true
		local oldwindowdata = {}
		local oldy = Window.AbsoluteSize.Y
		open_close.MouseButton1Click:Connect(function()
			if canopen then
				canopen = false
				if open then
					oldwindowdata = {}
					for i, v in pairs(Window:FindFirstChild("Tabs"):GetChildren()) do
						oldwindowdata[v] = v.Visible
						v.Visible = false
					end
					Resizer.Active = false
					oldy = Window.AbsoluteSize.Y
					Resize(open_close, {Rotation = 0}, options.tween_time)
					Resize(Window, {Size = UDim2.new(0, Window.AbsoluteSize.X, 0, 35)}, options.tween_time)
					open_close.Parent:FindFirstChild("Base").Transparency = 1
				else
					for i, v in pairs(oldwindowdata) do
						i.Visible = v
					end
					Resizer.Active = true
					Resize(open_close, {Rotation = 90}, options.tween_time)
					Resize(Window, {Size = UDim2.new(0, Window.AbsoluteSize.X, 0, oldy)}, options.tween_time)
					open_close.Parent:FindFirstChild("Base").Transparency = 0
				end
				open = not open
				wait(options.tween_time)
				canopen = true
			end
		end)
	end

	do -- UI Elements
		local tabs = Window:FindFirstChild("Tabs")
		local tab_selection = Window:FindFirstChild("TabSelection")
		local tab_buttons = tab_selection:FindFirstChild("TabButtons")

		function window_data:AddTab(tab_name)
			local tab_data = {}
			tab_name = tostring(tab_name or "New Tab")
			tab_selection.Visible = true

			local new_button = prefabs:FindFirstChild("TabButton"):Clone()
			new_button.Parent = tab_buttons
			new_button.Text = tab_name
			new_button.Size = UDim2.new(0, gNameLen(new_button), 0, 24)
			new_button.ZIndex = new_button.ZIndex + (windows * 10)
			new_button:GetChildren()[1].ZIndex = new_button:GetChildren()[1].ZIndex + (windows * 10)

			local new_tab = prefabs:FindFirstChild("Tab"):Clone()
			new_tab.Parent = tabs
			new_tab.ZIndex = new_tab.ZIndex + (windows * 10)

			local function show()
				if dropdown_open then return end
				for i, v in pairs(tab_buttons:GetChildren()) do
					if not (v:IsA("UIListLayout")) then
						v.BackgroundTransparency = 0.85
						Resize(v, {Size = UDim2.new(0, v.AbsoluteSize.X, 0, 24)}, options.tween_time)
					end
				end
				for i, v in pairs(tabs:GetChildren()) do
					v.Visible = false
				end
				new_button.BackgroundTransparency = 0.7
				new_tab.Visible = true
			end

			new_button.MouseButton1Click:Connect(function()
				show()
			end)

			function tab_data:Show()
				show()
			end

			do -- Tab Elements
				function tab_data:AddLabel(label_text)
					label_text = tostring(label_text or "New Label")
					local lbl = prefabs:FindFirstChild("Label"):Clone()
					lbl.Parent = new_tab
					lbl.Text = label_text
					lbl.Size = UDim2.new(0, gNameLen(lbl), 0, 20)
					lbl.ZIndex = lbl.ZIndex + (windows * 10)
					return lbl
				end

				function tab_data:AddButton(button_text, callback)
					button_text = tostring(button_text or "New Button")
					callback = typeof(callback) == "function" and callback or function() end
					local btn = prefabs:FindFirstChild("Button"):Clone()
					btn.Parent = new_tab
					btn.Text = button_text
					btn.Size = UDim2.new(0, gNameLen(btn), 0, 28)
					btn.ZIndex = btn.ZIndex + (windows * 10)
					btn:GetChildren()[1].ZIndex = btn:GetChildren()[1].ZIndex + (windows * 10)
					btn.MouseButton1Click:Connect(function()
						ripple(btn, mouse.X, mouse.Y)
						pcall(callback)
					end)
					return btn
				end

				function tab_data:AddSwitch(switch_text, callback)
					local switch_data = {}
					switch_text = tostring(switch_text or "New Switch")
					callback = typeof(callback) == "function" and callback or function() end
					local sw = prefabs:FindFirstChild("Switch"):Clone()
					sw.Parent = new_tab
					sw:FindFirstChild("Title").Text = switch_text
					sw:FindFirstChild("Title").ZIndex = sw:FindFirstChild("Title").ZIndex + (windows * 10)
					sw.ZIndex = sw.ZIndex + (windows * 10)
					sw:GetChildren()[1].ZIndex = sw:GetChildren()[1].ZIndex + (windows * 10)

					local toggled = false
					sw.MouseButton1Click:Connect(function()
						toggled = not toggled
						sw.Text = toggled and utf8.char(10003) or ""
						sw.BackgroundTransparency = toggled and 0.5 or 0.85
						pcall(callback, toggled)
					end)

					function switch_data:Set(bool)
						toggled = (typeof(bool) == "boolean") and bool or false
						sw.Text = toggled and utf8.char(10003) or ""
						sw.BackgroundTransparency = toggled and 0.5 or 0.85
						pcall(callback, toggled)
					end

					return switch_data, sw
				end

				function tab_data:AddTextBox(textbox_text, callback, textbox_options)
					textbox_text = tostring(textbox_text or "New TextBox")
					callback = typeof(callback) == "function" and callback or function() end
					textbox_options = typeof(textbox_options) == "table" and textbox_options or {["clear"] = true}
					textbox_options = {
						["clear"] = ((textbox_options.clear) == true)
					}
					local tbox = prefabs:FindFirstChild("TextBox"):Clone()
					tbox.Parent = new_tab
					tbox.PlaceholderText = textbox_text
					tbox.ZIndex = tbox.ZIndex + (windows * 10)
					tbox:GetChildren()[1].ZIndex = tbox:GetChildren()[1].ZIndex + (windows * 10)
					tbox.FocusLost:Connect(function(ep)
						if ep then
							if #tbox.Text > 0 then
								pcall(callback, tbox.Text)
								if textbox_options.clear then
									tbox.Text = ""
								end
							end
						end
					end)
					return tbox
				end

				function tab_data:AddSlider(slider_text, callback, slider_options)
					local slider_data = {}
					slider_text = tostring(slider_text or "New Slider")
					callback = typeof(callback) == "function" and callback or function() end
					slider_options = typeof(slider_options) == "table" and slider_options or {}
					slider_options = {
						["min"] = slider_options.min or 0,
						["max"] = slider_options.max or 100,
						["readonly"] = slider_options.readonly or false,
					}
					local sld = prefabs:FindFirstChild("Slider"):Clone()
					sld.Parent = new_tab
					sld.ZIndex = sld.ZIndex + (windows * 10)
					local title = sld:FindFirstChild("Title")
					local ind = sld:FindFirstChild("Indicator")
					local val = sld:FindFirstChild("Value")
					title.ZIndex = title.ZIndex + (windows * 10)
					ind.ZIndex = ind.ZIndex + (windows * 10)
					val.ZIndex = val.ZIndex + (windows * 10)
					title.Text = slider_text

					do -- Slider Math
						local Entered = false
						sld.MouseEnter:Connect(function()
							Entered = true
							Window.Draggable = false
						end)
						sld.MouseLeave:Connect(function()
							Entered = false
							Window.Draggable = true
						end)
						local Held = false
						UIS.InputBegan:Connect(function(inputObject)
							if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
								Held = true
								spawn(function()
									if Entered and not slider_options.readonly then
										while Held and (not dropdown_open) do
											local mouse_location = gMouse()
											local x = (sld.AbsoluteSize.X - (sld.AbsoluteSize.X - ((mouse_location.X - sld.AbsolutePosition.X)) + 1)) / sld.AbsoluteSize.X
											local min = 0
											local max = 1
											local size = min
											if x >= min and x <= max then
												size = x
											elseif x < min then
												size = min
											elseif x > max then
												size = max
											end
											Resize(ind, {Size = UDim2.new(size or min, 0, 0, 24)}, options.tween_time)
											local p = math.floor((size or min) * 100)
											local maxv = slider_options.max
											local minv = slider_options.min
											local diff = maxv - minv
											local sel_value = math.floor(((diff / 100) * p) + minv)
											val.Text = tostring(sel_value)
											pcall(callback, sel_value)
											RS.Heartbeat:Wait()
										end
									end
								end)
							end
						end)
						UIS.InputEnded:Connect(function(inputObject)
							if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
								Held = false
							end
						end)

						function slider_data:Set(new_value)
							new_value = tonumber(new_value) or 0
							new_value = (((new_value >= 0 and new_value <= 100) and new_value) / 100)
							Resize(ind, {Size = UDim2.new(new_value or 0, 0, 0, 24)}, options.tween_time)
							local p = math.floor((new_value or 0) * 100)
							local maxv = slider_options.max
							local minv = slider_options.min
							local diff = maxv - minv
							local sel_value = math.floor(((diff / 100) * p) + minv)
							val.Text = tostring(sel_value)
							pcall(callback, sel_value)
						end
						slider_data:Set(slider_options["min"])
					end
					return slider_data, sld
				end

				function tab_data:AddKeybind(keybind_name, callback, keybind_options)
					local keybind_data = {}
					keybind_name = tostring(keybind_name or "New Keybind")
					callback = typeof(callback) == "function" and callback or function() end
					keybind_options = typeof(keybind_options) == "table" and keybind_options or {}
					keybind_options = {
						["standard"] = keybind_options.standard or Enum.KeyCode.RightShift,
					}
					local kb = prefabs:FindFirstChild("Keybind"):Clone()
					local input = kb:FindFirstChild("Input")
					local title = kb:FindFirstChild("Title")
					kb.ZIndex = kb.ZIndex + (windows * 10)
					input.ZIndex = input.ZIndex + (windows * 10)
					input:GetChildren()[1].ZIndex = input:GetChildren()[1].ZIndex + (windows * 10)
					title.ZIndex = title.ZIndex + (windows * 10)
					kb.Parent = new_tab
					title.Text = " " .. keybind_name

					local shortkeys = {
						RightControl = 'RightCtrl',
						LeftControl = 'LeftCtrl',
						LeftShift = 'LShift',
						RightShift = 'RShift',
						MouseButton1 = "Mouse1",
						MouseButton2 = "Mouse2"
					}
					local currentKeybind = keybind_options.standard

					function keybind_data:SetKeybind(Keybind)
						local key = shortkeys[Keybind.Name] or Keybind.Name
						input.Text = key
						currentKeybind = Keybind
					end

					UIS.InputBegan:Connect(function(a, b)
						if checks.binding then
							spawn(function()
								wait()
								checks.binding = false
							end)
							return
						end
						if a.KeyCode == currentKeybind and not b then
							pcall(callback, currentKeybind)
						end
					end)

					keybind_data:SetKeybind(keybind_options.standard)

					input.MouseButton1Click:Connect(function()
						if checks.binding then return end
						input.Text = "..."
						checks.binding = true
						local a, b = UIS.InputBegan:Wait()
						keybind_data:SetKeybind(a.KeyCode)
					end)

					return keybind_data, kb
				end

				function tab_data:AddDropdown(dropdown_name, callback)
					local dropdown_data = {}
					dropdown_name = tostring(dropdown_name or "New Dropdown")
					callback = typeof(callback) == "function" and callback or function() end
					local dd = prefabs:FindFirstChild("Dropdown"):Clone()
					local box = dd:FindFirstChild("Box")
					local objects = box:FindFirstChild("Objects")
					local ind = dd:FindFirstChild("Indicator")
					dd.ZIndex = dd.ZIndex + (windows * 10)
					box.ZIndex = box.ZIndex + (windows * 10)
					objects.ZIndex = objects.ZIndex + (windows * 10)
					ind.ZIndex = ind.ZIndex + (windows * 10)
					dd:GetChildren()[3].ZIndex = dd:GetChildren()[3].ZIndex + (windows * 10)
					dd.Parent = new_tab
					dd.Text = " " .. dropdown_name
					box.Size = UDim2.new(1, 0, 0, 0)

					local open = false
					dd.MouseButton1Click:Connect(function()
						open = not open
						local len = (#objects:GetChildren() - 1) * 22
						if #objects:GetChildren() - 1 >= 8 then
							len = 8 * 22
							objects.CanvasSize = UDim2.new(0, 0, (#objects:GetChildren() - 1) * 0.08, 0)
						end
						if open then
							if dropdown_open then return end
							dropdown_open = true
							Resize(box, {Size = UDim2.new(1, 0, 0, len)}, options.tween_time)
							Resize(ind, {Rotation = 90}, options.tween_time)
						else
							dropdown_open = false
							Resize(box, {Size = UDim2.new(1, 0, 0, 0)}, options.tween_time)
							Resize(ind, {Rotation = -90}, options.tween_time)
						end
					end)

					function dropdown_data:Add(n)
						local object_data = {}
						n = tostring(n or "New Object")
						local object = prefabs:FindFirstChild("DropdownButton"):Clone()
						object.Parent = objects
						object.Text = " " .. n
						object.ZIndex = object.ZIndex + (windows * 10)
						object.MouseEnter:Connect(function()
							object.BackgroundTransparency = 0.7
						end)
						object.MouseLeave:Connect(function()
							object.BackgroundTransparency = 0.9
						end)

						if open then
							local len = (#objects:GetChildren() - 1) * 22
							if #objects:GetChildren() - 1 >= 8 then
								len = 8 * 22
								objects.CanvasSize = UDim2.new(0, 0, (#objects:GetChildren() - 1) * 0.08, 0)
							end
							Resize(box, {Size = UDim2.new(1, 0, 0, len)}, options.tween_time)
						end

						object.MouseButton1Click:Connect(function()
							if dropdown_open then
								dd.Text = " " .. n
								dropdown_open = false
								open = false
								Resize(box, {Size = UDim2.new(1, 0, 0, 0)}, options.tween_time)
								Resize(ind, {Rotation = -90}, options.tween_time)
								pcall(callback, n)
							end
						end)

						function object_data:Remove()
							object:Destroy()
						end

						return object, object_data
					end
					return dropdown_data, dd
				end

				function tab_data:AddColorPicker(callback)
					local color_picker_data = {}
					callback = typeof(callback) == "function" and callback or function() end
					local cp = prefabs:FindFirstChild("ColorPicker"):Clone()
					cp.Parent = new_tab
					cp.ZIndex = cp.ZIndex + (windows * 10)
					local pal = cp:FindFirstChild("Palette")
					local sam = cp:FindFirstChild("Sample")
					local sat = cp:FindFirstChild("Saturation")
					pal.ZIndex = pal.ZIndex + (windows * 10)
					sam.ZIndex = sam.ZIndex + (windows * 10)
					sat.ZIndex = sat.ZIndex + (windows * 10)

					do -- Color Picker Math
						local h = 0
						local s = 1
						local v = 1
						local function update()
							local color = Color3.fromHSV(h, s, v)
							sam.BackgroundColor3 = color
							sat.ImageColor3 = Color3.fromHSV(h, 1, 1)
							pcall(callback, color)
						end
						update()

						local Entered1, Entered2 = false, false
						pal.MouseEnter:Connect(function() Window.Draggable = false; Entered1 = true end)
						pal.MouseLeave:Connect(function() Window.Draggable = true; Entered1 = false end)
						sat.MouseEnter:Connect(function() Window.Draggable = false; Entered2 = true end)
						sat.MouseLeave:Connect(function() Window.Draggable = true; Entered2 = false end)

						local pal_ind = pal:FindFirstChild("Indicator")
						local sat_ind = sat:FindFirstChild("Indicator")
						pal_ind.ZIndex = pal_ind.ZIndex + (windows * 10)
						sat_ind.ZIndex = sat_ind.ZIndex + (windows * 10)

						local Held = false
						UIS.InputBegan:Connect(function(inputObject)
							if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
								Held = true
								spawn(function()
									while Held and Entered1 and (not dropdown_open) do
										local mouse_location = gMouse()
										local x = ((pal.AbsoluteSize.X - (mouse_location.X - pal.AbsolutePosition.X)) + 1)
										local y = ((pal.AbsoluteSize.Y - (mouse_location.Y - pal.AbsolutePosition.Y)) + 1.5)
										h = x / 100
										s = y / 100
										Resize(pal_ind, {Position = UDim2.new(0, math.abs(x - 100) - (pal_ind.AbsoluteSize.X / 2), 0, math.abs(y - 100) - (pal_ind.AbsoluteSize.Y / 2))}, options.tween_time)
										update()
										RS.Heartbeat:Wait()
									end
									while Held and Entered2 and (not dropdown_open) do
										local mouse_location = gMouse()
										local y = ((pal.AbsoluteSize.Y - (mouse_location.Y - pal.AbsolutePosition.Y)) + 1.5)
										v = y / 100
										Resize(sat_ind, {Position = UDim2.new(0, 0, 0, math.abs(y - 100))}, options.tween_time)
										update()
										RS.Heartbeat:Wait()
									end
								end)
							end
						end)
						UIS.InputEnded:Connect(function(inputObject)
							if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
								Held = false
							end
						end)

						function color_picker_data:Set(color)
							color = typeof(color) == "Color3" and color or Color3.new(1, 1, 1)
							local h2, s2, v2 = rgbtohsv(color.r * 255, color.g * 255, color.b * 255)
							sam.BackgroundColor3 = color
							sat.ImageColor3 = Color3.fromHSV(h2, 1, 1)
							pcall(callback, color)
						end
					end
					return color_picker_data, cp
				end

				function tab_data:AddConsole(console_options)
					local console_data = {}
					console_options = typeof(console_options) == "table" and console_options or {["readonly"] = true, ["full"] = false}
					console_options = {
						["y"] = tonumber(console_options.y) or 200,
						["source"] = console_options.source or "Logs",
						["readonly"] = ((console_options.readonly) == true),
						["full"] = ((console_options.full) == true),
					}
					local cons = prefabs:FindFirstChild("Console"):Clone()
					cons.Parent = new_tab
					cons.ZIndex = cons.ZIndex + (windows * 10)
					cons.Size = UDim2.new(1, 0, console_options.full and 1 or 0, console_options.y)
					local sf = cons:GetChildren()[1]
					local Source = sf:FindFirstChild("Source")
					local Lines = sf:FindFirstChild("Lines")
					Source.ZIndex = Source.ZIndex + (windows * 10)
					Lines.ZIndex = Lines.ZIndex + (windows * 10)
					Source.TextEditable = not console_options.readonly

					do
						for i, v in pairs(Source:GetChildren()) do
							v.ZIndex = v.ZIndex + (windows * 10) + 1
						end
					end
					Source.Comments.ZIndex = Source.Comments.ZIndex + 1

					do
						local lua_keywords = {"and", "break", "do", "else", "elseif", "end", "false", "for", "function", "goto", "if", "in", "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while"}
						local global_env = {"getrawmetatable", "newcclosure", "islclosure", "setclipboard", "game", "workspace", "script", "math", "string", "table", "print", "wait", "BrickColor", "Color3", "next", "pairs", "ipairs", "select", "unpack", "Instance", "Vector2", "Vector3", "CFrame", "Ray", "UDim2", "Enum", "assert", "error", "warn", "tick", "loadstring", "_G", "shared", "getfenv", "setfenv", "newproxy", "setmetatable", "getmetatable", "os", "debug", "pcall", "ypcall", "xpcall", "rawequal", "rawset", "rawget", "tonumber", "tostring", "type", "typeof", "_VERSION", "coroutine", "delay", "require", "spawn", "LoadLibrary", "settings", "stats", "time", "UserSettings", "version", "Axes", "ColorSequence", "Faces", "ColorSequenceKeypoint", "NumberRange", "NumberSequence", "NumberSequenceKeypoint", "gcinfo", "elapsedTime", "collectgarbage", "PhysicalProperties", "Rect", "Region3", "Region3int16", "UDim", "Vector2int16", "Vector3int16", "load", "fire", "Fire"}

						local Highlight = function(string, keywords)
							local K = {}
							local S = string
							local Token = {
								["="] = true, ["."] = true, [","] = true, ["("] = true, [")"] = true,
								["["] = true, ["]"] = true, ["{"] = true, ["}"] = true, [":"] = true,
								["*"] = true, ["/"] = true, ["+"] = true, ["-"] = true, ["%"] = true,
								[";"] = true, ["~"] = true
							}
							for i, v in pairs(keywords) do
								K[v] = true
							end
							S = S:gsub(".", function(c)
								if Token[c] ~= nil then
									return "\32"
								else
									return c
								end
							end)
							S = S:gsub("%S+", function(c)
								if K[c] ~= nil then
									return c
								else
									return (" "):rep(#c)
								end
							end)
							return S
						end

						local hTokens = function(string)
							local Token = {
								["="] = true, ["."] = true, [","] = true, ["("] = true, [")"] = true,
								["["] = true, ["]"] = true, ["{"] = true, ["}"] = true, [":"] = true,
								["*"] = true, ["/"] = true, ["+"] = true, ["-"] = true, ["%"] = true,
								[";"] = true, ["~"] = true
							}
							local A = ""
							string:gsub(".", function(c)
								if Token[c] ~= nil then
									A = A .. c
								elseif c == "\n" then
									A = A .. "\n"
								elseif c == "\t" then
									A = A .. "\t"
								else
									A = A .. "\32"
								end
							end)
							return A
						end

						local strings = function(string)
							local highlight = ""
							local quote = false
							string:gsub(".", function(c)
								if quote == false and c == "\34" then
									quote = true
								elseif quote == true and c == "\34" then
									quote = false
								end
								if quote == false and c == "\34" then
									highlight = highlight .. "\34"
								elseif c == "\n" then
									highlight = highlight .. "\n"
								elseif c == "\t" then
									highlight = highlight .. "\t"
								elseif quote == true then
									highlight = highlight .. c
								elseif quote == false then
									highlight = highlight .. "\32"
								end
							end)
							return highlight
						end

						local info = function(string)
							local highlight = ""
							local quote = false
							string:gsub(".", function(c)
								if quote == false and c == "[" then
									quote = true
								elseif quote == true and c == "]" then
									quote = false
								end
								if quote == false and c == "]" then
									highlight = highlight .. "]"
								elseif c == "\n" then
									highlight = highlight .. "\n"
								elseif c == "\t" then
									highlight = highlight .. "\t"
								elseif quote == true then
									highlight = highlight .. c
								elseif quote == false then
									highlight = highlight .. "\32"
								end
							end)
							return highlight
						end

						local comments = function(string)
							local ret = ""
							string:gsub("[^\r\n]+", function(c)
								local comm = false
								local i = 0
								c:gsub(".", function(n)
									i = i + 1
									if c:sub(i, i + 1) == "--" then
										comm = true
									end
									if comm == true then
										ret = ret .. n
									else
										ret = ret .. "\32"
									end
								end)
								ret = ret
							end)
							return ret
						end

						local numbers = function(string)
							local A = ""
							string:gsub(".", function(c)
								if tonumber(c) ~= nil then
									A = A .. c
								elseif c == "\n" then
									A = A .. "\n"
								elseif c == "\t" then
									A = A .. "\t"
								else
									A = A .. "\32"
								end
							end)
							return A
						end

						local highlight_lua = function(type)
							if type == "Text" then
								Source.Text = Source.Text:gsub("\13", "")
								Source.Text = Source.Text:gsub("\t", " ")
								local s = Source.Text
								Source.Keywords.Text = Highlight(s, lua_keywords)
								Source.Globals.Text = Highlight(s, global_env)
								Source.RemoteHighlight.Text = Highlight(s, {"FireServer", "fireServer", "InvokeServer", "invokeServer"})
								Source.Tokens.Text = hTokens(s)
								Source.Numbers.Text = numbers(s)
								Source.Strings.Text = strings(s)
								Source.Comments.Text = comments(s)
								Source.Info.Text = info(s)
								local lin = 1
								s:gsub("\n", function()
									lin = lin + 1
								end)
								Lines.Text = ""
								for i = 1, lin do
									Lines.Text = Lines.Text .. i .. "\n"
								end
								sf.CanvasSize = UDim2.new(0, 0, lin * 0.153846154, 0)
							end
						end

						local highlight_logs = function(type)
							if type == "Text" then
								Source.Text = Source.Text:gsub("\13", "")
								Source.Text = Source.Text:gsub("\t", " ")
								local s = Source.Text
								local lin = 1
								s:gsub("\n", function()
									lin = lin + 1
								end)
								Lines.Text = ""
								for i = 1, lin do
									Lines.Text = Lines.Text .. i .. "\n"
								end
								sf.CanvasSize = UDim2.new(0, 0, lin * 0.153846154, 0)
							end
						end

						if console_options.source == "Lua" then
							highlight_lua("Text")
							Source.Changed:Connect(highlight_lua)
						elseif console_options.source == "Logs" then
							Lines.Visible = false
							highlight_logs("Text")
							Source.Changed:Connect(highlight_logs)
						end

						function console_data:Set(code)
							Source.Text = tostring(code)
						end

						function console_data:Get()
							return Source.Text
						end

						function console_data:Log(msg)
							Source.Text = Source.Text .. "[*] " .. tostring(msg) .. "\n"
						end
					end
					return console_data, cons
				end

				function tab_data:AddHorizontalAlignment()
					local ha_data = {}
					local ha = prefabs:FindFirstChild("HorizontalAlignment"):Clone()
					ha.Parent = new_tab

					function ha_data:AddButton(...)
						local data, object
						local ret = {tab_data:AddButton(...)}
						if typeof(ret[1]) == "table" then
							data = ret[1]
							object = ret[2]
							object.Parent = ha
							return data, object
						else
							object = ret[1]
							object.Parent = ha
							return object
						end
					end
					return ha_data, ha
				end

				function tab_data:AddFolder(folder_name)
					local folder_data = {}
					folder_name = tostring(folder_name or "New Folder")
					local fld = prefabs:FindFirstChild("Folder"):Clone()
					local btn = fld:FindFirstChild("Button")
					local objs = fld:FindFirstChild("Objects")
					local tgl = btn:FindFirstChild("Toggle")
					fld.ZIndex = fld.ZIndex + (windows * 10)
					btn.ZIndex = btn.ZIndex + (windows * 10)
					objs.ZIndex = objs.ZIndex + (windows * 10)
					tgl.ZIndex = tgl.ZIndex + (windows * 10)
					btn:GetChildren()[1].ZIndex = btn:GetChildren()[1].ZIndex + (windows * 10)
					fld.Parent = new_tab
					btn.Text = "  " .. folder_name

					local function gFolderLen()
						local n = 28
						for i, v in pairs(objs:GetChildren()) do
							if not (v:IsA("UIListLayout")) then
								n = n + v.AbsoluteSize.Y + 4
							end
						end
						return n
					end

					local open = false
					btn.MouseButton1Click:Connect(function()
						if open then
							Resize(tgl, {Rotation = 0}, options.tween_time)
							objs.Visible = false
						else
							Resize(tgl, {Rotation = 90}, options.tween_time)
							objs.Visible = true
						end
						open = not open
					end)

					spawn(function()
						while true do
							Resize(fld, {Size = UDim2.new(1, 0, 0, (open and gFolderLen() or 24))}, options.tween_time)
							wait()
						end
					end)

					for i, v in pairs(tab_data) do
						folder_data[i] = function(...)
							local data, object
							local ret = {v(...)}
							if typeof(ret[1]) == "table" then
								data = ret[1]
								object = ret[2]
								object.Parent = objs
								return data, object
							else
								object = ret[1]
								object.Parent = objs
								return object
							end
						end
					end
					return folder_data, fld
				end
			end
			return tab_data, new_tab
		end
	end

	do
		for i, v in pairs(Window:GetDescendants()) do
			if hasprop(v, "ZIndex") then
				v.ZIndex = v.ZIndex + (windows * 10)
			end
		end
	end

	return window_data, Window
end

return library
