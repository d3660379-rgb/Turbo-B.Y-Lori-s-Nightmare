-- ЭТОТ КОД ВСТАВЛЯТЬ В ИНЖЕКТОР (Loader)

-- Шаг 1: Указываем ключ шифрования
local encryption_key = "Gemini2025" 

-- Шаг 2: Указываем ссылку на зашифрованный файл
local payload_url = "https://raw.githubusercontent.com/d3660379-rgb/Turbo-hubs-scripts/refs/heads/main/Turbo-BY-Lori-s-Nightmare-script" 
-- ВАЖНО: Убедитесь, что этот payload.txt был создан с использованием ключа "Gemini2025"

local success, obfuscated_code = pcall(function()
    return game:HttpGet(payload_url, true)
end)

if success and obfuscated_code then
    -- Шаг 3: Объединяем ключ с кодом перед запуском
    
    -- ПРИМЕРНАЯ ЛОГИКА ДЛЯ YASUSCATOR: 
    -- Мы предполагаем, что он ищет ключ в переменной 'key' или 'encryption_key'
    
    local final_code = "local key = [[" .. encryption_key .. "]];" .. obfuscated_code
    
    -- Запуск
    loadstring(final_code)() 
else
    warn("❌ Ошибка загрузки скрипта.")
end
