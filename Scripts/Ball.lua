Ball = Class {}

function Ball:init(type)
    self.x = -20
    self.y = -20
    self.width = 16
    self.height = 16

    self.type = type or 1
    -- 1 ==> Normal ball
    -- 2 ==> Strong ball
    -- 3 ==> Wrecking all

    self.enabled = true

    self.dy = 0
    self.dx = 0
end

-- AA-BB Collision detection - can be used against paddle and bricks
function Ball:collides(target)
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end

    return true
end

function Ball:update(dt)
    if self.enabled then
        self.x = self.x + self.dx * dt
        self.y = self.y + self.dy * dt

        -- Check collision with left wall
        if self.x <= 24 then
            self.x = 24
            self.dx = -self.dx
            gSounds['wallHit']:play()
        end

        -- Check collision with right wall
        if self.x >= VIRTUAL_WIDTH - (24 + self.width) then
            self.x = VIRTUAL_WIDTH - (24 + self.width)
            self.dx = -self.dx
            gSounds['wallHit']:play()
        end

        -- Check collision with ceiling
        if self.y <= 24 then
            self.y = 24
            self.dy = -self.dy
            gSounds['wallHit']:play()
        end
    end
end

function Ball:render()
    if self.enabled then
        love.graphics.draw(gTextures['balls'], gFrames['balls'][self.type], math.ceil(self.x), math.ceil(self.y))
    end
end
