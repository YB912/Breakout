ServeState = Class { __includes = BaseState }

local leftClicked = false
local selected = 0

function ServeState:enter(enteringParams)
    self.paddle = enteringParams.paddle
    self.bricks = enteringParams.bricks
    self.health = enteringParams.health
    self.score = enteringParams.score
    self.highScores = enteringParams.highScores
    self.level = enteringParams.level
    self.ball = Ball(1)

    gSounds['menu']:stop()
    gSounds['game']:play()

    self.paddle:reset()

    love.mouse.setVisible(false)
end

function ServeState:update(dt)
    if not gDialogueBoxEnabled then
        self.paddle:update(dt)
        self.ball.x = self.paddle.x + (self.paddle.width / 2) - self.ball.width / 2
        self.ball.y = self.paddle.y - self.ball.height
        self.health:update(dt)

        if leftClicked or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            leftClicked = false
            gStateMachine:change('play', {
                paddle = self.paddle,
                bricks = self.bricks,
                health = self.health,
                score = self.score,
                highScores = self.highScores,
                ball = self.ball,
                level = self.level
            })
        end

        -- Quitting dialogue box
        if love.keyboard.wasPressed('escape') then
            gSounds['pause']:play()
            gDialogueBoxEnabled = true
            love.mouse.setVisible(true)
        end
    else
        -- Quitting dialogue box
        if love.keyboard.wasPressed('escape') then
            gSounds['pause']:play()
            gDialogueBoxEnabled = false
            love.mouse.setVisible(false)
        end
    end
end

function ServeState:render()
    self.paddle:render()
    self.ball:render()
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    renderLevel(self.level)
    renderScore(self.score)
    self.health:render()

    if not gDialogueBoxEnabled then
        love.graphics.setFont(gFonts['medium'])
        love.graphics.setColor(80 / 255, 120 / 255, 230 / 255, 1)
        love.graphics.printf('Left-click or press enter to begin', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
    else
        renderDialogueBox()
    end
end

-- Event handler for clicking in the play state
function ServeState:onClick(button)
    if button == 1 then
        if not gDialogueBoxEnabled then
            leftClicked = true
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
end
