if os.getenv "LOCAL_LUA_DEBUGGER_VSCODE" == "1" then
    local lldebugger = require "lldebugger"
    lldebugger.start()
    local run = love.run
    function love.run(...)
        local f = lldebugger.call(run, false, ...)
        return function(...) return lldebugger.call(f, false, ...) end
    end
end

love.graphics.setDefaultFilter('nearest', 'nearest')
local screenW, screenH = love.graphics.getDimensions()
local AllCookieClicks = 0;
local currentCookieClicks = 0
local angle = 0
local rotationSpeed = 0;
local clickRotationPower = 0.4;

local scale = 1
local targetScale = 1
local popSpeed = 1.5

local clickUpgradeCost = 50;
local currentClickPower = 2

local SpinUpgradeCost = 100;
local SpiningCurrencyUnlocked = false


-- power ups
-- Increase Cokie production
-- Unlock Spining production (the cookie generate clicks while rotating


function love.load()
    -- init something here ...
    love.window.setTitle('Cookie Clicker')
    cookie = love.graphics.newImage("Assets/Cookie.png")
    background = love.graphics.newImage("Assets/background.jpg")

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    -- ...
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    if key == '1' then
        if currentCookieClicks > clickUpgradeCost then
            currentCookieClicks = currentCookieClicks - clickUpgradeCost
            currentClickPower = currentClickPower * 1.5
            clickUpgradeCost = clickUpgradeCost * 1.2
        end
    end
    if key == '2' then
        if SpiningCurrencyUnlocked == false and currentCookieClicks > 300 then
            currentCookieClicks = currentCookieClicks - 300
            SpiningCurrencyUnlocked = true
        else
            if currentCookieClicks > SpinUpgradeCost then
                currentCookieClicks = currentCookieClicks - SpinUpgradeCost
                SpinUpgradeCost = SpinUpgradeCost * 1.2
                clickRotationPower = clickRotationPower + 0.2;
            end
        end
    end

    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    -- change some values based on your actions
    love.keyboard.keysPressed = {}

    if rotationSpeed > 0 then
        rotationSpeed = rotationSpeed * (1 - 3 / 100)
    end

    -- animação de scale suavizada (volta para 1 quando POP terminar)
    if scale < targetScale then
        scale = math.min(scale + popSpeed * dt, targetScale)
    elseif scale > targetScale then
        scale = math.max(scale - popSpeed * dt, targetScale)
    end

    -- quando atinge o pico, volta para o normal
    if targetScale > 1 and math.abs(scale - targetScale) < 0.01 then
        targetScale = 1
    end

    angle = angle + rotationSpeed * dt
    if angle > 0.3 and SpiningCurrencyUnlocked then
        currentCookieClicks = currentCookieClicks + 0.1;
    end
end

function love.mousepressed(xMouseCordinate, yMouseCordinate, button)
    if button == 1 then
        local centerX, centerY = screenW / 2, screenH / 2
        local radius = (cookie:getWidth() * scale) / 2

        local distanceX = xMouseCordinate - centerX
        local distanceY = yMouseCordinate - centerY

        local distance = math.sqrt(distanceX * distanceX + distanceY * distanceY)
        if distance <= radius then
            currentCookieClicks = currentCookieClicks + currentClickPower -- updating
            AllCookieClicks = AllCookieClicks + currentClickPower
            rotationSpeed = rotationSpeed + clickRotationPower
            targetScale = 1.15
        end
    end
end

function love.draw()
    love.graphics.draw(background, 0, 0, 0, screenW / background:getWidth(),
        screenH / background:getHeight()) -- draw background

    -- draw your stuff here
    love.graphics.print('1 - Double click power - ' .. math.abs(clickUpgradeCost) .. " Cookies", 10, 10, 0, 1, 1, 0, 0)

    if SpiningCurrencyUnlocked == false then
        love.graphics.print('2 - Unlock spining currency - 300 Cookies', 10, 25, 0, 1, 1, 0, 0)
    else
        love.graphics.print('2 - Increase Spinning force - ' .. math.abs(SpinUpgradeCost) .. " Cookies", 10, 25, 0, 1, 1,
            0, 0)
    end


    love.graphics.print('Current click force: ' .. math.abs(currentClickPower), 10, 50, 0, 1, 1, 0, 0)
    love.graphics.print('Spinning force: ' .. math.abs(clickRotationPower), 10, 65, 0, 1, 1, 0, 0)

    love.graphics.print('All Cookies: ' .. math.abs(AllCookieClicks), screenW / 2 - 40, (screenH / 2) - 215, 0, 1, 1, 0,
        0)
    love.graphics.print('Cookie Clicks: ' .. math.ceil(currentCookieClicks), screenW / 2 - 50, (screenH / 2) - 200, 0, 1,
        1, 0, 0)
    love.graphics.draw(
        cookie,
        screenW / 2,
        screenH / 2,
        angle, -- rotation
        scale, scale,
        cookie:getWidth() / 2,
        cookie:getHeight() / 2 -- origin = center
    )
end
