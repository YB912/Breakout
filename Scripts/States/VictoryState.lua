VictoryState = Class { __includes = BaseState }

function VictoryState:enter(enteringParams)
    self.level = enteringParams.level
    self.score = enteringParams.score
    self.paddle = enteringParams.paddle
    self.health = enteringParams.health
    self.ball = enteringParams.ball
end

function VictoryState:update(dt)
    self.paddle:update(dt)

    self.ball.x = self.paddle.x + (self.paddle.width / 2) - self.ball.width / 2
    self.ball.y = self.paddle.y - self.ball.height

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('serve', {
            level = self.level + 1,
            bricks = LevelMaker.createMap(self.level + 1),
            paddle = self.paddle,
            health = self.health,
            score = self.score
        })
    end
end

function VictoryState:render()
    self.paddle:render()
    self.ball:render()

    renderLevel(self.level)
    renderHealth(self.health)
    renderScore(self.score)

    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(80 / 255, 120 / 255, 230 / 255, 1)
    love.graphics.printf("Level " .. tostring(self.level) .. " complete!",
        0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press Enter to proceed', 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')
end
