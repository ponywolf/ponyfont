-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

bmpFont = require "com.ponywolf.ponyfont"

display.setDefault("background", 0.4,0.4,0.4)

local options = {
    text = "Hello World, it's nice here.",     
    x = display.contentCenterX,
    y = display.contentCenterY,
    width = display.contentCenterX,
    font = "fonts/WalterTurncoat.fnt",
    fontSize = 48,
    align = "left",
}

local bmpText = bmpFont.newText(options)

--bmpText.text = "Updated text"

options.font = "fonts/WalterTurncoat.ttf"
local ttfText = display.newText(options)
ttfText.alpha = 0.5