_G.Lib = _G.Lib or {}

_G.Lib.Gui = _G.Lib.Gui or {}

function _G.Lib.Gui:CreateTitle(properties)
    local title = Instance.new("TextLabel")
    title.Text = properties.text or "Title"
    title.Size = UDim2.new(1, 0, 0.1, 0)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.SourceSans
    title.TextSize = 24
    title.TextXAlignment = Enum.TextXAlignment.Left  -- 标题文字靠左对齐
    return title
end

function _G.Lib.Gui:CreateBackground()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CustomGUI"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.5, 0, 0.7, 0)  -- 设置为较小的长方形
    frame.Position = UDim2.new(0.25, 0, 0.15, 0)  -- 居中位置
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    return frame
end

function _G.Lib.Gui:CreateTabContainer()
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(0.3, 0, 0.9, 0)
    tabContainer.Position = UDim2.new(0, 0, 0.1, 0)
    tabContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    tabContainer.BorderSizePixel = 0
    return tabContainer
end

function _G.Lib.Gui:CreateFunctionContainer()
    local functionContainer = Instance.new("Frame")
    functionContainer.Size = UDim2.new(0.7, 0, 0.9, 0)
    functionContainer.Position = UDim2.new(0.3, 0, 0.1, 0)
    functionContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    functionContainer.BorderSizePixel = 0
    return functionContainer
end

function _G.Lib.Gui:CreateTab(properties)
    local tab = Instance.new("Frame")
    tab.Size = UDim2.new(1, 0, 0.1, 0)
    tab.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    tab.BorderSizePixel = 0

    local toggleButton = Instance.new("TextButton")
    toggleButton.Text = properties.text or "Tab"
    toggleButton.Size = UDim2.new(1, 0, 1, 0)
    toggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextXAlignment = Enum.TextXAlignment.Left  -- 按钮文本靠左对齐
    toggleButton.Parent = tab

    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.Position = UDim2.new(0, 0, 1, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Visible = false
    contentFrame.Parent = tab

    toggleButton.MouseButton1Click:Connect(function()
        for _, sibling in pairs(tab.Parent:GetChildren()) do
            if sibling:IsA("Frame") and sibling ~= tab then
                sibling:FindFirstChildWhichIsA("Frame").Visible = false
            end
        end
        contentFrame.Visible = not contentFrame.Visible
    end)

    function tab:AddButton(properties)
        local button = Instance.new("TextButton")
        button.Text = properties.text or "Button"
        button.Size = UDim2.new(0.9, 0, 0.1, 0)
        button.Position = UDim2.new(0.05, 0, #contentFrame:GetChildren() * 0.15, 0)  -- 靠左对齐
        button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextXAlignment = Enum.TextXAlignment.Left  -- 按钮文本靠左对齐
        button.MouseButton1Click:Connect(properties.onClick or function() end)
        button.Parent = contentFrame
        return button
    end

    function tab:AddToggle(properties)
        local toggle = Instance.new("TextButton")
        toggle.Text = properties.text or "Toggle"
        toggle.Size = UDim2.new(0.9, 0, 0.1, 0)
        toggle.Position = UDim2.new(0.05, 0, #contentFrame:GetChildren() * 0.15, 0)  -- 靠左对齐
        toggle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggle.TextXAlignment = Enum.TextXAlignment.Left  -- 按钮文本靠左对齐
    
        local isToggled = false
        toggle.MouseButton1Click:Connect(function()
            isToggled = not isToggled
            if properties.onClick then
                properties.onClick(isToggled)
            end
        end)
    
        toggle.Parent = contentFrame
        return toggle
    end

    function tab:AddSlider(properties)
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(0.9, 0, 0.1, 0)
        sliderFrame.Position = UDim2.new(0.05, 0, #contentFrame:GetChildren() * 0.15, 0)  -- 靠左对齐
        sliderFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    
        local slider = Instance.new("TextButton")
        slider.Size = UDim2.new(0, 10, 1, 0)
        slider.Position = UDim2.new(0, 0, 0, 0)
        slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        slider.TextColor3 = Color3.fromRGB(0, 0, 0)
        slider.TextXAlignment = Enum.TextXAlignment.Left  -- 按钮文本靠左对齐
        slider.Parent = sliderFrame
    
        slider.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local moveConnection
                moveConnection = slider.InputChanged:Connect(function(moveInput)
                    if moveInput.UserInputType == Enum.UserInputType.MouseMovement then
                        local xPos = math.clamp(moveInput.Position.X - sliderFrame.AbsolutePosition.X, 0, sliderFrame.AbsoluteSize.X)
                        slider.Position = UDim2.new(0, xPos, 0, 0)
                        local value = properties.Min + (properties.Max - properties.Min) * (xPos / sliderFrame.AbsoluteSize.X)
                        if properties.onSlide then
                            properties.onSlide(value)
                        end
                    end
                end)
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        if moveConnection then
                            moveConnection:Disconnect()
                        end
                    end
                end)
            end
        end)
    
        sliderFrame.Parent = contentFrame
        return sliderFrame
    end

    return tab
end

return _G.Lib
