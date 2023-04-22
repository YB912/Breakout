PowerUp = Class {}

function PowerUp:init(x, y, type)
    self.x = x
    self.y = y
    self.width = 32
    self.height = 32
    self.type = type
    -- 1  ==> Extra ball
    -- 2  ==> Bigger paddle
    -- 3  ==> Slower
    -- 4  ==> Damage all bricks
    -- 5  ==> Strong balls
    -- 6  ==> Wrecking balls
    -- 7  ==> Extra health
    -- 8  ==> Bonus points
    -- 9  ==> Normal balls
    -- 10 ==> Faster
    -- 11 ==> Smaller paddle
    -- 12 ==> Death
    self.dy = POWERUP_SPEED
    self.toBeRemoved = false
end

function PowerUp:collides(paddle)
    if self.x <= paddle.x + paddle.width and self.x + self.width > paddle.x then
        if self.y <= paddle.y + paddle.height and self.y + self.height > paddle.y then
            return true
        end
    end
    return false
end

-- Extra ball powerup
function PowerUp:applyExtraBall(playState)
    local ball = Ball(playState.ballType)
    ball.x = playState.paddle.x + playState.paddle.width / 2
    ball.y = playState.paddle.y - ball.height
    ball.dx = math.random(-200, 200) * playState.ballSpeedModifier
    ball.dy = DEFAULT_BALL_DY * playState.ballSpeedModifier
    table.insert(playState.balls, ball)
end

-- Bigger paddle powerup
function PowerUp:applyBiggerPaddle(playState)
    if not (playState.paddle.size == 3) then
        playState.paddle.size = playState.paddle.size + 1
        playState.paddle.width = playState.paddle.size == 2 and 96 or 128
        playState.paddle.x = playState.paddle.x - 16
    end
end

-- Slower powerup
function PowerUp:applySlower(playState)
    playState.ballSpeedModifier = 1.00
    for l, ball in pairs(playState.balls) do
        local relation = ball.dx / ball.dy
        ball.dy = ball.dy < 0 and DEFAULT_BALL_DY or -DEFAULT_BALL_DY
        ball.dx = ball.dy * relation
    end
end

-- Damage all bricks powerup
function PowerUp:applyDamageAllBricks(playState)
    for k, brick in pairs(playState.bricks) do
        if brick.enabled then
            playState.score = brick.integrity == 0 and playState.score + 50 or playState.score + 10
            brick:hit()
        end
    end
    if playState:checkVictory() then
        gSounds['victory']:play()

        gStateMachine:change('victory', {
            level = playState.level,
            paddle = playState.paddle,
            health = playState.health,
            score = playState.score,
            highScores = playState.highScores,
            ball = Ball(1)
        })
    end
end

-- Strong balls powerup
function PowerUp:applyStrongBalls(playState)
    playState.ballType = 2
    for k, ball in pairs(playState.balls) do
        ball.type = 2
    end
end

-- Wrecking balls powerup
function PowerUp:applyWreckingBalls(playState)
    playState.ballType = 3
    for k, ball in pairs(playState.balls) do
        ball.type = 3
    end
end

-- Extra health powerup
function PowerUp:applyExtraHealth(playState)
    playState.health:gain()
end

-- Bonus points powerup
function PowerUp:applyBonusPoints(playState)
    playState.score = playState.score + BONUS_POINTS
end

-- Normal balls powerup
function PowerUp:applyNormalBalls(playState)
    playState.ballType = 1
    for k, ball in pairs(playState.balls) do
        ball.type = 1
    end
end

-- Faster powerup
function PowerUp:applyFaster(playState)
    for l, ball in pairs(playState.balls) do
        local relation = ball.dx / ball.dy
        ball.dy = ball.dy < 0 and ball.dy - 20 or ball.dy + 20
        ball.dx = ball.dy * relation
    end
end

-- Smaller paddle powerup
function PowerUp:applySmallerPaddle(playState)
    if not (playState.paddle.size == 1) then
        playState.paddle.size = playState.paddle.size - 1
        playState.paddle.width = playState.paddle.size == 1 and 64 or 96
        playState.paddle.x = playState.paddle.x + 16
    end
end

-- Death powerup
function PowerUp:applyDeath(playState)
    playState.health:lose()

    gSounds['hurt']:play()

    if playState.health.count == 0 then
        gStateMachine:change('gameOver', {
            score = playState.score,
            highScores = loadHighScores(),
            health = playState.health
        })
    else
        gStateMachine:change('serve', {
            paddle = playState.paddle,
            bricks = playState.bricks,
            health = playState.health,
            score = playState.score,
            highScores = playState.highScores,
            level = playState.level
        })
    end
end

function PowerUp:update(dt)
    self.y = self.y + self.dy * dt
end

function PowerUp:render()
    love.graphics.draw(gTextures['powerups'], gFrames['powerups'][self.type], self.x, self.y)
end
