Ball = Class {}

function Ball:init()
    self.width = 8
    self.height = 8

    self.dy = 0
    self.dx = 0
end

function Ball:collides(target)
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end

    return true
end

function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 4
    self.y = VIRTUAL_HEIGHT / 2 - 4
    self.dx = 0
    self.dy = 0
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    if self.x <= 24 then
        self.x = 24
        self.dx = -self.dx
        gSounds['wallHit']:play()
    end

    if self.x >= VIRTUAL_WIDTH - 32 then
        self.x = VIRTUAL_WIDTH - 32
        self.dx = -self.dx
        gSounds['wallHit']:play()
    end

    if self.y <= 24 then
        self.y = 24
        self.dy = -self.dy
        gSounds['wallHit']:play()
    end
end

function Ball:render()
    love.graphics.draw(gTextures['ball'], self.x, self.y)
end
