PlayState = Class { __includes = BaseState }

function PlayState:enter(enteringParams)
    self.paddle = enteringParams.paddle
    self.bricks = enteringParams.bricks
    self.health = enteringParams.health
    self.score = enteringParams.score
    self.highScores = enteringParams.highScores
    self.balls = {}
    self.ballSpeedModifier = 1.00
    self.ballType = 1
    self.level = enteringParams.level
    self.powerups = {}

    table.insert(self.balls, enteringParams.ball)

    for k, ball in pairs(self.balls) do
        ball.dx = math.random(-200, 200)
        ball.dy = DEFAULT_BALL_DY
    end
end

function PlayState:update(dt)
    if not gDialogueBoxEnabled then
        -- Handle'pause' feature
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

        -- Update each component of the scene
        self.paddle:update(dt)
        for k, ball in pairs(self.balls) do
            ball:update(dt)
        end
        self.health:update(dt)
        for k, brick in pairs(self.bricks) do
            brick:update(dt)
        end
        for k, powerup in pairs(self.powerups) do
            powerup:update(dt)
        end

        -- Handle balls' collisions
        for j, ball in pairs(self.balls) do
            -- Handle balls' collision with the paddle
            if ball:collides(self.paddle) then
                ball.dy = -ball.dy
                ball.y = self.paddle.y - ball.height

                -- Change the direction of the balls according to their collision point to give the player more control
                if ball.x < self.paddle.x + (self.paddle.width / 2) then
                    if self.paddle.dx < 0 then
                        ball.dx = -60 + -(5 * (self.paddle.x + self.paddle.width / 2 - ball.x))
                    else
                        ball.dx = -20 + -(3 * (self.paddle.x + self.paddle.width / 2 - ball.x))
                    end
                elseif ball.x > self.paddle.x + (self.paddle.width / 2) then
                    if self.paddle.dx > 0 then
                        ball.dx = 60 + (5 * math.abs(self.paddle.x + self.paddle.width / 2 - ball.x))
                    else
                        ball.dx = 20 + (3 * math.abs(self.paddle.x + self.paddle.width / 2 - ball.x))
                    end
                end

                gSounds['paddleHit']:play()
            end

            -- Handle collisions with bricks
            for k, brick in pairs(self.bricks) do
                if brick.enabled and ball:collides(brick) then

                    if self.ballType == 1 then
                        brick:hit()
                        self.score = brick.integrity == 0 and self.score + 50 or self.score + 10
                    elseif self.ballType == 2 or self.ballType == 3 then
                        self.score = self.score + (brick.integrity * 10) + 50
                        brick:explode()
                    end

                    -- Chance of spawning a random powerup on hit
                    local dropChance = math.random(5)
                    if dropChance == 1 then
                        table.insert(self.powerups, PowerUp(brick.x + brick.height / 2, brick.y + brick.height / 2, math.random(12)))
                    end

                    if self:checkVictory() then
                        gSounds['victory']:play()

                        gStateMachine:change('victory', {
                            level = self.level,
                            paddle = self.paddle,
                            health = self.health,
                            score = self.score,
                            highScores = self.highScores,
                            ball = Ball(1)
                        })
                    end

                    -- Change the direction of the ball according to the balls movement direction
                    if not (self.ballType == 3) then
                        if ball.x + 2 < brick.x and ball.dx > 0 then
                            ball.dx = -ball.dx
                            ball.x = brick.x - ball.width
                        elseif ball.x + 6 > brick.x + brick.width and ball.dx < 0 then
                            ball.dx = -ball.dx
                            ball.x = brick.x + brick.width
                        elseif ball.y < brick.y then
                            ball.dy = -ball.dy
                            ball.y = brick.y - ball.width
                        else
                            ball.dy = -ball.dy
                            ball.y = brick.y + brick.height
                        end
                    end

                    -- Make the game a little bit faster on each hit
                    self.ballSpeedModifier = self.ballSpeedModifier + BALL_SPEED_INCREASE

                    -- Apply the speed change on all of the balls
                    for l, b in pairs(self.balls) do
                        b.dx = b.dx * self.ballSpeedModifier
                        b.dy = b.dy * self.ballSpeedModifier
                    end
                end
            end

            -- If any ball goes out, disable it for removal and check loss
            if ball.y >= VIRTUAL_HEIGHT then
                ball.enabled = false
                PlayState:checkLoss(self)
            end
        end

        -- Handle different types of powerups upon pickup
        for k, powerup in pairs(self.powerups) do
            if powerup:collides(self.paddle) or powerup.y > VIRTUAL_HEIGHT then
                self.score = self.score + 100
                gSounds['powerup']:stop()
                gSounds['powerup']:play()
                powerup.toBeRemoved = true
                if powerup:collides(self.paddle) then
                    if powerup.type == 1 then
                        PowerUp:applyExtraBall(self)
                    elseif powerup.type == 2 then
                        PowerUp:applyBiggerPaddle(self)
                    elseif powerup.type == 3 then
                        PowerUp:applySlower(self)
                    elseif powerup.type == 4 then
                        PowerUp:applyDamageAllBricks(self)
                    elseif powerup.type == 5 then
                        PowerUp:applyStrongBalls(self)
                    elseif powerup.type == 6 then
                        PowerUp:applyWreckingBalls(self)
                    elseif powerup.type == 7 then
                        PowerUp:applyExtraHealth(self)
                    elseif powerup.type == 8 then
                        PowerUp:applyBonusPoints(self)
                    elseif powerup.type == 9 then
                        PowerUp:applyNormalBalls(self)
                    elseif powerup.type == 10 then
                        PowerUp:applyFaster(self)
                    elseif powerup.type == 11 then
                        PowerUp:applySmallerPaddle(self)
                    else
                        PowerUp:applyDeath(self)
                    end
                end
            end
        end

        for k, powerup in pairs(self.powerups) do
            if powerup.toBeRemoved then
                table.remove(self.powerups, k)
            end
        end

        -- Quitting dialogue box
        if love.keyboard.wasPressed('escape') then
            gSounds['pause']:play()
            gDialogueBoxEnabled = true
            love.mouse.setVisible(true)
        end
    else
        -- Quitting dialogue box
        if love.keyboard.wasPressed('escape') then
            gSounds['pause']:play()
            gDialogueBoxEnabled = false
            love.mouse.setVisible(false)
        end
    end
end

function PlayState:render()
    self.paddle:render()
    for k, ball in pairs(self.balls) do
        ball:render()
    end
    self.health:render()
    for k, brick in pairs(self.bricks) do
        brick:render()
        brick:renderParticles()
    end
    for k, powerup in pairs(self.powerups) do
        powerup:render()
    end

    renderLevel(self.level)
    renderScore(self.score)

    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.setColor(20 / 255, 20 / 255, 20 / 255, 1)
        love.graphics.printf("Paused", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    elseif gDialogueBoxEnabled then
        renderDialogueBox()
    end
end

-- Check if all the bricks in the table are disabled and if so, trigger victory
function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.enabled then
            return false
        end
    end
    return true
end

-- Check if all the balls in the table are disabled (passed down the screen) and if so, trigger loss
function PlayState:checkLoss(this)
    for k, ball in pairs(this.balls) do
        if ball.enabled then
            return false
        end
    end
    this.health:lose()

    gSounds['hurt']:play()

    if this.health.count == 0 then
        gStateMachine:change('gameOver', {
            score = this.score,
            highScores = loadHighScores(),
            health = this.health
        })
    else
        gStateMachine:change('serve', {
            paddle = this.paddle,
            bricks = this.bricks,
            health = this.health,
            score = this.score,
            highScores = this.highScores,
            level = this.level
        })
    end
end

-- Event handler for clicking in the play state
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