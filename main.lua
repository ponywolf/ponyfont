-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local ponyfont = require "com.ponywolf.ponyfont"
local options

display.setDefault("background", 0.4,0.4,0.4)

local subGroup = display.newGroup()
local mainGroup = display.newGroup()

mainGroup:insert(subGroup)
mainGroup.xScale, mainGroup.yScale = 0.5, 0.5

options = {
  text = "Hello World, it's nice here. I'd love to stay a while...",     
  x = display.contentCenterX,
  y = display.contentCenterY - 150,
  width = 500,
  font = "fonts/Orienta-Regular.fnt",
  fontSize = 52,
  align = "right",
}

-- Uses pretty much the same options as display.newText
local bmpText = ponyfont.newText(options)

--subGroup:insert(bmpText.raw) -- use the .raw to get to the displaygroup for inserting
--subGroup.xScale = 1.5
--subGroup.yScale = 1.5
--subGroup.x = subGroup.x - 150

-- You can set the properties without calling any update() function
-- uncomment the lines below to see how the text reacts
--bmpText.text = "This is updated text in the same displayObject..."
--bmpText.fontSize = 60
--bmpText.align = "left"


-- Demo looping through each letter
--for i = 1, bmpText.numChildren do
--  transition.from ( bmpText[i], { delay = 1000 + (i*25), time = 250, xScale = 2, yScale = 2, alpha = 0, transition = easing.outBounce })
--end

-- Show what the TTF verison of this text is like will the same options
options = {
  text = "Hello World, it's nice here. I'd love to stay a while...",     
  x = display.contentCenterX,
  y = display.contentCenterY + 150,
  width = 500,
  font = "fonts/Orienta-Regular.ttf", -- this
  fontSize = 52,
  align = "right",
}

local ttfText = display.newText(options)
