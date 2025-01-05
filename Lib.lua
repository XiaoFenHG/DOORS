_G.Library = {}

function _G.Library:CreateWindow(title)
    local screenGui = Instance.new("ScreenGui")
    local frame = Instance.new("Frame")
    local titleLabel = Instance.new("TextLabel")
    local tabContainer = Instance.new("Frame")

    screenGui.Name = "CustomUILib"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    frame.Name = "MainFrame"
    frame.Parent = screenGui
    frame.BackgroundColor3 = Color3.new(0, 0, 0) -- 设置背景为全黑
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(0, 600, 0, 400)
    frame.Position = UDim2.new(0.5, -300, 0.5, -200)
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

    self.frame = frame
    self.tabContainer = tabContainer
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
        local button = Instance.new("TextButton", _G.Library.frame)
        button.Name = "CustomButton"
        button.BackgroundColor3 = Color3.new(1, 1, 1) -- 背景颜色设置为白色
        button.Size = UDim2.new(0, 500, 0, 50)
        button.Position = UDim2.new(0, 110, 0, #self.elements * 60 + 50)
        button.Font = Enum.Font.SourceSans
        button.Text = buttonText
        button.TextColor3 = Color3.new(0, 0, 0) -- 文本颜色设置为黑色
        button.TextScaled = true
        button.Visible = false

        button.MouseButton1Click:Connect(onClick)
        table.insert(self.elements, button)
    end

    function tab:CreateToggle(toggleText, onToggle)
        local toggle = Instance.new("TextButton", _G.Library.frame)
        toggle.Name = "CustomToggle"
        toggle.BackgroundColor3 = Color3.new(1, 1, 1) -- 背景颜色设置为白色
        toggle.Size = UDim2.new(0, 500, 0, 50)
        toggle.Position = UDim2.new(0, 110, 0, #self.elements * 60 + 50)
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
    end

    function tab:CreateSlider(sliderText, min, max, onSlider)
    local sliderFrame = Instance.new("Frame", _G.Library.frame)
    sliderFrame.Name = "CustomSlider"
    sliderFrame.BackgroundColor3 = Color3.new(1, 1, 1) -- 背景颜色设置为白色
    sliderFrame.Size = UDim2.new(0, 500, 0, 50)
    sliderFrame.Position = UDim2.new(0, 110, 0, #self.elements * 60 + 50)
    sliderFrame.Visible = false

    local sliderLabel = Instance.new("TextLabel", sliderFrame)
    sliderLabel.Name = "SliderLabel"
    sliderLabel.BackgroundColor3 = Color3.new(1, 1, 1)
    sliderLabel.Size = UDim2.new(1, -100, 1, 0)
    sliderLabel.Font = Enum.Font.SourceSans
    sliderLabel.Text = sliderText
    sliderLabel.TextColor3 = Color3.new(0, 0, 0) -- 文本颜色设置为黑色
    sliderLabel.TextScaled = true

    local fill = Instance.new("Frame", sliderFrame)
    fill.Name = "Fill"
    fill.BackgroundColor3 = Color3.new(0, 0, 0) -- 填充颜色
    fill.Size = UDim2.new(0, 0, 1, 0)

    local sliderButton = Instance.new("TextButton", sliderFrame)
    sliderButton.Name = "SliderButton"
    sliderButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    sliderButton.Size = UDim2.new(0, 100, 1, 0)
    sliderButton.Position = UDim2.new(1, -100, 0, 0)
    sliderButton.Font = Enum.Font.SourceSans
    sliderButton.Text = "0"
    sliderButton.TextColor3 = Color3.new(1, 1, 1)
    sliderButton.TextScaled = true

    local dragging = false
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)

    sliderButton.MouseButton1Up:Connect(function()
        dragging = false
    end)

    sliderButton.MouseLeave:Connect(function()
        dragging = false
    end)

    sliderFrame.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = math.clamp(input.Position.X - sliderFrame.AbsolutePosition.X, 0, sliderFrame.AbsoluteSize.X)
            local value = math.clamp(math.floor((delta / sliderFrame.AbsoluteSize.X) * (max - min) + min), min, max)
            sliderButton.Position = UDim2.new(delta / sliderFrame.AbsoluteSize.X, -50, 0, 0)
            sliderButton.Text = tostring(value)
            fill.Size = UDim2.new(delta / sliderFrame.AbsoluteSize.X, 0, 1, 0)
            onSlider(value)
        end
    end)

    table.insert(self.elements, sliderFrame)
end

table.insert(_G.Library.tabs, tab)
return tab
end
