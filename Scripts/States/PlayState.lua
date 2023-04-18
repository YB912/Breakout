PlayState = Class { __includes = BaseState }

function PlayState:enter(enteringParams)
    self.paddle = enteringParams.paddle
    self.bricks = enteringParams.bricks
    self.health = enteringParams.health
    self.score = enteringParams.score
    self.ball = enteringParams.ball

    self.ball.dx = math.random(-200,200)
    self.ball.dy = math.random(-80, -100)
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    self.paddle:update(dt)
    self.ball:update(dt)

    if self.ball:collides(self.paddle) then
        self.ball.dy = -self.ball.dy
        self.ball.y = self.paddle.y - self.ball.height



        if self.ball.x < self.paddle.x + (self.paddle.width / 2) then
            if self.paddle.dx < 0 then
                self.ball.dx = -60 + -(5 * (self.paddle.x + self.paddle.width / 2 - self.ball.x))
            else
                self.ball.dx = -20 + -(3 * (self.paddle.x + self.paddle.width / 2 - self.ball.x))
            end
        elseif self.ball.x > self.paddle.x + (self.paddle.width / 2) then
            if self.paddle.dx > 0 then
                self.ball.dx = 60 + (5 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball.x))
            else
                self.ball.dx = 20 + (3 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball.x))
            end
        end

        gSounds['paddleHit']:play()
    end

    for k, brick in pairs(self.bricks) do
        if brick.enabled and self.ball:collides(brick) then
            self.score = brick.integrity == 0 and self.score + 50 or self.score + 10
            brick:hit()
            if self.ball.x + 2 < brick.x and self.ball.dx > 0 then
                self.ball.dx = -self.ball.dx
                self.ball.x = brick.x - self.ball.width
            elseif self.ball.x + 6 > brick.x + brick.width and self.ball.dx < 0 then
                self.ball.dx = -self.ball.dx
                self.ball.x = brick.x + brick.width
            elseif self.ball.y < brick.y then
                self.ball.dy = -self.ball.dy
                self.ball.y = brick.y - self.ball.width
            else
                self.ball.dy = -self.ball.dy
                self.ball.y = brick.y + brick.height
            end
            self.ball.dy = self.ball.dy * 1.005
        end
    end

    if self.ball.y >= VIRTUAL_HEIGHT then
        self.health = self.health - 1
        gSounds['hurt']:play()

        if self.health == 0 then
            gStateMachine:change('gameOver', {
                score = self.score
            })
        else
            gStateMachine:change('serve', {
                paddle = self.paddle,
                bricks = self.bricks,
                health = self.health,
                score = self.score
            })
        end
    end

    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

end

function PlayState:render()

    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    self.paddle:render()
    self.ball:render()

    renderHealth(self.health)
    renderScore(self.score)

    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("Paused", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end
