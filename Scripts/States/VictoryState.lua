VictoryState = Class { __includes = BaseState }

local leftClicked = false

function VictoryState:enter(enteringParams)
    self.level = enteringParams.level
    self.score = enteringParams.score + VICTORY_SCORE
    self.paddle = enteringParams.paddle
    self.health = enteringParams.health
    self.ball = enteringParams.ball

    self.paddle.size = 2
end

function VictoryState:update(dt)
    if not gDialogueBoxEnabled then
        self.paddle:update(dt)

        self.ball.x = self.paddle.x + (self.paddle.width / 2) - self.ball.width / 2
        self.ball.y = self.paddle.y - self.ball.height

        if leftClicked or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            gStateMachine:change('serve', {
                level = self.level + 1,
                bricks = LevelMaker.createMap(self.level + 1),
                paddle = self.paddle,
                health = self.health,
                score = self.score
            })
        elseif love.keyboard.wasPressed('escape') then
            gSounds['pause']:play()
            gDialogueBoxEnabled = true
            love.mouse.setVisible(true)
        end
    else
        if love.keyboard.wasPressed('escape') then
            gSounds['pause']:play()
            gDialogueBoxEnabled = false
            love.mouse.setVisible(false)
        end
    end

    leftClicked = false
end

function VictoryState:render()
    self.paddle:render()
    self.ball:render()

    renderLevel(self.level)
    renderScore(self.score)
    self.health:render()

    if not gDialogueBoxEnabled then
        love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(80 / 255, 120 / 255, 230 / 255, 1)
    love.graphics.printf("Level " .. tostring(self.level) .. " complete!",
        0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Left-click or press enter to proceed', 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')
    else
        renderDialogueBox()
    end
end

function VictoryState:onClick(button)
    if not gDialogueBoxEnabled then
        if button == 1 then
            leftClicked = true
        end
    else
        gDialogueBoxEnabled = false
        if gDialogueBoxSelection == 1 then
            gStateMachine:change('start', {
                highScores = loadHighScores()
            })
        elseif gDialogueBoxSelection == 2 then
            gSounds['pause']:play()
            love.mouse.setVisible(false)
        end
    end
end
