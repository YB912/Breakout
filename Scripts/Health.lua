Health = Class {}

function Health:init()
    self.count = 3
    self.particleSystem = love.graphics.newParticleSystem(gTextures['particle'], 50)
    self.particleSystem:setParticleLifetime(0.5, 1)
    self.particleSystem:setLinearAcceleration(-10, 0, 10, 50)
    self.particleSystem:setEmissionArea('ellipse', 10, 8)
    self.particleSystem:setColors(130 / 255, 20 / 255, 15 / 255, 1, 50 / 255, 10 / 255, 5 / 255, 0)
end

function Health:lose()
    self.count = self.count - 1
    self.particleSystem:emit(50)
end

function Health:update(dt)
    self.particleSystem:update(dt)
end

function Health:render()
    love.graphics.setColor(1, 1, 1, 1)
    local healthX = VIRTUAL_WIDTH / 2 - 28
    for i = 1, self.count do
        love.graphics.draw(gTextures['heart'], healthX, 6)
        healthX = healthX + 20
    end
    if self.count == 0 then
        love.graphics.draw(self.particleSystem, VIRTUAL_WIDTH / 2 - 20, 12)
    elseif self.count == 1 then
        love.graphics.draw(self.particleSystem, VIRTUAL_WIDTH / 2 , 12)
    elseif self.count == 2 then
        love.graphics.draw(self.particleSystem, VIRTUAL_WIDTH / 2 + 20, 12)
    end
end
