-- auth.lua — перевірка ключа з термінами, HWID, баном
local HttpService = game:GetService("HttpService")

-- ⚙️ НАЛАШТУВАННЯ
local KEY_LIST_URL = "https://raw.githubusercontent.com/yarukkiselov584-boop/Cheat/main/keys.json"

-- HWID (унікальний ID пристрою)
local function getHWID()
    local ok, hwid = pcall(function()
        if gethwid then return gethwid() end
        if game:GetService("RbxAnalyticsService") then
            return game:GetService("RbxAnalyticsService"):GetClientId()
        end
        return tostring(game.PlaceId) .. "_" .. tostring(game.JobId)
    end)
    return ok and hwid or "unknown_hwid"
end

local HWID = getHWID()

-- Отримуємо базу ключів
local function fetchKeys()
    local ok, data = pcall(function()
        local raw = game:HttpGet(KEY_LIST_URL .. "?t=" .. tick())
        return HttpService:JSONDecode(raw)
    end)
    return ok and data or nil
end

-- Форматуємо час у зрозумілий вигляд
local function formatTime(seconds)
    if seconds <= 0 then return "0 хв" end
    local days = math.floor(seconds / 86400)
    local hours = math.floor((seconds % 86400) / 3600)
    local mins = math.floor((seconds % 3600) / 60)
    if days > 0 then return days .. " дн " .. hours .. " год"
    elseif hours > 0 then return hours .. " год " .. mins .. " хв"
    else return mins .. " хв" end
end

-- Основна функція перевірки
local function validateKey(userKey)
    if not userKey or userKey == "" then
        return false, "❌ Ключ не вказано"
    end

    local keys = fetchKeys()
    if not keys then
        return false, "❌ Не вдалось завантажити базу ключів"
    end

    local now = os.time()

    for _, entry in ipairs(keys) do
        if entry.key == userKey then
            -- 1. Бан
            if entry.banned then
                return false, "🚫 Ключ забанений"
            end

            -- 2. Термін
            if entry.expires and now > entry.expires then
                return false, "❌ Ключ прострочений"
            end

            -- 3. HWID прив'язка
            if entry.hwid and entry.hwid ~= "" and entry.hwid ~= HWID then
                return false, "🔒 Ключ прив'язаний до іншого пристрою"
            end

            -- 4. Успіх
            local timeLeft = ""
            if entry.expires then
                timeLeft = " | залишилось: " .. formatTime(entry.expires - now)
            else
                timeLeft = " | ♾ назавжди"
            end

            return true, {
                key = entry.key,
                type = entry.type or "?",
                expires = entry.expires,
                hwid = entry.hwid,
                message = "✅ Ключ прийнято" .. timeLeft
            }
        end
    end

    return false, "❌ Невірний ключ"
end

return validateKey
