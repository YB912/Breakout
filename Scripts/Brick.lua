Brick = Class {}

particleColors = {
    -- Glass :
    [1] = {
        ['r'] = 155,
        ['g'] = 244,
        ['b'] = 244
    },
    -- Wood :
    [2] = {
        ['r'] = 80,
        ['g'] = 30,
        ['b'] = 0
    },
    -- Sandstone :
    [3] = {
        ['r'] = 230,
        ['g'] = 205,
        ['b'] = 120
    },
    -- Stone :
    [4] = {
        ['r'] = 190,
        ['g'] = 190,
        ['b'] = 190
    }
}

function Brick:init(x, y)
    self.material = 0
    self.integrity = 3

    self.x = x
    self.y = y
    self.width = 32
    self.height = 16

    self.enabled = true

    self.particleSystem = love.graphics.newParticleSystem(gTextures['particle'], 64)
    self.particleSystem:setParticleLifetime(0.5, 1)
    self.particleSystem:setLinearAcceleration(-15, 0, 15, 80)
    self.particleSystem:setEmissionArea('uniform', 16, 8)
end

function Brick:hit()
    self.particleSystem:setColors(
        particleColors[self.material].r / 255,
        particleColors[self.material].g / 255,
        particleColors[self.material].b / 255,
        55 * (self.material + 1) / 255,
        particleColors[self.material].r / 255,
        particleColors[self.material].g / 255,
        particleColors[self.material].b / 255,
        0
    )

    self.particleSystem:emit(64)

    self.integrity = self.integrity - 1

    if self.integrity == -1 then
        self.enabled = false
    end

    if self.enabled then
        gSounds['brickHit2']:stop()
        gSounds['brickHit2']:play()
    else
        gSounds['brickHit1']:stop()
        gSounds['brickHit1']:play()
    end
end

function Brick:update(dt)
    self.particleSystem:update(dt)
end

function Brick:render()
    if self.enabled then
        love.graphics.draw(gTextures['bricks'], gFrames['bricks'][1 + ((self.material - 1) * 4) + self.integrity], self
            .x,
            self.y)
    end
end

function Brick:renderParticles()
    love.graphics.draw(self.particleSystem, self.x + 16, self.y + 8)
end
