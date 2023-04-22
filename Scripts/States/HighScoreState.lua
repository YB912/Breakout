HighScoreState = Class { __includes = BaseState }

local goBack = false

function HighScoreState:enter(enteringParams)
    self.highScores = enteringParams.highScores
end

function HighScoreState:update(dt)
    if love.keyboard.wasPressed('escape') then
        goBack = true
    end

    if goBack then
        goBack = false
        gSounds['wallHit']:play()
        gStateMachine:change('start', {
            highScores = self.highScores
        })
    end
end

function HighScoreState:render()
    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(80 / 255, 120 / 255, 230 / 255, 1)
    love.graphics.printf('High Scores', 0, 30, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['scores'])
    love.graphics.setColor(20 / 255, 20 / 255, 20 / 255, 1)

    for i = 1, 10 do
        local name = self.highScores[i].name or '---'
        local score = self.highScores[i].score or '---'

        love.graphics.printf(tostring(i) .. '.', VIRTUAL_WIDTH / 3,
            90 + i * 20, 60, 'left')

        love.graphics.printf(name, VIRTUAL_WIDTH / 3 + 38,
            90 + i * 20, 70, 'right')

        love.graphics.printf(tostring(score), VIRTUAL_WIDTH / 2,
            90 + i * 20, 100, 'right')
    end

    love.graphics.printf("Press 'Escape' or click to return to the main menu",
        0, VIRTUAL_HEIGHT - 40, VIRTUAL_WIDTH, 'center')
end

-- Event handler for clicking in the play state
function HighScoreState:onClick(button)
    goBack = true
end
