StateMachine = Class {}

function StateMachine:init(states)
    self.empty = {
        render = function()
        end,
        update = function()
        end,
        enter = function()
        end,
        exit = function()
        end
    }
    self.states = states or {}
    self.current = self.empty
end

function StateMachine:change(stateName, enteringParams)
    assert(self.states[stateName])
    gCurrentState = stateName
    self.current:exit()
    love.mouse.setCursor(love.mouse.getSystemCursor('arrow'))
    self.current = self.states[stateName]()
    self.current:enter(enteringParams)
end

function StateMachine:update(dt)
    self.current:update(dt)
end

function StateMachine:render()
    self.current:render()
end
