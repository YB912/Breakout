Paddle = Class {}

function Paddle:init()
    self.x = VIRTUAL_WIDTH / 2 - 96
    self.y = VIRTUAL_HEIGHT - 24

    self.dx = 0

    self.width = 96
    self.height = 16

    -- Skin and size variables for calculating the index of the paddle needed in the Paddle.render() function
    self.skin = 3
    self.size = 2
end

function Paddle:update(dt)
    -- keyboard input
    if love.keyboard.isDown('left') then
        self.dx = -PADDLE_SPEED
    elseif love.keyboard.isDown('right') then
        self.dx = PADDLE_SPEED
    else
        self.dx = 0
    end

    if self.dx < 0 then
        self.x = math.max(24, self.x + self.dx * dt)
    else
        self.x = math.min(VIRTUAL_WIDTH - self.width - 24, self.x + self.dx * dt)
    end
end

function Paddle:render()
    love.graphics.draw(gTextures['paddles'], gFrames['paddles'][self.size + 3 * (self.skin - 1)],
        self.x, self.y)
end
