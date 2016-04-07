-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local ponyfont = require "com.ponywolf.ponyfont"
local options

display.setDefault("background", 0.4,0.4,0.4)

options = {
  text = "Hello World, it's nice here. I'd love to stay a while...",     
  x = display.contentCenterX,
  y = display.contentCenterY - 150,
  width = 500,
  font = "fonts/Orienta-Regular.fnt",
  fontSize = 52,
  align = "left",
}

-- Uses pretty much the same options as display.newText
local bmpText = ponyfont.newText(options)

-- You can set the properties without calling any update() function
-- uncomment the lines below to see how the text reacts
--bmpText.text = "This is updated text in the same displayOject..."
--bmpText.fontSize = 60
--bmpText.align = "right"

-- Demo looping through each letter
for i = 1, bmpText.numChildren do
  transition.from ( bmpText[i], { delay = 1000 + (i*25), time = 250, xScale = 2, yScale = 2, alpha = 0, transition = easing.outBounce })
end

-- Show what the TTF verison of this text is like will the same options
options = {
  text = "Hello World, it's nice here. I'd love to stay a while...",     
  x = display.contentCenterX,
  y = display.contentCenterY + 150,
  width = 500,
  font = "fonts/Orienta-Regular.ttf", -- this
  fontSize = 52,
  align = "left",
}

local ttfText = display.newText(options)
