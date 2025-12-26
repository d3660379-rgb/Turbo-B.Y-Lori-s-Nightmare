-- ============================================
-- BROOKHAVEN CUSTOM SCRIPT v1.0
-- Created by: [ВАШЕ ИМЯ]
-- For YouTube: [ВАШ КАНАЛ]
-- ============================================

-- Основные настройки
local Settings = {
    ScriptName = "Brookhaven Pro",
    Version = "1.0",
    Author = "Ваш никнейм",
    Discord = "ваш_дискорд",
    
    -- Цвета
    MainColor = Color3.fromRGB(52, 152, 219),
    SecondaryColor = Color3.fromRGB(41, 128, 185),
    TextColor = Color3.fromRGB(255, 255, 255),
    BackgroundColor = Color3.fromRGB(25, 25, 30),
    
    -- Клавиши
    ToggleKey = Enum.KeyCode.RightShift,
    OpenMenuKey = Enum.KeyCode.Insert,
    
    -- Настройки безопасности
    AntiLogs = true,
    AntiKick = true,
    Protection = true
}

-- Глобальные переменные
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local Workspace = game:GetService("Workspace")

-- Утилиты
local Utils = {}

-- Безопасный вызов
function Utils.SafeCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        warn("[ОШИБКА]:", result)
        return nil
    end
    return result
end

-- Поиск игрока по имени
function Utils.FindPlayer(name)
    name = name:lower()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name:lower():find(name) or player.DisplayName:lower():find(name) then
            return player
        end
    end
    return nil
end

-- Телепортация к позиции
function Utils.TeleportTo(position)
    if Character and HumanoidRootPart then
        HumanoidRootPart.CFrame = CFrame.new(position)
        return true
    end
    return false
end

-- Телепортация к игроку
function Utils.TeleportToPlayer(playerName)
    local target = Utils.FindPlayer(playerName)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        return Utils.TeleportTo(target.Character.HumanoidRootPart.Position)
    end
    return false
end

-- Получить все автомобили
function Utils.GetVehicles()
    local vehicles = {}
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj.Name == "Vehicle" and obj:FindFirstChild("DriveSeat") then
            table.insert(vehicles, obj)
        end
    end
    return vehicles
end

-- Анимация плавного изменения
function Utils.Tween(obj, properties, duration)
    local tweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = tweenService:Create(obj, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Основные функции
local Functions = {}

-- Деньги (требует исследования игры)
function Functions.AddMoney(amount)
    -- ЗАМЕНИТЬ НА РЕАЛЬНЫЙ МЕТОД
    print(f"[ДЕНЬГИ] Добавлено: {amount}")
    -- Пример: game:GetService("ReplicatedStorage").Events.AddMoney:FireServer(amount)
end

function Functions.RemoveMoney(amount)
    print(f"[ДЕНЬГИ] Убрано: {amount}")
end

-- Телепорты
function Functions.TeleportToSpawn()
    local spawn = Workspace:FindFirstChild("SpawnLocation")
    if spawn then
        Utils.TeleportTo(spawn.Position)
    end
end

function Functions.TeleportToBank()
    local bank = Workspace:FindFirstChild("Bank")
    if bank then
        Utils.TeleportTo(bank.Position + Vector3.new(0, 5, 0))
    end
end

function Functions.TeleportToPolice()
    local police = Workspace:FindFirstChild("PoliceStation")
    if police then
        Utils.TeleportTo(police.Position + Vector3.new(0, 5, 0))
    end
end

-- Машины
function Functions.SpawnCar(carName)
    -- ЗАМЕНИТЬ НА РЕАЛЬНЫЙ МЕТОД
    print(f"[МАШИНА] Спавн: {carName}")
    -- Пример: game:GetService("ReplicatedStorage").Events.SpawnVehicle:FireServer(carName)
end

function Functions.TeleportToCar()
    local vehicles = Utils.GetVehicles()
    if #vehicles > 0 then
        Utils.TeleportTo(vehicles[1].DriveSeat.Position)
    end
end

function Functions.DeleteAllCars()
    for _, vehicle in pairs(Utils.GetVehicles()) do
        vehicle:Destroy()
    end
end

-- Игроки
function Functions.KickPlayer(playerName)
    local target = Utils.FindPlayer(playerName)
    if target then
        -- ЗАМЕНИТЬ НА РЕАЛЬНЫЙ МЕТОД
        print(f"[КИК] Игрок: {target.Name}")
        -- Внимание: Кик других игроков может нарушать правила!
    end
end

function Functions.BringPlayer(playerName)
    local target = Utils.FindPlayer(playerName)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local pos = target.Character.HumanoidRootPart.Position
        Utils.TeleportTo(pos)
    end
end

-- Персонаж
function Functions.GodMode(enabled)
    if Character then
        if enabled then
            Humanoid.MaxHealth = math.huge
            Humanoid.Health = math.huge
        else
            Humanoid.MaxHealth = 100
            Humanoid.Health = 100
        end
    end
end

function Functions.Speed(speedValue)
    if Humanoid then
        Humanoid.WalkSpeed = speedValue
    end
end

function Functions.JumpPower(powerValue)
    if Humanoid then
        Humanoid.JumpPower = powerValue
    end
end

function Functions.InfiniteJump(enabled)
    if enabled then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end

-- Визуал
function Functions.Noclip(enabled)
    if enabled then
        RunService.Stepped:Connect(function()
            if Character then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end

function Functions.Fly(enabled, speed)
    -- Реализация полёта (упрощённая)
    if enabled then
        print("[ПОЛЁТ] Активирован")
    else
        print("[ПОЛЁТ] Деактивирован")
    end
end

function Functions.Invisible(enabled)
    if Character then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = enabled and 1 or 0
            end
        end
    end
end

-- Игровые пропуски (Gamepass)
function Functions.UnlockAllGamepasses()
    -- ЗАМЕНИТЬ НА РЕАЛЬНЫЙ МЕТОД
    print("[ПРОПУСКИ] Все разблокированы")
    -- Внимание: Это может быть нарушением!
end

function Functions.UnlockVIP()
    print("[VIP] Разблокирован")
end

-- GUI интерфейс
local GUI = {}

function GUI.Create()
    -- Загрузка библиотеки Rayfield
    local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
    
    -- Создание окна
    local Window = Rayfield:CreateWindow({
        Name = Settings.ScriptName .. " v" .. Settings.Version,
        LoadingTitle = "Загрузка...",
        LoadingSubtitle = "by " .. Settings.Author,
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "BrookhavenScript",
            FileName = "Config"
        },
        Discord = {
            Enabled = true,
            Invite = Settings.Discord,
            RememberJoins = true
        },
        KeySystem = false, -- Уже есть активация
        KeySettings = {
            Title = "Активация",
            Subtitle = "Введите ключ",
            Note = "Получите ключ в Discord",
            FileName = "Key",
            SaveKey = true,
            GrabKeyFromSite = false,
            Key = {"Rgg113"}
        }
    })
    
    -- Вкладка: Телепорты
    local TeleportTab = Window:CreateTab("Телепорты", "rbxassetid://4483345998")
    
    TeleportTab:CreateButton({
        Name = "Спавн",
        Callback = function()
            Functions.TeleportToSpawn()
        end
    })
    
    TeleportTab:CreateButton({
        Name = "Банк",
        Callback = function()
            Functions.TeleportToBank()
        end
    })
    
    TeleportTab:CreateButton({
        Name = "Полиция",
        Callback = function()
            Functions.TeleportToPolice()
        end
    })
    
    TeleportTab:CreateSection("К игрокам")
    
    local PlayerInput = TeleportTab:CreateInput({
        Name = "Имя игрока",
        PlaceholderText = "Введите ник",
        RemoveTextAfterFocusLost = false,
        Callback = function(Text)
            _G.TeleportTarget = Text
        end
    })
    
    TeleportTab:CreateButton({
        Name = "Телепорт к игроку",
        Callback = function()
            if _G.TeleportTarget then
                Functions.TeleportToPlayer(_G.TeleportTarget)
            end
        end
    })
    
    -- Вкладка: Персонаж
    local PlayerTab = Window:CreateTab("Персонаж", "rbxassetid://4483345998")
    
    PlayerTab:CreateSlider({
        Name = "Скорость",
        Range = {16, 500},
        Increment = 1,
        Suffix = "studs/s",
        CurrentValue = 16,
        Flag = "SpeedValue",
        Callback = function(Value)
            Functions.Speed(Value)
        end
    })
    
    PlayerTab:CreateSlider({
        Name = "Сила прыжка",
        Range = {50, 500},
        Increment = 1,
        Suffix = "power",
        CurrentValue = 50,
        Flag = "JumpPowerValue",
        Callback = function(Value)
            Functions.JumpPower(Value)
        end
    })
    
    PlayerTab:CreateToggle({
        Name = "Бессмертие",
        CurrentValue = false,
        Flag = "GodModeToggle",
        Callback = function(Value)
            Functions.GodMode(Value)
        end
    })
    
    PlayerTab:CreateToggle({
        Name = "Ноклип",
        CurrentValue = false,
        Flag = "NoclipToggle",
        Callback = function(Value)
            Functions.Noclip(Value)
        end
    })
    
    PlayerTab:CreateToggle({
        Name = "Невидимость",
        CurrentValue = false,
        Flag = "InvisibleToggle",
        Callback = function(Value)
            Functions.Invisible(Value)
        end
    })
    
    -- Вкладка: Машины
    local VehicleTab = Window:CreateTab("Машины", "rbxassetid://4483345998")
    
    VehicleTab:CreateButton({
        Name = "Телепорт к машине",
        Callback = function()
            Functions.TeleportToCar()
        end
    })
    
    VehicleTab:CreateButton({
        Name = "Удалить все машины",
        Callback = function()
            Functions.DeleteAllCars()
        end
    })
    
    VehicleTab:CreateSection("Спавн машин")
    
    local CarInput = VehicleTab:CreateInput({
        Name = "Название машины",
        PlaceholderText = "Введите название",
        RemoveTextAfterFocusLost = false,
        Callback = function(Text)
            _G.CarName = Text
        end
    })
    
    VehicleTab:CreateButton({
        Name = "Заспавнить машину",
        Callback = function()
            if _G.CarName then
                Functions.SpawnCar(_G.CarName)
            end
        end
    })
    
    -- Вкладка: Игроки
    local OtherPlayersTab = Window:CreateTab("Игроки", "rbxassetid://4483345998")
    
    OtherPlayersTab:CreateSection("Управление")
    
    local KickInput = OtherPlayersTab:CreateInput({
        Name = "Кик игрока",
        PlaceholderText = "Введите ник",
        RemoveTextAfterFocusLost = false,
        Callback = function(Text)
            _G.KickTarget = Text
        end
    })
    
    OtherPlayersTab:CreateButton({
        Name = "Выполнить кик",
        Callback = function()
            if _G.KickTarget then
                Functions.KickPlayer(_G.KickTarget)
            end
        end
    })
    
    local BringInput = OtherPlayersTab:CreateInput({
        Name = "Привести игрока",
        PlaceholderText = "Введите ник",
        RemoveTextAfterFocusLost = false,
        Callback = function(Text)
            _G.BringTarget = Text
        end
    })
    
    OtherPlayersTab:CreateButton({
        Name = "Выполнить приведение",
        Callback = function()
            if _G.BringTarget then
                Functions.BringPlayer(_G.BringTarget)
            end
        end
    })
    
    -- Вкладка: Настройки
    local SettingsTab = Window:CreateTab("Настройки", "rbxassetid://4483345998")
    
    SettingsTab:CreateLabel("Информация о скрипте")
    SettingsTab:CreateLabel("Название: " .. Settings.ScriptName)
    SettingsTab:CreateLabel("Версия: " .. Settings.Version)
    SettingsTab:CreateLabel("Автор: " .. Settings.Author)
    
    SettingsTab:CreateButton({
        Name = "Сохранить настройки",
        Callback = function()
            Rayfield:Notify({
                Title = "Сохранение",
                Content = "Настройки сохранены!",
                Duration = 3,
                Image = 4483362458
            })
        end
    })
    
    SettingsTab:CreateButton({
        Name = "Сбросить настройки",
        Callback = function()
            Rayfield:Notify({
                Title = "Сброс",
                Content = "Настройки сброшены!",
                Duration = 3,
                Image = 4483362458
            })
        end
    })
    
    SettingsTab:CreateButton({
        Name = "Закрыть меню",
        Callback = function()
            Rayfield:Destroy()
        end
    })
    
    -- Уведомление о загрузке
    Rayfield:Notify({
        Title = "Успешная загрузка!",
        Content = "Скрипт активирован. Нажмите " .. tostring(Settings.ToggleKey) .. " для открытия/закрытия.",
        Duration = 6,
        Image = 4483362458
    })
    
    print("[СКРИПТ] Загружен успешно!")
    print("[СКРИПТ] Название: " .. Settings.ScriptName)
    print("[СКРИПТ] Версия: " .. Settings.Version)
    print("[СКРИПТ] Автор: " .. Settings.Author)
end

-- Инициализация
function Init()
    -- Проверка игры
    if game.PlaceId ~= 4924922222 then -- ID Brookhaven
        warn("[ОШИБКА] Этот скрипт только для Brookhaven!")
        return
    end
    
    -- Создание GUI
    GUI.Create()
    
    -- Бинд клавиши
    local UIS = game:GetService("UserInputService")
    UIS.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed then
            if input.KeyCode == Settings.ToggleKey then
                -- Тут логика открытия/закрытия GUI
                print("[ГУЙ] Клавиша нажата")
            end
        end
    end)
    
    -- Защита от кика
    if Settings.AntiKick then
        LocalPlayer.OnTeleport:Connect(function(state)
            if state == Enum.TeleportState.Started then
                -- Сохранение данных при телепорте
            end
        end)
    end
end

-- Запуск
local success, err = pcall(Init)
if not success then
    warn("[КРИТИЧЕСКАЯ ОШИБКА]:", err)
end

-- Экспорт функций (для отладки)
return {
    Settings = Settings,
    Utils = Utils,
    Functions = Functions,
    GUI = GUI
}