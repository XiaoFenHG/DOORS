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
    local tabContainer = Instance.new("Frame")
    local scrollingFrame = Instance.new("ScrollingFrame")

    screenGui.Name = "CustomUILib"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    frame.Name = "MainFrame"
    frame.Parent = screenGui
    frame.BackgroundColor3 = Color3.new(0, 0, 0) -- 设置背景为全黑
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(0, 800, 0, 600) -- 背景扩大
    frame.Position = UDim2.new(0.5, -400, 0.5, -300)
    frame.Active = true
    frame.Draggable = true -- 设置可拖动

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

    tabContainer.Name = "TabContainer"
    tabContainer.Parent = frame
    tabContainer.BackgroundColor3 = Color3.new(0, 0, 0)
    tabContainer.BackgroundTransparency = 1 -- 背景透明
    tabContainer.Size = UDim2.new(0, 100, 1, -50)
    tabContainer.Position = UDim2.new(0, 0, 0, 50)

    scrollingFrame.Name = "ScrollingFrame"
    scrollingFrame.Parent = frame
    scrollingFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.Position = UDim2.new(0, 100, 0, 50)
    scrollingFrame.Size = UDim2.new(1, -100, 1, -50)
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

    local tabLabel = Instance.new("TextButton", self.tabContainer)
    tabLabel.Name = "TabLabel"
    tabLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    tabLabel.BackgroundTransparency = 1 -- 背景透明
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
        end
        for _, element in ipairs(tab.elements) do
            element.Visible = true
        end
        _G.Library.currentTab = tab
    end)

    function tab:CreateButton(buttonText, onClick)
        local button = Instance.new("TextButton", _G.Library.scrollFrame)
        button.Name = "CustomButton"
        button.BackgroundColor3 = Color3.new(1, 1, 1) -- 背景颜色设置为白色
        button.Size = UDim2.new(1, -20, 0, 50)
        button.Position = UDim2.new(0, 10, 0, #self.elements * 60)
        button.Font = Enum.Font.SourceSans
        button.Text = buttonText
        button.TextColor3 = Color3.new(0, 0, 0) -- 文本颜色设置为黑色
        button.TextScaled = true
        button.Visible = false

        button.MouseButton1Click:Connect(onClick)
        table.insert(self.elements, button)
        _G.Library.scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #self.elements * 60 + 10) -- 更新滚动区域
    end

    function tab:CreateToggle(toggleText, onToggle)
        local toggle = Instance.new("TextButton", _G.Library.scrollFrame)
        toggle.Name = "CustomToggle"
        toggle.BackgroundColor3 = Color3.new(1, 1, 1) -- 背景颜色设置为白色
        toggle.Size = UDim2.new(1, -20, 0, 50)
        toggle.Position = UDim2.new(0, 10, 0, #self.elements * 60)
        toggle.Font = Enum.Font.SourceSans
        toggle.Text = toggleText
        toggle.TextColor3 = Color3.new(0, 0, 0) -- 文本颜色设置为黑色
        toggle.TextScaled = true
        toggle.Visible = false

        local isOn = false
        toggle.MouseButton1Click:Connect(function()
            isOn = not isOn
            onToggle(isOn)
            toggle.Text = toggleText .. (isOn and " [On]" or " [Off]")
        end)
        table.insert(self.elements, toggle)
        _G.Library.scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #self.elements * 60 + 10) -- 更新滚动区域
    end

    function tab:CreateTextBox(boxText, onTextChanged)
    local textBoxFrame = Instance.new("Frame", _G.Library.scrollFrame)
    textBoxFrame.Name = "CustomTextBox"
    textBoxFrame.BackgroundColor3 = Color3.new(1, 1, 1) -- 背景颜色设置为白色
    textBoxFrame.Size = UDim2.new(1, -20, 0, 50)
    textBoxFrame.Position = UDim2.new(0, 10, 0, #self.elements * 60)
    textBoxFrame.Visible = false

    local textBoxLabel = Instance.new("TextLabel", textBoxFrame)
    textBoxLabel.Name = "TextBoxLabel"
    textBoxLabel.BackgroundColor3 = Color3.new(1, 1, 1)
    textBoxLabel.Size = UDim2.new(0.3, 0, 1, 0)
    textBoxLabel.Font = Enum.Font.SourceSans
    textBoxLabel.Text = boxText
    textBoxLabel.TextColor3 = Color3.new(0, 0, 0) -- 文本颜色设置为黑色
    textBoxLabel.TextScaled = true

    local textBox = Instance.new("TextBox", textBoxFrame)
    textBox.Name = "TextBox"
    textBox.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
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
    _G.Library.scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #self.elements * 60 + 10) -- 更新滚动区域
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
            self.frame:TweenPosition(UDim2.new(0, -self.frame.Size.X.Offset, 0.5, -self.frame.Size.Y.Offset / 2), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.5, true)
        else
            self.frame:TweenPosition(UDim2.new(0.5, -self.frame.Size.X.Offset / 2, 0.5, -self.frame.Size.Y.Offset / 2), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.5, true)
        end
    end)
end

function _G.Library:CreateMobileMinimizeButton()
    local openButton = Instance.new("ImageButton")
    openButton.Name = "OpenButton"
    openButton.Size = UDim2.new(0, 50, 0, 50)
    openButton.Position = UDim2.new(0, 10, 0.5, -25) -- 中间左边
    openButton.Image = "rbxassetid://6031094678" -- 图标
    openButton.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    openButton.Visible = false

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
