--[[
    Your love2d game start here
]]


love.graphics.setDefaultFilter('nearest', 'nearest')
local screenW, screenH = love.graphics.getDimensions()
local cookieClicks = 0
local angle = 0
local rotationSpeed = 0.2;

function love.load()
    -- init something here ...
    love.window.setTitle('Hello love2d!')
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
        cookieClicks = cookieClicks + 1
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
        rotationSpeed = rotationSpeed + 0.1
    else
        if rotationSpeed >= 0 then
            rotationSpeed = rotationSpeed - 0.03
        end
    end

    angle = angle + rotationSpeed * dt
end

function love.draw()
    -- draw your stuff here
    love.graphics.print('Cookie Clicks: ' .. cookieClicks, screenW / 2 - 50, (screenH / 2) - 200, 0, 1, 1, 0, 0)
    love.graphics.draw(
        cookie,
        screenW / 2,
        screenH / 2,
        angle,                 -- rotation
        1, 1,                  -- scale
        cookie:getWidth() / 2,
        cookie:getHeight() / 2 -- origin = center
    )
end
