ServeState = Class { __includes = BaseState }

function ServeState:enter(enteringParams)
    self.paddle = enteringParams.paddle
    self.bricks = enteringParams.bricks
    self.health = enteringParams.health
    self.score = enteringParams.score
    self.highScores = enteringParams.highScores
    self.level = enteringParams.level
    self.ball = Ball()

    gSounds['menu']:stop()
    gSounds['game']:play()
end

function ServeState:update(dt)
    self.paddle:update(dt)
    self.ball.x = self.paddle.x + (self.paddle.width / 2) - self.ball.width / 2
    self.ball.y = self.paddle.y - self.ball.height
    self.health:update(dt)

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play', {
            paddle = self.paddle,
            bricks = self.bricks,
            health = self.health,
            score = self.score,
            highScores = self.highScores,
            ball = self.ball,
            level = self.level
        })
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function ServeState:render()
    self.paddle:render()
    self.ball:render()
    for k, brick in pairs(self.bricks) do
        brick:render()
    end
    renderLevel(self.level)
    renderScore(self.score)
    self.health:render()
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(80 / 255, 120 / 255, 230 / 255, 1)
    love.graphics.printf('Press enter to begin', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
end
