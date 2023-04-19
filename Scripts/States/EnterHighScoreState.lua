EnterHighScoreState = Class { __includes = BaseState }

local characters = {
    [1] = 65,
    [2] = 65,
    [3] = 65
}

local highlightedChar = 1

function EnterHighScoreState:enter(enteringParams)
    self.highScores = enteringParams.highScores
    self.score = enteringParams.score
    self.scoreIndex = enteringParams.scoreIndex
end

function EnterHighScoreState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        local name = string.char(characters[1]) .. string.char(characters[2]) .. string.char(characters[3])

        for i = 10, self.scoreIndex, -1 do
            self.highScores[i + 1] = {
                name = self.highScores[i].name,
                score = self.highScores[i].score
            }
        end

        self.highScores[self.scoreIndex].name = name
        self.highScores[self.scoreIndex].score = self.score

        local scoresStr = ''

        for i = 1, 10 do
            scoresStr = scoresStr .. self.highScores[i].name .. '\n'
            scoresStr = scoresStr .. tostring(self.highScores[i].score) .. '\n'
        end

        love.filesystem.write('breakoutY.lst', scoresStr)

        gStateMachine:change('highScore', {
            highScores = self.highScores
        })
    end

    if love.keyboard.wasPressed('left') and highlightedChar > 1 then
        highlightedChar = highlightedChar - 1
        gSounds['select']:play()
    elseif love.keyboard.wasPressed('right') and highlightedChar < 3 then
        highlightedChar = highlightedChar + 1
        gSounds['select']:play()
    end

    if love.keyboard.wasPressed('up') then
        characters[highlightedChar] = characters[highlightedChar] + 1
        if characters[highlightedChar] > 90 then
            characters[highlightedChar] = 65
        end
    elseif love.keyboard.wasPressed('down') then
        characters[highlightedChar] = characters[highlightedChar] - 1
        if characters[highlightedChar] < 65 then
            characters[highlightedChar] = 90
        end
    end
end

function EnterHighScoreState:render()
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Your score: ' .. tostring(self.score), 0, 30,
        VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['large'])
    
    if highlightedChar == 1 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.print(string.char(characters[1]), VIRTUAL_WIDTH / 2 - 60, VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(1, 1, 1, 1)

    if highlightedChar == 2 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.print(string.char(characters[2]), VIRTUAL_WIDTH / 2 - 20 , VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(1, 1, 1, 1)

    if highlightedChar == 3 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.print(string.char(characters[3]), VIRTUAL_WIDTH / 2 + 20, VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(1, 1, 1, 1)
    
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Press Enter to confirm', 0, VIRTUAL_HEIGHT - 18,
        VIRTUAL_WIDTH, 'center')
end

