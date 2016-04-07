-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local ponyfont = require "com.ponywolf.ponyfont"

display.setDefault("background", 0.4,0.4,0.4)

local options = {
    text = "Hello World, it's nice here. I'd love to stay a while...",     
    x = display.contentCenterX,
    y = display.contentCenterY - 150,
    width = 500,
    font = "fonts/WalterTurncoat.fnt",
    fontSize = 52,
    align = "left",
}

local bmpText = ponyfont.newText(options)

for i = 1, bmpText.numChildren do
  transition.from ( bmpText[i], { delay = 300 + (i*25), time = 250, xScale = 2, yScale = 2, alpha = 0, transition = easing.outBounce })
end

options.font = "fonts/WalterTurncoat.ttf"
options.y = display.contentCenterY + 150

local ttfText = display.newText(options)
