-- Конфигурация
local ACTIVATION_CODE = "Rgg113"

-- Определение типа устройства
local function GetDeviceType()
    local userInputService = game:GetService("UserInputService")
    
    -- Проверка на мобильное устройство
    if userInputService.TouchEnabled then
        -- Проверка на планшет (размер экрана больше порога)
        local viewportSize = workspace.CurrentCamera.ViewportSize
        if math.min(viewportSize.X, viewportSize.Y) > 800 then
            return "tablet", viewportSize
        else
            return "phone", viewportSize
        end
    -- Проверка на консоль
    elseif userInputService.GamepadEnabled and not userInputService.KeyboardEnabled then
        return "console", workspace.CurrentCamera.ViewportSize
    else
        -- Десктоп/ноутбук
        return "desktop", workspace.CurrentCamera.ViewportSize
    end
end

-- Настройки размеров для разных устройств
local DeviceSettings = {
    desktop = {
        windowSize = UDim2.new(0, 500, 0, 400),
        windowPosition = UDim2.new(0.5, -250, 0.5, -200),
        titleSize = UDim2.new(1, -40, 0, 60),
        titlePosition = UDim2.new(0, 20, 0, 10),
        titleFontSize = 28,
        infoFrameSize = UDim2.new(1, -40, 0, 180),
        infoFramePosition = UDim2.new(0, 20, 0, 80),
        injectorFontSize = 22,
        recommendationFontSize = 16,
        envFontSize = 18,
        codeFrameSize = UDim2.new(1, -40, 0, 50),
        codeFramePosition = UDim2.new(0, 20, 0, 280),
        buttonSize = UDim2.new(1, -40, 0, 45),
        buttonPosition = UDim2.new(0, 20, 0, 340),
        codeFontSize = 18,
        buttonFontSize = 18,
        cornerRadius = 15,
        infoCornerRadius = 10,
        codeCornerRadius = 8,
        buttonCornerRadius = 8,
        spacing = 20
    },
    tablet = {
        windowSize = UDim2.new(0.8, 0, 0.7, 0),
        windowPosition = UDim2.new(0.1, 0, 0.15, 0),
        titleSize = UDim2.new(1, -30, 0, 70),
        titlePosition = UDim2.new(0, 15, 0, 10),
        titleFontSize = 26,
        infoFrameSize = UDim2.new(1, -30, 0, 200),
        infoFramePosition = UDim2.new(0, 15, 0, 90),
        injectorFontSize = 20,
        recommendationFontSize = 15,
        envFontSize = 17,
        codeFrameSize = UDim2.new(1, -30, 0, 55),
        codeFramePosition = UDim2.new(0, 15, 0, 300),
        buttonSize = UDim2.new(1, -30, 0, 50),
        buttonPosition = UDim2.new(0, 15, 0, 365),
        codeFontSize = 17,
        buttonFontSize = 17,
        cornerRadius = 12,
        infoCornerRadius = 8,
        codeCornerRadius = 6,
        buttonCornerRadius = 6,
        spacing = 15
    },
    phone = {
        windowSize = UDim2.new(0.95, 0, 0.85, 0),
        windowPosition = UDim2.new(0.025, 0, 0.075, 0),
        titleSize = UDim2.new(1, -20, 0, 80),
        titlePosition = UDim2.new(0, 10, 0, 5),
        titleFontSize = 22,
        infoFrameSize = UDim2.new(1, -20, 0, 220),
        infoFramePosition = UDim2.new(0, 10, 0, 95),
        injectorFontSize = 18,
        recommendationFontSize = 14,
        envFontSize = 16,
        codeFrameSize = UDim2.new(1, -20, 0, 60),
        codeFramePosition = UDim2.new(0, 10, 0, 325),
        buttonSize = UDim2.new(1, -20, 0, 55),
        buttonPosition = UDim2.new(0, 10, 0, 395),
        codeFontSize = 16,
        buttonFontSize = 16,
        cornerRadius = 10,
        infoCornerRadius = 6,
        codeCornerRadius = 5,
        buttonCornerRadius = 5,
        spacing = 10
    },
    console = {
        windowSize = UDim2.new(0, 600, 0, 450),
        windowPosition = UDim2.new(0.5, -300, 0.5, -225),
        titleSize = UDim2.new(1, -40, 0, 70),
        titlePosition = UDim2.new(0, 20, 0, 10),
        titleFontSize = 26,
        infoFrameSize = UDim2.new(1, -40, 0, 190),
        infoFramePosition = UDim2.new(0, 20, 0, 90),
        injectorFontSize = 21,
        recommendationFontSize = 16,
        envFontSize = 18,
        codeFrameSize = UDim2.new(1, -40, 0, 55),
        codeFramePosition = UDim2.new(0, 20, 0, 290),
        buttonSize = UDim2.new(1, -40, 0, 50),
        buttonPosition = UDim2.new(0, 20, 0, 355),
        codeFontSize = 18,
        buttonFontSize = 18,
        cornerRadius = 15,
        infoCornerRadius = 10,
        codeCornerRadius = 8,
        buttonCornerRadius = 8,
        spacing = 20
    }
}

-- Улучшенный детектор инжекторов
local function DetectInjector()
    -- Сначала проверяем Delta через специфичные методы
    local _, deltaErr = pcall(function()
        loadstring("")
    end)
    
    if deltaErr and (type(deltaErr) == "string") then
        if deltaErr:find("Delta") or deltaErr:find("delta") then
            return "Delta Executor", Color3.fromRGB(52, 152, 219), true
        end
    end
    
    -- Проверка глобальных переменных Delta
    if pcall(function() return _G.Delta end) or 
       pcall(function() return getgenv().DeltaLoaded end) or
       pcall(function() return getgenv().DELTA_EXEC end) then
        return "Delta Executor", Color3.fromRGB(52, 152, 219), true
    end
    
    -- Проверка на Script-Ware
    if identifyexecutor then
        local execName = identifyexecutor()
        if execName then
            if execName:lower():find("ware") then
                return "Script-Ware", Color3.fromRGB(230, 126, 34), true
            end
            return execName, Color3.fromRGB(155, 89, 182), true
        end
    end
    
    -- Проверка на Synapse X
    if syn and syn.protect_gui then
        return "Synapse X", Color3.fromRGB(41, 128, 185), true
    end
    
    -- Проверка на Krnl
    if Krnl and Krnl.Version then
        return "Krnl", Color3.fromRGB(231, 76, 60), true
    end
    
    -- Проверка на Fluxus
    if fluxus and fluxus.version then
        return "Fluxus", Color3.fromRGB(46, 204, 113), true
    end
    
    -- Проверка на JJsploit
    if jj and jj.encode then
        return "JJsploit", Color3.fromRGB(142, 68, 173), false
    end
    
    -- Проверка на WeAreDevs
    if iswindowactive or type(getreg) == "function" then
        return "WeAreDevs API", Color3.fromRGB(149, 165, 166), false
    end
    
    -- Проверка на Xeno
    if _G.xenover or (xenon and xenon.placeid) then
        return "Xeno", Color3.fromRGB(241, 196, 15), true
    end
    
    -- Проверка на Solara
    if solara or _G.Solara then
        return "Solara", Color3.fromRGB(26, 188, 156), true
    end
    
    -- Проверка на Oxygen U
    if oxygen and oxygen.getthreadcontext then
        return "Oxygen U", Color3.fromRGB(243, 156, 18), true
    end
    
    -- Проверка на Celery
    if celery then
        return "Celery", Color3.fromRGB(39, 174, 96), true
    end
    
    -- Если ничего не обнаружено
    return "Неизвестный инжектор", Color3.fromRGB(127, 140, 141), false
end

-- Проверка окружения
local function EnvironmentCheck()
    local checks = {
        {"loadstring", function() return type(loadstring) == "function" end},
        {"getgenv", function() return type(getgenv) == "function" end},
        {"Instance", function() return pcall(function() Instance.new("Part") end) end},
        {"Http", function() 
            return (type(HttpGet) == "function") or 
                   (syn and type(syn.request) == "function") or
                   (request and type(request) == "function")
        end},
        {"Players", function() return pcall(function() return game.Players.LocalPlayer end) end}
    }
    
    local results = {}
    local passed = 0
    
    for i, check in ipairs(checks) do
        local name, func = check[1], check[2]
        local success, result = pcall(func)
        
        results[name] = success and result
        if success and result then
            passed = passed + 1
        end
    end
    
    return passed >= 3, passed, #checks, results
end

-- Определение устройства и получение настроек
local deviceType, viewportSize = GetDeviceType()
local settings = DeviceSettings[deviceType] or DeviceSettings.desktop

-- Основной интерфейс
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InjectorDetector_" .. deviceType
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Затемнение фона
local Background = Instance.new("Frame")
Background.Name = "Background"
Background.Size = UDim2.new(1, 0, 1, 0)
Background.BackgroundColor3 = Color3.new(0, 0, 0)
Background.BackgroundTransparency = 0.7
Background.Parent = ScreenGui

-- Главное окно
local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Size = settings.windowSize
MainWindow.Position = settings.windowPosition
MainWindow.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainWindow.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, settings.cornerRadius)
UICorner.Parent = MainWindow

-- Заголовок с указанием устройства
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = settings.titleSize
Title.Position = settings.titlePosition
Title.BackgroundTransparency = 1
Title.Text = "АНАЛИЗ ИНЖЕКТОРА [" .. string.upper(deviceType) .. "]"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = settings.titleFontSize
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainWindow

-- Область информации
local InfoFrame = Instance.new("Frame")
InfoFrame.Name = "InfoFrame"
InfoFrame.Size = settings.infoFrameSize
InfoFrame.Position = settings.infoFramePosition
InfoFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
InfoFrame.Parent = MainWindow

local InfoCorner = Instance.new("UICorner")
InfoCorner.CornerRadius = UDim.new(0, settings.infoCornerRadius)
InfoCorner.Parent = InfoFrame

-- Результат детекции инжектора
local injectorName, injectorColor, isRecommended = DetectInjector()
local envWorking, passedChecks, totalChecks, checkResults = EnvironmentCheck()

local InjectorResult = Instance.new("TextLabel")
InjectorResult.Name = "InjectorResult"
InjectorResult.Size = UDim2.new(1, -settings.spacing, 0, deviceType == "phone" and 35 or 40)
InjectorResult.Position = UDim2.new(0, settings.spacing/2, 0, 10)
InjectorResult.BackgroundTransparency = 1
InjectorResult.Text = "ОБНАРУЖЕНО: " .. injectorName
InjectorResult.TextColor3 = injectorColor
InjectorResult.TextSize = settings.injectorFontSize
InjectorResult.Font = Enum.Font.GothamBold
InjectorResult.TextXAlignment = Enum.TextXAlignment.Left
InjectorResult.TextWrapped = true
InjectorResult.Parent = InfoFrame

-- Статус рекомендации
local Recommendation = Instance.new("TextLabel")
Recommendation.Name = "Recommendation"
Recommendation.Size = UDim2.new(1, -settings.spacing, 0, deviceType == "phone" and 25 : 30)
Recommendation.Position = UDim2.new(0, settings.spacing/2, 0, deviceType == "phone" and 50 : 55)
Recommendation.BackgroundTransparency = 1
Recommendation.Text = isRecommended and "✅ РЕКОМЕНДУЕМЫЙ ИНЖЕКТОР" or "⚠ НЕРЕКОМЕНДУЕМЫЙ ИНЖЕКТОР"
Recommendation.TextColor3 = isRecommended and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(241, 196, 15)
Recommendation.TextSize = settings.recommendationFontSize
Recommendation.Font = Enum.Font.Gotham
Recommendation.TextXAlignment = Enum.TextXAlignment.Left
Recommendation.TextWrapped = true
Recommendation.Parent = InfoFrame

-- Результаты проверки окружения
local EnvStatus = Instance.new("TextLabel")
EnvStatus.Name = "EnvStatus"
EnvStatus.Size = UDim2.new(1, -settings.spacing, 0, deviceType == "phone" and 50 : 60)
EnvStatus.Position = UDim2.new(0, settings.spacing/2, 0, deviceType == "phone" and 85 : 95)
EnvStatus.BackgroundTransparency = 1
EnvStatus.Text = "ПРОВЕРКА ОКРУЖЕНИЯ: " .. passedChecks .. "/" .. totalChecks .. " пройдено"
EnvStatus.TextColor3 = envWorking and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(231, 76, 60)
EnvStatus.TextSize = settings.envFontSize
EnvStatus.Font = Enum.Font.Gotham
EnvStatus.TextXAlignment = Enum.TextXAlignment.Left
EnvStatus.TextWrapped = true
EnvStatus.Parent = InfoFrame

-- Детали окружения (только для десктопа и планшета)
if deviceType == "desktop" or deviceType == "tablet" then
    local EnvDetails = Instance.new("TextLabel")
    EnvDetails.Name = "EnvDetails"
    EnvDetails.Size = UDim2.new(1, -settings.spacing, 0, 40)
    EnvDetails.Position = UDim2.new(0, settings.spacing/2, 0, deviceType == "desktop" and 150 : 160)
    EnvDetails.BackgroundTransparency = 1
    EnvDetails.Text = "Загрузка: " .. viewportSize.X .. "x" .. viewportSize.Y
    EnvDetails.TextColor3 = Color3.fromRGB(200, 200, 200)
    EnvDetails.TextSize = settings.recommendationFontSize
    EnvDetails.Font = Enum.Font.Gotham
    EnvDetails.TextXAlignment = Enum.TextXAlignment.Left
    EnvDetails.Parent = InfoFrame
end

-- Поле для ввода кода
local CodeFrame = Instance.new("Frame")
CodeFrame.Name = "CodeFrame"
CodeFrame.Size = settings.codeFrameSize
CodeFrame.Position = settings.codeFramePosition
CodeFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
CodeFrame.Parent = MainWindow

local CodeCorner = Instance.new("UICorner")
CodeCorner.CornerRadius = UDim.new(0, settings.codeCornerRadius)
CodeCorner.Parent = CodeFrame

local CodeBox = Instance.new("TextBox")
CodeBox.Name = "CodeBox"
CodeBox.Size = UDim2.new(1, -10, 1, -10)
CodeBox.Position = UDim2.new(0, 5, 0, 5)
CodeBox.BackgroundTransparency = 1
CodeBox.PlaceholderText = "Введите код проверки (" .. ACTIVATION_CODE .. ")"
CodeBox.Text = ""
CodeBox.TextColor3 = Color3.new(1, 1, 1)
CodeBox.TextSize = settings.codeFontSize
CodeBox.ClearTextOnFocus = false
CodeBox.Font = Enum.Font.Gotham
CodeBox.Parent = CodeFrame

-- Адаптация для мобильных устройств
if deviceType == "phone" or deviceType == "tablet" then
    CodeBox.TextScaled = true
    CodeBox.ClearTextOnFocus = true
end

-- Кнопка проверки
local VerifyButton = Instance.new("TextButton")
VerifyButton.Name = "VerifyButton"
VerifyButton.Size = settings.buttonSize
VerifyButton.Position = settings.buttonPosition
VerifyButton.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
VerifyButton.Text = "ВВЕСТИ КОД ДЛЯ ПРОВЕРКИ"
VerifyButton.TextColor3 = Color3.new(1, 1, 1)
VerifyButton.TextSize = settings.buttonFontSize
VerifyButton.Font = Enum.Font.GothamBold
VerifyButton.Parent = MainWindow

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, settings.buttonCornerRadius)
ButtonCorner.Parent = VerifyButton

-- Адаптация кнопки для мобильных устройств
if deviceType == "phone" or deviceType == "tablet" then
    VerifyButton.TextScaled = true
    VerifyButton.AutoButtonColor = true
    
    -- Увеличиваем область нажатия для сенсорного ввода
    local TouchFrame = Instance.new("Frame")
    TouchFrame.Name = "TouchFrame"
    TouchFrame.Size = UDim2.new(1, 10, 1, 10)
    TouchFrame.Position = UDim2.new(0, -5, 0, -5)
    TouchFrame.BackgroundTransparency = 1
    TouchFrame.Parent = VerifyButton
end

-- Функция проверки кода
local function VerifyCode(input)
    if input == ACTIVATION_CODE then
        VerifyButton.Text = "✅ КОД ПРИНЯТ"
        VerifyButton.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
        
        -- Анимация успеха
        task.spawn(function()
            for i = 1, 10 do
                VerifyButton.Rotation = i % 2 == 0 and 1 or -1
                task.wait(0.05)
            end
            VerifyButton.Rotation = 0
        end)
        
        -- Закрытие интерфейса
        task.delay(1.5, function()
            for i = 0, 1, 0.05 do
                MainWindow.BackgroundTransparency = i
                Background.BackgroundTransparency = 0.7 + (i * 0.3)
                task.wait()
            end
            ScreenGui:Destroy()
            
            -- Здесь будет запуск вашего основного скрипта
            print("[SYSTEM] Устройство: " .. deviceType)
            print("[SYSTEM] Разрешение: " .. viewportSize.X .. "x" .. viewportSize.Y)
            print("[SYSTEM] Injector: " .. injectorName)
            print("[SYSTEM] Environment check: " .. passedChecks .. "/" .. totalChecks)
            print("[SYSTEM] Code verified successfully!")
            -- loadstring(game:HttpGet("ВАШ_СКРИПТ"))()
        end)
        
        return true
    else
        VerifyButton.Text = "❌ НЕВЕРНЫЙ КОД"
        VerifyButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
        
        -- Анимация ошибки
        task.spawn(function()
            local originalPos = CodeBox.Position
            for i = 1, 3 do
                CodeBox.Position = UDim2.new(0, 5 + math.random(-5, 5), 0, 5)
                task.wait(0.1)
            end
            CodeBox.Position = originalPos
        end)
        
        task.delay(1, function()
            VerifyButton.Text = "ВВЕСТИ КОД ДЛЯ ПРОВЕРКИ"
            VerifyButton.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
            CodeBox.Text = ""
        end)
        
        return false
    end
end

-- Обработчики событий
CodeBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        VerifyCode(CodeBox.Text)
    end
end)

VerifyButton.MouseButton1Click:Connect(function()
    VerifyCode(CodeBox.Text)
end)

-- Для мобильных устройств добавляем обработку сенсорного ввода
if deviceType == "phone" or deviceType == "tablet" then
    CodeBox.FocusLost:Connect(function()
        VerifyCode(CodeBox.Text)
    end)
end

-- Вывод информации в консоль
print("==========================================")
print("АНАЛИЗ ИНЖЕКТОРА")
print("Устройство: " .. deviceType)
print("Разрешение: " .. viewportSize.X .. "x" .. viewportSize.Y)
print("Обнаружен: " .. injectorName)
print("Рекомендуемый: " .. (isRecommended and "Да" or "Нет"))
print("Проверка окружения: " .. passedChecks .. "/" .. totalChecks)
print("Код для активации: " .. ACTIVATION_CODE)
print("==========================================")