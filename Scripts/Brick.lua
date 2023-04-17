Brick = Class{}

function Brick:init(x, y)
    self.tier = 2
    self.integrity = 1

    self.x = x
    self.y = y
    self.width = 32
    self.height = 16

    self.enabled = true
end

function Brick:hit()
    gSounds['brickHit2']:play()

    self.enabled = false
end

function Brick:render()
    if self.enabled then
        love.graphics.draw(gTextures['bricks'], gFrames['bricks'][1 + ((self.tier - 1) * 4) + self.integrity], self.x, self.y)
    end
end