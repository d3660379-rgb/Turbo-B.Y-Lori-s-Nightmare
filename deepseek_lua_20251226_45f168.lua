-- Загружаем Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Создаём окно
local Window = Rayfield:CreateWindow({
   Name = "Brookhaven Pro | ПОЛНЫЙ DEX",
   LoadingTitle = "Полное исследование игры...",
   LoadingSubtitle = "Поиск ВСЕХ объектов через Dex",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BrookhavenScript",
      FileName = "Config"
   },
   KeySystem = false,
})

-- УГЛУБЛЁННОЕ ИССЛЕДОВАНИЕ ЧЕРЕЗ DEX
local function DeepExploreGame()
    print("========================================")
    print("ПОЛНОЕ ИССЛЕДОВАНИЕ BROOKHAVEN")
    print("========================================")
    
    local Workspace = game:GetService("Workspace")
    local foundObjects = {
        Vehicles = {},
        Houses = {},
        Stores = {},
        SpecialBuildings = {},
        AllLocations = {}
    }
    
    -- 1. ВСЕ машины (включая скрытые и новые)
    for _, obj in pairs(Workspace:GetDescendants()) do
        -- Машины по DriveSeat
        if obj.Name == "DriveSeat" and obj:IsA("VehicleSeat") then
            local vehicle = obj.Parent
            if vehicle:IsA("Model") then
                table.insert(foundObjects.Vehicles, {
                    Name = vehicle.Name,
                    Model = vehicle,
                    DriveSeat = obj,
                    Position = vehicle:GetPivot().Position
                })
            end
        end
        
        -- Машины по VehicleTag
        if obj:IsA("ObjectValue") and obj.Name == "VehicleTag" then
            local vehicle = obj.Parent
            if vehicle:IsA("Model") then
                table.insert(foundObjects.Vehicles, {
                    Name = vehicle.Name,
                    Model = vehicle,
                    Tag = "VehicleTag",
                    Position = vehicle:GetPivot().Position
                })
            end
        end
    end
    
    -- 2. ВСЕ дома и магазины (интеллектуальный поиск)
    local buildingPatterns = {
        houses = {"House", "Home", "Mansion", "Villa", "Apartment", "Building"},
        stores = {"Store", "Shop", "Market", "Shop", "Mall", "GasStation", "Pizza"},
        special = {"Bank", "Police", "Hospital", "FireStation", "School", "Hospital", "Church", "Hotel"}
    }
    
    for _, model in pairs(Workspace:GetChildren()) do
        if model:IsA("Model") then
            local modelName = model.Name:lower()
            local primaryPart = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
            
            if primaryPart then
                -- Проверяем категории
                for category, patterns in pairs(buildingPatterns) do
                    for _, pattern in pairs(patterns) do
                        if modelName:find(pattern:lower()) then
                            local buildingType = "Unknown"
                            
                            if category == "houses" then
                                buildingType = "Дом"
                                table.insert(foundObjects.Houses, {
                                    Name = model.Name,
                                    Model = model,
                                    Type = buildingType,
                                    Position = primaryPart.Position,
                                    Size = primaryPart.Size
                                })
                            elseif category == "stores" then
                                buildingType = "Магазин"
                                table.insert(foundObjects.Stores, {
                                    Name = model.Name,
                                    Model = model,
                                    Type = buildingType,
                                    Position = primaryPart.Position,
                                    Size = primaryPart.Size
                                })
                            elseif category == "special" then
                                buildingType = "Спецздание"
                                table.insert(foundObjects.SpecialBuildings, {
                                    Name = model.Name,
                                    Model = model,
                                    Type = buildingType,
                                    Position = primaryPart.Position,
                                    Size = primaryPart.Size
                                })
                            end
                            
                            -- Добавляем во все локации
                            table.insert(foundObjects.AllLocations, {
                                Name = model.Name,
                                Model = model,
                                Category = buildingType,
                                Position = primaryPart.Position
                            })
                            
                            break
                        end
                    end
                end
            end
        end
    end
    
    -- 3. Точный поиск известных мест Brookhaven
    local knownLocations = {
        -- Дома
        {Name = "Modern House", Search = "Modern"},
        {Name = "Big Mansion", Search = "Mansion"},
        {Name = "Blue House", Search = "BlueHouse"},
        {Name = "Red House", Search = "RedHouse"},
        {Name = "Green House", Search = "GreenHouse"},
        {Name = "Apartment Building", Search = "Apartment"},
        
        -- Магазины
        {Name = "Gun Store", Search = "GunStore"},
        {Name = "Gas Station", Search = "GasStation"},
        {Name = "Pizza Shop", Search = "Pizza"},
        {Name = "Supermarket", Search = "Supermarket"},
        {Name = "Clothing Store", Search = "Clothing"},
        {Name = "Toy Store", Search = "ToyStore"},
        
        -- Специальные
        {Name = "Bank", Search = "Bank"},
        {Name = "Police Station", Search = "Police"},
        {Name = "Hospital", Search = "Hospital"},
        {Name = "Fire Station", Search = "FireStation"},
        {Name = "School", Search = "School"},
        {Name = "Hotel", Search = "Hotel"},
        {Name = "Church", Search = "Church"},
        
        -- Транспорт
        {Name = "Train Station", Search = "Train"},
        {Name = "Helipad", Search = "Helipad"},
        {Name = "Boat Dock", Search = "Dock"},
        
        -- Развлечения
        {Name = "Cinema", Search = "Cinema"},
        {Name = "Night Club", Search = "NightClub"},
        {Name = "Arcade", Search = "Arcade"},
        {Name = "Park", Search = "Park"},
    }
    
    -- Поиск точных совпадений
    for _, location in pairs(knownLocations) do
        local found = Workspace:FindFirstChild(location.Search) or 
                     Workspace:FindFirstChild(location.Name, true)
        
        if found then
            local primaryPart = found.PrimaryPart or found:FindFirstChildWhichIsA("BasePart")
            if primaryPart then
                table.insert(foundObjects.AllLocations, {
                    Name = location.Name,
                    Model = found,
                    Category = "Известная локация",
                    Position = primaryPart.Position,
                    ExactMatch = true
                })
            end
        end
    end
    
    -- 4. Поиск по мебели и интерьеру (дополнительный метод)
    for _, model in pairs(Workspace:GetChildren()) do
        if model:IsA("Model") then
            -- Дома обычно имеют дверь, окна, мебель
            local hasDoor = model:FindFirstChild("Door") or model:FindFirstChild("FrontDoor")
            local hasFurniture = model:FindFirstChild("Furniture") or model:FindFirstChild("Interior")
            local hasWindows = model:FindFirstChild("Window") or model:FindFirstChild("Glass")
            
            if (hasDoor or hasFurniture or hasWindows) and not foundObjects.AllLocations[model.Name] then
                local primaryPart = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    table.insert(foundObjects.AllLocations, {
                        Name = model.Name .. " (автоопределение)",
                        Model = model,
                        Category = "Автоопределено",
                        Position = primaryPart.Position,
                        Reason = "Имеет дверь/мебель/окна"
                    })
                end
            end
        end
    end
    
    -- Вывод статистики
    print("[СТАТИСТИКА] Найдено:")
    print("- Машин: " .. #foundObjects.Vehicles)
    print("- Домов: " .. #foundObjects.Houses)
    print("- Магазинов: " .. #foundObjects.Stores)
    print("- Спецзданий: " .. #foundObjects.SpecialBuildings)
    print("- Всего локаций: " .. #foundObjects.AllLocations)
    
    return foundObjects
end

-- Получаем ГЛУБОКИЕ данные
local DeepData = DeepExploreGame()

-- ВКЛАДКА "ВСЕ ТЕЛЕПОРТЫ"
local AllTeleportsTab = Window:CreateTab("Все телепорты", 12308313279)

-- Группировка по категориям
local categories = {
    {Name = "🏠 ДОМА", Data = DeepData.Houses},
    {Name = "🛒 МАГАЗИНЫ", Data = DeepData.Stores},
    {Name = "🚨 СПЕЦЗДАНИЯ", Data = DeepData.SpecialBuildings},
    {Name = "📍 ВСЕ ЛОКАЦИИ", Data = DeepData.AllLocations}
}

for _, category in pairs(categories) do
    if #category.Data > 0 then
        AllTeleportsTab:CreateSection(category.Name)
        
        for _, location in pairs(category.Data) do
            AllTeleportsTab:CreateButton({
                Name = location.Name .. " (" .. location.Category .. ")",
                Callback = function()
                    local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local targetPos = location.Position
                        
                        -- Умная телепортация
                        if location.Model:IsA("Model") then
                            local entrance = location.Model:FindFirstChild("Door") or 
                                           location.Model:FindFirstChild("Entrance") or
                                           location.Model:FindFirstChild("FrontDoor")
                            
                            if entrance and entrance:IsA("BasePart") then
                                targetPos = entrance.Position + Vector3.new(0, 3, 5)
                            else
                                -- Телепорт перед зданием, а не внутрь
                                targetPos = location.Position + Vector3.new(0, 5, 10)
                            end
                        end
                        
                        hrp.CFrame = CFrame.new(targetPos)
                        
                        print("[ТЕЛЕПОРТ] " .. location.Name .. 
                              " | Категория: " .. location.Category ..
                              " | Позиция: " .. math.floor(targetPos.X) .. ", " .. 
                              math.floor(targetPos.Y) .. ", " .. math.floor(targetPos.Z))
                    end
                end,
            })
        end
    end
end

-- ВКЛАДКА "МАШИНЫ 2024"
local Vehicles2024Tab = Window:CreateTab("Машины 2024", 12309228907)

if #DeepData.Vehicles > 0 then
    Vehicles2024Tab:CreateLabel("Найдено машин: " .. #DeepData.Vehicles)
    
    -- Телепорт к ближайшей машине
    Vehicles2024Tab:CreateButton({
        Name = "🚗 Телепорт к БЛИЖАЙШЕЙ машине",
        Callback = function()
            local playerPos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
            local nearest = nil
            local nearestDist = math.huge
            
            for _, vehicle in pairs(DeepData.Vehicles) do
                local dist = (vehicle.Position - playerPos).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearest = vehicle
                end
            end
            
            if nearest then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = 
                    CFrame.new(nearest.Position + Vector3.new(0, 3, 0))
                print("[МАШИНА] Ближайшая: " .. nearest.Name .. 
                      " | Дистанция: " .. math.floor(nearestDist) .. " studs")
            end
        end,
    })
    
    -- Список всех машин
    Vehicles2024Tab:CreateSection("Все найденные машины")
    
    for i, vehicle in pairs(DeepData.Vehicles) do
        if i <= 20 then -- Показать первые 20
            Vehicles2024Tab:CreateButton({
                Name = vehicle.Name .. " (" .. (vehicle.Tag or "DriveSeat") .. ")",
                Callback = function()
                    local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
                    hrp.CFrame = CFrame.new(vehicle.Position + Vector3.new(0, 3, 0))
                    print("[МАШИНА] Телепорт к " .. vehicle.Name)
                end,
            })
        end
    end
    
    if #DeepData.Vehicles > 20 then
        Vehicles2024Tab:CreateLabel("... и ещё " .. (#DeepData.Vehicles - 20) .. " машин")
    end
else
    Vehicles2024Tab:CreateLabel("⚠ Машины не найдены!")
    Vehicles2024Tab:CreateLabel("Попробуйте пересканировать")
end

-- ВКЛАДКА "ИГРОКИ"
local PlayersTab = Window:CreateTab("Игроки", 12308573542)

-- Динамический список игроков
local function GetPlayersList()
    local players = {}
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            table.insert(players, player.Name)
        end
    end
    return players
end

local PlayerDropdown = PlayersTab:CreateDropdown({
    Name = "Выберите игрока",
    Options = GetPlayersList(),
    CurrentOption = "",
    Flag = "PlayerSelect",
    Callback = function(Option)
        _G.SelectedPlayer = Option
    end,
})

-- Обновление списка
game.Players.PlayerAdded:Connect(function(player)
    PlayerDropdown:Refresh(GetPlayersList(), true)
end)

game.Players.PlayerRemoving:Connect(function(player)
    PlayerDropdown:Refresh(GetPlayersList(), true)
end)

PlayersTab:CreateButton({
    Name = "📌 Телепорт к игроку",
    Callback = function()
        if _G.SelectedPlayer then
            local target = game.Players[_G.SelectedPlayer]
            if target and target.Character then
                local hrp = target.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = hrp.CFrame
                    print("[ИГРОК] Телепорт к " .. target.Name)
                end
            end
        end
    end,
})

-- ВКЛАДКА "DEX SCANNER"
local DexTab = Window:CreateTab("DEX Сканер", 12308413127)

DexTab:CreateSection("Результаты сканирования")

DexTab:CreateLabel("🏠 Домов: " .. #DeepData.Houses)
DexTab:CreateLabel("🛒 Магазинов: " .. #DeepData.Stores)
DexTab:CreateLabel("🚨 Спецзданий: " .. #DeepData.SpecialBuildings)
DexTab:CreateLabel("🚗 Машин: " .. #DeepData.Vehicles)
DexTab:CreateLabel("📍 Всего локаций: " .. #DeepData.AllLocations)

DexTab:CreateButton({
    Name = "🔄 Пересканировать игру",
    Callback = function()
        DeepData = DeepExploreGame()
        Rayfield:Notify({
            Title = "DEX пересканирован",
            Content = "Данные обновлены!",
            Duration = 4,
            Image = 12308282053,
        })
    end,
})

DexTab:CreateSection("Поиск по названию")

local SearchBox = DexTab:CreateInput({
    Name = "Поиск локации",
    PlaceholderText = "Введите название...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        _G.SearchQuery = Text:lower()
    end,
})

DexTab:CreateButton({
    Name = "🔍 Найти и телепортировать",
    Callback = function()
        if _G.SearchQuery and _G.SearchQuery ~= "" then
            for _, location in pairs(DeepData.AllLocations) do
                if location.Name:lower():find(_G.SearchQuery) then
                    local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
                    hrp.CFrame = CFrame.new(location.Position + Vector3.new(0, 5, 0))
                    
                    Rayfield:Notify({
                        Title = "Найдено!",
                        Content = location.Name,
                        Duration = 3,
                        Image = 12308282053,
                    })
                    
                    print("[ПОИСК] Найдено: " .. location.Name .. 
                          " | Категория: " .. location.Category)
                    return
                end
            end
            
            Rayfield:Notify({
                Title = "Не найдено",
                Content = "Локация не обнаружена",
                Duration = 3,
                Image = 12308282053,
            })
        end
    end,
})

-- ВКЛАДКА "СЕРВЕР"
local ServerTab = Window:CreateTab("Сервер", 12308623315)

ServerTab:CreateButton({
    Name = "🔄 Перезайти на сервер",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end,
})

ServerTab:CreateButton({
    Name = "🎮 Сервер на автопистолеты",
    Callback = function()
        game:GetService("TeleportService"):Teleport(6839171747)
    end,
})

-- Уведомление о загрузке
Rayfield:Notify({
    Title = "ПОЛНЫЙ DEX АКТИВИРОВАН",
    Content = "Найдено " .. #DeepData.AllLocations .. " локаций и " .. 
             #DeepData.Vehicles .. " машин",
    Duration = 6,
    Image = 12308282053,
})

-- Вывод в консоль
print("╔═══════════════════════════════════════════════════╗")
print("║         BROOKHAVEN PRO - ПОЛНЫЙ DEX              ║")
print("║         Найдено ВСЕ локации и машины!           ║")
print("╠═══════════════════════════════════════════════════╣")
print("║ 🏠  Домов:        " .. string.format("%-30s", #DeepData.Houses) .. "║")
print("║ 🛒  Магазинов:    " .. string.format("%-30s", #DeepData.Stores) .. "║")
print("║ 🚨  Спецзданий:   " .. string.format("%-30s", #DeepData.SpecialBuildings) .. "║")
print("║ 🚗  Машин:        " .. string.format("%-30s", #DeepData.Vehicles) .. "║")
print("║ 📍  Всего:        " .. string.format("%-30s", #DeepData.AllLocations) .. "║")
print("╠═══════════════════════════════════════════════════╣")
print("║  Клавиша: RightShift                              ║")
print("║  Поиск: Введите название в DEX Сканере            ║")
print("╚═══════════════════════════════════════════════════╝")

-- Горячая клавиша
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        Rayfield:Toggle()
    end
end)

-- Автоматическое обновление каждые 60 секунд
while true do
    wait(60)
    local oldCount = #DeepData.AllLocations
    DeepData = DeepExploreGame()
    
    if #DeepData.AllLocations > oldCount then
        print("[АВТО-ОБНОВЛЕНИЕ] Найдено новых локаций: " .. 
              (#DeepData.AllLocations - oldCount))
    end
end