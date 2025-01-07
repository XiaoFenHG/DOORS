_G.Library = {}

function _G.Library:DetectDeviceType()
    local userInputService = game:GetService("UserInputService")
    if userInputService.TouchEnabled then
        return "Mobile"
    else
        return "Desktop"
    end
end

function _G.Library:CreateWindow(title)
    local screenGui = Instance.new("ScreenGui")
    local frame = Instance.new("Frame")
    local titleLabel = Instance.new("TextLabel")
    local toggleButton = Instance.new("TextButton")
    local tabContainer = Instance.new("Frame")
    local scrollingFrame = Instance.new("ScrollingFrame")

    screenGui.Name = "CustomUILib"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    frame.Name = "MainFrame"
    frame.Parent = screenGui
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.new(1, 1, 1)
    frame.Size = UDim2.new(0, 800, 0, 600)
    frame.Position = UDim2.new(0.5, -400, 0.5, -300)
    frame.Active = true
    frame.Draggable = true

    titleLabel.Name = "TitleLabel"
    titleLabel.Parent = frame
    titleLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, 0, 0, 50)
    titleLabel.Font = Enum.Font.SourceSans
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextScaled = true
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    toggleButton.Name = "ToggleButton"
    toggleButton.Parent = frame
    toggleButton.BackgroundColor3 = Color3.new(1, 1, 1)
    toggleButton.BorderSizePixel = 2
    toggleButton.BorderColor3 = Color3.new(0, 0, 0)
    toggleButton.Size = UDim2.new(0, 100, 0, 50)
    toggleButton.Position = UDim2.new(0, 0, 0, 50)
    toggleButton.Font = Enum.Font.SourceSans
    toggleButton.Text = "Toggle UI"
    toggleButton.TextColor3 = Color3.new(0, 0, 0)
    toggleButton.TextScaled = true

    toggleButton.MouseButton1Click:Connect(function()
        frame.Visible = not frame.Visible
    end)

    tabContainer.Name = "TabContainer"
    tabContainer.Parent = frame
    tabContainer.BackgroundColor3 = Color3.new(0, 0, 0)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Size = UDim2.new(0, 100, 1, -100)
    tabContainer.Position = UDim2.new(0, 0, 0, 100)

    scrollingFrame.Name = "ScrollingFrame"
    scrollingFrame.Parent = frame
    scrollingFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.Position = UDim2.new(0, 100, 0, 100)
    scrollingFrame.Size = UDim2.new(1, -100, 1, -100)
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollingFrame.ScrollBarThickness = 10

    self.frame = frame
    self.tabContainer = tabContainer
    self.scrollFrame = scrollingFrame
    self.tabs = {}
    self.currentTab = nil
    return self
end

function _G.Library:CreateTab(tabName)
    local tab = {}
    tab.elements = {}
    tab.groups = {}

    local tabLabel = Instance.new("TextButton", self.tabContainer)
    tabLabel.Name = "TabLabel"
    tabLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    tabLabel.BorderSizePixel = 2
    tabLabel.BorderColor3 = Color3.new(1, 1, 1)
    tabLabel.Size = UDim2.new(1, 0, 0, 30)
    tabLabel.Position = UDim2.new(0, 0, 0, #self.tabs * 30)
    tabLabel.Font = Enum.Font.SourceSans
    tabLabel.Text = tabName
    tabLabel.TextColor3 = Color3.new(1, 1, 1)
    tabLabel.TextScaled = true

    tabLabel.MouseButton1Click:Connect(function()
        if _G.Library.currentTab then
            for _, element in ipairs(_G.Library.currentTab.elements) do
                element.Visible = false
            end
            for _, group in pairs(_G.Library.currentTab.groups) do
                group.frame.Visible = false
            end
        end
        for _, element in ipairs(tab.elements) do
            element.Visible = true
        end
        for _, group in pairs(tab.groups) do
            group.frame.Visible = true
        end
        _G.Library.currentTab = tab
    end)

    function tab:CreateGroup(groupName)
        local group = {}
        group.elements = {}

        local groupFrame = Instance.new("Frame", _G.Library.scrollFrame)
        groupFrame.Name = "GroupFrame"
        groupFrame.BackgroundColor3 = Color3.new(1, 1, 1)
        groupFrame.BorderSizePixel = 2
        groupFrame.BorderColor3 = Color3.new(0, 0, 0)
        groupFrame.Size = UDim2.new(1, -20, 0, 200)
        groupFrame.Position = UDim2.new(0, 10, 0, #self.groups * 210)
        groupFrame.Visible = false

        local groupLabel = Instance.new("TextLabel", groupFrame)
        groupLabel.Name = "GroupLabel"
        groupLabel.BackgroundColor3 = Color3.new(1, 1, 1)
        groupLabel.BorderSizePixel = 2
        groupLabel.BorderColor3 = Color3.new(0, 0, 0)
        groupLabel.Size = UDim2.new(1, 0, 0, 50)
        groupLabel.Font = Enum.Font.SourceSans
        groupLabel.Text = groupName
        groupLabel.TextColor3 = Color3.new(0, 0, 0)
        groupLabel.TextScaled = true

        group.frame = groupFrame

        function group:CreateButton(buttonText, onClick)
            local button = Instance.new("TextButton", groupFrame)
            button.Name = "CustomButton"
            button.BackgroundColor3 = Color3.new(1, 1, 1)
            button.BorderSizePixel = 2
            button.BorderColor3 = Color3.new(0, 0, 0)
            button.Size = UDim2.new(1, -20, 0, 50)
            button.Position = UDim2.new(0, 10, 0, 50 + #self.elements * 60)
            button.Font = Enum.Font.SourceSans
            button.Text = buttonText
            button.TextColor3 = Color3.new(0, 0, 0)
            button.TextScaled = true
            button.Visible = false

            button.MouseButton1Click:Connect(onClick)
            table.insert(self.elements, button)
            groupFrame.Size = UDim2.new(1, -20, 0, 50 + #self.elements * 60 + 10)
        end

        function group:CreateToggle(toggleText, onToggle)
            local toggle = Instance.new("TextButton", groupFrame)
            toggle.Name = "CustomToggle"
            toggle.BackgroundColor3 = Color3.new(1, 1, 1)
            toggle.BorderSizePixel = 2
            toggle.BorderColor3 = Color3.new(0, 0, 0)
            toggle.Size = UDim2.new(1, -20, 0, 50)
            toggle.Position = UDim2.new(0, 10, 0, 50 + #self.elements * 60)
            toggle.Font = Enum.Font.SourceSans
            toggle.Text = toggleText
            toggle.TextColor3 = Color3.new(0, 0, 0)
            toggle.TextScaled = true
            toggle.Visible = false

            local isOn = false
            toggle.MouseButton1Click:Connect(function()
                isOn = not isOn
                onToggle(isOn)
                toggle.Text = toggleText .. (isOn and " [On]" or " [Off]")
            end)
            table.insert(self.elements, toggle)
            groupFrame.Size = UDim2.new(1, -20, 0, 50 + #self.elements * 60 + 10)
        end

        function group:CreateTextBox(boxText, onTextChanged)
            local textBoxFrame = Instance.new("Frame", groupFrame)
            textBoxFrame.Name = "CustomTextBox"
            textBoxFrame.BackgroundColor3 = Color3.new(1, 1, 1)
            textBoxFrame.BorderSizePixel = 2
            textBoxFrame.BorderColor3 = Color3.new(0, 0, 0)
            textBoxFrame.Size = UDim2.new(1, -20, 0, 50)
            textBoxFrame.Position = UDim2.new(0, 10, 0, 50 + #self.elements * 60)
            textBoxFrame.Visible = false

            local textBoxLabel = Instance.new("TextLabel", textBoxFrame)
            textBoxLabel.Name = "TextBoxLabel"
            textBoxLabel.BackgroundColor3 = Color3.new(1, 1, 1)
            textBoxLabel.BorderSizePixel = 2
            textBoxLabel.BorderColor3 = Color3.new(0, 0, 0)
            textBoxLabel.Size = UDim2.new(0.3, 0, 1, 0)
            textBoxLabel.Font = Enum.Font.SourceSans
            textBoxLabel.Text = boxText
            textBoxLabel.TextColor3 = Color3.new(0, 0, 0)
            textBoxLabel.TextScaled = true

            local textBox = Instance.new("TextBox", textBoxFrame)
            textBox.Name = "TextBox"
            textBox.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
            textBox.BorderSizePixel = 2
            textBox.BorderColor3 = Color3.new(0, 0, 0)
            textBox.Size = UDim2.new(0.7, 0, 1, 0)
            textBox.Position = UDim2.new(0.3, 0, 0, 0)
            textBox.Font = Enum.Font.SourceSans
            textBox.Text = ""
            textBox.TextColor3 = Color3.new(1, 1, 1)
            textBox.TextScaled = true

            textBox:GetPropertyChangedSignal("Text"):Connect(function()
                onTextChanged(textBox.Text)
            end)

            table.insert(self.elements, textBoxFrame)
            groupFrame.Size = UDim2.new(1, -20, 0, 50 + #self.elements * 60 + 10)
        end

        table.insert(tab.groups, group)
        return group
    end

    table.insert(_G.Library.tabs, tab)
    return tab
end

function _G.Library:CreateMinimizeButton()
    local minimizeButton = Instance.new("ImageButton", self.frame)
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Size = UDim2.new(0, 30, 0, 30)
    minimizeButton.Position = UDim2.new(1, -40, 0, 10)
    minimizeButton.Image = "rbxassetid://6031094678" -- 图标

    local isMinimized = false
    minimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            self.frame:TweenPosition(UDim2.new(0, -self.frame.Size.X.Offset, 0.5, -self.frame.Size.Y.Offset / 2), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.5, true, function()
                self.frame.Visible = false
            end)
        else
            self.frame.Visible = true
            self.frame:TweenPosition(UDim2.new(0.5, -self.frame.Size.X.Offset / 2, 0.5, -self.frame.Size.Y.Offset / 2), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.5, true)
        end
    end)
end

function _G.Library:CreateMobileMinimizeButton()
    local openButton = Instance.new("ImageButton")
    openButton.Name = "OpenButton"
    openButton.Size = UDim2.new(0, 50, 0, 50)
    openButton.Position = UDim2.new(0, 10, 0.5, -25)
    openButton.Image = "rbxassetid://6031094678" -- 图标
    openButton.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    openButton.Visible = true  -- Initially visible

    local minimizeButton = Instance.new("ImageButton", self.frame)
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Size = UDim2.new(0, 30, 0, 30)
    minimizeButton.Position = UDim2.new(1, -40, 0, 10)
    minimizeButton.Image = "rbxassetid://6031094678" -- 图标

    local isMinimized = false
    minimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            self.frame:TweenPosition(UDim2.new(0, -self.frame.Size.X.Offset, 0.5, -self.frame.Size.Y.Offset / 2), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.5, true, function()
                self.frame.Visible = false
                openButton.Visible = true
            end)
        else
            self.frame.Visible = true
            self.frame:TweenPosition(UDim2.new(0.5, -self.frame.Size.X.Offset / 2, 0.5, -self.frame.Size.Y.Offset / 2), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.5, true)
            openButton.Visible = false
        end
    end)

    openButton.MouseButton1Click:Connect(function()
        self.frame.Visible = true
        self.frame:TweenPosition(UDim2.new(0.5, -self.frame.Size.X.Offset / 2, 0.5, -self.frame.Size.Y.Offset / 2), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.5, true)
        openButton.Visible = false
    end)
end
