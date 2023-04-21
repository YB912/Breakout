PlayState = Class { __includes = BaseState }

function PlayState:enter(enteringParams)
    self.paddle = enteringParams.paddle
    self.bricks = enteringParams.bricks
    self.health = enteringParams.health
    self.score = enteringParams.score
    self.highScores = enteringParams.highScores
    self.ball = enteringParams.ball
    self.level = enteringParams.level

    self.ball.dx = math.random(-200, 200)
    self.ball.dy = math.random(-80, -100)

end

function PlayState:update(dt)
    if not gDialogueBoxEnabled then
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
        self.health:update(dt)
    
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
    
                if self:checkVictory() then
                    gSounds['victory']:play()
    
                    gStateMachine:change('victory', {
                        level = self.level,
                        paddle = self.paddle,
                        health = self.health,
                        score = self.score,
                        highScores = self.highScores,
                        ball = self.ball
                    })
                end
    
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
                self.ball.dy = self.ball.dy * 1.05
            end
        end
    
        if self.ball.y >= VIRTUAL_HEIGHT then
            self.health:lose()
    
            gSounds['hurt']:play()
    
            if self.health.count == 0 then
                gStateMachine:change('gameOver', {
                    score = self.score,
                    highScores = loadHighScores(),
                    health = self.health
                })
            else
                gStateMachine:change('serve', {
                    paddle = self.paddle,
                    bricks = self.bricks,
                    health = self.health,
                    score = self.score,
                    highScores = self.highScores,
                    level = self.level
                })
            end
        end
    
        for k, brick in pairs(self.bricks) do
            brick:update(dt)
        end
    
        if love.keyboard.wasPressed('escape') then
            gSounds['pause']:play()
            gDialogueBoxEnabled = true
            love.mouse.setVisible(true)
        end
    else
        if love.keyboard.wasPressed('escape') then
            gSounds['pause']:play()
            gDialogueBoxEnabled = false
            love.mouse.setVisible(false)
        end
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


    renderLevel(self.level)
    renderScore(self.score)
    self.health:render()

    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.setColor(20 / 255, 20 / 255, 20 / 255, 1)
        love.graphics.printf("Paused", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    elseif gDialogueBoxEnabled then
        renderDialogueBox()
    end
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.enabled then
            return false
        end
    end

    return true
end

function PlayState:onClick(button)
    if gDialogueBoxEnabled then
        gDialogueBoxEnabled = false
        if gDialogueBoxSelection == 1 then
            gStateMachine:change('start', {
                highScores = loadHighScores()
            })
        elseif gDialogueBoxSelection == 2 then
            gSounds['pause']:play()
            love.mouse.setVisible(false)
        end
    end
end
