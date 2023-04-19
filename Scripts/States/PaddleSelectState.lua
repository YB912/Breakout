PaddleSelectState = Class { __includes = BaseState }

function PaddleSelectState:enter(params)
    self.highScores = params.highScores
end

function PaddleSelectState:init()
    self.currentPaddle = 1
end

function PaddleSelectState:update(dt)
    if love.keyboard.wasPressed('left') then
        if self.currentPaddle == 1 then
            gSounds['noSelect']:play()
        else
            gSounds['select']:play()
            self.currentPaddle = self.currentPaddle - 1
        end
    elseif love.keyboard.wasPressed('right') then
        if self.currentPaddle == 3 then
            gSounds['noSelect']:play()
        else
            gSounds['select']:play()
            self.currentPaddle = self.currentPaddle + 1
        end
    end

    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        gSounds['confirm']:play()

        gStateMachine:change('serve', {
            paddle = Paddle(self.currentPaddle),
            bricks = LevelMaker.createMap(1),
            health = 3,
            score = 0,
            highScores = self.highScores,
            level = 1
        })
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PaddleSelectState:render()
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(80 / 255, 120 / 255, 230 / 255, 1)
    love.graphics.printf("Select your paddle", 0, VIRTUAL_HEIGHT / 4,
        VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['scores'])
    love.graphics.setColor(20 / 255, 20 / 255, 20 / 255, 1)
    love.graphics.printf("(Press Enter to continue)", 0, VIRTUAL_HEIGHT / 3 + 30,
        VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(1, 1, 1, 1)

    if self.currentPaddle == 1 then
        love.graphics.setColor(40 / 255, 40 / 255, 40 / 255, 1)
    end

    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][1], VIRTUAL_WIDTH / 2 - 100,
        VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)

    love.graphics.setColor(1, 1, 1, 1)

    if self.currentPaddle == 3 then
        love.graphics.setColor(40 / 255, 40 / 255, 40 / 255, 1)
    end

    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][2], VIRTUAL_WIDTH / 2 + 68,
        VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)

    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.draw(gTextures['paddles'], gFrames['paddles'][2 + 3 * (self.currentPaddle - 1)],
        VIRTUAL_WIDTH / 2 - 48, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)
end
