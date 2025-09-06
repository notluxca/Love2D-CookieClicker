love.graphics.setDefaultFilter('nearest', 'nearest')
local screenW, screenH = love.graphics.getDimensions()
local cookieClicks = 0
local angle = 0
local rotationSpeed = 0.2;

local scale = 1
local targetScale = 1
local popSpeed = 1.5

function love.load()
    -- init something here ...
    love.window.setTitle('Cookie Clicker')
    cookie = love.graphics.newImage("Assets/Cookie.png")

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    -- ...
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    if key == "space" then
        cookieClicks = cookieClicks + 1 -- updating
        targetScale = 1.15              --
    end

    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    -- change some values based on your actions
    love.keyboard.keysPressed = {}

    if love.keyboard.isDown("space") then
        rotationSpeed = rotationSpeed + 0.4
    else
        if rotationSpeed > 0 then
            rotationSpeed = rotationSpeed * (1 - 3 / 100)
        end
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
end

function love.mousepressed(xMouseCordinate, yMouseCordinate, button)
    if button == 1 then
        local centerX, centerY = screenW / 2, screenH / 2
        local radius = (cookie:getWidth() * scale) / 2

        local distanceX = xMouseCordinate - centerX
        local distanceY = yMouseCordinate - centerY

        local distance = math.sqrt(distanceX * distanceX + distanceY * distanceY)
        if distance <= radius then
            cookieClicks = cookieClicks + 1 -- updating
            targetScale = 1.15
        end
    end
end

function love.draw()
    -- draw your stuff here
    love.graphics.print('Cookie Clicks: ' .. cookieClicks, screenW / 2 - 50, (screenH / 2) - 200, 0, 1, 1, 0, 0)
    love.graphics.draw(
        cookie,
        screenW / 2,
        screenH / 2,
        angle,                 -- rotation
        scale, scale,          -- agora usa scale!
        cookie:getWidth() / 2,
        cookie:getHeight() / 2 -- origin = center
    )
end
