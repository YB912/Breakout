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

-- For when a bigger paddle powerup is activated
function Paddle:grow()
    if not (self.size == 3) then
        self.size = self.size + 1
        self.width = self.size == 2 and 96 or 128
        self.x = self.x - 16
    end
end

-- For when a smaller paddle powerup is activated
function Paddle:shrink()
    if not (self.size == 1) then
        self.size = self.size - 1
        self.width = self.size == 1 and 64 or 96
        self.x = self.x + 16
    end
end

function Paddle:reset()
    self.width = 96
    if self.size == 1 then
        self.x = self.x - 16
    elseif self.size == 3 then
        self.x = self.x + 16
    end
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

-- Event handler for moving the mouse while the paddle is visible
function Paddle:onMouseMove(dx) 
    mouseMoving = true  
    self.mouseDX = dx
end
