require 'Scripts.Dependencies'

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    love.window.setTitle('Breakout')

    gFonts = {
        ['small'] = love.graphics.newFont('Assets/Fonts/font.ttf', 12),
        ['medium'] = love.graphics.newFont('Assets/Fonts/font.ttf', 36),
        ['large'] = love.graphics.newFont('Assets/Fonts/font.ttf', 60)
    }

    love.graphics.setFont(gFonts['small'])

    gTextures = {
        ['background'] = love.graphics.newImage('Assets/Graphics/Background.png')
    }

    gSounds = {
        ['brickHit1'] = love.audio.newSource('Assets/Audio/BrickHit1.wav', 'static'),
        ['brickHit2'] = love.audio.newSource('Assets/Audio/BrickHit2.wav', 'static'),
        ['confirm'] = love.audio.newSource('Assets/Audio/Confirm.wav', 'static'),
        ['highScore'] = love.audio.newSource('Assets/Audio/HighScore.wav', 'static'),
        ['hurt'] = love.audio.newSource('Assets/Audio/Hurt.wav', 'static'),
        ['noSelect'] = love.audio.newSource('Assets/Audio/NoSelect.wav', 'static'),
        ['paddleHit'] = love.audio.newSource('Assets/Audio/PaddleHit.wav', 'static'),
        ['pause'] = love.audio.newSource('Assets/Audio/Pause.wav', 'static'),
        ['recover'] = love.audio.newSource('Assets/Audio/Recover.wav', 'static'),
        ['score'] = love.audio.newSource('Assets/Audio/Score.wav', 'static'),
        ['select'] = love.audio.newSource('Assets/Audio/Select.wav', 'static'),
        ['victory'] = love.audio.newSource('Assets/Audio/Victory.wav', 'static'),
        ['wallHit'] = love.audio.newSource('Assets/Audio/WallHit.wav', 'static'),
        ['menu'] = love.audio.newSource('Assets/Audio/Menu.mp3', 'static'),
        ['game'] = love.audio.newSource('Assets/Audio/Game.mp3', 'static')
    }

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        resizable = true,
        fullscreen = false
    })

    gStateMachine = StateMachine {
        ['start'] = function()
            return StartState()
        end
    }

    gStateMachine:change('start')

    love.keyboard.keysPressed = {}
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key] == true and true or false
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    local backgroundWidth = gTextures['background']:getWidth()
    local backgroundHeight = gTextures['background']:getHeight()

    love.graphics.draw(gTextures['background'], 0, 0, 0, VIRTUAL_WIDTH / (backgroundWidth - 1),
        VIRTUAL_HEIGHT / (backgroundHeight - 1))

    gStateMachine:render()

    displayFPS()

    push:finish()
end

function displayFPS()
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
end
