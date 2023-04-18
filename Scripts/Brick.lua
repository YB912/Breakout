Brick = Class {}

function Brick:init(x, y)
    self.material = 0
    self.integrity = 3

    self.x = x
    self.y = y
    self.width = 32
    self.height = 16

    self.enabled = true
end

function Brick:hit()
    gSounds['brickHit2']:play()

    self.integrity = self.integrity - 1

    if self.integrity == -1 then
    self.enabled = false
    end
end

function Brick:render()
    if self.enabled then
        love.graphics.draw(gTextures['bricks'], gFrames['bricks'][1 + ((self.material - 1) * 4) + self.integrity], self.x,
        self.y)
    end
end
