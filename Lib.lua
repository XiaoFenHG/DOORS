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
    local closeButton = Instance.new("TextButton") -- 关闭按钮
    local openButton = Instance.new("TextButton") -- 打开按钮
    local tabContainer = Instance.new("Frame")
    local tabIndicator = Instance.new("Frame") -- 当前Tab指示条
    local scrollingFrame = Instance.new("ScrollingFrame")

    screenGui.Name = "CustomUILib"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    frame.Name = "MainFrame"
    frame.Parent = screenGui
    frame.BackgroundColor3 = Color3.new(1, 1, 1)
    frame.BackgroundTransparency = 1 -- 完全透明背景
    frame.Size = UDim2.new(0, 800, 0, 600) 
    frame.Position = UDim2.new(0.5, -400, 0.5, -300)
    frame.Active = true
    frame.Draggable = true 
    frame.Visible = false -- 初始时隐藏
    frame.CornerRadius = UDim.new(0, 10) -- 设置圆角

    titleLabel.Name = "TitleLabel"
    titleLabel.Parent = frame
    titleLabel.BackgroundColor3 = Color3.new(1, 1, 1)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, 0, 0, 50)
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.new(0, 0, 0)
    titleLabel.TextScaled = true
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    closeButton.Name = "CloseButton"
    closeButton.Parent = titleLabel
    closeButton.BackgroundColor3 = Color3.new(1, 0, 0) -- 红色关闭按钮
    closeButton.Size = UDim2.new(0, 50, 1, 0)
    closeButton.Position = UDim2.new(1, -50, 0, 0)
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.BackgroundTransparency = 1 -- 完全透明背景
    closeButton.Text = "Close"
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.TextScaled = true

    closeButton.MouseButton1Click:Connect(function()
        frame.Visible = false
    end)

    openButton.Name = "OpenButton"
    openButton.Parent = screenGui
    openButton.BackgroundColor3 = Color3.new(0, 0, 1) -- 蓝色打开按钮
    openButton.Size = UDim2.new(0, 100, 0, 50)
    openButton.Position = UDim2.new(0.5, -50, 0.5, -25)
    openButton.Font = Enum.Font.SourceSansBold
    openButton.BackgroundTransparency = 1 -- 完全透明背景
    openButton.Text = "Open UI"
    openButton.TextColor3 = Color3.new(1, 1, 1)
    openButton.TextScaled = true

    openButton.MouseButton1Click:Connect(function()
        frame.Visible = true
    end)

    tabContainer.Name = "TabContainer"
    tabContainer.Parent = frame
    tabContainer.BackgroundColor3 = Color3.new(1, 1, 1)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Size = UDim2.new(0, 120, 1, -50) -- 增大Tab布局
    tabContainer.Position = UDim2.new(0, 0, 0, 50)
    tabContainer.CornerRadius = UDim.new(0, 10) -- 设置圆角

    tabIndicator.Name = "TabIndicator"
    tabIndicator.Parent = tabContainer
    tabIndicator.BackgroundColor3 = Color3.new(0, 0, 1) -- 蓝色指示条
    tabIndicator.Size = UDim2.new(0, 2, 1, 0) -- 非常细的竖条
    tabIndicator.Position = UDim2.new(0, 0, 0, 0)

    scrollingFrame.Name = "ScrollingFrame"
    scrollingFrame.Parent = frame
    scrollingFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.Position = UDim2.new(0, 120, 0, 50)
    scrollingFrame.Size = UDim2.new(1, -120, 1, -50)
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollingFrame.ScrollBarThickness = 10
    scrollingFrame.CornerRadius = UDim.new(0, 10) -- 设置圆角

    self.frame = frame
    self.tabContainer = tabContainer
    self.tabIndicator = tabIndicator
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
    tabLabel.BackgroundColor3 = Color3.new(1, 1, 1)
    tabLabel.BackgroundTransparency = 1
    tabLabel.Size = UDim2.new(1, 0, 0, 40) -- 增大Tab按钮
    tabLabel.Position = UDim2.new(0, 0, 0, #self.tabs * 40)
    tabLabel.Font = Enum.Font.SourceSansBold
    tabLabel.Text = tabName
    tabLabel.TextColor3 = Color3.new(0, 0, 0)
    tabLabel.TextScaled = true

    tabLabel.MouseButton1Click:Connect(function()
        if self.currentTab then
            for _, element in ipairs(self.currentTab.elements) do
                element.Visible = false
            end
        end
        for _, element in ipairs(tab.elements) do
            element.Visible = true
        end
        self.currentTab = tab

        -- 更新Tab指示条位置
        self.tabIndicator.Position = UDim2.new(0, 0, 0, #self.tabs * 40)
    end)

    function tab:CreateButton(buttonText, onClick)
    local button = Instance.new("TextButton", self.scrollFrame)
    button.Name = "CustomButton"
    button.BackgroundColor3 = Color3.fromRGB(200, 200, 200) -- 灰色背景
    button.Size = UDim2.new(1, -20, 0, 50)
    button.Position = UDim2.new(0, 10, 0, #self.elements * 60)
    button.Font = Enum.Font.SourceSansBold
    button.Text = buttonText
    button.TextColor3 = Color3.new(0, 0, 0)
    button.TextScaled = true
    button.Visible = false

    button.MouseButton1Click:Connect(onClick)
    table.insert(self.elements, button)
    self.scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #self.elements * 60 + 10)
end

function tab:CreateToggle(toggleText, onToggle)
    local toggle = Instance.new("TextButton", self.scrollFrame)
    toggle.Name = "CustomToggle"
    toggle.BackgroundColor3 = Color3.fromRGB(200, 200, 200) -- 灰色背景
    toggle.Size = UDim2.new(1, -20, 0, 50)
    toggle.Position = UDim2.new(0, 10, 0, #self.elements * 60)
    toggle.Font = Enum.Font.SourceSansBold
    toggle.Text = toggleText .. " [Off]"
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
    self.scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #self.elements * 60 + 10)
end

function tab:CreateTextBox(boxText, onTextChanged)
    local textBoxFrame = Instance.new("Frame", self.scrollFrame)
    textBoxFrame.Name = "CustomTextBox"
    textBoxFrame.BackgroundColor3 = Color3.fromRGB(200, 200, 200) -- 灰色背景
    textBoxFrame.Size = UDim2.new(1, -20, 0, 60)
    textBoxFrame.Position = UDim2.new(0, 10, 0, #self.elements * 60)
    textBoxFrame.Visible = false

    local textBoxLabel = Instance.new("TextLabel", textBoxFrame)
    textBoxLabel.Name = "TextBoxLabel"
    textBoxLabel.BackgroundColor3 = Color3.fromRGB(200, 200, 200) -- 灰色背景
    textBoxLabel.Size = UDim2.new(0.3, 0, 1, 0)
    textBoxLabel.Font = Enum.Font.SourceSansBold
    textBoxLabel.Text = boxText
    textBoxLabel.TextColor3 = Color3.new(0, 0, 0)
    textBoxLabel.TextScaled = true

    local textBox = Instance.new("TextBox", textBoxFrame)
    textBox.Name = "TextBox"
    textBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- 白色输入框
    textBox.Size = UDim2.new(0.7, 0, 1, 0)
    textBox.Position = UDim2.new(0.3, 0, 0, 0)
    textBox.Font = Enum.Font.SourceSans
    textBox.Text = ""
    textBox.TextColor3 = Color3.new(0, 0, 0)
    textBox.TextScaled = true

    textBox:GetPropertyChangedSignal("Text"):Connect(function()
        onTextChanged(textBox.Text)
    end)

    table.insert(self.elements, textBoxFrame)
    self.scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #self.elements * 60 + 10)
end

table.insert(_G.Library.tabs, tab)
return tab
