-- 初始化库
_G.GUI = {}

-- 创建一个新的 GUI 元素
function _G.GUI:CreateElement(elementType, properties)
    local element = Instance.new(elementType)
    for property, value in pairs(properties) do
        element[property] = value
    end
    return element
end

-- 创建 CoreGui
function _G.GUI:CreateCoreGui()
    local coreGui = Instance.new("ScreenGui")
    coreGui.Name = "MyCoreGui"
    coreGui.Parent = game:GetService("CoreGui")
    return coreGui
end

-- 创建标题
function _G.GUI:CreateTitle(parent, text)
    local title = _G.GUI:CreateElement("TextLabel", {
        Text = text,
        Size = UDim2.new(1, 0, 0, 50),
        Position = UDim2.new(0, 0, 0, 0),
        Parent = parent,
        BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.SourceSansBold,
        TextSize = 24
    })
end

-- 创建 Tab
function _G.GUI:CreateTab(parent, text)
    local tab = _G.GUI:CreateElement("Frame", {
        Name = text,
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Color3.new(0.8, 0.8, 0.8),
        Parent = parent,
        LayoutOrder = #parent:GetChildren() + 1 -- 自动排列分区
    })
    
    _G.GUI:CreateElement("TextLabel", {
        Text = text,
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        Parent = tab,
        BackgroundColor3 = Color3.new(0.4, 0.4, 0.4),
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.SourceSansBold,
        TextSize = 24
    })
    
    return tab
end

-- 创建按钮
function _G.GUI:CreateButton(parent, text, onClick)
    local button = _G.GUI:CreateElement("TextButton", {
        Text = text,
        Size = UDim2.new(1, 0, 0, 50),
        Position = UDim2.new(0, 0, #parent:GetChildren() * 50, 0),
        Parent = parent,
        BackgroundColor3 = Color3.new(0.4, 0.4, 0.4),
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.SourceSansBold,
        TextSize = 24
    })

    button.MouseButton1Click:Connect(onClick)
    return button
end

-- 创建 Toggle
function _G.GUI:CreateToggle(parent, text, onClick)
    local toggle = _G.GUI:CreateElement("TextButton", {
        Text = text,
        Size = UDim2.new(1, 0, 0, 50),
        Position = UDim2.new(0, 0, #parent:GetChildren() * 50, 0),
        Parent = parent,
        BackgroundColor3 = Color3.new(0.4, 0.4, 0.4),
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.SourceSansBold,
        TextSize = 24
    })

    local toggleState = false
    toggle.MouseButton1Click:Connect(function()
        toggleState = not toggleState
        onClick(toggleState)
    end)

    return toggle
end

-- 创建 Slider
function _G.GUI:CreateSlider(parent, text, min, max, onSlide)
    local slider = _G.GUI:CreateElement("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        Position = UDim2.new(0, 0, #parent:GetChildren() * 50, 0),
        Parent = parent,
        BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
    })

    _G.GUI:CreateElement("TextLabel", {
        Text = text,
        Size = UDim2.new(0.2, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        Parent = slider,
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.SourceSansBold,
        TextSize = 24
    })

    local slideBar = _G.GUI:CreateElement("TextButton", {
        Text = "",
        Size = UDim2.new(0.6, 0, 0.2, 0),
        Position = UDim2.new(0.2, 0, 0.4, 0),
        Parent = slider,
        BackgroundColor3 = Color3.new(0.6, 0.6, 0.6)
    })

    local slideHandle = _G.GUI:CreateElement("TextButton", {
        Text = "",
        Size = UDim2.new(0, 10, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        Parent = slideBar,
        BackgroundColor3 = Color3.new(1, 1, 1)
    })

    slideHandle.MouseButton1Down:Connect(function()
        local dragging = true
        local inputChanged
        inputChanged = slideHandle.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mouse = game:GetService("Players").LocalPlayer:GetMouse()
                local sliderWidth = slideBar.AbsoluteSize.X
                local newX = math.clamp(mouse.X - slideBar.AbsolutePosition.X, 0, sliderWidth)
                slideHandle.Position = UDim2.new(0, newX, 0, 0)
                local value = min + (max - min) * (newX / sliderWidth)
                onSlide(value)
            end
        end)
        slideHandle.MouseButton1Up:Connect(function()
            dragging = false
            inputChanged:Disconnect()
        end)
    end)

    return slider
end

-- 使用示例
