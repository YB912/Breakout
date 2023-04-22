Paddle = Class {}

local mouseMoving = false

function Paddle:init(skin)
    self.x = VIRTUAL_WIDTH / 2 - 96
    self.y = VIRTUAL_HEIGHT - 24

    self.dx = 0
    self.mouseDX = 0

    self.width = 96
    self.height = 16

    self.skin = skin
    self.size = 2
end

function Paddle:update(dt)
    if mouseMoving then
        self.dx = self.mouseDX * PADDLE_SPEED / 5
    elseif love.keyboard.isDown('left') then
        self.dx = -PADDLE_SPEED
    elseif love.keyboard.isDown('right') then
        self.dx = PADDLE_SPEED
    else
        self.dx = 0
        self.mouseDX = 0
    end
        
    if self.dx < 0 then
        self.x = math.max(24, self.x + self.dx * dt)
    else
        self.x = math.min(VIRTUAL_WIDTH - self.width - 24, self.x + self.dx * dt)
    end 

    mouseMoving = false
end

function Paddle:render()
    love.graphics.draw(gTextures['paddles'], gFrames['paddles'][self.size + 3 * (self.skin - 1)],
        math.ceil(self.x), math.ceil(self.y))
end

function Paddle:onMouseMove(dx) 
    mouseMoving = true  
    self.mouseDX = dx
end
