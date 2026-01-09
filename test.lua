--[[
    NoName UI Library
    Clean, Modular, and Functional
]]

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
    Toggled = true,
    Accent = Color3.fromRGB(176, 141, 109),
    Background = Color3.fromRGB(9, 9, 9),
    Border = Color3.fromRGB(41, 41, 41),
    Text = Color3.fromRGB(255, 255, 255),
    SecondaryText = Color3.fromRGB(87, 87, 87)
}

-- Utility Functions
function Library:Tween(object, duration, goal)
    local tween = TweenService:Create(object, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goal)
    tween:Play()
    return tween
end

function Library:MakeDraggable(frame, parent)
    parent = parent or frame
    local dragging = false
    local dragInput, dragStart, startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = parent.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            parent.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function Library:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NoName"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")
    self.ScreenGui = ScreenGui

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.BackgroundColor3 = Library.Background
    Main.BorderColor3 = Library.Border
    Main.Position = UDim2.new(0.5, -322, 0.5, -310)
    Main.Size = UDim2.new(0, 644, 0, 620)
    Main.Parent = ScreenGui
    self.Main = Main

    Library:MakeDraggable(Main)

    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.BackgroundTransparency = 1
    Header.Size = UDim2.new(1, 0, 0, 60)
    Header.Parent = Main

    local TitleContainer = Instance.new("Frame")
    TitleContainer.Name = "TitleContainer"
    TitleContainer.BackgroundTransparency = 1
    TitleContainer.Position = UDim2.new(0.5, 0, 0, 0)
    TitleContainer.Size = UDim2.new(0, 0, 0, 35)
    TitleContainer.Parent = Header

    local Title1 = Instance.new("TextLabel")
    Title1.Name = "Title1"
    Title1.BackgroundTransparency = 1
    Title1.Position = UDim2.new(0, -45, 0, 0)
    Title1.Size = UDim2.new(0, 57, 1, 0)
    Title1.Font = Enum.Font.SourceSansBold
    Title1.Text = "NoName"
    Title1.TextColor3 = Library.Text
    Title1.TextSize = 18
    Title1.Parent = TitleContainer

    local Title2 = Instance.new("TextLabel")
    Title2.Name = "Title2"
    Title2.BackgroundTransparency = 1
    Title2.Position = UDim2.new(0, 12, 0, 0)
    Title2.Size = UDim2.new(0, 40, 1, 0)
    Title2.Font = Enum.Font.SourceSansBold
    Title2.Text = title or "WTF"
    Title2.TextColor3 = Library.Accent
    Title2.TextSize = 18
    Title2.Parent = TitleContainer

    local Line = Instance.new("Frame")
    Line.Name = "Line"
    Line.BackgroundColor3 = Library.Border
    Line.BorderSizePixel = 0
    Line.Position = UDim2.new(0, 10, 0, 35)
    Line.Size = UDim2.new(1, -20, 0, 1)
    Line.Parent = Header

    local TabsContainer = Instance.new("Frame")
    TabsContainer.Name = "TabsContainer"
    TabsContainer.BackgroundTransparency = 1
    TabsContainer.Position = UDim2.new(0, 10, 0, 36)
    TabsContainer.Size = UDim2.new(1, -20, 0, 24)
    TabsContainer.Parent = Header

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.FillDirection = Enum.FillDirection.Horizontal
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Parent = TabsContainer

    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.BackgroundColor3 = Library.Background
    Container.BorderColor3 = Library.Border
    Container.Position = UDim2.new(0, 10, 0, 70)
    Container.Size = UDim2.new(1, -20, 1, -80)
    Container.Parent = Main

    local Window = {
        CurrentTab = nil,
        Tabs = {}
    }

    function Window:CreateTab(name)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name .. "Tab"
        TabButton.BackgroundTransparency = 1
        TabButton.Size = UDim2.new(0, (624 / 4), 1, 0)
        TabButton.Font = Enum.Font.SourceSans
        TabButton.Text = name
        TabButton.TextColor3 = Library.SecondaryText
        TabButton.TextSize = 14
        TabButton.Parent = TabsContainer

        local TabIndicator = Instance.new("Frame")
        TabIndicator.Name = "Indicator"
        TabIndicator.BackgroundColor3 = Library.Accent
        TabIndicator.BorderSizePixel = 0
        TabIndicator.Position = UDim2.new(0.1, 0, 1, -1)
        TabIndicator.Size = UDim2.new(0.8, 0, 0, 1)
        TabIndicator.Visible = false
        TabIndicator.Parent = TabButton

        local TabFrame = Instance.new("Frame")
        TabFrame.Name = name .. "Frame"
        TabFrame.BackgroundTransparency = 1
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.Visible = false
        TabFrame.Parent = Container

        local LeftSide = Instance.new("ScrollingFrame")
        LeftSide.Name = "Left"
        LeftSide.BackgroundTransparency = 1
        LeftSide.Position = UDim2.new(0, 5, 0, 5)
        LeftSide.Size = UDim2.new(0.5, -7, 1, -10)
        LeftSide.CanvasSize = UDim2.new(0, 0, 0, 0)
        LeftSide.ScrollBarThickness = 0
        LeftSide.Parent = TabFrame

        local RightSide = Instance.new("ScrollingFrame")
        RightSide.Name = "Right"
        RightSide.BackgroundTransparency = 1
        RightSide.Position = UDim2.new(0.5, 2, 0, 5)
        RightSide.Size = UDim2.new(0.5, -7, 1, -10)
        RightSide.CanvasSize = UDim2.new(0, 0, 0, 0)
        RightSide.ScrollBarThickness = 0
        RightSide.Parent = TabFrame

        local LeftLayout = Instance.new("UIListLayout")
        LeftLayout.Padding = UDim.new(0, 10)
        LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
        LeftLayout.Parent = LeftSide

        local RightLayout = Instance.new("UIListLayout")
        RightLayout.Padding = UDim.new(0, 10)
        RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
        RightLayout.Parent = RightSide

        local Tab = {
            Sections = {}
        }

        function Tab:Select()
            if Window.CurrentTab then
                Window.CurrentTab.Button.TextColor3 = Library.SecondaryText
                Window.CurrentTab.Indicator.Visible = false
                Window.CurrentTab.Frame.Visible = false
            end
            TabButton.TextColor3 = Library.Text
            TabIndicator.Visible = true
            TabFrame.Visible = true
            Window.CurrentTab = {
                Button = TabButton,
                Indicator = TabIndicator,
                Frame = TabFrame
            }
        end

        TabButton.MouseButton1Click:Connect(function()
            Tab:Select()
        end)

        if not Window.CurrentTab then
            Tab:Select()
        end

        function Tab:CreateSection(name, side)
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = name .. "Section"
            SectionFrame.BackgroundColor3 = Library.Background
            SectionFrame.BorderColor3 = Library.Border
            SectionFrame.Size = UDim2.new(1, 0, 0, 30)
            SectionFrame.Parent = (tostring(side):lower() == "right" and RightSide or LeftSide)

            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "Title"
            SectionTitle.BackgroundColor3 = Library.Background
            SectionTitle.BorderSizePixel = 0
            SectionTitle.Position = UDim2.new(0, 10, 0, -8)
            SectionTitle.Size = UDim2.new(0, 0, 0, 14)
            SectionTitle.Font = Enum.Font.SourceSansBold
            SectionTitle.Text = "  " .. name .. "  "
            SectionTitle.TextColor3 = Library.Text
            SectionTitle.TextSize = 14
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.AutomaticSize = Enum.AutomaticSize.X
            SectionTitle.Parent = SectionFrame

            local Content = Instance.new("Frame")
            Content.Name = "Content"
            Content.BackgroundTransparency = 1
            Content.Position = UDim2.new(0, 10, 0, 12)
            Content.Size = UDim2.new(1, -20, 1, -22)
            Content.Parent = SectionFrame

            local ContentLayout = Instance.new("UIListLayout")
            ContentLayout.Padding = UDim.new(0, 8)
            ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ContentLayout.Parent = Content

            ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionFrame.Size = UDim2.new(1, 0, 0, ContentLayout.AbsoluteContentSize.Y + 25)
                LeftSide.CanvasSize = UDim2.new(0, 0, 0, LeftLayout.AbsoluteContentSize.Y + 10)
                RightSide.CanvasSize = UDim2.new(0, 0, 0, RightLayout.AbsoluteContentSize.Y + 10)
            end)

            local Section = {}

            function Section:CreateCheckbox(text, default, callback)
                local CheckboxFrame = Instance.new("Frame")
                CheckboxFrame.Name = text .. "Checkbox"
                CheckboxFrame.BackgroundTransparency = 1
                CheckboxFrame.Size = UDim2.new(1, 0, 0, 15)
                CheckboxFrame.Parent = Content

                local Box = Instance.new("TextButton")
                Box.Name = "Box"
                Box.BackgroundColor3 = Library.Background
                Box.BorderColor3 = Library.Border
                Box.Size = UDim2.new(0, 15, 0, 15)
                Box.Text = ""
                Box.Parent = CheckboxFrame

                local Label = Instance.new("TextLabel")
                Label.Name = "Label"
                Label.BackgroundTransparency = 1
                Label.Position = UDim2.new(0, 25, 0, 0)
                Label.Size = UDim2.new(1, -25, 1, 0)
                Label.Font = Enum.Font.SourceSans
                Label.Text = text
                Label.TextColor3 = Library.Text
                Label.TextSize = 14
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = CheckboxFrame

                local Enabled = default or false
                local function Update()
                    Box.BackgroundColor3 = Enabled and Library.Accent or Library.Background
                    Box.BorderColor3 = Enabled and Library.Accent or Library.Border
                    callback(Enabled)
                end

                Box.MouseButton1Click:Connect(function()
                    Enabled = not Enabled
                    Update()
                end)

                Update()
                return {
                    Set = function(val) Enabled = val Update() end
                }
            end

            function Section:CreateSlider(text, min, max, default, callback)
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Name = text .. "Slider"
                SliderFrame.BackgroundTransparency = 1
                SliderFrame.Size = UDim2.new(1, 0, 0, 30)
                SliderFrame.Parent = Content

                local Label = Instance.new("TextLabel")
                Label.Name = "Label"
                Label.BackgroundTransparency = 1
                Label.Size = UDim2.new(1, 0, 0, 15)
                Label.Font = Enum.Font.SourceSans
                Label.Text = text
                Label.TextColor3 = Library.Text
                Label.TextSize = 14
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = SliderFrame

                local ValueLabel = Instance.new("TextLabel")
                ValueLabel.Name = "Value"
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.Size = UDim2.new(1, 0, 0, 15)
                ValueLabel.Font = Enum.Font.SourceSans
                ValueLabel.Text = tostring(default)
                ValueLabel.TextColor3 = Library.Text
                ValueLabel.TextSize = 14
                ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
                ValueLabel.Parent = SliderFrame

                local SliderBack = Instance.new("TextButton")
                SliderBack.Name = "Back"
                SliderBack.BackgroundColor3 = Library.Background
                SliderBack.BorderColor3 = Library.Border
                SliderBack.Position = UDim2.new(0, 0, 0, 20)
                SliderBack.Size = UDim2.new(1, 0, 0, 6)
                SliderBack.Text = ""
                SliderBack.Parent = SliderFrame

                local SliderFill = Instance.new("Frame")
                SliderFill.Name = "Fill"
                SliderFill.BackgroundColor3 = Library.Accent
                SliderFill.BorderSizePixel = 0
                SliderFill.Size = UDim2.new(0, 0, 1, 0)
                SliderFill.Parent = SliderBack

                local Value = default or min
                local function Update()
                    local percent = (Value - min) / (max - min)
                    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    ValueLabel.Text = tostring(math.floor(Value))
                    callback(Value)
                end

                local function Move()
                    local mousePos = UserInputService:GetMouseLocation().X
                    local relativePos = mousePos - SliderBack.AbsolutePosition.X
                    local percent = math.clamp(relativePos / SliderBack.AbsoluteSize.X, 0, 1)
                    Value = min + (max - min) * percent
                    Update()
                end

                SliderBack.MouseButton1Down:Connect(function()
                    Move()
                    local Connection; Connection = RunService.RenderStepped:Connect(function()
                        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                            Move()
                        else
                            Connection:Disconnect()
                        end
                    end)
                end)

                Update()
            end

            function Section:CreateDropdown(text, options, default, callback)
                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.Name = text .. "Dropdown"
                DropdownFrame.BackgroundTransparency = 1
                DropdownFrame.Size = UDim2.new(1, 0, 0, 40)
                DropdownFrame.Parent = Content

                local Label = Instance.new("TextLabel")
                Label.Name = "Label"
                Label.BackgroundTransparency = 1
                Label.Size = UDim2.new(1, 0, 0, 15)
                Label.Font = Enum.Font.SourceSans
                Label.Text = text
                Label.TextColor3 = Library.Text
                Label.TextSize = 14
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = DropdownFrame

                local Button = Instance.new("TextButton")
                Button.Name = "Button"
                Button.BackgroundColor3 = Library.Background
                Button.BorderColor3 = Library.Border
                Button.Position = UDim2.new(0, 0, 0, 20)
                Button.Size = UDim2.new(1, 0, 0, 18)
                Button.Font = Enum.Font.SourceSans
                Button.Text = " " .. (default or "None")
                Button.TextColor3 = Library.Text
                Button.TextSize = 14
                Button.TextXAlignment = Enum.TextXAlignment.Left
                Button.Parent = DropdownFrame

                local Icon = Instance.new("TextLabel")
                Icon.Name = "Icon"
                Icon.BackgroundTransparency = 1
                Icon.Position = UDim2.new(1, -18, 0, 0)
                Icon.Size = UDim2.new(0, 18, 1, 0)
                Icon.Font = Enum.Font.SourceSans
                Icon.Text = "▼"
                Icon.TextColor3 = Library.Text
                Icon.TextSize = 10
                Icon.Parent = Button

                local List = Instance.new("Frame")
                List.Name = "List"
                List.BackgroundColor3 = Library.Background
                List.BorderColor3 = Library.Border
                List.Position = UDim2.new(0, 0, 1, 2)
                List.Size = UDim2.new(1, 0, 0, 0)
                List.Visible = false
                List.ZIndex = 5
                List.Parent = Button

                local ListLayout = Instance.new("UIListLayout")
                ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                ListLayout.Parent = List

                local Open = false
                local function ToggleList()
                    Open = not Open
                    List.Visible = Open
                    List.Size = Open and UDim2.new(1, 0, 0, ListLayout.AbsoluteContentSize.Y) or UDim2.new(1, 0, 0, 0)
                    Icon.Text = Open and "▲" or "▼"
                    if Open then
                        -- Close other dropdowns/pickers
                    end
                end

                Button.MouseButton1Click:Connect(ToggleList)

                -- Click away to close
                UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 and Open then
                        local mousePos = UserInputService:GetMouseLocation()
                        local pos, size = Button.AbsolutePosition, Button.AbsoluteSize
                        local listSize = List.AbsoluteSize
                        if not (mousePos.X >= pos.X and mousePos.X <= pos.X + size.X and mousePos.Y >= pos.Y and mousePos.Y <= pos.Y + size.Y + listSize.Y) then
                            ToggleList()
                        end
                    end
                end)

                for _, opt in ipairs(options) do
                    local OptBtn = Instance.new("TextButton")
                    OptBtn.Name = opt
                    OptBtn.BackgroundColor3 = Library.Background
                    OptBtn.BorderSizePixel = 0
                    OptBtn.Size = UDim2.new(1, 0, 0, 18)
                    OptBtn.Font = Enum.Font.SourceSans
                    OptBtn.Text = " " .. opt
                    OptBtn.TextColor3 = Library.SecondaryText
                    OptBtn.TextSize = 14
                    OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                    OptBtn.ZIndex = 6
                    OptBtn.Parent = List

                    OptBtn.MouseButton1Click:Connect(function()
                        Button.Text = " " .. opt
                        callback(opt)
                        ToggleList()
                    end)

                    OptBtn.MouseEnter:Connect(function() OptBtn.TextColor3 = Library.Text end)
                    OptBtn.MouseLeave:Connect(function() if Button.Text ~= " " .. opt then OptBtn.TextColor3 = Library.SecondaryText end end)
                end
            end

            function Section:CreateColorpicker(text, default, callback)
                local ColorpickerFrame = Instance.new("Frame")
                ColorpickerFrame.Name = text .. "Colorpicker"
                ColorpickerFrame.BackgroundTransparency = 1
                ColorpickerFrame.Size = UDim2.new(1, 0, 0, 15)
                ColorpickerFrame.Parent = Content

                local Label = Instance.new("TextLabel")
                Label.Name = "Label"
                Label.BackgroundTransparency = 1
                Label.Size = UDim2.new(1, 0, 0, 15)
                Label.Font = Enum.Font.SourceSans
                Label.Text = text
                Label.TextColor3 = Library.Text
                Label.TextSize = 14
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = ColorpickerFrame

                local ColorBox = Instance.new("TextButton")
                ColorBox.Name = "ColorBox"
                ColorBox.BackgroundColor3 = default or Library.Accent
                ColorBox.BorderColor3 = Library.Border
                ColorBox.Position = UDim2.new(1, -30, 0, 0)
                ColorBox.Size = UDim2.new(0, 30, 0, 15)
                ColorBox.Text = ""
                ColorBox.Parent = ColorpickerFrame

                local PickerFrame = Instance.new("Frame")
                PickerFrame.Name = "Picker"
                PickerFrame.BackgroundColor3 = Library.Background
                PickerFrame.BorderColor3 = Library.Border
                PickerFrame.Position = UDim2.new(1, 5, 0, 0)
                PickerFrame.Size = UDim2.new(0, 150, 0, 150)
                PickerFrame.Visible = false
                PickerFrame.ZIndex = 10
                PickerFrame.Parent = ColorBox

                local Hue = Instance.new("ImageButton")
                Hue.Name = "Hue"
                Hue.Position = UDim2.new(0, 130, 0, 5)
                Hue.Size = UDim2.new(0, 15, 0, 140)
                Hue.Image = "rbxassetid://2561571714"
                Hue.ZIndex = 11
                Hue.Parent = PickerFrame

                local SatVal = Instance.new("ImageButton")
                SatVal.Name = "SatVal"
                SatVal.Position = UDim2.new(0, 5, 0, 5)
                SatVal.Size = UDim2.new(0, 120, 0, 140)
                SatVal.Image = "rbxassetid://4155801252"
                SatVal.ZIndex = 11
                SatVal.Parent = PickerFrame

                local h, s, v = Color3.toHSV(default or Library.Accent)

                local function Update()
                    local color = Color3.fromHSV(h, s, v)
                    ColorBox.BackgroundColor3 = color
                    SatVal.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    callback(color)
                end

                ColorBox.MouseButton1Click:Connect(function()
                    PickerFrame.Visible = not PickerFrame.Visible
                end)

                -- Click away to close
                UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 and PickerFrame.Visible then
                        local mousePos = UserInputService:GetMouseLocation()
                        local pos, size = PickerFrame.AbsolutePosition, PickerFrame.AbsoluteSize
                        local boxPos, boxSize = ColorBox.AbsolutePosition, ColorBox.AbsoluteSize
                        if not (mousePos.X >= pos.X and mousePos.X <= pos.X + size.X and mousePos.Y >= pos.Y and mousePos.Y <= pos.Y + size.Y) and
                           not (mousePos.X >= boxPos.X and mousePos.X <= boxPos.X + boxSize.X and mousePos.Y >= boxPos.Y and mousePos.Y <= boxPos.Y + boxSize.Y) then
                            PickerFrame.Visible = false
                        end
                    end
                end)

                Hue.MouseButton1Down:Connect(function()
                    local function Move()
                        local mousePos = UserInputService:GetMouseLocation().Y
                        local relativePos = mousePos - Hue.AbsolutePosition.Y
                        h = 1 - math.clamp(relativePos / Hue.AbsoluteSize.Y, 0, 1)
                        Update()
                    end
                    Move()
                    local Connection; Connection = RunService.RenderStepped:Connect(function()
                        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                            Move()
                        else
                            Connection:Disconnect()
                        end
                    end)
                end)

                SatVal.MouseButton1Down:Connect(function()
                    local function Move()
                        local mousePos = UserInputService:GetMouseLocation()
                        local relativeX = mousePos.X - SatVal.AbsolutePosition.X
                        local relativeY = mousePos.Y - SatVal.AbsolutePosition.Y
                        s = math.clamp(relativeX / SatVal.AbsoluteSize.X, 0, 1)
                        v = 1 - math.clamp(relativeY / SatVal.AbsoluteSize.Y, 0, 1)
                        Update()
                    end
                    Move()
                    local Connection; Connection = RunService.RenderStepped:Connect(function()
                        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                            Move()
                        else
                            Connection:Disconnect()
                        end
                    end)
                end)

                Update()
            end

            function Section:CreateKeybind(text, default, callback)
                local KeybindFrame = Instance.new("Frame")
                KeybindFrame.Name = text .. "Keybind"
                KeybindFrame.BackgroundTransparency = 1
                KeybindFrame.Size = UDim2.new(1, 0, 0, 15)
                KeybindFrame.Parent = Content

                local Label = Instance.new("TextLabel")
                Label.Name = "Label"
                Label.BackgroundTransparency = 1
                Label.Size = UDim2.new(1, 0, 0, 15)
                Label.Font = Enum.Font.SourceSans
                Label.Text = text
                Label.TextColor3 = Library.Text
                Label.TextSize = 14
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = KeybindFrame

                local BindButton = Instance.new("TextButton")
                BindButton.Name = "Bind"
                BindButton.BackgroundColor3 = Library.Background
                BindButton.BorderColor3 = Library.Border
                BindButton.Position = UDim2.new(1, -60, 0, 0)
                BindButton.Size = UDim2.new(0, 60, 0, 15)
                BindButton.Font = Enum.Font.SourceSans
                BindButton.Text = "[ " .. (default and default.Name or "None") .. " ]"
                BindButton.TextColor3 = Library.SecondaryText
                BindButton.TextSize = 14
                BindButton.Parent = KeybindFrame

                local CurrentBind = default
                local Binding = false

                BindButton.MouseButton1Click:Connect(function()
                    Binding = true
                    BindButton.Text = "[ ... ]"
                end)

                UserInputService.InputBegan:Connect(function(input)
                    if Binding then
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            CurrentBind = input.KeyCode
                            Binding = false
                            BindButton.Text = "[ " .. input.KeyCode.Name .. " ]"
                            callback(input.KeyCode)
                        elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
                            CurrentBind = input.UserInputType
                            Binding = false
                            BindButton.Text = "[ " .. input.UserInputType.Name .. " ]"
                            callback(input.UserInputType)
                        end
                    end
                end)
            end

            function Section:CreateButton(text, callback)
                local Button = Instance.new("TextButton")
                Button.Name = text .. "Button"
                Button.BackgroundColor3 = Library.Background
                Button.BorderColor3 = Library.Border
                Button.Size = UDim2.new(1, 0, 0, 20)
                Button.Font = Enum.Font.SourceSans
                Button.Text = text
                Button.TextColor3 = Library.Text
                Button.TextSize = 14
                Button.Parent = Content

                Button.MouseButton1Click:Connect(callback)
                
                Button.MouseEnter:Connect(function() Button.BorderColor3 = Library.Accent end)
                Button.MouseLeave:Connect(function() Button.BorderColor3 = Library.Border end)
            end

            return Section
        end

        return Tab
    end

    return Window
end

function Library:CreateWatermark(name)
    local Watermark = Instance.new("Frame")
    Watermark.Name = "Watermark"
    Watermark.BackgroundColor3 = Library.Background
    Watermark.BorderColor3 = Library.Border
    Watermark.Position = UDim2.new(0.011, 0, 0.019, 0)
    Watermark.Size = UDim2.new(0, 200, 0, 110)
    Watermark.Parent = self.ScreenGui

    local Line = Instance.new("Frame")
    Line.BackgroundColor3 = Library.Accent
    Line.BorderSizePixel = 0
    Line.Size = UDim2.new(0, 2, 1, 0)
    Line.Parent = Watermark

    local TitleCont = Instance.new("Frame")
    TitleCont.BackgroundTransparency = 1
    TitleCont.Position = UDim2.new(0, 10, 0, 5)
    TitleCont.Size = UDim2.new(1, -15, 0, 20)
    TitleCont.Parent = Watermark

    local T1 = Instance.new("TextLabel")
    T1.BackgroundTransparency = 1
    T1.Size = UDim2.new(0, 50, 1, 0)
    T1.Font = Enum.Font.SourceSansBold
    T1.Text = "NoName"
    T1.TextColor3 = Library.Text
    T1.TextSize = 14
    T1.TextXAlignment = Enum.TextXAlignment.Left
    T1.Parent = TitleCont

    local T2 = Instance.new("TextLabel")
    T2.BackgroundTransparency = 1
    T2.Position = UDim2.new(0, 55, 0, 0)
    T2.Size = UDim2.new(0, 50, 1, 0)
    T2.Font = Enum.Font.SourceSansBold
    T2.Text = name or "WTF"
    T2.TextColor3 = Library.Accent
    T2.TextSize = 14
    T2.TextXAlignment = Enum.TextXAlignment.Left
    T2.Parent = TitleCont

    local User = Instance.new("TextLabel")
    User.BackgroundTransparency = 1
    User.Position = UDim2.new(0, 10, 0, 25)
    User.Size = UDim2.new(1, -15, 0, 20)
    User.Font = Enum.Font.SourceSans
    User.Text = "> User: " .. LocalPlayer.Name
    User.TextColor3 = Library.Text
    User.TextSize = 14
    User.TextXAlignment = Enum.TextXAlignment.Left
    User.Parent = Watermark

    local Date = Instance.new("TextLabel")
    Date.BackgroundTransparency = 1
    Date.Position = UDim2.new(0, 10, 0, 45)
    Date.Size = UDim2.new(1, -15, 0, 20)
    Date.Font = Enum.Font.SourceSans
    Date.Text = "> Date: " .. os.date("%x")
    Date.TextColor3 = Library.Text
    Date.TextSize = 14
    Date.TextXAlignment = Enum.TextXAlignment.Left
    Date.Parent = Watermark

    local Ping = Instance.new("TextLabel")
    Ping.BackgroundTransparency = 1
    Ping.Position = UDim2.new(0, 10, 0, 65)
    Ping.Size = UDim2.new(1, -15, 0, 20)
    Ping.Font = Enum.Font.SourceSans
    Ping.Text = "> Ping: 0ms"
    Ping.TextColor3 = Library.Text
    Ping.TextSize = 14
    Ping.TextXAlignment = Enum.TextXAlignment.Left
    Ping.Parent = Watermark

    local Playtime = Instance.new("TextLabel")
    Playtime.BackgroundTransparency = 1
    Playtime.Position = UDim2.new(0, 10, 0, 85)
    Playtime.Size = UDim2.new(1, -15, 0, 20)
    Playtime.Font = Enum.Font.SourceSans
    Playtime.Text = "> Play-time: 0s"
    Playtime.TextColor3 = Library.Text
    Playtime.TextSize = 14
    Playtime.TextXAlignment = Enum.TextXAlignment.Left
    Playtime.Parent = Watermark

    local StartTime = tick()
    RunService.Heartbeat:Connect(function()
        Playtime.Text = "> Play-time: " .. math.floor(tick() - StartTime) .. "s"
        Ping.Text = "> Ping: " .. (game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString() or "0")
    end)
end

function Library:CreateKeybindList()
    local List = Instance.new("Frame")
    List.Name = "KeybindList"
    List.BackgroundColor3 = Library.Background
    List.BorderColor3 = Library.Border
    List.Position = UDim2.new(0.01, 0, 0.5, 0)
    List.Size = UDim2.new(0, 150, 0, 25)
    List.Parent = self.ScreenGui

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1, 0, 0, 25)
    Title.Font = Enum.Font.SourceSansBold
    Title.Text = "Keybinds"
    Title.TextColor3 = Library.Text
    Title.TextSize = 14
    Title.Parent = List

    local Items = Instance.new("Frame")
    Items.Name = "Items"
    Items.BackgroundTransparency = 1
    Items.Position = UDim2.new(0, 0, 0, 25)
    Items.Size = UDim2.new(1, 0, 0, 0)
    Items.Parent = List

    local Layout = Instance.new("UIListLayout")
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Parent = Items

    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Items.Size = UDim2.new(1, 0, 0, Layout.AbsoluteContentSize.Y)
        List.Size = UDim2.new(0, 150, 0, Layout.AbsoluteContentSize.Y + 25)
    end)

    local Binds = {}

    function Library:AddBindToList(name, key)
        if Binds[name] then
            Binds[name].Key.Text = "[ " .. key.Name .. " ]"
            return
        end

        local BindFrame = Instance.new("Frame")
        BindFrame.BackgroundTransparency = 1
        BindFrame.Size = UDim2.new(1, 0, 0, 20)
        BindFrame.Parent = Items

        local Label = Instance.new("TextLabel")
        Label.BackgroundTransparency = 1
        Label.Position = UDim2.new(0, 5, 0, 0)
        Label.Size = UDim2.new(0.6, -5, 1, 0)
        Label.Font = Enum.Font.SourceSans
        Label.Text = name
        Label.TextColor3 = Library.Text
        Label.TextSize = 14
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = BindFrame

        local Key = Instance.new("TextLabel")
        Key.BackgroundTransparency = 1
        Key.Position = UDim2.new(0.6, 0, 0, 0)
        Key.Size = UDim2.new(0.4, -5, 1, 0)
        Key.Font = Enum.Font.SourceSans
        Key.Text = "[ " .. key.Name .. " ]"
        Key.TextColor3 = Library.Accent
        Key.TextSize = 14
        Key.TextXAlignment = Enum.TextXAlignment.Right
        Key.Parent = BindFrame

        Binds[name] = {Frame = BindFrame, Key = Key}
    end
end

function Library:CreateRadar()
    local RadarFrame = Instance.new("Frame")
    RadarFrame.Name = "Radar"
    RadarFrame.BackgroundColor3 = Library.Background
    RadarFrame.BorderColor3 = Library.Border
    RadarFrame.Position = UDim2.new(0.01, 0, 0.25, 0)
    RadarFrame.Size = UDim2.new(0, 200, 0, 200)
    RadarFrame.Parent = self.ScreenGui
    
    Library:MakeDraggable(RadarFrame)

    local Title = Instance.new("TextLabel")
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1, 0, 0, 25)
    Title.Font = Enum.Font.SourceSansBold
    Title.Text = "Radar"
    Title.TextColor3 = Library.Text
    Title.TextSize = 14
    Title.Parent = RadarFrame

    local LineH = Instance.new("Frame")
    LineH.BackgroundColor3 = Library.Border
    LineH.BorderSizePixel = 0
    LineH.Position = UDim2.new(0, 0, 0.5, 0)
    LineH.Size = UDim2.new(1, 0, 0, 1)
    LineH.Parent = RadarFrame

    local LineV = Instance.new("Frame")
    LineV.BackgroundColor3 = Library.Border
    LineV.BorderSizePixel = 0
    LineV.Position = UDim2.new(0.5, 0, 0, 25)
    LineV.Size = UDim2.new(0, 1, 1, -25)
    LineV.Parent = RadarFrame

    local Container = Instance.new("Frame")
    Container.BackgroundTransparency = 1
    Container.Position = UDim2.new(0, 0, 0, 25)
    Container.Size = UDim2.new(1, 0, 1, -25)
    Container.ClipsDescendants = true
    Container.Parent = RadarFrame

    local PlayerDot = Instance.new("Frame")
    PlayerDot.BackgroundColor3 = Color3.new(1, 1, 1)
    PlayerDot.BorderSizePixel = 0
    PlayerDot.Position = UDim2.new(0.5, -2, 0.5, -2)
    PlayerDot.Size = UDim2.new(0, 4, 0, 4)
    PlayerDot.Parent = Container

    local Dots = {}
    local Range = 200

    RunService.RenderStepped:Connect(function()
        if not RadarFrame.Visible then return end
        
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dot = Dots[p]
                if not dot then
                    dot = Instance.new("Frame")
                    dot.Size = UDim2.new(0, 4, 0, 4)
                    dot.BorderSizePixel = 0
                    dot.BackgroundColor3 = Library.Accent
                    dot.Parent = Container
                    Dots[p] = dot
                end

                local relPos = p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position
                local x = relPos.X / Range
                local z = relPos.Z / Range
                
                -- Rotate based on camera
                local camRot = math.atan2(workspace.CurrentCamera.CFrame.LookVector.X, workspace.CurrentCamera.CFrame.LookVector.Z)
                local cos = math.cos(camRot)
                local sin = math.sin(camRot)
                
                local rotX = x * cos - z * sin
                local rotZ = x * sin + z * cos

                dot.Position = UDim2.new(0.5 + rotX, -2, 0.5 + rotZ, -2)
                dot.Visible = (math.abs(rotX) < 0.5 and math.abs(rotZ) < 0.5)
            else
                if Dots[p] then
                    Dots[p]:Destroy()
                    Dots[p] = nil
                end
            end
        end
    end)
end

function Library:CreateEspPreview()
    local Preview = Instance.new("Frame")
    Preview.Name = "EspPreview"
    Preview.BackgroundColor3 = Library.Background
    Preview.BorderColor3 = Library.Border
    Preview.Position = UDim2.new(0.75, 0, 0.25, 0)
    Preview.Size = UDim2.new(0, 200, 0, 300)
    Preview.Parent = self.ScreenGui

    Library:MakeDraggable(Preview)

    local Title = Instance.new("TextLabel")
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1, 0, 0, 25)
    Title.Font = Enum.Font.SourceSansBold
    Title.Text = "ESP Preview"
    Title.TextColor3 = Library.Text
    Title.TextSize = 14
    Title.Parent = Preview

    local Dummy = Instance.new("Frame")
    Dummy.BackgroundTransparency = 1
    Dummy.Position = UDim2.new(0.2, 0, 0.2, 0)
    Dummy.Size = UDim2.new(0.6, 0, 0.6, 0)
    Dummy.Parent = Preview

    local Box = Instance.new("Frame")
    Box.BackgroundTransparency = 1
    Box.BorderColor3 = Library.Accent
    Box.BorderSizePixel = 1
    Box.Size = UDim2.new(1, 0, 1, 0)
    Box.Parent = Dummy

    local Name = Instance.new("TextLabel")
    Name.BackgroundTransparency = 1
    Name.Position = UDim2.new(0, 0, 0, -15)
    Name.Size = UDim2.new(1, 0, 0, 15)
    Name.Font = Enum.Font.SourceSans
    Name.Text = "Player Name"
    Name.TextColor3 = Library.Text
    Name.TextSize = 12
    Name.Parent = Dummy

    local Health = Instance.new("Frame")
    Health.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    Health.BorderSizePixel = 0
    Health.Position = UDim2.new(0, -5, 0, 0)
    Health.Size = UDim2.new(0, 2, 1, 0)
    Health.Parent = Dummy
end

return Library
