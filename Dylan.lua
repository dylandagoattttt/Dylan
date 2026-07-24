local a = {
    main_color = Color3.fromRGB(255, 50, 50),
    min_size = Vector2.new(400, 300),
    toggle_key = Enum.KeyCode.RightShift,
    can_resize = true
}

do
    local b = game:GetService("CoreGui"):FindFirstChild("imgui")
    if b then b:Destroy() end
end

local b = Instance.new("ScreenGui")
local c = Instance.new("Frame")
local d = Instance.new("TextLabel")
local e = Instance.new("Frame")        -- Window prefab
local f = Instance.new("Frame")        -- Resizer
local g = Instance.new("Frame")        -- Top bar
local h = Instance.new("ImageButton")  -- Close button (minimize)
local i = Instance.new("ImageLabel")   -- Icon
local j = Instance.new("ImageLabel")   -- (unused)
local k = Instance.new("Frame")        -- Tabs sidebar container
local l = Instance.new("TextLabel")    -- Title
local m = Instance.new("ImageLabel")   -- (unused)
local n = Instance.new("Frame")        -- Tab buttons container
local o = Instance.new("UIListLayout") -- Tab list layout
local p = Instance.new("Frame")        -- (unused)
local q = Instance.new("ScrollingFrame") -- Tab content prefab
local r = Instance.new("UIListLayout") -- Content list layout
local s = Instance.new("TextBox")
local t = Instance.new("ImageLabel")
local u = Instance.new("ImageLabel")
local v = Instance.new("TextLabel")
local w = Instance.new("ImageLabel")
local x = Instance.new("TextLabel")
local y = Instance.new("TextLabel")
local z = Instance.new("TextLabel")
local A = Instance.new("ImageLabel")
local B = Instance.new("UIListLayout")
local C = Instance.new("TextButton")
local D = Instance.new("ImageLabel")
local E = Instance.new("ImageButton")
local F = Instance.new("ScrollingFrame")
local G = Instance.new("UIListLayout")
local H = Instance.new("ImageLabel")
local I = Instance.new("TextButton")
local J = Instance.new("ImageLabel")
local K = Instance.new("ImageLabel")
local L = Instance.new("TextButton")
local M = Instance.new("ImageLabel")
local N = Instance.new("ImageLabel")
local O = Instance.new("Frame")
local P = Instance.new("UIListLayout")
local Q = Instance.new("Frame")
local R = Instance.new("UIListLayout")
local S = Instance.new("ImageLabel")
local T = Instance.new("ScrollingFrame")
local U = Instance.new("TextBox")
local V = Instance.new("TextLabel")
local W = Instance.new("TextLabel")
local X = Instance.new("TextLabel")
local Y = Instance.new("TextLabel")
local Z = Instance.new("TextLabel")
local _ = Instance.new("TextLabel")
local a0 = Instance.new("TextLabel")
local a1 = Instance.new("TextLabel")
local a2 = Instance.new("TextLabel")
local a3 = Instance.new("ImageLabel")
local a4 = Instance.new("ImageLabel")
local a5 = Instance.new("ImageLabel")
local a6 = Instance.new("ImageLabel")
local a7 = Instance.new("ImageLabel")
local a8 = Instance.new("Frame")
local a9 = Instance.new("TextButton")
local aa = Instance.new("ImageLabel")
local ab = Instance.new("TextLabel")
local ac = Instance.new("TextButton")
local ad = Instance.new("ImageLabel")
local ae = Instance.new("TextButton")
local af = Instance.new("ImageLabel")
local ag = Instance.new("TextLabel")
local ah = Instance.new("TextButton")
local ai = Instance.new("ImageLabel")
local aj = Instance.new("Frame")        -- Windows container

b.Name = "imgui"
b.Parent = game:GetService("CoreGui") or gethui()

-- Windows container
aj.Name = "Windows"
aj.Parent = b
aj.BackgroundColor3 = Color3.new(1, 1, 1)
aj.BackgroundTransparency = 1
aj.Position = UDim2.new(0, 20, 0, 20)
aj.Size = UDim2.new(1, 20, 1, -20)

c.Name = "Prefabs"
c.Parent = b
c.BackgroundColor3 = Color3.new(1, 1, 1)
c.Size = UDim2.new(0, 100, 0, 100)
c.Visible = false

-- ====== Antora-style Window prefab ======
e.Name = "Window"
e.Parent = c
e.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
e.BackgroundTransparency = 0.05
e.ClipsDescendants = true
e.Position = UDim2.new(0, 20, 0, 20)
e.Size = UDim2.new(0, 540, 0, 350)

f.Name = "Resizer"
f.Parent = e
f.Active = true
f.BackgroundColor3 = Color3.new(1, 1, 1)
f.BackgroundTransparency = 1
f.BorderSizePixel = 0
f.Position = UDim2.new(1, -20, 1, -20)
f.Size = UDim2.new(0, 20, 0, 20)

g.Name = "Bar"
g.Parent = e
g.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
g.BackgroundTransparency = 0
g.BorderSizePixel = 0
g.Position = UDim2.new(0, 0, 0, 0)
g.Size = UDim2.new(1, 0, 0, 28)

local barGrad = Instance.new("UIGradient")
barGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 150, 150)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 0, 0))
})
barGrad.Rotation = 90
barGrad.Parent = g

h.Name = "CloseButton"
h.Parent = g
h.BackgroundTransparency = 1
h.AnchorPoint = Vector2.new(1, 0.5)
h.Position = UDim2.new(1, -8, 0.5, 0)
h.Size = UDim2.new(0, 24, 0, 24)
h.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=118561288885971&width=300&height=300&format=png"
h.ScaleType = Enum.ScaleType.Fit

i.Name = "Icon"
i.Parent = g
i.BackgroundTransparency = 1
i.Position = UDim2.new(0, 8, 0.5, 0)
i.AnchorPoint = Vector2.new(0, 0.5)
i.Size = UDim2.new(0, 20, 0, 20)
i.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=84595542654454&width=678&height=810&format=png"

l.Name = "Title"
l.Parent = g
l.BackgroundTransparency = 1
l.Position = UDim2.new(0, 32, 0.5, 0)
l.AnchorPoint = Vector2.new(0, 0.5)
l.Size = UDim2.new(0, 0, 0, 20)
l.AutomaticSize = Enum.AutomaticSize.XY
l.Font = Enum.Font.Creepster
l.Text = "Antora Library"
l.TextColor3 = Color3.fromRGB(243, 243, 243)
l.TextSize = 14
l.TextXAlignment = Enum.TextXAlignment.Left

local subTitle = Instance.new("TextLabel")
subTitle.Name = "SubTitle"
subTitle.Parent = l
subTitle.BackgroundTransparency = 1
subTitle.AutomaticSize = Enum.AutomaticSize.X
subTitle.AnchorPoint = Vector2.new(0, 1)
subTitle.Position = UDim2.new(1, 5, 0.9, 0)
subTitle.Font = Enum.Font.Creepster
subTitle.Text = "by: unkinou"
subTitle.TextColor3 = Color3.fromRGB(80, 80, 80)
subTitle.TextSize = 10
subTitle.TextXAlignment = Enum.TextXAlignment.Left
subTitle.TextYAlignment = Enum.TextYAlignment.Bottom

k.Name = "Tabs"
k.Parent = e
k.BackgroundTransparency = 1
k.Position = UDim2.new(0, 0, 1, 0)
k.AnchorPoint = Vector2.new(0, 1)
k.Size = UDim2.new(0, 150, 1, -28)

local tabScroll = Instance.new("ScrollingFrame")
tabScroll.Name = "TabScroll"
tabScroll.Parent = k
tabScroll.BackgroundTransparency = 1
tabScroll.Size = UDim2.new(1, 0, 1, 0)
tabScroll.CanvasSize = UDim2.new()
tabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
tabScroll.ScrollBarThickness = 2
tabScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
tabScroll.ScrollBarImageTransparency = 0.5
tabScroll.BorderSizePixel = 0

local tabPad = Instance.new("UIPadding")
tabPad.PaddingLeft = UDim.new(0, 8)
tabPad.PaddingRight = UDim.new(0, 8)
tabPad.PaddingTop = UDim.new(0, 10)
tabPad.PaddingBottom = UDim.new(0, 10)
tabPad.Parent = tabScroll

o.Name = "TabList"
o.Parent = tabScroll
o.Padding = UDim.new(0, 5)

local contentContainer = Instance.new("Frame")
contentContainer.Name = "Content"
contentContainer.Parent = e
contentContainer.BackgroundTransparency = 1
contentContainer.Position = UDim2.new(0, 150, 0, 28)
contentContainer.Size = UDim2.new(1, -150, 1, -28)
contentContainer.ClipsDescendants = true

-- Tab content prefab (ScrollingFrame)
q.Name = "Tab"
q.Parent = c
q.BackgroundTransparency = 1
q.Size = UDim2.new(1, 0, 1, 0)
q.Visible = false
q.ScrollBarThickness = 2
q.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
q.ScrollBarImageTransparency = 0.5
q.AutomaticCanvasSize = Enum.AutomaticSize.Y
q.CanvasSize = UDim2.new()
q.BorderSizePixel = 0

r.Name = "UIListLayout"
r.Parent = q
r.SortOrder = Enum.SortOrder.LayoutOrder
r.Padding = UDim.new(0, 5)

local contentPad = Instance.new("UIPadding")
contentPad.Parent = q
contentPad.PaddingLeft = UDim.new(0, 10)
contentPad.PaddingRight = UDim.new(0, 10)
contentPad.PaddingTop = UDim.new(0, 10)
contentPad.PaddingBottom = UDim.new(0, 10)

-- ====== Prefabs (Label, TextBox, etc.) ======
d.Name = "Label"
d.Parent = c
d.BackgroundColor3 = Color3.new(1, 1, 1)
d.BackgroundTransparency = 1
d.Size = UDim2.new(0, 200, 0, 20)
d.Font = Enum.Font.GothamSemibold
d.Text = "Hello, world 123"
d.TextColor3 = Color3.fromRGB(243, 243, 243)
d.TextSize = 14
d.TextXAlignment = Enum.TextXAlignment.Left

s.Parent = c
s.BackgroundColor3 = Color3.new(1, 1, 1)
s.BackgroundTransparency = 1
s.BorderSizePixel = 0
s.Size = UDim2.new(1, 0, 0, 20)
s.ZIndex = 2
s.Font = Enum.Font.GothamSemibold
s.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
s.PlaceholderText = "Input Text"
s.Text = ""
s.TextColor3 = Color3.fromRGB(243, 243, 243)
s.TextSize = 14

t.Name = "TextBox_Roundify_4px"
t.Parent = s
t.BackgroundColor3 = Color3.new(1, 1, 1)
t.BackgroundTransparency = 1
t.Size = UDim2.new(1, 0, 1, 0)
t.Image = "rbxassetid://2851929490"
t.ImageColor3 = Color3.fromRGB(40, 40, 40)
t.ScaleType = Enum.ScaleType.Slice
t.SliceCenter = Rect.new(4, 4, 4, 4)

u.Name = "Slider"
u.Parent = c
u.BackgroundColor3 = Color3.new(1, 1, 1)
u.BackgroundTransparency = 1
u.Position = UDim2.new(0, 0, 0.178571433, 0)
u.Size = UDim2.new(1, 0, 0, 20)
u.Image = "rbxassetid://2851929490"
u.ImageColor3 = Color3.fromRGB(40, 40, 40)
u.ScaleType = Enum.ScaleType.Slice
u.SliceCenter = Rect.new(4, 4, 4, 4)

v.Name = "Title"
v.Parent = u
v.BackgroundColor3 = Color3.new(1, 1, 1)
v.BackgroundTransparency = 1
v.Position = UDim2.new(0.5, 0, 0.5, -10)
v.Size = UDim2.new(0, 0, 0, 20)
v.ZIndex = 2
v.Font = Enum.Font.GothamBold
v.Text = "Slider"
v.TextColor3 = Color3.fromRGB(243, 243, 243)
v.TextSize = 14

w.Name = "Indicator"
w.Parent = u
w.BackgroundColor3 = Color3.new(1, 1, 1)
w.BackgroundTransparency = 1
w.Size = UDim2.new(0, 0, 0, 20)
w.Image = "rbxassetid://2851929490"
w.ImageColor3 = Color3.fromRGB(255, 50, 50)
w.ScaleType = Enum.ScaleType.Slice
w.SliceCenter = Rect.new(4, 4, 4, 4)

x.Name = "Value"
x.Parent = u
x.BackgroundColor3 = Color3.new(1, 1, 1)
x.BackgroundTransparency = 1
x.Position = UDim2.new(1, -55, 0.5, -10)
x.Size = UDim2.new(0, 50, 0, 20)
x.Font = Enum.Font.GothamBold
x.Text = "0%"
x.TextColor3 = Color3.fromRGB(243, 243, 243)
x.TextSize = 14

y.Parent = u
y.BackgroundColor3 = Color3.new(1, 1, 1)
y.BackgroundTransparency = 1
y.Position = UDim2.new(1, -20, -0.75, 0)
y.Size = UDim2.new(0, 26, 0, 50)
y.Font = Enum.Font.GothamBold
y.Text = "]"
y.TextColor3 = Color3.fromRGB(180, 180, 180)
y.TextSize = 14

z.Parent = u
z.BackgroundColor3 = Color3.new(1, 1, 1)
z.BackgroundTransparency = 1
z.Position = UDim2.new(1, -65, -0.75, 0)
z.Size = UDim2.new(0, 26, 0, 50)
z.Font = Enum.Font.GothamBold
z.Text = "["
z.TextColor3 = Color3.fromRGB(180, 180, 180)
z.TextSize = 14

A.Name = "Circle"
A.Parent = c
A.BackgroundColor3 = Color3.new(1, 1, 1)
A.BackgroundTransparency = 1
A.Image = "rbxassetid://266543268"
A.ImageTransparency = 0.5

B.Parent = c
B.FillDirection = Enum.FillDirection.Horizontal
B.SortOrder = Enum.SortOrder.LayoutOrder
B.Padding = UDim.new(0, 20)

C.Name = "Dropdown"
C.Parent = c
C.BackgroundColor3 = Color3.new(1, 1, 1)
C.BackgroundTransparency = 1
C.BorderSizePixel = 0
C.Position = UDim2.new(-0.055555556, 0, 0.0833333284, 0)
C.Size = UDim2.new(0, 200, 0, 20)
C.ZIndex = 2
C.Font = Enum.Font.GothamBold
C.Text = "      Dropdown"
C.TextColor3 = Color3.fromRGB(243, 243, 243)
C.TextSize = 14
C.TextXAlignment = Enum.TextXAlignment.Left

D.Name = "Indicator"
D.Parent = C
D.BackgroundColor3 = Color3.new(1, 1, 1)
D.BackgroundTransparency = 1
D.Position = UDim2.new(0.899999976, -10, 0.100000001, 0)
D.Rotation = -90
D.Size = UDim2.new(0, 15, 0, 15)
D.ZIndex = 2
D.Image = "https://www.roblox.com/Thumbs/Asset.ashx?width=420&height=420&assetId=4744658743"

E.Name = "Box"
E.Parent = C
E.BackgroundColor3 = Color3.new(1, 1, 1)
E.BackgroundTransparency = 1
E.Position = UDim2.new(0, 0, 0, 25)
E.Size = UDim2.new(1, 0, 0, 150)
E.ZIndex = 3
E.Image = "rbxassetid://2851929490"
E.ImageColor3 = Color3.fromRGB(20, 20, 20)
E.ScaleType = Enum.ScaleType.Slice
E.SliceCenter = Rect.new(4, 4, 4, 4)

F.Name = "Objects"
F.Parent = E
F.BackgroundColor3 = Color3.new(1, 1, 1)
F.BackgroundTransparency = 1
F.BorderSizePixel = 0
F.Size = UDim2.new(1, 0, 1, 0)
F.ZIndex = 3
F.CanvasSize = UDim2.new(0, 0, 0, 0)
F.ScrollBarThickness = 8

G.Parent = F
G.SortOrder = Enum.SortOrder.LayoutOrder

H.Name = "TextButton_Roundify_4px"
H.Parent = C
H.BackgroundColor3 = Color3.new(1, 1, 1)
H.BackgroundTransparency = 1
H.Size = UDim2.new(1, 0, 1, 0)
H.Image = "rbxassetid://2851929490"
H.ImageColor3 = Color3.fromRGB(40, 40, 40)
H.ScaleType = Enum.ScaleType.Slice
H.SliceCenter = Rect.new(4, 4, 4, 4)

I.Name = "TabButton"
I.Parent = c
I.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
I.BackgroundTransparency = 1
I.BorderSizePixel = 0
I.Position = UDim2.new(0.185185179, 0, 0, 0)
I.Size = UDim2.new(0, 71, 0, 20)
I.ZIndex = 2
I.Font = Enum.Font.GothamSemibold
I.Text = "Test tab"
I.TextColor3 = Color3.fromRGB(243, 243, 243)
I.TextSize = 14

J.Name = "TextButton_Roundify_4px"
J.Parent = I
J.BackgroundColor3 = Color3.new(1, 1, 1)
J.BackgroundTransparency = 1
J.Size = UDim2.new(1, 0, 1, 0)
J.Image = "rbxassetid://2851929490"
J.ImageColor3 = Color3.fromRGB(40, 40, 40)
J.ScaleType = Enum.ScaleType.Slice
J.SliceCenter = Rect.new(4, 4, 4, 4)

K.Name = "Folder"
K.Parent = c
K.BackgroundColor3 = Color3.new(1, 1, 1)
K.BackgroundTransparency = 1
K.Position = UDim2.new(0, 0, 0, 50)
K.Size = UDim2.new(1, 0, 0, 20)
K.Image = "rbxassetid://2851929490"
K.ImageColor3 = Color3.fromRGB(20, 20, 20)
K.ScaleType = Enum.ScaleType.Slice
K.SliceCenter = Rect.new(4, 4, 4, 4)

L.Name = "Button"
L.Parent = K
L.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
L.BackgroundTransparency = 1
L.BorderSizePixel = 0
L.Size = UDim2.new(1, 0, 0, 20)
L.ZIndex = 2
L.Font = Enum.Font.GothamSemibold
L.Text = "      Folder"
L.TextColor3 = Color3.fromRGB(243, 243, 243)
L.TextSize = 14
L.TextXAlignment = Enum.TextXAlignment.Left

M.Name = "TextButton_Roundify_4px"
M.Parent = L
M.BackgroundColor3 = Color3.new(1, 1, 1)
M.BackgroundTransparency = 1
M.Size = UDim2.new(1, 0, 1, 0)
M.Image = "rbxassetid://2851929490"
M.ImageColor3 = Color3.fromRGB(255, 50, 50)
M.ScaleType = Enum.ScaleType.Slice
M.SliceCenter = Rect.new(4, 4, 4, 4)

N.Name = "Toggle"
N.Parent = L
N.BackgroundColor3 = Color3.new(1, 1, 1)
N.BackgroundTransparency = 1
N.Position = UDim2.new(0, 5, 0, 0)
N.Size = UDim2.new(0, 20, 0, 20)
N.Image = "https://www.roblox.com/Thumbs/Asset.ashx?width=420&height=420&assetId=4731371541"

O.Name = "Objects"
O.Parent = K
O.BackgroundColor3 = Color3.new(1, 1, 1)
O.BackgroundTransparency = 1
O.Position = UDim2.new(0, 10, 0, 25)
O.Size = UDim2.new(1, -10, 1, -25)
O.Visible = false

P.Parent = O
P.SortOrder = Enum.SortOrder.LayoutOrder
P.Padding = UDim.new(0, 5)

Q.Name = "HorizontalAlignment"
Q.Parent = c
Q.BackgroundColor3 = Color3.new(1, 1, 1)
Q.BackgroundTransparency = 1
Q.Size = UDim2.new(1, 0, 0, 20)

R.Parent = Q
R.FillDirection = Enum.FillDirection.Horizontal
R.SortOrder = Enum.SortOrder.LayoutOrder
R.Padding = UDim.new(0, 5)

S.Name = "Console"
S.Parent = c
S.BackgroundColor3 = Color3.new(1, 1, 1)
S.BackgroundTransparency = 1
S.Size = UDim2.new(1, 0, 0, 200)
S.Image = "rbxassetid://2851928141"
S.ImageColor3 = Color3.fromRGB(20, 20, 20)
S.ScaleType = Enum.ScaleType.Slice
S.SliceCenter = Rect.new(8, 8, 8, 8)

T.Parent = S
T.BackgroundColor3 = Color3.new(1, 1, 1)
T.BackgroundTransparency = 1
T.BorderSizePixel = 0
T.Size = UDim2.new(1, 0, 1, 1)
T.CanvasSize = UDim2.new(0, 0, 0, 0)
T.ScrollBarThickness = 4

U.Name = "Source"
U.Parent = T
U.BackgroundColor3 = Color3.new(1, 1, 1)
U.BackgroundTransparency = 1
U.Position = UDim2.new(0, 40, 0, 0)
U.Size = UDim2.new(1, -40, 0, 10000)
U.ZIndex = 3
U.ClearTextOnFocus = false
U.Font = Enum.Font.Code
U.MultiLine = true
U.PlaceholderColor3 = Color3.new(0.8, 0.8, 0.8)
U.Text = ""
U.TextColor3 = Color3.fromRGB(243, 243, 243)
U.TextSize = 15
U.TextStrokeColor3 = Color3.new(1, 1, 1)
U.TextWrapped = true
U.TextXAlignment = Enum.TextXAlignment.Left
U.TextYAlignment = Enum.TextYAlignment.Top

V.Name = "Comments"
V.Parent = U
V.BackgroundColor3 = Color3.new(1, 1, 1)
V.BackgroundTransparency = 1
V.Size = UDim2.new(1, 0, 1, 0)
V.ZIndex = 5
V.Font = Enum.Font.Code
V.Text = ""
V.TextColor3 = Color3.new(0.231373, 0.784314, 0.231373)
V.TextSize = 15
V.TextXAlignment = Enum.TextXAlignment.Left
V.TextYAlignment = Enum.TextYAlignment.Top

W.Name = "Globals"
W.Parent = U
W.BackgroundColor3 = Color3.new(1, 1, 1)
W.BackgroundTransparency = 1
W.Size = UDim2.new(1, 0, 1, 0)
W.ZIndex = 5
W.Font = Enum.Font.Code
W.Text = ""
W.TextColor3 = Color3.new(0.517647, 0.839216, 0.968628)
W.TextSize = 15
W.TextXAlignment = Enum.TextXAlignment.Left
W.TextYAlignment = Enum.TextYAlignment.Top

X.Name = "Keywords"
X.Parent = U
X.BackgroundColor3 = Color3.new(1, 1, 1)
X.BackgroundTransparency = 1
X.Size = UDim2.new(1, 0, 1, 0)
X.ZIndex = 5
X.Font = Enum.Font.Code
X.Text = ""
X.TextColor3 = Color3.new(0.972549, 0.427451, 0.486275)
X.TextSize = 15
X.TextXAlignment = Enum.TextXAlignment.Left
X.TextYAlignment = Enum.TextYAlignment.Top

Y.Name = "RemoteHighlight"
Y.Parent = U
Y.BackgroundColor3 = Color3.new(1, 1, 1)
Y.BackgroundTransparency = 1
Y.Size = UDim2.new(1, 0, 1, 0)
Y.ZIndex = 5
Y.Font = Enum.Font.Code
Y.Text = ""
Y.TextColor3 = Color3.new(0, 0.568627, 1)
Y.TextSize = 15
Y.TextXAlignment = Enum.TextXAlignment.Left
Y.TextYAlignment = Enum.TextYAlignment.Top

Z.Name = "Strings"
Z.Parent = U
Z.BackgroundColor3 = Color3.new(1, 1, 1)
Z.BackgroundTransparency = 1
Z.Size = UDim2.new(1, 0, 1, 0)
Z.ZIndex = 5
Z.Font = Enum.Font.Code
Z.Text = ""
Z.TextColor3 = Color3.new(0.678431, 0.945098, 0.584314)
Z.TextSize = 15
Z.TextXAlignment = Enum.TextXAlignment.Left
Z.TextYAlignment = Enum.TextYAlignment.Top

_.Name = "Tokens"
_.Parent = U
_.BackgroundColor3 = Color3.new(1, 1, 1)
_.BackgroundTransparency = 1
_.Size = UDim2.new(1, 0, 1, 0)
_.ZIndex = 5
_.Font = Enum.Font.Code
_.Text = ""
_.TextColor3 = Color3.fromRGB(243, 243, 243)
_.TextSize = 15
_.TextXAlignment = Enum.TextXAlignment.Left
_.TextYAlignment = Enum.TextYAlignment.Top

a0.Name = "Numbers"
a0.Parent = U
a0.BackgroundColor3 = Color3.new(1, 1, 1)
a0.BackgroundTransparency = 1
a0.Size = UDim2.new(1, 0, 1, 0)
a0.ZIndex = 4
a0.Font = Enum.Font.Code
a0.Text = ""
a0.TextColor3 = Color3.new(1, 0.776471, 0)
a0.TextSize = 15
a0.TextXAlignment = Enum.TextXAlignment.Left
a0.TextYAlignment = Enum.TextYAlignment.Top

a1.Name = "Info"
a1.Parent = U
a1.BackgroundColor3 = Color3.new(1, 1, 1)
a1.BackgroundTransparency = 1
a1.Size = UDim2.new(1, 0, 1, 0)
a1.ZIndex = 5
a1.Font = Enum.Font.Code
a1.Text = ""
a1.TextColor3 = Color3.new(0, 0.635294, 1)
a1.TextSize = 15
a1.TextXAlignment = Enum.TextXAlignment.Left
a1.TextYAlignment = Enum.TextYAlignment.Top

a2.Name = "Lines"
a2.Parent = T
a2.BackgroundColor3 = Color3.new(1, 1, 1)
a2.BackgroundTransparency = 1
a2.BorderSizePixel = 0
a2.Size = UDim2.new(0, 40, 0, 10000)
a2.ZIndex = 4
a2.Font = Enum.Font.Code
a2.Text = "1\n"
a2.TextColor3 = Color3.fromRGB(243, 243, 243)
a2.TextSize = 15
a2.TextWrapped = true
a2.TextYAlignment = Enum.TextYAlignment.Top

a3.Name = "ColorPicker"
a3.Parent = c
a3.BackgroundColor3 = Color3.new(1, 1, 1)
a3.BackgroundTransparency = 1
a3.Size = UDim2.new(0, 180, 0, 110)
a3.Image = "rbxassetid://2851929490"
a3.ImageColor3 = Color3.fromRGB(40, 40, 40)
a3.ScaleType = Enum.ScaleType.Slice
a3.SliceCenter = Rect.new(4, 4, 4, 4)

a4.Name = "Palette"
a4.Parent = a3
a4.BackgroundColor3 = Color3.new(1, 1, 1)
a4.BackgroundTransparency = 1
a4.Position = UDim2.new(0.0500000007, 0, 0.0500000007, 0)
a4.Size = UDim2.new(0, 100, 0, 100)
a4.Image = "rbxassetid://698052001"
a4.ScaleType = Enum.ScaleType.Slice
a4.SliceCenter = Rect.new(4, 4, 4, 4)

a5.Name = "Indicator"
a5.Parent = a4
a5.BackgroundColor3 = Color3.new(1, 1, 1)
a5.BackgroundTransparency = 1
a5.Size = UDim2.new(0, 5, 0, 5)
a5.ZIndex = 2
a5.Image = "rbxassetid://2851926732"
a5.ImageColor3 = Color3.new(0, 0, 0)
a5.ScaleType = Enum.ScaleType.Slice
a5.SliceCenter = Rect.new(12, 12, 12, 12)

a6.Name = "Sample"
a6.Parent = a3
a6.BackgroundColor3 = Color3.new(1, 1, 1)
a6.BackgroundTransparency = 1
a6.Position = UDim2.new(0.800000012, 0, 0.0500000007, 0)
a6.Size = UDim2.new(0, 25, 0, 25)
a6.Image = "rbxassetid://2851929490"
a6.ScaleType = Enum.ScaleType.Slice
a6.SliceCenter = Rect.new(4, 4, 4, 4)

a7.Name = "Saturation"
a7.Parent = a3
a7.BackgroundColor3 = Color3.new(1, 1, 1)
a7.Position = UDim2.new(0.649999976, 0, 0.0500000007, 0)
a7.Size = UDim2.new(0, 15, 0, 100)
a7.Image = "rbxassetid://3641079629"

a8.Name = "Indicator"
a8.Parent = a7
a8.BackgroundColor3 = Color3.new(1, 1, 1)
a8.BorderSizePixel = 0
a8.Size = UDim2.new(0, 20, 0, 2)
a8.ZIndex = 2

a9.Name = "Switch"
a9.Parent = c
a9.BackgroundColor3 = Color3.new(1, 1, 1)
a9.BackgroundTransparency = 1
a9.BorderSizePixel = 0
a9.Position = UDim2.new(0.229411766, 0, 0.20714286, 0)
a9.Size = UDim2.new(0, 20, 0, 20)
a9.ZIndex = 2
a9.Font = Enum.Font.SourceSans
a9.Text = ""
a9.TextColor3 = Color3.new(1, 1, 1)
a9.TextSize = 18

aa.Name = "TextButton_Roundify_4px"
aa.Parent = a9
aa.BackgroundColor3 = Color3.new(1, 1, 1)
aa.BackgroundTransparency = 1
aa.Size = UDim2.new(1, 0, 1, 0)
aa.Image = "rbxassetid://2851929490"
aa.ImageColor3 = Color3.fromRGB(255, 50, 50)
aa.ImageTransparency = 0.5
aa.ScaleType = Enum.ScaleType.Slice
aa.SliceCenter = Rect.new(4, 4, 4, 4)

ab.Name = "Title"
ab.Parent = a9
ab.BackgroundColor3 = Color3.new(1, 1, 1)
ab.BackgroundTransparency = 1
ab.Position = UDim2.new(1.20000005, 0, 0, 0)
ab.Size = UDim2.new(0, 20, 0, 20)
ab.Font = Enum.Font.GothamSemibold
ab.Text = "Switch"
ab.TextColor3 = Color3.fromRGB(243, 243, 243)
ab.TextSize = 14
ab.TextXAlignment = Enum.TextXAlignment.Left

ac.Name = "Button"
ac.Parent = c
ac.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
ac.BackgroundTransparency = 1
ac.BorderSizePixel = 0
ac.Size = UDim2.new(0, 91, 0, 20)
ac.ZIndex = 2
ac.Font = Enum.Font.GothamSemibold
ac.TextColor3 = Color3.fromRGB(243, 243, 243)
ac.TextSize = 14

ad.Name = "TextButton_Roundify_4px"
ad.Parent = ac
ad.BackgroundColor3 = Color3.new(1, 1, 1)
ad.BackgroundTransparency = 1
ad.Size = UDim2.new(1, 0, 1, 0)
ad.Image = "rbxassetid://2851929490"
ad.ImageColor3 = Color3.fromRGB(255, 50, 50)
ad.ScaleType = Enum.ScaleType.Slice
ad.SliceCenter = Rect.new(4, 4, 4, 4)

ae.Name = "DropdownButton"
ae.Parent = c
ae.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ae.BorderSizePixel = 0
ae.Size = UDim2.new(1, 0, 0, 20)
ae.ZIndex = 3
ae.Font = Enum.Font.GothamBold
ae.Text = "      Button"
ae.TextColor3 = Color3.fromRGB(243, 243, 243)
ae.TextSize = 14
ae.TextXAlignment = Enum.TextXAlignment.Left

af.Name = "Keybind"
af.Parent = c
af.BackgroundColor3 = Color3.new(1, 1, 1)
af.BackgroundTransparency = 1
af.Size = UDim2.new(0, 200, 0, 20)
af.Image = "rbxassetid://2851929490"
af.ImageColor3 = Color3.fromRGB(40, 40, 40)
af.ScaleType = Enum.ScaleType.Slice
af.SliceCenter = Rect.new(4, 4, 4, 4)

ag.Name = "Title"
ag.Parent = af
ag.BackgroundColor3 = Color3.new(1, 1, 1)
ag.BackgroundTransparency = 1
ag.Size = UDim2.new(0, 0, 1, 0)
ag.Font = Enum.Font.GothamBold
ag.Text = "Keybind"
ag.TextColor3 = Color3.fromRGB(243, 243, 243)
ag.TextSize = 14
ag.TextXAlignment = Enum.TextXAlignment.Left

ah.Name = "Input"
ah.Parent = af
ah.BackgroundColor3 = Color3.new(1, 1, 1)
ah.BackgroundTransparency = 1
ah.BorderSizePixel = 0
ah.Position = UDim2.new(1, -85, 0, 2)
ah.Size = UDim2.new(0, 80, 1, -4)
ah.ZIndex = 2
ah.Font = Enum.Font.GothamSemibold
ah.Text = "RShift"
ah.TextColor3 = Color3.fromRGB(243, 243, 243)
ah.TextSize = 12
ah.TextWrapped = true

ai.Name = "Input_Roundify_4px"
ai.Parent = ah
ai.BackgroundColor3 = Color3.new(1, 1, 1)
ai.BackgroundTransparency = 1
ai.Size = UDim2.new(1, 0, 1, 0)
ai.Image = "rbxassetid://2851929490"
ai.ImageColor3 = Color3.fromRGB(40, 40, 40)
ai.ScaleType = Enum.ScaleType.Slice
ai.SliceCenter = Rect.new(4, 4, 4, 4)

-- ====== End of prefabs ======

-- Now the script logic (no usage of script.Parent to find Windows)
local ak = game:GetService("UserInputService")
local al = game:GetService("TweenService")
local am = game:GetService("RunService")
local an = game:GetService("Players")
local ao = an.LocalPlayer
local ap = ao:GetMouse()
-- Note: we already have 'aj' as the Windows container, so we don't need to reassign it.
local aq = {["binding"] = false}

ak.InputBegan:Connect(function(ar, as)
    if ar.KeyCode == (typeof(a.toggle_key) == "EnumItem" and a.toggle_key or Enum.KeyCode.RightShift) then
        if script.Parent then
            if not aq.binding then
                script.Parent.Enabled = not script.Parent.Enabled
            end
        end
    end
end)

local function at(au, av, aw)
    aw = aw or 0.5
    local ax = TweenInfo.new(aw, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local ay = al:Create(au, ax, av)
    ay:Play()
end

local function az(aA, aB, aC)
    local aD = aA:FindFirstChild("UIGradient")
    if aD then aD:Destroy() end
    if typeof(aB) == "Color3" then aB = {aB} end
    if not aB or #aB == 0 then return end
    if #aB == 1 then
        if aA:IsA("ImageLabel") or aA:IsA("ImageButton") then
            aA.ImageColor3 = aB[1]
        else
            aA.BackgroundColor3 = aB[1]
        end
        return
    end
    local aE = Instance.new("UIGradient")
    aE.Parent = aA
    aE.Rotation = aC or 0
    local aF = {}
    if #aB == 2 then
        table.insert(aF, ColorSequenceKeypoint.new(0, aB[1]))
        table.insert(aF, ColorSequenceKeypoint.new(1, aB[2]))
    elseif #aB >= 3 then
        table.insert(aF, ColorSequenceKeypoint.new(0, aB[1]))
        table.insert(aF, ColorSequenceKeypoint.new(0.5, aB[2]))
        table.insert(aF, ColorSequenceKeypoint.new(1, aB[3]))
    end
    aE.Color = ColorSequence.new(aF)
    if aA:IsA("ImageLabel") or aA:IsA("ImageButton") then
        aA.ImageColor3 = Color3.new(1, 1, 1)
    else
        aA.BackgroundColor3 = Color3.new(1, 1, 1)
    end
end

local function aG(aH, aI, aJ)
    aH, aI, aJ = aH / 255, aI / 255, aJ / 255
    local aK, aL = math.max(aH, aI, aJ), math.min(aH, aI, aJ)
    local aM, aN, aO
    aO = aK
    local aP = aK - aL
    if aK == 0 then
        aN = 0
    else
        aN = aP / aK
    end
    if aK == aL then
        aM = 0
    else
        if aK == aH then
            aM = (aI - aJ) / aP
            if aI < aJ then aM = aM + 6 end
        elseif aK == aI then
            aM = (aJ - aH) / aP + 2
        elseif aK == aJ then
            aM = (aH - aI) / aP + 4
        end
        aM = aM / 6
    end
    return aM, aN, aO
end

local function aQ(aR, aS)
    local aT, aJ = pcall(function() return aR[tostring(aS)] end)
    if aT then return aJ end
end

local function aU(aV)
    return aV.TextBounds.X + 15
end

local function aW()
    return Vector2.new(ak:GetMouseLocation().X + 1, ak:GetMouseLocation().Y - 35)
end

local function aX(aY, aZ, a_)
    spawn(function()
        aY.ClipsDescendants = true
        local b0 = c:FindFirstChild("Circle"):Clone()
        b0.Parent = aY
        b0.ZIndex = 1000
        local b1 = aZ - b0.AbsolutePosition.X
        local b2 = a_ - b0.AbsolutePosition.Y
        b0.Position = UDim2.new(0, b1, 0, b2)
        local b3 = 0
        if aY.AbsoluteSize.X > aY.AbsoluteSize.Y then
            b3 = aY.AbsoluteSize.X * 1.5
        elseif aY.AbsoluteSize.X < aY.AbsoluteSize.Y then
            b3 = aY.AbsoluteSize.Y * 1.5
        elseif aY.AbsoluteSize.X == aY.AbsoluteSize.Y then
            b3 = aY.AbsoluteSize.X * 1.5
        end
        b0:TweenSizeAndPosition(
            UDim2.new(0, b3, 0, b3),
            UDim2.new(0.5, -b3/2, 0.5, -b3/2),
            "Out", "Quad", 0.5, false, nil
        )
        at(b0, {ImageTransparency = 1}, 0.5)
        wait(0.5)
        b0:Destroy()
    end)
end

local b4 = 0
local b5 = {}

local function b6()
    -- not needed
end

function b5:FormatWindows()
    b6()
end

function b5:AddWindow(ba, bb)
    b4 = b4 + 1
    local bc = false
    ba = tostring(ba or "New Window")
    bb = typeof(bb) == "table" and bb or a
    bb.tween_time = 0.1
    bb.title_bar = bb.title_bar or {Color3.fromRGB(255, 50, 50)}
    if typeof(bb.title_bar) == "Color3" then bb.title_bar = {bb.title_bar} end
    bb.title_bar_transparency = bb.title_bar_transparency or 0
    bb.background = bb.background or {Color3.fromRGB(20, 20, 20)}
    if typeof(bb.background) == "Color3" then bb.background = {bb.background} end
    bb.background_transparency = bb.background_transparency or 0.05
    if not bb.main_color then bb.main_color = bb.title_bar[1] end

    -- Clone the window prefab
    local eClone = e:Clone()
    eClone.Parent = aj  -- Use the Windows container
    eClone.Size = UDim2.new(0, bb.min_size.X, 0, bb.min_size.Y)
    eClone.ZIndex = eClone.ZIndex + b4 * 10

    -- Add rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = eClone

    -- Add glow stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 2
    stroke.Transparency = 0.15
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = eClone

    -- Set title
    local titleLabel = eClone:FindFirstChild("Bar"):FindFirstChild("Title")
    if titleLabel then
        titleLabel.Text = ba
    end

    -- Get references
    local bar = eClone:FindFirstChild("Bar")
    local closeBtn = bar:FindFirstChild("CloseButton")
    local tabsContainer = eClone:FindFirstChild("Tabs")
    local tabScroll = tabsContainer:FindFirstChild("TabScroll")
    local tabList = tabScroll:FindFirstChild("TabList")
    local contentFrame = eClone:FindFirstChild("Content")
    local resizer = eClone:FindFirstChild("Resizer")

    -- ====== Drag ======
    eClone.Draggable = true
    do
        local bp = ap.Icon
        local bq = false
        resizer.MouseEnter:Connect(function()
            eClone.Draggable = false
            if bb.can_resize then bp = ap.Icon end
            bq = true
        end)
        resizer.MouseLeave:Connect(function()
            bq = false
            if bb.can_resize then ap.Icon = bp end
            eClone.Draggable = true
        end)
        local br = false
        ak.InputBegan:Connect(function(bs)
            if bs.UserInputType == Enum.UserInputType.MouseButton1 then
                br = true
                spawn(function()
                    if bq and resizer.Active and bb.can_resize then
                        while br and resizer.Active do
                            local bt = aW()
                            local aZ = bt.X - eClone.AbsolutePosition.X
                            local a_ = bt.Y - eClone.AbsolutePosition.Y
                            if aZ >= bb.min_size.X and a_ >= bb.min_size.Y then
                                at(eClone, {Size = UDim2.new(0, aZ, 0, a_)}, bb.tween_time)
                            elseif aZ >= bb.min_size.X then
                                at(eClone, {Size = UDim2.new(0, aZ, 0, bb.min_size.Y)}, bb.tween_time)
                            elseif a_ >= bb.min_size.Y then
                                at(eClone, {Size = UDim2.new(0, bb.min_size.X, 0, a_)}, bb.tween_time)
                            else
                                at(eClone, {Size = UDim2.new(0, bb.min_size.X, 0, bb.min_size.Y)}, bb.tween_time)
                            end
                            am.Heartbeat:Wait()
                        end
                    end
                end)
            end
        end)
        ak.InputEnded:Connect(function(bs)
            if bs.UserInputType == Enum.UserInputType.MouseButton1 then
                br = false
            end
        end)
    end

    -- ====== Minimize/Restore ======
    local isMinimized = false
    local mainSize = eClone.Size
    local mainPos = eClone.Position

    local minimizedFrame = Instance.new("ImageButton")
    minimizedFrame.Name = "MinimizedFrame"
    minimizedFrame.Parent = b
    minimizedFrame.AnchorPoint = Vector2.new(1, 0)
    minimizedFrame.Position = UDim2.new(1, -20, 0, 20)
    minimizedFrame.Size = UDim2.fromOffset(60, 60)
    minimizedFrame.BackgroundTransparency = 1
    minimizedFrame.BorderSizePixel = 0
    minimizedFrame.Visible = false
    minimizedFrame.ZIndex = 100
    minimizedFrame.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=84595542654454&width=300&height=300&format=png"
    minimizedFrame.ScaleType = Enum.ScaleType.Fit
    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(1, 0)
    minCorner.Parent = minimizedFrame
    local minStroke = Instance.new("UIStroke")
    minStroke.Color = Color3.fromRGB(255, 255, 255)
    minStroke.Thickness = 2
    minStroke.Transparency = 0.3
    minStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    minStroke.Parent = minimizedFrame

    local function MinimizeUI()
        if isMinimized then return end
        isMinimized = true
        local targetPos = UDim2.new(1, -40, 0, 40)
        local targetSize = UDim2.fromScale(0.05, 0.05)
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
        al:Create(eClone, tweenInfo, {Size = targetSize, Position = targetPos}):Play()
        task.wait(0.3)
        eClone.Visible = false
        minimizedFrame.Visible = true
        minimizedFrame.Size = UDim2.fromOffset(0, 0)
        minimizedFrame:TweenSize(UDim2.fromOffset(60,60), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.3, true)
    end

    local function RestoreUI()
        isMinimized = false
        minimizedFrame.Visible = false
        eClone.Visible = true
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        al:Create(eClone, tweenInfo, {Size = mainSize, Position = mainPos}):Play()
    end

    closeBtn.MouseButton1Click:Connect(MinimizeUI)
    minimizedFrame.MouseButton1Click:Connect(RestoreUI)

    -- ====== Tab management ======
    local tabButtons = {}
    local activeTab = nil
    local tabContentFrames = {}

    local function selectTab(tabButton, tabContent)
        if activeTab then
            local prevOutline = activeTab:FindFirstChild("TabOutline")
            if prevOutline then prevOutline.Visible = false end
            activeTab.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        activeTab = tabButton
        local outline = tabButton:FindFirstChild("TabOutline")
        if outline then outline.Visible = true end
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)

        for _, frame in pairs(tabContentFrames) do
            frame.Visible = false
        end
        tabContent.Visible = true
    end

    local windowObj = {}

    function windowObj:AddTab(tabName)
        tabName = tostring(tabName or "New Tab")

        local tabButton = c:FindFirstChild("TabButton"):Clone()
        tabButton.Parent = tabScroll
        tabButton.Text = tabName
        tabButton.Size = UDim2.new(0, aU(tabButton) + 20, 0, 18)
        tabButton.ZIndex = tabButton.ZIndex + b4 * 10
        tabButton.BackgroundTransparency = 1

        local bg = tabButton:GetChildren()[1]
        if bg then bg.ZIndex = tabButton.ZIndex + b4 * 10 end

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 4)
        btnCorner.Parent = tabButton

        tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        tabButton.TextSize = 13
        tabButton.Font = Enum.Font.GothamSemibold

        local stroke2 = Instance.new("UIStroke")
        stroke2.Color = Color3.new(0, 0, 0)
        stroke2.Thickness = 1.2
        stroke2.Transparency = 0.7
        stroke2.Parent = tabButton

        local outline = Instance.new("Frame")
        outline.Name = "TabOutline"
        outline.Size = UDim2.new(1, 0, 1, 0)
        outline.BackgroundTransparency = 1
        outline.BorderSizePixel = 2
        outline.BorderColor3 = bb.main_color
        outline.ZIndex = tabButton.ZIndex + 10
        outline.Visible = false
        local outCorner = Instance.new("UICorner")
        outCorner.CornerRadius = UDim.new(0, 4)
        outCorner.Parent = outline
        outline.Parent = tabButton

        local tabContent = q:Clone()
        tabContent.Parent = contentFrame
        tabContent.Visible = false
        tabContent.ZIndex = tabContent.ZIndex + b4 * 10
        table.insert(tabContentFrames, tabContent)

        tabButton.MouseButton1Click:Connect(function()
            selectTab(tabButton, tabContent)
        end)

        tabButton.MouseEnter:Connect(function()
            if tabButton ~= activeTab then tabButton.TextColor3 = Color3.fromRGB(230, 230, 230) end
        end)
        tabButton.MouseLeave:Connect(function()
            if tabButton ~= activeTab then tabButton.TextColor3 = Color3.fromRGB(200, 200, 200) end
        end)

        if #tabContentFrames == 1 then
            selectTab(tabButton, tabContent)
        end

        local tabMethods = {}

        -- ====== Add methods ======
        function tabMethods:AddLabel(text)
            text = tostring(text or "New Label")
            local label = c:FindFirstChild("Label"):Clone()
            label.Parent = tabContent
            label.Text = text
            label.Size = UDim2.new(0, aU(label), 0, 20)
            label.ZIndex = label.ZIndex + b4 * 10
            return label
        end

        function tabMethods:AddButton(text, callback)
            text = tostring(text or "New Button")
            callback = typeof(callback) == "function" and callback or function() end
            local btn = c:FindFirstChild("Button"):Clone()
            btn.Parent = tabContent
            btn.Text = text
            btn.Size = UDim2.new(0, aU(btn), 0, 20)
            btn.ZIndex = btn.ZIndex + b4 * 10
            local bg2 = btn:GetChildren()[1]
            if bg2 then
                bg2.ZIndex = bg2.ZIndex + b4 * 10
                bg2.ImageTransparency = bb.title_bar_transparency or 0
                az(bg2, bb.title_bar, 0)
            end
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.MouseButton1Click:Connect(function()
                aX(btn, ap.X, ap.Y)
                pcall(callback)
            end)
            return btn
        end

        function tabMethods:AddSwitch(text, callback)
            local switchObj = {}
            text = tostring(text or "New Switch")
            callback = typeof(callback) == "function" and callback or function() end
            local sw = c:FindFirstChild("Switch"):Clone()
            sw.Parent = tabContent
            sw:FindFirstChild("Title").Text = text
            sw:FindFirstChild("Title").ZIndex = sw:FindFirstChild("Title").ZIndex + b4 * 10
            sw.ZIndex = sw.ZIndex + b4 * 10
            local bg3 = sw:GetChildren()[1]
            if bg3 then
                bg3.ZIndex = bg3.ZIndex + b4 * 10
                bg3.ImageTransparency = bb.title_bar_transparency or 0
                az(bg3, bb.title_bar, 0)
            end
            local state = false
            sw.MouseButton1Click:Connect(function()
                state = not state
                sw.Text = state and utf8.char(10003) or ""
                pcall(callback, state)
            end)
            function switchObj:Set(value)
                state = typeof(value) == "boolean" and value or false
                sw.Text = state and utf8.char(10003) or ""
                pcall(callback, state)
            end
            return switchObj, sw
        end

        function tabMethods:AddTextBox(placeholder, callback, clear)
            placeholder = tostring(placeholder or "New TextBox")
            callback = typeof(callback) == "function" and callback or function() end
            clear = clear and true or false
            local tb = c:FindFirstChild("TextBox"):Clone()
            tb.Size = UDim2.new(0.5, -5, 0, 20)
            tb.Parent = tabContent
            tb.PlaceholderText = placeholder
            tb.ZIndex = tb.ZIndex + b4 * 10
            local bg4 = tb:GetChildren()[1]
            if bg4 then
                bg4.ZIndex = bg4.ZIndex + b4 * 10
                bg4.ImageTransparency = bb.title_bar_transparency or 0
                az(bg4, bb.title_bar, 0)
            end
            tb.TextColor3 = Color3.new(1, 1, 1)
            tb.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
            tb.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    if #tb.Text > 0 then
                        pcall(callback, tb.Text)
                        if clear then tb.Text = "" end
                    end
                end
            end)
            return tb
        end

        function tabMethods:AddSlider(title, callback, options)
            local sliderObj = {}
            title = tostring(title or "New Slider")
            callback = typeof(callback) == "function" and callback or function() end
            options = typeof(options) == "table" and options or {}
            options.min = options.min or 0
            options.max = options.max or 100
            options.readonly = options.readonly or false

            local slider = c:FindFirstChild("Slider"):Clone()
            slider.Parent = tabContent
            slider.ZIndex = slider.ZIndex + b4 * 10
            local titleLabel2 = slider:FindFirstChild("Title")
            local indicator = slider:FindFirstChild("Indicator")
            local valueLabel = slider:FindFirstChild("Value")
            if titleLabel2 then titleLabel2.ZIndex = titleLabel2.ZIndex + b4 * 10 end
            if indicator then indicator.ZIndex = indicator.ZIndex + b4 * 10 end
            if valueLabel then valueLabel.ZIndex = valueLabel.ZIndex + b4 * 10 end
            if titleLabel2 then titleLabel2.Text = title end

            local dragging = false
            slider.MouseEnter:Connect(function() eClone.Draggable = false; dragging = true end)
            slider.MouseLeave:Connect(function() eClone.Draggable = true; dragging = false end)

            ak.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    spawn(function()
                        while dragging and not options.readonly do
                            local mousePos = aW()
                            local relativeX = mousePos.X - slider.AbsolutePosition.X
                            local percent = math.clamp(relativeX / slider.AbsoluteSize.X, 0, 1)
                            at(indicator, {Size = UDim2.new(percent, 0, 0, 20)}, bb.tween_time)
                            local val = math.floor((options.max - options.min) * percent + options.min)
                            if valueLabel then valueLabel.Text = tostring(val) end
                            pcall(callback, val)
                            am.Heartbeat:Wait()
                        end
                    end)
                end
            end)

            function sliderObj:Set(value)
                value = tonumber(value) or 0
                value = math.clamp((value - options.min) / (options.max - options.min), 0, 1)
                at(indicator, {Size = UDim2.new(value, 0, 0, 20)}, bb.tween_time)
                local val = math.floor((options.max - options.min) * value + options.min)
                if valueLabel then valueLabel.Text = tostring(val) end
                pcall(callback, val)
            end
            sliderObj:Set(options.min)
            return sliderObj, slider
        end

        function tabMethods:AddKeybind(title, callback, key)
            local keyObj = {}
            title = tostring(title or "New Keybind")
            callback = typeof(callback) == "function" and callback or function() end
            key = key or Enum.KeyCode.RightShift

            local kb = c:FindFirstChild("Keybind"):Clone()
            local inputButton = kb:FindFirstChild("Input")
            local labelTitle = kb:FindFirstChild("Title")
            kb.ZIndex = kb.ZIndex + b4 * 10
            inputButton.ZIndex = inputButton.ZIndex + b4 * 10
            labelTitle.ZIndex = labelTitle.ZIndex + b4 * 10
            kb.Parent = tabContent
            labelTitle.Text = "  " .. title
            kb.Size = UDim2.new(0, aU(labelTitle) + 80, 0, 20)

            local keyNames = {
                RightControl = 'RightCtrl',
                LeftControl = 'LeftCtrl',
                LeftShift = 'LShift',
                RightShift = 'RShift',
                MouseButton1 = "Mouse1",
                MouseButton2 = "Mouse2"
            }
            local currentKey = key

            function keyObj:SetKeybind(newKey)
                local name = keyNames[newKey.Name] or newKey.Name
                inputButton.Text = name
                currentKey = newKey
            end

            ak.InputBegan:Connect(function(input, processed)
                if aq.binding then
                    spawn(function() wait(); aq.binding = false end)
                    return
                end
                if input.KeyCode == currentKey and not processed then
                    pcall(callback, currentKey)
                end
            end)

            keyObj:SetKeybind(key)

            inputButton.MouseButton1Click:Connect(function()
                if aq.binding then return end
                inputButton.Text = "..."
                aq.binding = true
                local input, proc = ak.InputBegan:Wait()
                keyObj:SetKeybind(input.KeyCode)
            end)

            return keyObj, kb
        end

        function tabMethods:AddDropdown(title, callback)
            local dropdownObj = {}
            title = tostring(title or "New Dropdown")
            callback = typeof(callback) == "function" and callback or function() end

            local dd = c:FindFirstChild("Dropdown"):Clone()
            local box = dd:FindFirstChild("Box")
            local objects = box:FindFirstChild("Objects")
            local indicatorArrow = dd:FindFirstChild("Indicator")
            dd.ZIndex = dd.ZIndex + b4 * 10
            box.ZIndex = box.ZIndex + b4 * 10
            objects.ZIndex = objects.ZIndex + b4 * 10
            indicatorArrow.ZIndex = indicatorArrow.ZIndex + b4 * 10
            dd.Size = UDim2.new(0.5, -5, 0, 20)
            local bg5 = dd:GetChildren()[3]
            if bg5 then
                bg5.ZIndex = bg5.ZIndex + b4 * 10
                bg5.ImageTransparency = bb.title_bar_transparency or 0
                az(bg5, bb.title_bar, 0)
            end
            box.ImageTransparency = bb.background_transparency or 0.1
            az(box, bb.background, 0)
            local boxCorner = Instance.new("UICorner")
            boxCorner.CornerRadius = UDim.new(0, 6)
            boxCorner.Parent = box

            objects.BackgroundTransparency = 1
            objects.Position = UDim2.new(0, 0, 0, 0)
            objects.Size = UDim2.new(1, 0, 1, 0)
            dd.Parent = tabContent
            dd.Text = "      " .. title
            box.Size = UDim2.new(1, 0, 0, 0)
            dd.TextColor3 = Color3.new(1, 1, 1)

            local open = false
            dd.MouseButton1Click:Connect(function()
                open = not open
                local childrenCount = #objects:GetChildren() - 1
                local height = childrenCount * 20
                if childrenCount >= 10 then
                    height = 10 * 20
                    objects.CanvasSize = UDim2.new(0, 0, childrenCount * 0.1, 0)
                end
                if open then
                    at(box, {Size = UDim2.new(1, 0, 0, height)}, bb.tween_time)
                    at(indicatorArrow, {Rotation = 90}, bb.tween_time)
                else
                    at(box, {Size = UDim2.new(1, 0, 0, 0)}, bb.tween_time)
                    at(indicatorArrow, {Rotation = -90}, bb.tween_time)
                end
            end)

            function dropdownObj:Add(optionText)
                optionText = tostring(optionText or "New Option")
                local btn = c:FindFirstChild("DropdownButton"):Clone()
                btn.Parent = objects
                btn.Text = optionText
                btn.ZIndex = btn.ZIndex + b4 * 10 + 5
                btn.BackgroundTransparency = 1
                btn.TextColor3 = Color3.new(1, 1, 1)
                btn.BorderSizePixel = 0
                btn.TextXAlignment = Enum.TextXAlignment.Left

                local corner2 = btn:FindFirstChildOfClass("UICorner")
                if corner2 then corner2:Destroy() end

                local stroke3 = Instance.new("UIStroke")
                stroke3.Color = Color3.new(0, 0, 0)
                stroke3.Thickness = 1
                stroke3.Transparency = 0.3
                stroke3.Parent = btn

                btn.MouseEnter:Connect(function()
                    btn.BackgroundTransparency = 0.8
                    btn.BackgroundColor3 = bb.main_color
                end)
                btn.MouseLeave:Connect(function()
                    btn.BackgroundTransparency = 1
                end)

                btn.MouseButton1Click:Connect(function()
                    if open then
                        dd.Text = "      [ " .. optionText .. " ]"
                        open = false
                        at(box, {Size = UDim2.new(1, 0, 0, 0)}, bb.tween_time)
                        at(indicatorArrow, {Rotation = -90}, bb.tween_time)
                        pcall(callback, optionText)
                    end
                end)
                return btn
            end

            return dropdownObj, dd
        end

        function tabMethods:AddColorPicker(callback)
            local pickerObj = {}
            callback = typeof(callback) == "function" and callback or function() end
            local picker = c:FindFirstChild("ColorPicker"):Clone()
            picker.Parent = tabContent
            picker.ZIndex = picker.ZIndex + b4 * 10
            local palette = picker:FindFirstChild("Palette")
            local sample = picker:FindFirstChild("Sample")
            local saturation = picker:FindFirstChild("Saturation")
            -- Full implementation from original can be added here if needed
            return pickerObj, picker
        end

        function tabMethods:AddConsole(opts)
            local consoleObj = {}
            opts = opts or {}
            local console = c:FindFirstChild("Console"):Clone()
            console.Parent = tabContent
            -- Full implementation from original can be added here if needed
            return consoleObj, console
        end

        function tabMethods:AddHorizontalAlignment()
            local ha = {}
            local haFrame = c:FindFirstChild("HorizontalAlignment"):Clone()
            haFrame.Parent = tabContent
            return ha, haFrame
        end

        function tabMethods:AddFolder(folderName)
            local folderObj = {}
            folderName = tostring(folderName or "New Folder")
            local folder = c:FindFirstChild("Folder"):Clone()
            folder.Parent = tabContent
            -- Full implementation from original can be added here if needed
            return folderObj, folder
        end

        return tabMethods, tabContent
    end

    -- ====== Window methods ======
    function windowObj:Close()
        eClone:Destroy()
        minimizedFrame:Destroy()
    end

    function windowObj:Minimize()
        MinimizeUI()
    end

    function windowObj:Restore()
        RestoreUI()
    end

    return windowObj, eClone
end

-- Set script parent (optional, but keep)
script.Parent = b

return b5
