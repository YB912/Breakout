PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.paddle = Paddle()
    self.ball = Ball()
    self.paused = false

    self.ball.dx = math.random(-200,200)
    self.ball.dy = math.random(-80, -100)

    self.ball.x = VIRTUAL_WIDTH / 2 - 4
    self.ball.y = VIRTUAL_HEIGHT - 40
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
        self.ball.y = self.paddle.y - 8
        gSounds['paddleHit']:play()
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    self.paddle:render()
    self.ball:render()

    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("Paused", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end