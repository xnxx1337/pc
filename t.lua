--[=[
 d888b  db    db d888888b      .d888b.      db      db    db  .d8b.  
88' Y8b 88    88   `88'        VP  `8D      88      88    88 d8' `8b 
88      88    88    88            odD'      88      88    88 88ooo88 
88  ooo 88    88    88          .88'        88      88    88 88~~~88 
88. ~8~ 88b  d88   .88.        j88.         88booo. 88b  d88 88   YP  @uniquadev
 Y888P  ~Y8888P' Y888888P      888888D      Y88888P ~Y8888P' YP   YP  UI LIBRARY
]=]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Library = {
    Tabs = {},
    Sections = {},
    Flags = {},
    Accent = Color3.fromRGB(176, 141, 109),
    Background = Color3.fromRGB(9, 9, 9),
    Border = Color3.fromRGB(41, 41, 41),
    Toggled = true,
    KeybindDisplays = {}
}

local function Tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.2, Enum.EasingStyle.Quart), props):Play()
end

local function MakeDraggable(topbarobject, object)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil

    local function Update(input)
        local Delta = input.Position - DragStart
        object.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
    end

    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
end

function Library:CreateWindow(cfg)
    cfg = cfg or {}
    local Name = cfg.Name or "NoName"
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NoNameUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    self.ScreenGui = ScreenGui

    local Main = Instance.new("Frame")
    Main.Name = "main"
    Main.BackgroundColor3 = self.Background
    Main.BorderColor3 = self.Border
    Main.Position = UDim2.new(0.5, -322, 0.5, -316)
    Main.Size = UDim2.new(0, 644, 0, 632)
    Main.Parent = ScreenGui
    self.Main = Main

    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.Size = UDim2.new(1, 50, 1, 50)
    Shadow.Image = "rbxassetid://1316045217"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.Parent = Main

    MakeDraggable(Main, Main)

    -- Toggle UI
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == (cfg.ToggleKey or Enum.KeyCode.RightControl) then
            self.Toggled = not self.Toggled
            Main.Visible = self.Toggled
        end
    end)

    local Line = Instance.new("Frame")
    Line.Name = "line"
    Line.BackgroundColor3 = self.Background
    Line.BorderColor3 = self.Border
    Line.Position = UDim2.new(0.01, 0, 0.036, 0)
    Line.Size = UDim2.new(0, 628, 0, 1)
    Line.Parent = Main

    local TitleWhite = Instance.new("TextLabel")
    TitleWhite.Name = "title_white"
    TitleWhite.BackgroundTransparency = 1
    TitleWhite.Position = UDim2.new(0, 0, 0, 0)
    TitleWhite.Size = UDim2.new(1, 0, 0, 25)
    TitleWhite.Font = Enum.Font.SourceSansBold
    TitleWhite.Text = Name .. " <font color='rgb(176, 141, 109)'>WTF</font>"
    TitleWhite.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleWhite.TextSize = 15
    TitleWhite.TextStrokeTransparency = 0.9
    TitleWhite.RichText = true
    TitleWhite.Parent = Main

    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "Tabs"
    TabContainer.BackgroundTransparency = 1
    TabContainer.Position = UDim2.new(0.01, 0, 0.052, 0)
    TabContainer.Size = UDim2.new(0.98, 0, 0, 25)
    TabContainer.Parent = Main

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.Parent = TabContainer

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "Content"
    ContentContainer.BackgroundColor3 = self.Background
    ContentContainer.BorderColor3 = self.Border
    ContentContainer.Position = UDim2.new(0.008, 0, 0.098, 0)
    ContentContainer.Size = UDim2.new(0, 630, 0, 562)
    ContentContainer.Parent = Main

    self.TabContainer = TabContainer
    self.ContentContainer = ContentContainer

    -- Watermark
    self:CreateWatermark()
    -- Keybind List
    self:CreateKeybindList()

    return self
end

function Library:CreateTab(name)
    local Tab = {
        Name = name,
        Active = false,
        Buttons = {},
        Sections = {}
    }

    local TabButton = Instance.new("TextButton")
    TabButton.Name = name .. "Tab"
    TabButton.BackgroundTransparency = 1
    TabButton.Size = UDim2.new(0, 120, 1, 0)
    TabButton.Font = Enum.Font.SourceSans
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(87, 87, 87)
    TabButton.TextSize = 14
    TabButton.TextStrokeTransparency = 0.5
    TabButton.Parent = self.TabContainer

    local TabLine = Instance.new("Frame")
    TabLine.BackgroundColor3 = self.Accent
    TabLine.BorderSizePixel = 0
    TabLine.Position = UDim2.new(0.1, 0, 1, 0)
    TabLine.Size = UDim2.new(0.8, 0, 0, 1)
    TabLine.Visible = false
    TabLine.Parent = TabButton

    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Name = name .. "Page"
    TabPage.BackgroundTransparency = 1
    TabPage.BorderSizePixel = 0
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.Visible = false
    TabPage.ScrollBarThickness = 0
    TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabPage.Parent = self.ContentContainer

    local LeftColumn = Instance.new("Frame")
    LeftColumn.Name = "Left"
    LeftColumn.BackgroundTransparency = 1
    LeftColumn.Position = UDim2.new(0.015, 0, 0.01, 0)
    LeftColumn.Size = UDim2.new(0.48, 0, 0.98, 0)
    LeftColumn.Parent = TabPage

    local RightColumn = Instance.new("Frame")
    RightColumn.Name = "Right"
    RightColumn.BackgroundTransparency = 1
    RightColumn.Position = UDim2.new(0.505, 0, 0.01, 0)
    RightColumn.Size = UDim2.new(0.48, 0, 0.98, 0)
    RightColumn.Parent = TabPage

    local function CreateColumnLayout(col)
        local layout = Instance.new("UIListLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 10)
        layout.Parent = col
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, math.max(LeftColumn.UIListLayout.AbsoluteContentSize.Y, RightColumn.UIListLayout.AbsoluteContentSize.Y) + 20)
        end)
        return layout
    end

    CreateColumnLayout(LeftColumn)
    CreateColumnLayout(RightColumn)

    local function Activate()
        for _, t in pairs(self.Tabs) do
            t.Page.Visible = false
            Tween(t.Button, {TextColor3 = Color3.fromRGB(87, 87, 87)}, 0.2)
            t.Line.Visible = false
        end
        TabPage.Visible = true
        Tween(TabButton, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
        TabLine.Visible = true
    end

    TabButton.MouseButton1Click:Connect(Activate)

    Tab.Button = TabButton
    Tab.Line = TabLine
    Tab.Page = TabPage
    Tab.Left = LeftColumn
    Tab.Right = RightColumn

    table.insert(self.Tabs, Tab)

    if #self.Tabs == 1 then
        Activate()
    end

    function Tab:CreateSection(side)
        local Section = {}
        local Container = side == "Right" and RightColumn or LeftColumn

        local SectionFrame = Instance.new("Frame")
        SectionFrame.Name = "Section"
        SectionFrame.BackgroundColor3 = Library.Background
        SectionFrame.BorderColor3 = Library.Border
        SectionFrame.Size = UDim2.new(1, 0, 0, 30)
        SectionFrame.Parent = Container

        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Padding = UDim.new(0, 8)
        UIListLayout.Parent = SectionFrame

        local UIPadding = Instance.new("UIPadding")
        UIPadding.PaddingLeft = UDim.new(0, 10)
        UIPadding.PaddingRight = UDim.new(0, 10)
        UIPadding.PaddingTop = UDim.new(0, 10)
        UIPadding.PaddingBottom = UDim.new(0, 10)
        UIPadding.Parent = SectionFrame

        UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            SectionFrame.Size = UDim2.new(1, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
        end)

        function Section:CreateCheckbox(options)
            local cb = {Value = options.Default or false}
            local Button = Instance.new("TextButton")
            Button.Name = "Checkbox"
            Button.BackgroundColor3 = Library.Background
            Button.BorderColor3 = Library.Border
            Button.Size = UDim2.new(0, 15, 0, 15)
            Button.Text = ""
            Button.Parent = SectionFrame

            local Fill = Instance.new("Frame")
            Fill.BorderSizePixel = 0
            Fill.BackgroundColor3 = Library.Accent
            Fill.Size = UDim2.new(0, 0, 0, 0)
            Fill.AnchorPoint = Vector2.new(0.5, 0.5)
            Fill.Position = UDim2.new(0.5, 0, 0.5, 0)
            Fill.Parent = Button

            local Label = Instance.new("TextLabel")
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(1.4, 0, 0, 0)
            Label.Size = UDim2.new(0, 200, 1, 0)
            Label.Font = Enum.Font.SourceSans
            Label.Text = options.Name or "Checkbox"
            Label.TextColor3 = Color3.fromRGB(220, 220, 220)
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.TextStrokeTransparency = 0.8
            Label.Parent = Button

            local function Toggle(val)
                if val ~= nil then cb.Value = val else cb.Value = not cb.Value end
                if cb.Value then
                    Tween(Fill, {Size = UDim2.new(1, -2, 1, -2)}, 0.1)
                    Tween(Label, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.1)
                else
                    Tween(Fill, {Size = UDim2.new(0, 0, 0, 0)}, 0.1)
                    Tween(Label, {TextColor3 = Color3.fromRGB(220, 220, 220)}, 0.1)
                end
                if options.Callback then options.Callback(cb.Value) end
                if options.Flag then Library.Flags[options.Flag] = cb.Value end
            end

            Button.MouseButton1Click:Connect(function() Toggle() end)
            if cb.Value then Toggle(true) end

            return {Set = Toggle}
        end

        function Section:CreateSlider(options)
            local slider = {Value = options.Default or options.Min or 0}
            local min = options.Min or 0
            local max = options.Max or 100

            local Container = Instance.new("Frame")
            Container.Name = "SliderContainer"
            Container.BackgroundTransparency = 1
            Container.Size = UDim2.new(1, 0, 0, 35)
            Container.Parent = SectionFrame

            local Label = Instance.new("TextLabel")
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(1, 0, 0, 18)
            Label.Font = Enum.Font.SourceSans
            Label.Text = options.Name
            Label.TextColor3 = Color3.fromRGB(220, 220, 220)
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.TextStrokeTransparency = 0.8
            Label.Parent = Container

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Size = UDim2.new(1, 0, 0, 18)
            ValueLabel.Font = Enum.Font.SourceSans
            ValueLabel.Text = tostring(slider.Value)
            ValueLabel.TextColor3 = Library.Accent
            ValueLabel.TextSize = 13
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Parent = Container

            local SliderBack = Instance.new("TextButton")
            SliderBack.Name = "Slider"
            SliderBack.BackgroundColor3 = Library.Background
            SliderBack.BorderColor3 = Library.Border
            SliderBack.Position = UDim2.new(0, 0, 0, 22)
            SliderBack.Size = UDim2.new(1, 0, 0, 8)
            SliderBack.Text = ""
            SliderBack.AutoButtonColor = false
            SliderBack.Parent = Container

            local SliderFill = Instance.new("Frame")
            SliderFill.BackgroundColor3 = Library.Accent
            SliderFill.BorderSizePixel = 0
            SliderFill.Size = UDim2.new((slider.Value - min) / (max - min), 0, 1, 0)
            SliderFill.Parent = SliderBack

            local function Update(input)
                local pos = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
                slider.Value = math.floor(min + (max - min) * pos)
                SliderFill.Size = UDim2.new(pos, 0, 1, 0)
                ValueLabel.Text = tostring(slider.Value)
                if options.Callback then options.Callback(slider.Value) end
                if options.Flag then Library.Flags[options.Flag] = slider.Value end
            end

            local dragging = false
            SliderBack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    Update(input)
                end
            end)
            SliderBack.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    Update(input)
                end
            end)

            function slider:Set(val)
                slider.Value = math.clamp(val, min, max)
                local pos = (slider.Value - min) / (max - min)
                SliderFill.Size = UDim2.new(pos, 0, 1, 0)
                ValueLabel.Text = tostring(slider.Value)
                if options.Callback then options.Callback(slider.Value) end
            end

            return slider
        end

        function Section:CreateKeybind(options)
            local kb = {Value = options.Default or Enum.KeyCode.Unknown, Binding = false}
            
            local Container = Instance.new("Frame")
            Container.BackgroundTransparency = 1
            Container.Size = UDim2.new(1, 0, 0, 20)
            Container.Parent = SectionFrame

            local Label = Instance.new("TextLabel")
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(0.6, 0, 1, 0)
            Label.Font = Enum.Font.SourceSans
            Label.Text = options.Name or "Keybind"
            Label.TextColor3 = Color3.fromRGB(220, 220, 220)
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.TextStrokeTransparency = 0.8
            Label.Parent = Container

            local BindButton = Instance.new("TextButton")
            BindButton.BackgroundColor3 = Library.Background
            BindButton.BorderColor3 = Library.Border
            BindButton.Position = UDim2.new(1, -70, 0, 0)
            BindButton.Size = UDim2.new(0, 70, 1, 0)
            BindButton.Font = Enum.Font.SourceSans
            BindButton.Text = kb.Value.Name
            BindButton.TextColor3 = Library.Accent
            BindButton.TextSize = 13
            BindButton.Parent = Container

            local function UpdateBind(newKey)
                kb.Value = newKey
                BindButton.Text = kb.Value.Name
                if options.Callback then options.Callback(kb.Value) end
                
                -- Sync with Keybind List (Automatic or Manual)
                local displayName = options.DisplayName or options.Name
                if Library.KeybindDisplays[displayName] then
                    Library.KeybindDisplays[displayName].Update(kb.Value.Name)
                end
            end

            -- Automatic registration in Keybind List
            if options.Display ~= false then
                Library:AddKeybindDisplay(options.DisplayName or options.Name, kb.Value)
            end

            BindButton.MouseButton1Click:Connect(function()
                kb.Binding = true
                BindButton.Text = "..."
                BindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            end)

            UserInputService.InputBegan:Connect(function(input, gpe)
                if kb.Binding and input.UserInputType == Enum.UserInputType.Keyboard then
                    kb.Binding = false
                    BindButton.TextColor3 = Library.Accent
                    UpdateBind(input.KeyCode)
                elseif not kb.Binding and not gpe and input.KeyCode == kb.Value then
                    if options.Callback then options.Callback(kb.Value) end
                end
            end)

            return kb
        end

        function Section:CreateColorpicker(options)
            local cp = {Value = options.Default or Color3.fromRGB(255, 255, 255), Toggled = false}
            local h, s, v = cp.Value:ToHSV()

            local Container = Instance.new("Frame")
            Container.BackgroundTransparency = 1
            Container.Size = UDim2.new(1, 0, 0, 20)
            Container.Parent = SectionFrame

            local Label = Instance.new("TextLabel")
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(0.6, 0, 1, 0)
            Label.Font = Enum.Font.SourceSans
            Label.Text = options.Name or "Colorpicker"
            Label.TextColor3 = Color3.fromRGB(220, 220, 220)
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.TextStrokeTransparency = 0.8
            Label.Parent = Container

            local ColorBox = Instance.new("TextButton")
            ColorBox.BackgroundColor3 = cp.Value
            ColorBox.BorderColor3 = Library.Border
            ColorBox.Position = UDim2.new(1, -30, 0, 0)
            ColorBox.Size = UDim2.new(0, 30, 1, 0)
            ColorBox.Text = ""
            ColorBox.Parent = Container

            -- Create Picker at ScreenGui level to avoid clipping
            local PickerFrame = Instance.new("Frame")
            PickerFrame.Name = "Picker_" .. (options.Name or "Colorpicker")
            PickerFrame.BackgroundColor3 = Library.Background
            PickerFrame.BorderColor3 = Library.Border
            PickerFrame.Size = UDim2.new(0, 150, 0, 160)
            PickerFrame.Visible = false
            PickerFrame.ZIndex = 10
            PickerFrame.Parent = Library.ScreenGui

            -- Saturation/Value Square
            local SVSquare = Instance.new("TextButton")
            SVSquare.Name = "SVSquare"
            SVSquare.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
            SVSquare.BorderSizePixel = 0
            SVSquare.Position = UDim2.new(0, 10, 0, 10)
            SVSquare.Size = UDim2.new(0, 110, 0, 140)
            SVSquare.Text = ""
            SVSquare.AutoButtonColor = false
            SVSquare.Parent = PickerFrame

            local SGradient = Instance.new("ImageLabel")
            SGradient.Size = UDim2.new(1, 0, 1, 0)
            SGradient.BackgroundTransparency = 1
            SGradient.Image = "rbxassetid://4155801252"
            SGradient.Parent = SVSquare

            local VGradient = Instance.new("ImageLabel")
            VGradient.Size = UDim2.new(1, 0, 1, 0)
            VGradient.BackgroundTransparency = 1
            VGradient.Image = "rbxassetid://4155801332"
            VGradient.Parent = SVSquare

            -- Hue Slider
            local HueSlider = Instance.new("TextButton")
            HueSlider.Name = "Hue"
            HueSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            HueSlider.BorderSizePixel = 0
            HueSlider.Position = UDim2.new(0, 130, 0, 10)
            HueSlider.Size = UDim2.new(0, 10, 0, 140)
            HueSlider.Text = ""
            HueSlider.AutoButtonColor = false
            HueSlider.Parent = PickerFrame

            local HueGradient = Instance.new("UIGradient")
            HueGradient.Rotation = 90
            HueGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromHSV(1, 1, 1)),
                ColorSequenceKeypoint.new(0.166, Color3.fromHSV(0.833, 1, 1)),
                ColorSequenceKeypoint.new(0.333, Color3.fromHSV(0.666, 1, 1)),
                ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
                ColorSequenceKeypoint.new(0.666, Color3.fromHSV(0.333, 1, 1)),
                ColorSequenceKeypoint.new(0.833, Color3.fromHSV(0.166, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.fromHSV(0, 1, 1))
            })
            HueGradient.Parent = HueSlider

            local function UpdateColor()
                cp.Value = Color3.fromHSV(h, s, v)
                ColorBox.BackgroundColor3 = cp.Value
                SVSquare.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                if options.Callback then options.Callback(cp.Value) end
                if options.Flag then Library.Flags[options.Flag] = cp.Value end
            end

            local HueDragging = false
            local SVDragging = false

            HueSlider.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    HueDragging = true
                end
            end)
            SVSquare.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    SVDragging = true
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    HueDragging = false
                    SVDragging = false
                end
            end)

            RunService.RenderStepped:Connect(function()
                if not PickerFrame.Visible then return end
                local mouseLoc = UserInputService:GetMouseLocation()
                if HueDragging then
                    local pos = math.clamp((mouseLoc.Y - 36 - HueSlider.AbsolutePosition.Y) / HueSlider.AbsoluteSize.Y, 0, 1)
                    h = 1 - pos
                    UpdateColor()
                end
                if SVDragging then
                    local posX = math.clamp((mouseLoc.X - SVSquare.AbsolutePosition.X) / SVSquare.AbsoluteSize.X, 0, 1)
                    local posY = math.clamp((mouseLoc.Y - 36 - SVSquare.AbsolutePosition.Y) / SVSquare.AbsoluteSize.Y, 0, 1)
                    s = posX
                    v = 1 - posY
                    UpdateColor()
                end
            end)

            ColorBox.MouseButton1Click:Connect(function()
                cp.Toggled = not cp.Toggled
                if cp.Toggled then
                    -- Update position relative to ColorBox
                    PickerFrame.Position = UDim2.new(0, ColorBox.AbsolutePosition.X + 35, 0, ColorBox.AbsolutePosition.Y)
                end
                PickerFrame.Visible = cp.Toggled
            end)

            return cp
        end

        return Section
    end

    return Tab
end

function Library:CreateWatermark()
    if self.WatermarkMain then self.WatermarkMain:Destroy() end

    local WatermarkMain = Instance.new("Frame")
    WatermarkMain.Name = "Watermark"
    WatermarkMain.BackgroundColor3 = self.Background
    WatermarkMain.BorderColor3 = self.Border
    WatermarkMain.Position = UDim2.new(0.01, 0, 0.01, 0)
    WatermarkMain.Size = UDim2.new(0, 220, 0, 140)
    WatermarkMain.Parent = self.ScreenGui
    self.WatermarkMain = WatermarkMain

    MakeDraggable(WatermarkMain, WatermarkMain)

    local AccentTop = Instance.new("Frame")
    AccentTop.BackgroundColor3 = self.Accent
    AccentTop.BorderSizePixel = 0
    AccentTop.Size = UDim2.new(1, 0, 0, 2)
    AccentTop.Parent = WatermarkMain

    local Title = Instance.new("TextLabel")
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 10, 0, 5)
    Title.Size = UDim2.new(1, -20, 0, 20)
    Title.Font = Enum.Font.SourceSansBold
    Title.Text = "NoName <font color='rgb(176, 141, 109)'>WTF</font>"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.RichText = true
    Title.Parent = WatermarkMain

    local Container = Instance.new("Frame")
    Container.BackgroundTransparency = 1
    Container.Position = UDim2.new(0, 10, 0, 30)
    Container.Size = UDim2.new(1, -20, 1, -40)
    Container.Parent = WatermarkMain

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 4)
    UIListLayout.Parent = Container

    local function CreateInfo(name, text)
        local Label = Instance.new("TextLabel")
        Label.BackgroundTransparency = 1
        Label.Size = UDim2.new(1, 0, 0, 16)
        Label.Font = Enum.Font.SourceSans
        Label.Text = "> " .. text
        Label.TextColor3 = Color3.fromRGB(200, 200, 200)
        Label.TextSize = 13
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Container
        return Label
    end

    local UserLabel = CreateInfo("user", "User: " .. LocalPlayer.Name)
    local DateLabel = CreateInfo("date", "Date: 00/00/0000")
    local PingLabel = CreateInfo("ping", "Ping: 0ms")
    local PlayLabel = CreateInfo("play", "Play-time: 0s")

    spawn(function()
        local start = tick()
        while wait(1) do
            DateLabel.Text = "> Date: " .. os.date("%x")
            PlayLabel.Text = "> Play-time: " .. math.floor(tick() - start) .. "s"
            PingLabel.Text = "> Ping: " .. math.floor(LocalPlayer:GetNetworkPing() * 1000) .. "ms"
        end
    end)
end

function Library:CreateKeybindList()
    if self.KeybindFrame then self.KeybindFrame:Destroy() end

    local KeybindFrame = Instance.new("Frame")
    KeybindFrame.Name = "KeybindList"
    KeybindFrame.BackgroundColor3 = self.Background
    KeybindFrame.BorderColor3 = self.Border
    KeybindFrame.Position = UDim2.new(0.01, 0, 0.4, 0)
    KeybindFrame.Size = UDim2.new(0, 180, 0, 0)
    KeybindFrame.AutomaticSize = Enum.AutomaticSize.Y
    KeybindFrame.ClipsDescendants = false
    KeybindFrame.Parent = self.ScreenGui
    self.KeybindFrame = KeybindFrame

    MakeDraggable(KeybindFrame, KeybindFrame)

    local AccentTop = Instance.new("Frame")
    AccentTop.BackgroundColor3 = self.Accent
    AccentTop.BorderSizePixel = 0
    AccentTop.Size = UDim2.new(1, 0, 0, 2)
    AccentTop.Parent = KeybindFrame

    local Title = Instance.new("TextLabel")
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 0, 0, 2)
    Title.Size = UDim2.new(1, 0, 0, 25)
    Title.Font = Enum.Font.SourceSansBold
    Title.Text = "Keybinds"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.Parent = KeybindFrame

    local Container = Instance.new("Frame")
    Container.BackgroundTransparency = 1
    Container.Position = UDim2.new(0, 10, 0, 30)
    Container.Size = UDim2.new(1, -20, 0, 0)
    Container.AutomaticSize = Enum.AutomaticSize.Y
    Container.Parent = KeybindFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 4)
    UIListLayout.Parent = Container

    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingBottom = UDim.new(0, 10)
    UIPadding.Parent = Container

    self.KeybindContainer = Container
end

function Library:AddKeybindDisplay(name, key)
    local keyText = typeof(key) == "EnumItem" and key.Name or tostring(key)
    
    local Label = Instance.new("TextLabel")
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, 0, 0, 16)
    Label.Font = Enum.Font.SourceSans
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = self.KeybindContainer

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Size = UDim2.new(1, 0, 1, 0)
    ValueLabel.Font = Enum.Font.SourceSans
    ValueLabel.Text = "[" .. keyText .. "]"
    ValueLabel.TextColor3 = self.Accent
    ValueLabel.TextSize = 13
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = Label

    local display = {
        Update = function(newKey)
            local newKeyText = typeof(newKey) == "EnumItem" and newKey.Name or tostring(newKey)
            ValueLabel.Text = "[" .. newKeyText .. "]"
        end,
        Remove = function()
            Label:Destroy()
            Library.KeybindDisplays[name] = nil
        end
    }

    Library.KeybindDisplays[name] = display
    -- Force initial update if key is passed
    display.Update(key)
    
    return display
end


return Library
