-- auth.lua (вбудований у loader)
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- ⚙️ НАЛАШТУВАННЯ
local KEY_LIST_URL = "https://raw.githubusercontent.com/yarukkiselov584-boop/Cheat/main/keys.json" -- або raw GitHub/Pastebin
local HWID = game:GetService("RbxAnalyticsService"):GetClientId()  -- унікальний ID пристрою

-- Отримуємо базу ключів
local function fetchKeys()
    local ok, data = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(KEY_LIST_URL))
    end)
    return ok and data or nil
end

-- Перевірка ключа
local function validateKey(userKey)
    local keys = fetchKeys()
    if not keys then
        return false, "Не вдалось завантажити базу ключів"
    end

    for _, entry in ipairs(keys) do
        if entry.key == userKey then
            -- Перевірка HWID (якщо вже прив'язаний)
            if entry.hwid and entry.hwid ~= HWID then
                return false, "Ключ прив'язаний до іншого пристрою"
            end

            -- Перевірка терміну
            if entry.expires and os.time() > entry.expires then
                return false, "Ключ прострочений"
            end

            return true, entry  -- ✅ валідний
        end
    end

    return false, "Невірний ключ"
end

return validateKey
