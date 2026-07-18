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

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

local cloneref = cloneref and cloneref or function(...) return ... end
local CoreGui = cloneref(game:GetService("CoreGui"))

--// Create main ScreenGui
local imgui = Instance.new("ScreenGui")
imgui.Name = "imgui"
imgui.ResetOnSpawn = false
imgui.IgnoreGuiInset = true
imgui.Parent = gethui and gethui() or (CoreGui or PlayerGui)

--// Helper to create a panel with shadow (YOUR DESIGN)
local function CreatePanel(name, anchorPos, size, cornerRadius, zIndex)
    local panel = {}
    
    -- Shadow
    panel.Shadow = Instance.new("Frame")
    panel.Shadow.Name = name .. "Shadow"
    panel.Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.Shadow.Position = anchorPos + UDim2.new(0, 0, 0, 8)
    panel.Shadow.Size = size
    panel.Shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
    panel.Shadow.BackgroundTransparency = 0.5
    panel.Shadow.BorderSizePixel = 0
    panel.Shadow.ZIndex = zIndex or 0
    panel.Shadow.Parent = imgui
    Instance.new("UICorner", panel.Shadow).CornerRadius = UDim.new(0, cornerRadius or 20)

    -- Main frame
    panel.Frame = Instance.new("Frame")
    panel.Frame.Name = name
    panel.Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.Frame.Position = anchorPos
    panel.Frame.Size = size
    panel.Frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
    panel.Frame.BackgroundTransparency = 0.15
    panel.Frame.BorderSizePixel = 0
    panel.Frame.Parent = imgui
    panel.Frame.ZIndex = zIndex or 0
    Instance.new("UICorner", panel.Frame).CornerRadius = UDim.new(0, cornerRadius or 20)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255,255,255)
    stroke.Thickness = 2
    stroke.Transparency = 0.3
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = panel.Frame

    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 90
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(110,45,220)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(176,96,244)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(236,198,255))
    }
    gradient.Parent = panel.Frame

    local marble = Instance.new("ImageLabel")
    marble.Name = "MarbleTexture"
    marble.Size = UDim2.fromScale(1,1)
    marble.BackgroundTransparency = 1
    marble.BorderSizePixel = 0
    marble.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=133709037992585&width=678&height=810&format=png"
    marble.ImageTransparency = 0.6
    marble.ScaleType = Enum.ScaleType.Stretch
    marble.Parent = panel.Frame
    Instance.new("UICorner", marble).CornerRadius = UDim.new(0, cornerRadius or 20)

    return panel
end

--// Create styling for elements (YOUR DESIGN AESTHETIC)
local function StyleButton(button)
    button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundTransparency = 0.85
    button.BorderSizePixel = 0
    button.Font = Enum.Font.GothamBold
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = button
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 90
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(110,45,220)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(176,96,244)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(236,198,255))
    }
    gradient.Parent = button
end

local function StyleTextBox(textbox)
    textbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    textbox.BackgroundTransparency = 0.85
    textbox.BorderSizePixel = 0
    textbox.Font = Enum.Font.GothamSemibold
    textbox.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
    textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textbox.TextSize = 14
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = textbox
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = textbox
end

local function StyleSlider(slider)
    slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    slider.BackgroundTransparency = 0.85
    slider.BorderSizePixel = 0
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = slider
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = slider
end

local function StyleDropdown(dropdown)
    dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dropdown.BackgroundTransparency = 0.85
    dropdown.BorderSizePixel = 0
    dropdown.Font = Enum.Font.GothamBold
    dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdown.TextSize = 14
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = dropdown
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = dropdown
end

-- Prefabs container (hidden)
local prefabs = Instance.new("Frame")
prefabs.Name = "Prefabs"
prefabs.Parent = imgui
prefabs.BackgroundColor3 = Color3.new(1, 1, 1)
prefabs.Size = UDim2.new(0, 100, 0, 100)
prefabs.Visible = false

--// Create prefab elements (simplified - we'll style them when cloning)
local label = Instance.new("TextLabel")
label.Name = "Label"
label.Parent = prefabs
label.BackgroundTransparency = 1
label.Size = UDim2.new(0, 200, 0, 20)
label.Font = Enum.Font.GothamSemibold
label.Text = "Hello, world 123"
label.TextColor3 = Color3.new(1, 1, 1)
label.TextSize = 14
label.TextXAlignment = Enum.TextXAlignment.Left

local tabButton = Instance.new("TextButton")
tabButton.Name = "TabButton"
tabButton.Parent = prefabs
tabButton.BackgroundTransparency = 0.85
tabButton.BorderSizePixel = 0
tabButton.Size = UDim2.new(0, 120, 0, 35)
tabButton.Font = Enum.Font.GothamBold
tabButton.Text = "Test tab"
tabButton.TextColor3 = Color3.new(1, 1, 1)
tabButton.TextSize = 14
StyleButton(tabButton)

local tab = Instance.new("Frame")
tab.Name = "Tab"
tab.Parent = prefabs
tab.BackgroundTransparency = 1
tab.Size = UDim2.new(1, 0, 1, 0)
tab.Visible = false

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Parent = tab
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Padding = UDim.new(0, 8)

-- Button prefab
local button = Instance.new("TextButton")
button.Name = "Button"
button.Parent = prefabs
button.Size = UDim2.new(1, -20, 0, 35)
button.Font = Enum.Font.GothamBold
button.TextColor3 = Color3.new(1, 1, 1)
button.TextSize = 14
StyleButton(button)

-- Switch prefab
local switchButton = Instance.new("TextButton")
switchButton.Name = "Switch"
switchButton.Parent = prefabs
switchButton.Size = UDim2.new(0, 40, 0, 40)
switchButton.Font = Enum.Font.GothamBold
switchButton.Text = ""
switchButton.TextColor3 = Color3.new(1, 1, 1)
switchButton.TextSize = 18
StyleButton(switchButton)

local switchTitle = Instance.new("TextLabel")
switchTitle.Name = "Title"
switchTitle.Parent = switchButton
switchTitle.BackgroundTransparency = 1
switchTitle.Position = UDim2.new(1.2, 0, 0, 0)
switchTitle.Size = UDim2.new(0, 100, 1, 0)
switchTitle.Font = Enum.Font.GothamSemibold
switchTitle.Text = "Switch"
switchTitle.TextColor3 = Color3.new(1, 1, 1)
switchTitle.TextSize = 14
switchTitle.TextXAlignment = Enum.TextXAlignment.Left

-- TextBox prefab
local textBox = Instance.new("TextBox")
textBox.Name = "TextBox"
textBox.Parent = prefabs
textBox.Size = UDim2.new(1, -20, 0, 35)
textBox.Font = Enum.Font.GothamSemibold
textBox.PlaceholderColor3 = Color3.new(0.8, 0.8, 0.8)
textBox.PlaceholderText = "Input Text"
textBox.Text = ""
textBox.TextColor3 = Color3.new(1, 1, 1)
textBox.TextSize = 14
StyleTextBox(textBox)

-- Slider prefab
local slider = Instance.new("Frame")
slider.Name = "Slider"
slider.Parent = prefabs
slider.Size = UDim2.new(1, -20, 0, 40)
StyleSlider(slider)

local sliderTitle = Instance.new("TextLabel")
sliderTitle.Name = "Title"
sliderTitle.Parent = slider
sliderTitle.BackgroundTransparency = 1
sliderTitle.Position = UDim2.new(0, 10, 0, 0)
sliderTitle.Size = UDim2.new(0, 100, 1, 0)
sliderTitle.Font = Enum.Font.GothamBold
sliderTitle.Text = "Slider"
sliderTitle.TextColor3 = Color3.new(1, 1, 1)
sliderTitle.TextSize = 12

local sliderIndicator = Instance.new("Frame")
sliderIndicator.Name = "Indicator"
sliderIndicator.Parent = slider
sliderIndicator.BackgroundColor3 = Color3.fromRGB(176, 96, 244)
sliderIndicator.BorderSizePixel = 0
sliderIndicator.Size = UDim2.new(0, 0, 1, 0)
Instance.new("UICorner", sliderIndicator).CornerRadius = UDim.new(0, 8)

local sliderValue = Instance.new("TextLabel")
sliderValue.Name = "Value"
sliderValue.Parent = slider
sliderValue.BackgroundTransparency = 1
sliderValue.Position = UDim2.new(1, -60, 0, 0)
sliderValue.Size = UDim2.new(0, 50, 1, 0)
sliderValue.Font = Enum.Font.GothamBold
sliderValue.Text = "0"
sliderValue.TextColor3 = Color3.new(1, 1, 1)
sliderValue.TextSize = 12
sliderValue.TextXAlignment = Enum.TextXAlignment.Right

-- Dropdown prefab
local dropdown = Instance.new("Frame")
dropdown.Name = "Dropdown"
dropdown.Parent = prefabs
dropdown.Size = UDim2.new(1, -20, 0, 35)
StyleDropdown(dropdown)

local dropdownButton = Instance.new("TextButton")
dropdownButton.Name = "DropdownButton"
dropdownButton.Parent = dropdown
dropdownButton.Size = UDim2.new(1, 0, 1, 0)
dropdownButton.BackgroundTransparency = 1
dropdownButton.Font = Enum.Font.GothamBold
dropdownButton.Text = "Dropdown"
dropdownButton.TextColor3 = Color3.new(1, 1, 1)
dropdownButton.TextSize = 14
dropdownButton.TextXAlignment = Enum.TextXAlignment.Left

local dropdownBox = Instance.new("Frame")
dropdownBox.Name = "Box"
dropdownBox.Parent = dropdown
dropdownBox.Position = UDim2.new(0, 0, 1, 5)
dropdownBox.Size = UDim2.new(1, 0, 0, 0)
dropdownBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
dropdownBox.BackgroundTransparency = 0.9
dropdownBox.BorderSizePixel = 0
dropdownBox.ClipsDescendants = true
Instance.new("UICorner", dropdownBox).CornerRadius = UDim.new(0, 8)

local dropdownObjects = Instance.new("ScrollingFrame")
dropdownObjects.Name = "Objects"
dropdownObjects.Parent = dropdownBox
dropdownObjects.BackgroundTransparency = 1
dropdownObjects.BorderSizePixel = 0
dropdownObjects.Size = UDim2.new(1, 0, 1, 0)
dropdownObjects.CanvasSize = UDim2.new(0, 0, 0, 0)
dropdownObjects.ScrollBarThickness = 4

local uiListLayout4 = Instance.new("UIListLayout")
uiListLayout4.Parent = dropdownObjects
uiListLayout4.SortOrder = Enum.SortOrder.LayoutOrder

local dropdownOption = Instance.new("TextButton")
dropdownOption.Name = "DropdownOption"
dropdownOption.Parent = prefabs
dropdownOption.Size = UDim2.new(1, 0, 0, 30)
dropdownOption.BackgroundTransparency = 1
dropdownOption.Font = Enum.Font.GothamSemibold
dropdownOption.Text = "Option"
dropdownOption.TextColor3 = Color3.new(1, 1, 1)
dropdownOption.TextSize = 14
dropdownOption.TextXAlignment = Enum.TextXAlignment.Left

-- Keybind prefab
local keybind = Instance.new("Frame")
keybind.Name = "Keybind"
keybind.Parent = prefabs
keybind.Size = UDim2.new(1, -20, 0, 35)
StyleDropdown(keybind)

local keybindTitle = Instance.new("TextLabel")
keybindTitle.Name = "Title"
keybindTitle.Parent = keybind
keybindTitle.BackgroundTransparency = 1
keybindTitle.Position = UDim2.new(0, 10, 0, 0)
keybindTitle.Size = UDim2.new(0, 100, 1, 0)
keybindTitle.Font = Enum.Font.GothamBold
keybindTitle.Text = "Keybind"
keybindTitle.TextColor3 = Color3.new(1, 1, 1)
keybindTitle.TextSize = 14
keybindTitle.TextXAlignment = Enum.TextXAlignment.Left

local keybindInput = Instance.new("TextButton")
keybindInput.Name = "Input"
keybindInput.Parent = keybind
keybindInput.AnchorPoint = Vector2.new(1, 0.5)
keybindInput.Position = UDim2.new(1, -5, 0.5, 0)
keybindInput.Size = UDim2.new(0, 80, 0, 25)
keybindInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
keybindInput.BackgroundTransparency = 0.8
keybindInput.BorderSizePixel = 0
keybindInput.Font = Enum.Font.GothamSemibold
keybindInput.Text = "RShift"
keybindInput.TextColor3 = Color3.new(1, 1, 1)
keybindInput.TextSize = 12
Instance.new("UICorner", keybindInput).CornerRadius = UDim.new(0, 6)

-- ColorPicker prefab
local colorPicker = Instance.new("Frame")
colorPicker.Name = "ColorPicker"
colorPicker.Parent = prefabs
colorPicker.Size = UDim2.new(1, -20, 0, 140)
StyleDropdown(colorPicker)

local palette = Instance.new("ImageLabel")
palette.Name = "Palette"
palette.Parent = colorPicker
palette.BackgroundColor3 = Color3.new(1, 1, 1)
palette.BackgroundTransparency = 1
palette.Position = UDim2.new(0.05, 0, 0.1, 0)
palette.Size = UDim2.new(0, 100, 0, 100)
palette.Image = "rbxassetid://698052001"
palette.ScaleType = Enum.ScaleType.Slice
palette.SliceCenter = Rect.new(4, 4, 4, 4)

local paletteIndicator = Instance.new("Frame")
paletteIndicator.Name = "Indicator"
paletteIndicator.Parent = palette
paletteIndicator.Size = UDim2.new(0, 6, 0, 6)
paletteIndicator.ZIndex = 2
Instance.new("UICorner", paletteIndicator).CornerRadius = UDim.new(1, 0)

local saturationBar = Instance.new("ImageLabel")
saturationBar.Name = "Saturation"
saturationBar.Parent = colorPicker
saturationBar.BackgroundColor3 = Color3.new(1, 1, 1)
saturationBar.Position = UDim2.new(0.65, 0, 0.1, 0)
saturationBar.Size = UDim2.new(0, 15, 0, 100)
saturationBar.Image = "rbxassetid://3641079629"

local saturationIndicator = Instance.new("Frame")
saturationIndicator.Name = "Indicator"
saturationIndicator.Parent = saturationBar
saturationIndicator.BackgroundColor3 = Color3.new(1, 1, 1)
saturationIndicator.BorderSizePixel = 0
saturationIndicator.Size = UDim2.new(0, 20, 0, 2)
saturationIndicator.ZIndex = 2

local colorSample = Instance.new("ImageLabel")
colorSample.Name = "Sample"
colorSample.Parent = colorPicker
colorSample.BackgroundColor3 = Color3.new(1, 1, 1)
colorSample.BackgroundTransparency = 1
colorSample.Position = UDim2.new(0.82, 0, 0.1, 0)
colorSample.Size = UDim2.new(0, 25, 0, 25)
colorSample.Image = "rbxassetid://2851929490"
colorSample.ScaleType = Enum.ScaleType.Slice
colorSample.SliceCenter = Rect.new(4, 4, 4, 4)
Instance.new("UICorner", colorSample).CornerRadius = UDim.new(0, 4)

--// Console prefab
local console = Instance.new("Frame")
console.Name = "Console"
console.Parent = prefabs
console.Size = UDim2.new(1, -20, 0, 200)
console.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
console.BackgroundTransparency = 0.9
console.BorderSizePixel = 0
Instance.new("UICorner", console).CornerRadius = UDim.new(0, 8)

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Parent = console
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.BorderSizePixel = 0
scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.ScrollBarThickness = 4

local source = Instance.new("TextBox")
source.Name = "Source"
source.Parent = scrollingFrame
source.BackgroundTransparency = 1
source.Position = UDim2.new(0, 40, 0, 0)
source.Size = UDim2.new(1, -40, 0, 10000)
source.ClearTextOnFocus = false
source.Font = Enum.Font.Code
source.MultiLine = true
source.Text = ""
source.TextColor3 = Color3.new(1, 1, 1)
source.TextSize = 15
source.TextXAlignment = Enum.TextXAlignment.Left
source.TextYAlignment = Enum.TextYAlignment.Top

local linesLabel = Instance.new("TextLabel")
linesLabel.Name = "Lines"
linesLabel.Parent = scrollingFrame
linesLabel.BackgroundTransparency = 1
linesLabel.BorderSizePixel = 0
linesLabel.Size = UDim2.new(0, 40, 0, 10000)
linesLabel.Font = Enum.Font.Code
linesLabel.Text = "1\n"
linesLabel.TextColor3 = Color3.new(1, 1, 1)
linesLabel.TextSize = 15
linesLabel.TextWrapped = true
linesLabel.TextYAlignment = Enum.TextYAlignment.Top

-- Syntax highlighting labels (same as original for functionality)
local commentsLabel = Instance.new("TextLabel")
commentsLabel.Name = "Comments"
commentsLabel.Parent = source
commentsLabel.BackgroundTransparency = 1
commentsLabel.Size = UDim2.new(1, 0, 1, 0)
commentsLabel.ZIndex = 5
commentsLabel.Font = Enum.Font.Code
commentsLabel.Text = ""
commentsLabel.TextColor3 = Color3.fromRGB(59, 200, 59)
commentsLabel.TextSize = 15
commentsLabel.TextXAlignment = Enum.TextXAlignment.Left
commentsLabel.TextYAlignment = Enum.TextYAlignment.Top

-- Create similar syntax labels (Globals, Keywords, etc.)
local function createSyntaxLabel(name, color, zIndex)
    local lbl = Instance.new("TextLabel")
    lbl.Name = name
    lbl.Parent = source
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.ZIndex = zIndex or 5
    lbl.Font = Enum.Font.Code
    lbl.Text = ""
    lbl.TextColor3 = color
    lbl.TextSize = 15
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextYAlignment = Enum.TextYAlignment.Top
    return lbl
end

local globalsLabel = createSyntaxLabel("Globals", Color3.fromRGB(132, 214, 247), 5)
local keywordsLabel = createSyntaxLabel("Keywords", Color3.fromRGB(248, 109, 124), 5)
local remoteHighlight = createSyntaxLabel("RemoteHighlight", Color3.fromRGB(0, 145, 255), 5)
local stringsLabel = createSyntaxLabel("Strings", Color3.fromRGB(173, 241, 149), 5)
local tokensLabel = createSyntaxLabel("Tokens", Color3.fromRGB(255, 255, 255), 5)
local numbersLabel = createSyntaxLabel("Numbers", Color3.fromRGB(255, 198, 0), 4)
local infoLabel = createSyntaxLabel("Info", Color3.fromRGB(0, 162, 255), 5)

--// MAIN UI SETUP
local windows = {}
local windowsFrame = Instance.new("Frame")
windowsFrame.Name = "Windows"
windowsFrame.Parent = imgui
windowsFrame.BackgroundTransparency = 1
windowsFrame.Size = UDim2.new(1, 0, 1, 0)

--// State management (PRESERVED FROM ORIGINAL)
local checks = {
    ["binding"] = false,
}

UIS.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == ((typeof(ui_options.toggle_key) == "EnumItem") and ui_options.toggle_key or Enum.KeyCode.RightShift) then
        if imgui then
            if not checks.binding and imgui.Enabled ~= nil then
                imgui.Enabled = not imgui.Enabled
            end
        end
    end
end)

--// Utility functions (PRESERVED FROM ORIGINAL)
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
    return obj.TextBounds.X + 15
end

local function gMouse()
    return Vector2.new(UIS:GetMouseLocation().X + 1, UIS:GetMouseLocation().Y - 35)
end

local function ripple(button, x, y)
    spawn(function()
        button.ClipsDescendants = true
        local circle = Instance.new("ImageLabel")
        circle.BackgroundTransparency = 1
        circle.Image = "rbxassetid://266543268"
        circle.ImageTransparency = 0.5
        circle.Parent = button
        circle.ZIndex = 1000
        local new_x = x - circle.AbsolutePosition.X
        local new_y = y - circle.AbsolutePosition.Y
        circle.Position = UDim2.new(0, new_x, 0, new_y)
        local size = 0
        if button.AbsoluteSize.X > button.AbsoluteSize.Y then
            size = button.AbsoluteSize.X * 1.5
        elseif button.AbsoluteSize.X < button.AbsoluteSize.Y then
            size = button.AbsoluteSize.Y * 1.5
        elseif button.AbsoluteSize.X == button.AbsoluteSize.Y then
            size = button.AbsoluteSize.X * 1.5
        end
        circle:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, -size / 2, 0.5, -size / 2), "Out", "Quad", 0.5, false, nil)
        Resize(circle, {ImageTransparency = 1}, 0.5)
        wait(0.5)
        circle:Destroy()
    end)
end

--// LIBRARY (PRESERVED FUNCTIONALITY)
local library = {}
local windowCount = 0

function library:FormatWindows()
    -- Keep original functionality
end

function library:AddWindow(title, options)
    windowCount = windowCount + 1
    local dropdown_open = false
    title = tostring(title or "New Window")
    options = (typeof(options) == "table") and options or ui_options
    options.tween_time = 0.1
    
    --// LAYOUT PARAMETERS (YOUR DESIGN)
    local MainWidth = 0.40
    local MainHeight = 0.75
    local SideWidth = 0.15
    local SideHeight = 0.75
    local Gap = 0.025
    
    local MainSize = UDim2.fromScale(MainWidth, MainHeight)
    local MainPos = UDim2.fromScale(0.5, 0.54)
    local SideX = (0.5 - MainWidth/2) - Gap - SideWidth/2
    local SidePos = UDim2.new(SideX, 0, 0.54, 0)
    local SideSize = UDim2.fromScale(SideWidth, SideHeight)
    
    -- Create panels (YOUR DESIGN)
    local MainPanel = CreatePanel("Main_" .. title, MainPos, MainSize, 20, windowCount * 10)
    local SidePanel = CreatePanel("Side_" .. title, SidePos, SideSize, 20, windowCount * 10)
    
    --// HEADER (YOUR DESIGN)
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.AnchorPoint = Vector2.new(0.5, 0)
    Header.Position = UDim2.new(0.5, 0, -0.04, 0)
    Header.Size = UDim2.fromScale(0.5, 0.09)
    Header.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Header.BorderSizePixel = 0
    Header.Parent = MainPanel.Frame
    Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 18)
    
    local HeaderGradient = Instance.new("UIGradient")
    HeaderGradient.Rotation = 90
    HeaderGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(110,45,220)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(176,96,244)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(236,198,255))
    }
    HeaderGradient.Parent = Header
    
    local HeaderMarble = Instance.new("ImageLabel")
    HeaderMarble.Size = UDim2.fromScale(1, 1)
    HeaderMarble.BackgroundTransparency = 1
    HeaderMarble.BorderSizePixel = 0
    HeaderMarble.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=133709037992585&width=678&height=810&format=png"
    HeaderMarble.ImageTransparency = 0.6
    HeaderMarble.ScaleType = Enum.ScaleType.Stretch
    HeaderMarble.Parent = Header
    Instance.new("UICorner", HeaderMarble).CornerRadius = UDim.new(0, 18)
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.AnchorPoint = Vector2.new(0.5, 0.5)
    Title.Position = UDim2.fromScale(0.5, 0.5)
    Title.Size = UDim2.fromScale(0.9, 0.8)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.Bangers
    Title.Text = title:upper()
    Title.TextScaled = true
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Parent = Header
    
    --// CLOSE/MINIMIZE BUTTON (YOUR DESIGN)
    local CloseButton = Instance.new("ImageButton")
    CloseButton.Name = "CloseButton"
    CloseButton.AnchorPoint = Vector2.new(0.5, 0.5)
    CloseButton.Position = UDim2.new(1, 0, 0, 0)
    CloseButton.Size = UDim2.fromOffset(56, 56)
    CloseButton.BackgroundTransparency = 1
    CloseButton.BorderSizePixel = 0
    CloseButton.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=114840795551292&width=678&height=810&format=png"
    CloseButton.ScaleType = Enum.ScaleType.Fit
    CloseButton.ZIndex = 10
    CloseButton.Parent = MainPanel.Frame
    Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(1, 0)
    
    CloseButton.MouseEnter:Connect(function()
        CloseButton:TweenSize(UDim2.fromOffset(62, 62), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
    end)
    CloseButton.MouseLeave:Connect(function()
        CloseButton:TweenSize(UDim2.fromOffset(56, 56), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
    end)
    
    --// MINIMIZED STATE (YOUR DESIGN)
    local MinimizedFrame = Instance.new("ImageButton")
    MinimizedFrame.Name = "MinimizedFrame"
    MinimizedFrame.AnchorPoint = Vector2.new(1, 0)
    MinimizedFrame.Position = UDim2.new(1, -20, 0, 20)
    MinimizedFrame.Size = UDim2.fromOffset(60, 60)
    MinimizedFrame.BackgroundTransparency = 1
    MinimizedFrame.BorderSizePixel = 0
    MinimizedFrame.Visible = false
    MinimizedFrame.ZIndex = 100
    MinimizedFrame.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=103591022804634&width=678&height=810&format=png"
    MinimizedFrame.ScaleType = Enum.ScaleType.Fit
    MinimizedFrame.Parent = imgui
    Instance.new("UICorner", MinimizedFrame).CornerRadius = UDim.new(1, 0)
    
    local MinimizedStroke = Instance.new("UIStroke")
    MinimizedStroke.Color = Color3.fromRGB(255, 255, 255)
    MinimizedStroke.Thickness = 2
    MinimizedStroke.Transparency = 0.3
    MinimizedStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MinimizedStroke.Parent = MinimizedFrame
    
    -- Minimize/Restore functionality (PRESERVED)
    MinimizedFrame.MouseButton1Click:Connect(function()
        MinimizedFrame.Visible = false
        MainPanel.Frame.Visible = true
        MainPanel.Shadow.Visible = true
        SidePanel.Frame.Visible = true
        SidePanel.Shadow.Visible = true
        
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        TweenService:Create(MainPanel.Frame, tweenInfo, {Size = MainSize, Position = MainPos}):Play()
        TweenService:Create(MainPanel.Shadow, tweenInfo, {Size = MainSize, Position = MainPos + UDim2.new(0,0,0,8)}):Play()
        TweenService:Create(SidePanel.Frame, tweenInfo, {Size = SideSize, Position = SidePos}):Play()
        TweenService:Create(SidePanel.Shadow, tweenInfo, {Size = SideSize, Position = SidePos + UDim2.new(0,0,0,8)}):Play()
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        local targetPos = UDim2.new(1, -40, 0, 40)
        local targetSize = UDim2.fromScale(0.05, 0.05)
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
        
        TweenService:Create(MainPanel.Frame, tweenInfo, {Size = targetSize, Position = targetPos}):Play()
        TweenService:Create(MainPanel.Shadow, tweenInfo, {Size = targetSize, Position = targetPos + UDim2.new(0,0,0,8)}):Play()
        TweenService:Create(SidePanel.Frame, tweenInfo, {Size = targetSize, Position = targetPos + UDim2.new(0,0,0,0)}):Play()
        TweenService:Create(SidePanel.Shadow, tweenInfo, {Size = targetSize, Position = targetPos + UDim2.new(0,0,0,8)}):Play()
        
        task.wait(0.3)
        MainPanel.Frame.Visible = false
        MainPanel.Shadow.Visible = false
        SidePanel.Frame.Visible = false
        SidePanel.Shadow.Visible = false
        
        MinimizedFrame.Visible = true
        MinimizedFrame.Size = UDim2.fromOffset(0, 0)
        MinimizedFrame:TweenSize(UDim2.fromOffset(60, 60), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.3, true)
    end)
    
    --// CONTENT CONTAINERS (YOUR DESIGN)
    local MainContent = Instance.new("Frame")
    MainContent.Name = "MainContent"
    MainContent.Size = UDim2.fromScale(0.95, 0.75)
    MainContent.Position = UDim2.fromScale(0.5, 0.52)
    MainContent.AnchorPoint = Vector2.new(0.5, 0)
    MainContent.BackgroundTransparency = 1
    MainContent.Parent = MainPanel.Frame
    
    local SideContent = Instance.new("Frame")
    SideContent.Name = "SideContent"
    SideContent.Size = UDim2.fromScale(0.9, 0.9)
    SideContent.Position = UDim2.fromScale(0.5, 0.5)
    SideContent.AnchorPoint = Vector2.new(0.5, 0.5)
    SideContent.BackgroundTransparency = 1
    SideContent.Parent = SidePanel.Frame
    
    -- Layout for tab buttons in side panel
    local TabButtonsLayout = Instance.new("UIListLayout")
    TabButtonsLayout.Parent = SideContent
    TabButtonsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabButtonsLayout.Padding = UDim.new(0, 8)
    
    -- Layout for main content
    local MainContentLayout = Instance.new("UIListLayout")
    MainContentLayout.Parent = MainContent
    MainContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    MainContentLayout.Padding = UDim.new(0, 5)
    
    --// WINDOW DATA (PRESERVED FUNCTIONALITY)
    local window_data = {}
    local tabs = {}
    local currentTab = nil
    
    function window_data:AddTab(tab_name)
        local tab_data = {}
        tab_name = tostring(tab_name or "New Tab")
        
        -- Create tab button in side panel (YOUR DESIGN)
        local new_button = tabButton:Clone()
        new_button.Parent = SideContent
        new_button.Text = tab_name
        new_button.Size = UDim2.new(1, -10, 0, 35)
        StyleButton(new_button)
        
        -- Create tab content in main panel (YOUR DESIGN)
        local new_tab = Instance.new("Frame")
        new_tab.Name = tab_name
        new_tab.BackgroundTransparency = 1
        new_tab.Size = UDim2.new(1, 0, 1, 0)
        new_tab.Visible = false
        new_tab.Parent = MainContent
        
        -- Layout for tab elements
        local tabLayout = Instance.new("UIListLayout")
        tabLayout.Parent = new_tab
        tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabLayout.Padding = UDim.new(0, 5)
        
        local function show()
            if dropdown_open then return end
            for _, btn in pairs(SideContent:GetChildren()) do
                if btn:IsA("TextButton") and btn ~= TabButtonsLayout then
                    btn.BackgroundTransparency = 0.85
                end
            end
            for _, t in pairs(MainContent:GetChildren()) do
                if t:IsA("Frame") then
                    t.Visible = false
                end
            end
            new_button.BackgroundTransparency = 0.7
            new_tab.Visible = true
        end
        
        new_button.MouseButton1Click:Connect(show)
        
        function tab_data:Show()
            show()
        end
        
        --// TAB ELEMENTS (PRESERVED FUNCTIONALITY WITH YOUR STYLING)
        function tab_data:AddLabel(label_text)
            label_text = tostring(label_text or "New Label")
            local lbl = label:Clone()
            lbl.Parent = new_tab
            lbl.Text = label_text
            lbl.Size = UDim2.new(1, -20, 0, 25)
            lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            return lbl
        end
        
        function tab_data:AddButton(button_text, callback)
            button_text = tostring(button_text or "New Button")
            callback = typeof(callback) == "function" and callback or function() end
            
            local btn = button:Clone()
            btn.Parent = new_tab
            btn.Text = button_text
            btn.Size = UDim2.new(1, -20, 0, 35)
            StyleButton(btn)
            
            btn.MouseButton1Click:Connect(function()
                ripple(btn, UIS:GetMouseLocation().X, UIS:GetMouseLocation().Y)
                pcall(callback)
            end)
            
            return btn
        end
        
        function tab_data:AddSwitch(switch_text, callback)
            local switch_data = {}
            switch_text = tostring(switch_text or "New Switch")
            callback = typeof(callback) == "function" and callback or function() end
            
            local switchFrame = Instance.new("Frame")
            switchFrame.Size = UDim2.new(1, -20, 0, 35)
            switchFrame.BackgroundTransparency = 1
            switchFrame.Parent = new_tab
            
            local sw = switchButton:Clone()
            sw.Parent = switchFrame
            sw.Position = UDim2.new(0, 0, 0.5, -20)
            StyleButton(sw)
            
            local title = switchTitle:Clone()
            title.Parent = switchFrame
            title.Text = switch_text
            title.Position = UDim2.new(0, 50, 0, 0)
            title.Size = UDim2.new(1, -60, 1, 0)
            
            local toggled = false
            sw.MouseButton1Click:Connect(function()
                toggled = not toggled
                sw.Text = toggled and utf8.char(10003) or ""
                pcall(callback, toggled)
            end)
            
            function switch_data:Set(bool)
                toggled = (typeof(bool) == "boolean") and bool or false
                sw.Text = toggled and utf8.char(10003) or ""
                pcall(callback, toggled)
            end
            
            return switch_data, switchFrame
        end
        
        function tab_data:AddTextBox(textbox_text, callback, textbox_options)
            textbox_text = tostring(textbox_text or "New TextBox")
            callback = typeof(callback) == "function" and callback or function() end
            textbox_options = typeof(textbox_options) == "table" and textbox_options or {["clear"] = true}
            textbox_options = {
                ["clear"] = ((textbox_options.clear) == true)
            }
            
            local tb = textBox:Clone()
            tb.Parent = new_tab
            tb.PlaceholderText = textbox_text
            StyleTextBox(tb)
            
            tb.FocusLost:Connect(function(ep)
                if ep then
                    if #tb.Text > 0 then
                        pcall(callback, tb.Text)
                        if textbox_options.clear then
                            tb.Text = ""
                        end
                    end
                end
            end)
            
            return tb
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
            
            local sl = slider:Clone()
            sl.Parent = new_tab
            StyleSlider(sl)
            
            local title = sl:FindFirstChild("Title")
            local indicator = sl:FindFirstChild("Indicator")
            local value = sl:FindFirstChild("Value")
            
            title.Text = slider_text
            indicator.Size = UDim2.new(0, 0, 1, 0)
            
            local Entered = false
            sl.MouseEnter:Connect(function()
                Entered = true
            end)
            sl.MouseLeave:Connect(function()
                Entered = false
            end)
            
            local Held = false
            UIS.InputBegan:Connect(function(inputObject)
                if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
                    Held = true
                    spawn(function()
                        if Entered and not slider_options.readonly then
                            while Held and (not dropdown_open) do
                                local mouse_location = gMouse()
                                local x = (sl.AbsoluteSize.X - (sl.AbsoluteSize.X - ((mouse_location.X - sl.AbsolutePosition.X)) + 1)) / sl.AbsoluteSize.X
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
                                Resize(indicator, {Size = UDim2.new(size or min, 0, 1, 0)}, options.tween_time)
                                local p = math.floor((size or min) * 100)
                                local maxv = slider_options.max
                                local minv = slider_options.min
                                local diff = maxv - minv
                                local sel_value = math.floor(((diff / 100) * p) + minv)
                                value.Text = tostring(sel_value)
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
                Resize(indicator, {Size = UDim2.new(new_value or 0, 0, 1, 0)}, options.tween_time)
                local p = math.floor((new_value or 0) * 100)
                local maxv = slider_options.max
                local minv = slider_options.min
                local diff = maxv - minv
                local sel_value = math.floor(((diff / 100) * p) + minv)
                value.Text = tostring(sel_value)
                pcall(callback, sel_value)
            end
            
            slider_data:Set(slider_options["min"])
            return slider_data, sl
        end
        
        function tab_data:AddKeybind(keybind_name, callback, keybind_options)
            local keybind_data = {}
            keybind_name = tostring(keybind_name or "New Keybind")
            callback = typeof(callback) == "function" and callback or function() end
            keybind_options = typeof(keybind_options) == "table" and keybind_options or {}
            keybind_options = {
                ["standard"] = keybind_options.standard or Enum.KeyCode.RightShift,
            }
            
            local kb = keybind:Clone()
            local input = kb:FindFirstChild("Input")
            local title = kb:FindFirstChild("Title")
            
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
            
            local dd = dropdown:Clone()
            dd.Parent = new_tab
            
            local btn = dd:FindFirstChild("DropdownButton")
            local box = dd:FindFirstChild("Box")
            local objects = box:FindFirstChild("Objects")
            
            btn.Text = dropdown_name
            box.Size = UDim2.new(1, 0, 0, 0)
            
            local open = false
            btn.MouseButton1Click:Connect(function()
                open = not open
                local len = (#objects:GetChildren() - 1) * 30
                if #objects:GetChildren() - 1 >= 10 then
                    len = 10 * 30
                    objects.CanvasSize = UDim2.new(0, 0, (#objects:GetChildren() - 1) * 0.1, 0)
                end
                if open then
                    if dropdown_open then return end
                    dropdown_open = true
                    Resize(box, {Size = UDim2.new(1, 0, 0, len)}, options.tween_time)
                else
                    dropdown_open = false
                    Resize(box, {Size = UDim2.new(1, 0, 0, 0)}, options.tween_time)
                end
            end)
            
            function dropdown_data:Add(n)
                local object_data = {}
                n = tostring(n or "New Object")
                
                local object = dropdownOption:Clone()
                object.Parent = objects
                object.Text = n
                
                object.MouseEnter:Connect(function()
                    object.BackgroundTransparency = 0.8
                end)
                object.MouseLeave:Connect(function()
                    object.BackgroundTransparency = 0.9
                end)
                
                if open then
                    local len = (#objects:GetChildren() - 1) * 30
                    if #objects:GetChildren() - 1 >= 10 then
                        len = 10 * 30
                        objects.CanvasSize = UDim2.new(0, 0, (#objects:GetChildren() - 1) * 0.1, 0)
                    end
                    Resize(box, {Size = UDim2.new(1, 0, 0, len)}, options.tween_time)
                end
                
                object.MouseButton1Click:Connect(function()
                    if dropdown_open then
                        btn.Text = n
                        dropdown_open = false
                        open = false
                        Resize(box, {Size = UDim2.new(1, 0, 0, 0)}, options.tween_time)
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
            
            local cp = colorPicker:Clone()
            cp.Parent = new_tab
            
            local palette = cp:FindFirstChild("Palette")
            local sample = cp:FindFirstChild("Sample")
            local saturation = cp:FindFirstChild("Saturation")
            local palette_indicator = palette:FindFirstChild("Indicator")
            local saturation_indicator = saturation:FindFirstChild("Indicator")
            
            local h = 0
            local s = 1
            local v = 1
            
            local function update()
                local color = Color3.fromHSV(h, s, v)
                sample.ImageColor3 = color
                saturation.ImageColor3 = Color3.fromHSV(h, 1, 1)
                pcall(callback, color)
            end
            
            -- Initialize
            local color = Color3.fromHSV(h, s, v)
            sample.ImageColor3 = color
            saturation.ImageColor3 = Color3.fromHSV(h, 1, 1)
            
            local Entered1, Entered2 = false, false
            
            palette.MouseEnter:Connect(function()
                Entered1 = true
            end)
            palette.MouseLeave:Connect(function()
                Entered1 = false
            end)
            saturation.MouseEnter:Connect(function()
                Entered2 = true
            end)
            saturation.MouseLeave:Connect(function()
                Entered2 = false
            end)
            
            local Held = false
            UIS.InputBegan:Connect(function(inputObject)
                if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
                    Held = true
                    spawn(function()
                        while Held and Entered1 and (not dropdown_open) do
                            local mouse_location = gMouse()
                            local x = ((palette.AbsoluteSize.X - (mouse_location.X - palette.AbsolutePosition.X)) + 1)
                            local y = ((palette.AbsoluteSize.Y - (mouse_location.Y - palette.AbsolutePosition.Y)) + 1.5)
                            h = x / 100
                            s = y / 100
                            Resize(palette_indicator, {Position = UDim2.new(0, math.abs(x - 100) - (palette_indicator.AbsoluteSize.X / 2), 0, math.abs(y - 100) - (palette_indicator.AbsoluteSize.Y / 2))}, options.tween_time)
                            update()
                            RS.Heartbeat:Wait()
                        end
                        while Held and Entered2 and (not dropdown_open) do
                            local mouse_location = gMouse()
                            local y = ((palette.AbsoluteSize.Y - (mouse_location.Y - palette.AbsolutePosition.Y)) + 1.5)
                            v = y / 100
                            Resize(saturation_indicator, {Position = UDim2.new(0, 0, 0, math.abs(y - 100))}, options.tween_time)
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
                sample.ImageColor3 = color
                saturation.ImageColor3 = Color3.fromHSV(h2, 1, 1)
                pcall(callback, color)
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
            
            local con = console:Clone()
            con.Parent = new_tab
            con.Size = UDim2.new(1, -20, console_options.full and 1 or 0, console_options.y)
            
            local sf = con:FindFirstChildOfClass("ScrollingFrame")
            local Source = sf:FindFirstChild("Source")
            local Lines = sf:FindFirstChild("Lines")
            
            Source.TextEditable = not console_options.readonly
            
            -- Copy syntax highlighting labels
            for _, name in pairs({"Comments", "Globals", "Keywords", "RemoteHighlight", "Strings", "Tokens", "Numbers", "Info"}) do
                local existingLabel = Source:FindFirstChild(name)
                if not existingLabel then
                    local newLabel = Instance.new("TextLabel")
                    newLabel.Name = name
                    newLabel.BackgroundTransparency = 1
                    newLabel.Size = UDim2.new(1, 0, 1, 0)
                    newLabel.ZIndex = 5
                    newLabel.Font = Enum.Font.Code
                    newLabel.Text = ""
                    newLabel.TextSize = 15
                    newLabel.TextXAlignment = Enum.TextXAlignment.Left
                    newLabel.TextYAlignment = Enum.TextYAlignment.Top
                    newLabel.Parent = Source
                    
                    local colors = {
                        Comments = Color3.fromRGB(59, 200, 59),
                        Globals = Color3.fromRGB(132, 214, 247),
                        Keywords = Color3.fromRGB(248, 109, 124),
                        RemoteHighlight = Color3.fromRGB(0, 145, 255),
                        Strings = Color3.fromRGB(173, 241, 149),
                        Tokens = Color3.fromRGB(255, 255, 255),
                        Numbers = Color3.fromRGB(255, 198, 0),
                        Info = Color3.fromRGB(0, 162, 255),
                    }
                    newLabel.TextColor3 = colors[name] or Color3.fromRGB(255, 255, 255)
                end
            end
            
            -- Syntax highlighting logic (PRESERVED FROM ORIGINAL)
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
            
            local highlight_logs = function(type)
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
            
            return console_data, con
        end
        
        function tab_data:AddHorizontalAlignment()
            local ha_data = {}
            local ha = Instance.new("Frame")
            ha.Size = UDim2.new(1, -20, 0, 35)
            ha.BackgroundTransparency = 1
            ha.Parent = new_tab
            
            local layout = Instance.new("UIListLayout")
            layout.FillDirection = Enum.FillDirection.Horizontal
            layout.SortOrder = Enum.SortOrder.LayoutOrder
            layout.Padding = UDim.new(0, 5)
            layout.Parent = ha
            
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
            
            local folderFrame = Instance.new("Frame")
            folderFrame.Size = UDim2.new(1, -20, 0, 35)
            folderFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            folderFrame.BackgroundTransparency = 0.85
            folderFrame.BorderSizePixel = 0
            folderFrame.ClipsDescendants = true
            folderFrame.Parent = new_tab
            Instance.new("UICorner", folderFrame).CornerRadius = UDim.new(0, 8)
            
            local folderButton = Instance.new("TextButton")
            folderButton.Size = UDim2.new(1, 0, 0, 35)
            folderButton.BackgroundTransparency = 1
            folderButton.Font = Enum.Font.GothamBold
            folderButton.Text = " " .. folder_name
            folderButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            folderButton.TextSize = 14
            folderButton.TextXAlignment = Enum.TextXAlignment.Left
            folderButton.Parent = folderFrame
            
            local objects = Instance.new("Frame")
            objects.Name = "Objects"
            objects.BackgroundTransparency = 1
            objects.Position = UDim2.new(0, 10, 0, 40)
            objects.Size = UDim2.new(1, -10, 1, -40)
            objects.Visible = false            objects.Parent = folderFrame
            
            local objectsLayout = Instance.new("UIListLayout")
            objectsLayout.Parent = objects
            objectsLayout.SortOrder = Enum.SortOrder.LayoutOrder
            objectsLayout.Padding = UDim.new(0, 5)
            
            local open = false
            
            local function gFolderLen()
                local n = 40
                for i, v in pairs(objects:GetChildren()) do
                    if not (v:IsA("UIListLayout")) then
                        n = n + v.AbsoluteSize.Y + 5
                    end
                end
                return n
            end
            
            folderButton.MouseButton1Click:Connect(function()
                open = not open
                if open then
                    objects.Visible = true
                else
                    objects.Visible = false
                end
            end)
            
            spawn(function()
                while true do
                    Resize(folderFrame, {Size = UDim2.new(1, -20, 0, (open and gFolderLen() or 35))}, options.tween_time)
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
                        object.Parent = objects
                        return data, object
                    else
                        object = ret[1]
                        object.Parent = objects
                        return object
                    end
                end
            end
            
            return folder_data, folderFrame
        end
        
        table.insert(tabs, {button = new_button, tab = new_tab, data = tab_data})
        
        -- Show first tab by default
        if #tabs == 1 then
            show()
        end
        
        return tab_data, new_tab
    end
    
    table.insert(windows, {
        window_data = window_data,
        MainPanel = MainPanel,
        SidePanel = SidePanel,
        MinimizedFrame = MinimizedFrame
    })
    
    return window_data
end

return library
