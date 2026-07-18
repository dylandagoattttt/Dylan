local ui_options = {
	main_color = Color3.fromRGB(110, 45, 220),
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

-- Helper function to create panels with your gradient/marble style
local function StyleFrame(frame, cornerRadius)
	cornerRadius = cornerRadius or 8
	
	-- Clear existing children that might conflict
	local existingCorner = frame:FindFirstChildWhichIsA("UICorner")
	if existingCorner then existingCorner:Destroy() end
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, cornerRadius)
	corner.Parent = frame
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Thickness = 1.5
	stroke.Transparency = 0.5
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = frame
	
	local gradient = Instance.new("UIGradient")
	gradient.Rotation = 90
	gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0.00, Color3.fromRGB(110, 45, 220)),
		ColorSequenceKeypoint.new(0.45, Color3.fromRGB(176, 96, 244)),
		ColorSequenceKeypoint.new(1.00, Color3.fromRGB(236, 198, 255))
	}
	gradient.Parent = frame
	
	local marble = Instance.new("ImageLabel")
	marble.Name = "MarbleTexture"
	marble.Size = UDim2.fromScale(1, 1)
	marble.BackgroundTransparency = 1
	marble.BorderSizePixel = 0
	marble.Image = "rbxassetid://133709037992585"
	marble.ImageTransparency = 0.7
	marble.ScaleType = Enum.ScaleType.Stretch
	marble.ZIndex = 0
	marble.Parent = frame
	local marbleCorner = Instance.new("UICorner")
	marbleCorner.CornerRadius = UDim.new(0, cornerRadius)
	marbleCorner.Parent = marble
end

-- Window Prefab
local window = Instance.new("Frame")
window.Name = "Window"
window.Parent = prefabs
window.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
window.BackgroundTransparency = 0.15
window.ClipsDescendants = true
window.Position = UDim2.new(0, 20, 0, 20)
window.Size = UDim2.new(0, 200, 0, 200)
window.BorderSizePixel = 0
window.ZIndex = 1
StyleFrame(window, 12)

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

-- Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Parent = bar
titleLabel.BackgroundColor3 = Color3.new(1, 1, 1)
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 35, 0, 0)
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "Window"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 6

-- Close/Minimize button
local closeButton = Instance.new("ImageButton")
closeButton.Name = "CloseButton"
closeButton.Parent = bar
closeButton.BackgroundTransparency = 1
closeButton.Position = UDim2.new(1, -30, 0.5, -10)
closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.ZIndex = 6
closeButton.Image = "rbxassetid://114840795551292"
closeButton.ScaleType = Enum.ScaleType.Fit

-- Tab Selection background
local tabSelection = Instance.new("Frame")
tabSelection.Name = "TabSelection"
tabSelection.Parent = window
tabSelection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
tabSelection.BackgroundTransparency = 0.92
tabSelection.Position = UDim2.new(0, 10, 0, 35)
tabSelection.Size = UDim2.new(1, -20, 0, 28)
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

-- Tabs container
local tabs = Instance.new("Frame")
tabs.Name = "Tabs"
tabs.Parent = window
tabs.BackgroundColor3 = Color3.new(1, 1, 1)
tabs.BackgroundTransparency = 1
tabs.Position = UDim2.new(0, 10, 0, 70)
tabs.Size = UDim2.new(1, -20, 1, -80)
tabs.ZIndex = 2

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

-- Tab Button Prefab
local tabButton = Instance.new("TextButton")
tabButton.Name = "TabButton"
tabButton.Parent = prefabs
tabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
tabButton.BackgroundTransparency = 0.85
tabButton.BorderSizePixel = 0
tabButton.Size = UDim2.new(0, 80, 0, 24)
tabButton.ZIndex = 3
tabButton.Font = Enum.Font.GothamSemibold
tabButton.Text = "Tab"
tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
tabButton.TextSize = 13
Instance.new("UICorner", tabButton).CornerRadius = UDim.new(0, 6)

-- Label Prefab
local label = Instance.new("TextLabel")
label.Name = "Label"
label.Parent = prefabs
label.BackgroundColor3 = Color3.new(1, 1, 1)
label.BackgroundTransparency = 1
label.Size = UDim2.new(0, 200, 0, 20)
label.Font = Enum.Font.GothamSemibold
label.Text = "Hello, world"
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextSize = 14
label.TextXAlignment = Enum.TextXAlignment.Left

-- Button Prefab
local button = Instance.new("TextButton")
button.Name = "Button"
button.Parent = prefabs
button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
button.BackgroundTransparency = 0.85
button.BorderSizePixel = 0
button.Size = UDim2.new(0, 120, 0, 28)
button.ZIndex = 2
button.Font = Enum.Font.GothamSemibold
button.Text = "Button"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 14
button.ClipsDescendants = true
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)

-- Toggle Switch Prefab
local switchButton = Instance.new("TextButton")
switchButton.Name = "Switch"
switchButton.Parent = prefabs
switchButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
switchButton.BackgroundTransparency = 0.85
switchButton.BorderSizePixel = 0
switchButton.Size = UDim2.new(0, 22, 0, 22)
switchButton.ZIndex = 2
switchButton.Font = Enum.Font.GothamBold
switchButton.Text = ""
switchButton.TextColor3 = Color3.fromRGB(255, 255, 255)
switchButton.TextSize = 16
Instance.new("UICorner", switchButton).CornerRadius = UDim.new(0, 6)

local title3Label = Instance.new("TextLabel")
title3Label.Name = "Title"
title3Label.Parent = switchButton
title3Label.BackgroundColor3 = Color3.new(1, 1, 1)
title3Label.BackgroundTransparency = 1
title3Label.Position = UDim2.new(1.3, 0, 0, 0)
title3Label.Size = UDim2.new(0, 80, 0, 22)
title3Label.Font = Enum.Font.GothamSemibold
title3Label.Text = "Switch"
title3Label.TextColor3 = Color3.fromRGB(255, 255, 255)
title3Label.TextSize = 14
title3Label.TextXAlignment = Enum.TextXAlignment.Left

-- TextBox Prefab
local textBox = Instance.new("TextBox")
textBox.Name = "TextBox"
textBox.Parent = prefabs
textBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
textBox.BackgroundTransparency = 0.85
textBox.BorderSizePixel = 0
textBox.Size = UDim2.new(1, 0, 0, 28)
textBox.ZIndex = 2
textBox.Font = Enum.Font.GothamSemibold
textBox.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
textBox.PlaceholderText = "Input..."
textBox.Text = ""
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.TextSize = 14
Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 8)

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
dropdown.Text = "Dropdown"
dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
dropdown.TextSize = 14
dropdown.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 8)

local dropdownIndicator = Instance.new("ImageLabel")
dropdownIndicator.Name = "Indicator"
dropdownIndicator.Parent = dropdown
dropdownIndicator.BackgroundColor3 = Color3.new(1, 1, 1)
dropdownIndicator.BackgroundTransparency = 1
dropdownIndicator.Position = UDim2.new(0.95, -10, 0.5, -8)
dropdownIndicator.Rotation = -90
dropdownIndicator.Size = UDim2.new(0, 16, 0, 16)
dropdownIndicator.ZIndex = 3
dropdownIndicator.Image = "rbxassetid://4744658743"
dropdownIndicator.ImageColor3 = Color3.fromRGB(255, 255, 255)

local dropdownBox = Instance.new("ImageButton")
dropdownBox.Name = "Box"
dropdownBox.Parent = dropdown
dropdownBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
dropdownBox.BackgroundTransparency = 0.85
dropdownBox.Position = UDim2.new(0, 0, 0, 30)
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
dropdownButton.Text = "Option"
dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
dropdownButton.TextSize = 13
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
title4Label.Size = UDim2.new(0, 80, 1, 0)
title4Label.Font = Enum.Font.GothamBold
title4Label.Text = "Keybind"
title4Label.TextColor3 = Color3.fromRGB(255, 255, 255)
title4Label.TextSize = 14
title4Label.TextXAlignment = Enum.TextXAlignment.Left

local inputButton = Instance.new("TextButton")
inputButton.Name = "Input"
inputButton.Parent = keybind
inputButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
inputButton.BackgroundTransparency = 0.75
inputButton.BorderSizePixel = 0
inputButton.Position = UDim2.new(1, -80, 0.5, -10)
inputButton.Size = UDim2.new(0, 70, 0, 20)
inputButton.ZIndex = 3
inputButton.Font = Enum.Font.GothamSemibold
inputButton.Text = "..."
inputButton.TextColor3 = Color3.fromRGB(255, 255, 255)
inputButton.TextSize = 12
Instance.new("UICorner", inputButton).CornerRadius = UDim.new(0, 6)

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

local paletteIndicator = Instance.new("Frame")
paletteIndicator.Name = "Indicator"
paletteIndicator.Parent = palette
paletteIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
paletteIndicator.BackgroundTransparency = 0.5
paletteIndicator.BorderSizePixel = 1
paletteIndicator.Size = UDim2.new(0, 8, 0, 8)
paletteIndicator.ZIndex = 5
Instance.new("UICorner", paletteIndicator).CornerRadius = UDim.new(1, 0)

local sample = Instance.new("Frame")
sample.Name = "Sample"
sample.Parent = colorPicker
sample.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
sample.Position = UDim2.new(0.78, 0, 0.05, 0)
sample.Size = UDim2.new(0, 25, 0, 25)
sample.BorderSizePixel = 0
Instance.new("UICorner", sample).CornerRadius = UDim.new(0, 6)

local saturation = Instance.new("ImageLabel")
saturation.Name = "Saturation"
saturation.Parent = colorPicker
saturation.BackgroundColor3 = Color3.new(1, 1, 1)
saturation.Position = UDim2.new(0.63, 0, 0.05, 0)
saturation.Size = UDim2.new(0, 15, 0, 100)
saturation.Image = "rbxassetid://3641079629"

local saturationIndicator = Instance.new("Frame")
saturationIndicator.Name = "Indicator"
saturationIndicator.Parent = saturation
saturationIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
saturationIndicator.BorderSizePixel = 0
saturationIndicator.Size = UDim2.new(0, 20, 0, 3)
saturationIndicator.ZIndex = 5

-- Folder Prefab
local folder = Instance.new("Frame")
folder.Name = "Folder"
folder.Parent = prefabs
folder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
folder.BackgroundTransparency = 0.85
folder.Size = UDim2.new(1, 0, 0, 24)
folder.BorderSizePixel = 0
Instance.new("UICorner", folder).CornerRadius = UDim.new(0, 8)

local folderButton = Instance.new("TextButton")
folderButton.Name = "Button"
folderButton.Parent = folder
folderButton.BackgroundColor3 = Color3.new(1, 1, 1)
folderButton.BackgroundTransparency = 1
folderButton.Size = UDim2.new(1, 0, 0, 24)
folderButton.ZIndex = 2
folderButton.Font = Enum.Font.GothamSemibold
folderButton.Text = "Folder"
folderButton.TextColor3 = Color3.fromRGB(255, 255, 255)
folderButton.TextSize = 14
folderButton.TextXAlignment = Enum.TextXAlignment.Left

local folderToggle = Instance.new("ImageLabel")
folderToggle.Name = "Toggle"
folderToggle.Parent = folderButton
folderToggle.BackgroundColor3 = Color3.new(1, 1, 1)
folderToggle.BackgroundTransparency = 1
folderToggle.Position = UDim2.new(0, 5, 0.5, -10)
folderToggle.Size = UDim2.new(0, 20, 0, 20)
folderToggle.ZIndex = 3
folderToggle.Image = "rbxassetid://4731371541"
folderToggle.ImageColor3 = Color3.fromRGB(255, 255, 255)

local folderObjects = Instance.new("Frame")
folderObjects.Name = "Objects"
folderObjects.Parent = folder
folderObjects.BackgroundColor3 = Color3.new(1, 1, 1)
folderObjects.BackgroundTransparency = 1
folderObjects.Position = UDim2.new(0, 10, 0, 28)
folderObjects.Size = UDim2.new(1, -10, 1, -28)
folderObjects.Visible = false

local uiListLayout5 = Instance.new("UIListLayout")
uiListLayout5.Parent = folderObjects
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
scrollingFrame.Size = UDim2.new(1, 0, 1, -5)
scrollingFrame.Position = UDim2.new(0, 0, 0, 5)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.ScrollBarThickness = 4

local source = Instance.new("TextBox")
source.Name = "Source"
source.Parent = scrollingFrame
source.BackgroundColor3 = Color3.new(1, 1, 1)
source.BackgroundTransparency = 1
source.Position = UDim2.new(0, 35, 0, 0)
source.Size = UDim2.new(1, -35, 0, 10000)
source.ZIndex = 3
source.ClearTextOnFocus = false
source.Font = Enum.Font.Code
source.MultiLine = true
source.Text = ""
source.TextColor3 = Color3.fromRGB(255, 255, 255)
source.TextSize = 14
source.TextXAlignment = Enum.TextXAlignment.Left
source.TextYAlignment = Enum.TextYAlignment.Top

local linesLabel = Instance.new("TextLabel")
linesLabel.Name = "Lines"
linesLabel.Parent = scrollingFrame
linesLabel.BackgroundColor3 = Color3.new(1, 1, 1)
linesLabel.BackgroundTransparency = 1
linesLabel.Size = UDim2.new(0, 35, 0, 10000)
linesLabel.ZIndex = 4
linesLabel.Font = Enum.Font.Code
linesLabel.Text = "1\n"
linesLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
linesLabel.TextSize = 14
linesLabel.TextYAlignment = Enum.TextYAlignment.Top

-- Windows Container
local windowsFrame = Instance.new("Frame")
windowsFrame.Name = "Windows"
windowsFrame.Parent = imgui
windowsFrame.BackgroundColor3 = Color3.new(1, 1, 1)
windowsFrame.BackgroundTransparency = 1
windowsFrame.Size = UDim2.new(1, 0, 1, 0)

-- Circle for ripple effect
local circle = Instance.new("ImageLabel")
circle.Name = "Circle"
circle.Parent = prefabs
circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
circle.BackgroundTransparency = 0.3
circle.Image = "rbxassetid://266543268"
circle.Visible = false

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
		else
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
	local ull = prefabs:FindFirstChild("UIListLayout")
	if not ull then
		ull = Instance.new("UIListLayout")
	end
	ull = ull:Clone()
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
	options.tween_time = 0.15
	
	local Window = prefabs:FindFirstChild("Window"):Clone()
	StyleFrame(Window, 12)
	Window.Parent = windowsFrame
	Window:FindFirstChild("Bar"):FindFirstChild("Title").Text = title
	Window.Size = UDim2.new(0, options.min_size.X, 0, options.min_size.Y)
	Window.ZIndex = Window.ZIndex + (windows * 10)
	
	local Bar = Window:FindFirstChild("Bar")
	local Title = Bar:FindFirstChild("Title")
	local Toggle = Bar:FindFirstChild("Toggle")
	local CloseButton = Bar:FindFirstChild("CloseButton")
	
	local window_data = {}
	Window.Draggable = true
	Window.Active = true
	
	-- Resize functionality
	local Resizer = Instance.new("Frame")
	Resizer.Name = "Resizer"
	Resizer.Parent = Window
	Resizer.BackgroundTransparency = 1
	Resizer.Size = UDim2.new(0, 20, 0, 20)
	Resizer.Position = UDim2.new(1, -20, 1, -20)
	Resizer.ZIndex = 100
	Resizer.Active = true
	
	do -- Resize Window
		local Entered = false
		Resizer.MouseEnter:Connect(function()
			Window.Draggable = false
			Entered = true
		end)
		Resizer.MouseLeave:Connect(function()
			Entered = false
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
	
	do -- Open/Close Window
		local open = true
		local canopen = true
		local oldy = Window.AbsoluteSize.Y
		
		Toggle.MouseButton1Click:Connect(function()
			if canopen then
				canopen = false
				if open then
					-- Close
					Resizer.Active = false
					oldy = Window.AbsoluteSize.Y
					Resize(Toggle, {Rotation = 0}, options.tween_time)
					Resize(Window, {Size = UDim2.new(0, Window.AbsoluteSize.X, 0, 35)}, options.tween_time)
				else
					-- Open
					Resizer.Active = true
					Resize(Toggle, {Rotation = 90}, options.tween_time)
					Resize(Window, {Size = UDim2.new(0, Window.AbsoluteSize.X, 0, oldy)}, options.tween_time)
				end
				open = not open
				wait(options.tween_time)
				canopen = true
			end
		end)
		
		-- Close button minimizes
		CloseButton.MouseButton1Click:Connect(function()
			if canopen then
				canopen = false
				if open then
					Resizer.Active = false
					oldy = Window.AbsoluteSize.Y
					Resize(Toggle, {Rotation = 0}, options.tween_time)
					Resize(Window, {Size = UDim2.new(0, Window.AbsoluteSize.X, 0, 35)}, options.tween_time)
				else
					Resizer.Active = true
					Resize(Toggle, {Rotation = 90}, options.tween_time)
					Resize(Window, {Size = UDim2.new(0, Window.AbsoluteSize.X, 0, oldy)}, options.tween_time)
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
					btn.Size = UDim2.new(1, -10, 0, 28)
					btn.ZIndex = btn.ZIndex + (windows * 10)
					StyleFrame(btn, 8)
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
					sw.ZIndex = sw.ZIndex + (windows * 10)
					
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
					title.ZIndex = title.ZIndex + (windows * 10)
					kb.Parent = new_tab
					title.Text = "  " .. keybind_name
					
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
					dd.Parent = new_tab
					dd.Text = " " .. dropdown_name
					
					local open = false
					dd.MouseButton1Click:Connect(function()
						open = not open
						local len = (#objects:GetChildren() - 1) * 22
						if #objects:GetChildren() - 1 >= 8 then
							len = 8 * 22
							objects.CanvasSize = UDim2.new(0, 0, (#objects:GetChildren() - 1) * 0.05, 0)
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
								objects.CanvasSize = UDim2.new(0, 0, (#objects:GetChildren() - 1) * 0.05, 0)
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
						
						return object
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
						["readonly"] = ((console_options.readonly) == true),
						["full"] = ((console_options.full) == true),
					}
					local cons = prefabs:FindFirstChild("Console"):Clone()
					cons.Parent = new_tab
					cons.ZIndex = cons.ZIndex + (windows * 10)
					cons.Size = UDim2.new(1, -5, console_options.full and 1 or 0, console_options.y)
					local sf = cons:GetChildren()[1]
					local Source = sf:FindFirstChild("Source")
					local Lines = sf:FindFirstChild("Lines")
					Source.ZIndex = Source.ZIndex + (windows * 10)
					Lines.ZIndex = Lines.ZIndex + (windows * 10)
					Source.TextEditable = not console_options.readonly
					
					Source.Changed:Connect(function()
						local lin = 1
						Source.Text:gsub("\n", function()
							lin = lin + 1
						end)
						Lines.Text = ""
						for i = 1, lin do
							Lines.Text = Lines.Text .. i .. "\n"
						end
						sf.CanvasSize = UDim2.new(0, 0, lin * 0.07, 0)
					end)
					
					function console_data:Set(code)
						Source.Text = tostring(code)
					end
					
					function console_data:Get()
						return Source.Text
					end
					
					function console_data:Log(msg)
						Source.Text = Source.Text .. "[*] " .. tostring(msg) .. "\n"
					end
					
					return console_data, cons
				end
				
				function tab_data:AddHorizontalAlignment()
					local ha_data = {}
					local ha = prefabs:FindFirstChild("HorizontalAlignment"):Clone()
					ha.Parent = new_tab
					function ha_data:AddButton(...)
						local ret = {tab_data:AddButton(...)}
						local obj = ret[1]
						obj.Parent = ha
						obj.Size = UDim2.new(0, 100, 0, 28)
						return obj
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
