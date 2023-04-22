require 'Scripts/Dependencies'

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    love.window.setTitle('Breakout')

    gFonts = {
        ['small'] = love.graphics.newFont('Assets/Fonts/smallFont.ttf', 7),
        ['scores'] = love.graphics.newFont('Assets/Fonts/smallFont.ttf', 10),
        ['medium'] = love.graphics.newFont('Assets/Fonts/font.ttf', 36),
        ['large'] = love.graphics.newFont('Assets/Fonts/font.ttf', 60)
    }

    love.graphics.setFont(gFonts['small'])

    gTextures = {
        ['background'] = love.graphics.newImage('Assets/Graphics/Background.png'),
        ['bricks'] = love.graphics.newImage('Assets/Graphics/Bricks.png'),
        ['paddles'] = love.graphics.newImage('Assets/Graphics/Paddles.png'),
        ['balls'] = love.graphics.newImage('Assets/Graphics/Balls.png'),
        ['arrows'] = love.graphics.newImage('Assets/Graphics/Arrows.png'),
        ['heart'] = love.graphics.newImage('Assets/Graphics/Heart.png'),
        ['particle'] = love.graphics.newImage('Assets/Graphics/Particle.png'),
        ['powerups'] = love.graphics.newImage('Assets/Graphics/Powerups.png')
    }

    gFrames = {
        ['paddles'] = GenerateQuadsPaddles(gTextures['paddles']),
        ['balls'] = GenerateQuadsBalls(gTextures['balls']),
        ['bricks'] = GenerateQuadsBricks(gTextures['bricks']),
        ['arrows'] = GenerateQuadsArrows(gTextures['arrows']),
        ['powerups'] = GenerateQuadsPowerups(gTextures['powerups'])
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
        ['score'] = love.audio.newSource('Assets/Audio/Score.wav', 'static'),
        ['select'] = love.audio.newSource('Assets/Audio/Select.wav', 'static'),
        ['victory'] = love.audio.newSource('Assets/Audio/Victory.wav', 'static'),
        ['wallHit'] = love.audio.newSource('Assets/Audio/WallHit.wav', 'static'),
        ['powerup'] = love.audio.newSource('Assets/Audio/Powerup.wav', 'static'),
        ['menu'] = love.audio.newSource('Assets/Audio/Menu.mp3', 'static'),
        ['game'] = love.audio.newSource('Assets/Audio/Game.mp3', 'static')
    }

    gSounds['menu']:setLooping(true)
    gSounds['game']:setLooping(true)

    gSounds['menu']:setVolume(0.3)
    gSounds['game']:setVolume(0.3)


    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = false
    })

    gStateMachine = StateMachine {
        ['start'] = function()
            return StartState()
        end,
        ['play'] = function()
            return PlayState()
        end,
        ['serve'] = function()
            return ServeState()
        end,
        ['gameOver'] = function()
            return GameOverState()
        end,
        ['victory'] = function()
            return VictoryState()
        end,
        ['highScore'] = function()
            return HighScoreState()
        end,
        ['entry'] = function()
            return EnterHighScoreState()
        end,
        ['paddleSelect'] = function()
            return PaddleSelectState()
        end
    }

    gStateMachine:change('start', {
        highScores = loadHighScores()
    })

    gDialogueBoxEnabled = false

    gDialogueBoxSelection = 0

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

    love.graphics.draw(gTextures['background'], 0, 0, 0, VIRTUAL_WIDTH / (backgroundWidth),
        VIRTUAL_HEIGHT / (backgroundHeight))

    gStateMachine:render()

    -- displayFPS()

    push:finish()
end

function loadHighScores()
    love.filesystem.setIdentity('breakoutY')

    if not love.filesystem.getInfo('breakoutY.lst') then
        local scores = ''
        for i = 10, 1, -1 do
            scores = scores .. 'non\n'
            scores = scores .. tostring(i * 0) .. '\n'
        end

        love.filesystem.write('breakoutY.lst', scores)
    end

    local name = true
    local currentName = nil
    local counter = 1

    local scores = {}

    for i = 1, 10 do
        scores[i] = {
            name = nil,
            score = nil
        }
    end

    for line in love.filesystem.lines('breakoutY.lst') do
        if name then
            scores[counter].name = string.sub(line, 1, 3)
        else
            scores[counter].score = tonumber(line)
            counter = counter + 1
        end

        name = not name
    end

    return scores
end

-- Set different states to listen to mouse buttons being pressed
function love.mousepressed(x, y, button, istouch, presses)
    if gCurrentState == 'start' then
        StartState:onClick(button)
    elseif gCurrentState == 'highScore' then
        HighScoreState:onClick(button)
    elseif gCurrentState == 'paddleSelect' then
        PaddleSelectState:onClick(button)
    elseif gCurrentState == 'serve' then
        ServeState:onClick(button)
    elseif gCurrentState == 'play' then
        PlayState:onClick(button)
    elseif gCurrentState == 'victory' then
        VictoryState:onClick(button)
    elseif gCurrentState == 'gameOver' then
        GameOverState:onClick(button)
    end
end

-- Set the states in which the paddle is visible to listen to mouse being moved
function love.mousemoved(x, y, dx, dy, istouch)
    if gCurrentState == 'serve' or gCurrentState == 'play' or gCurrentState == 'victory' then
        gStateMachine.current.paddle:onMouseMove(dx)
    end
end

function renderLevel(level)
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(20 / 255, 20 / 255, 20 / 255, 1)
    love.graphics.print('Level: ' .. tostring(level), VIRTUAL_WIDTH / 2 - 84, 6)
end

function renderScore(score)
    love.graphics.setFont(gFonts['scores'])
    love.graphics.setColor(20 / 255, 20 / 255, 20 / 255, 1)
    love.graphics.print(tostring(score), VIRTUAL_WIDTH / 2 + 44, 5)
end

local enteredButtonArea

function renderDialogueBox()
    if love.mouse.getY() >= 400 and love.mouse.getY() < 470 then
        if love.mouse.getX() >= 500 and love.mouse.getX() < 580 then
            if not enteredButtonArea then
                gDialogueBoxSelection = 1
                gSounds['paddleHit']:play()
                love.mouse.setCursor(love.mouse.getSystemCursor('hand'))
            end
            enteredButtonArea = true
        elseif love.mouse.getX() >= 700 and love.mouse.getX() < 755 then
            if not enteredButtonArea then
                gDialogueBoxSelection = 2
                gSounds['paddleHit']:play()
                love.mouse.setCursor(love.mouse.getSystemCursor('hand'))
            end
            enteredButtonArea = true
        else
            gDialogueBoxSelection = 0
            love.mouse.setCursor(love.mouse.getSystemCursor('arrow'))
            enteredButtonArea = false
        end
    else
        gDialogueBoxSelection = 0
        love.mouse.setCursor(love.mouse.getSystemCursor('arrow'))
        enteredButtonArea = false
    end
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(80 / 255, 120 / 255, 230 / 255, 1)
    love.graphics.printf('Quit to the main menu?', 0, VIRTUAL_HEIGHT / 2 - 40, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(20 / 255, 20 / 255, 20 / 255, 1)

    if gDialogueBoxSelection == 1 then
        love.graphics.setColor(80 / 255, 120 / 255, 230 / 255, 1)
    end
    love.graphics.print('Yes', VIRTUAL_WIDTH / 2 - 70, VIRTUAL_HEIGHT / 2 + 20 )

    love.graphics.setColor(20 / 255, 20 / 255, 20 / 255, 1)

    if gDialogueBoxSelection == 2 then
        love.graphics.setColor(80 / 255, 120 / 255, 230 / 255, 1)
    end
    love.graphics.print('No', VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 2 + 20 )

    love.graphics.setColor(1, 1, 1, 1)
end

function displayFPS()
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
end
