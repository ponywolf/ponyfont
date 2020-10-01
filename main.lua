-- Demo project for ponyfont...

local ponyfont = require "com.ponywolf.ponyfont"
local options

display.setDefault("background", 0.4,0.4,0.4)

local subGroup = display.newGroup()

options = {
  text = "Hello World, it's nice here. I'd love to stay a while...",
  x = display.contentCenterX,
  y = display.contentCenterY - 150,
  width = 400,
  font = "fonts/Orienta-Regular.fnt",
  fontSize = 52,
  align = "right",
}

-- Uses pretty much the same options as display.newText
local bmpText = ponyfont.newText(options)

subGroup:insert(bmpText.raw) -- use the .raw to get to the displaygroup for inserting


-- You can set the properties without calling any update() function
-- uncomment the lines below to see how the text reacts.
-- You need to comment out the demo loop to keep them for fighting for updates

--bmpText.text = "This is updated text in the same displayObject..."
--bmpText.fontSize = 60
--bmpText.align = "left"

-- Demo looping through each letter w/ pause on "," and "."
local delay = 100
for i = 1, bmpText.numChildren do
  local extraDelay = (bmpText[i].chr == "," or bmpText[i].chr == ".")
  delay = delay + 25
  transition.from ( bmpText[i], { delay = delay, time = 250, xScale = 2, yScale = 2, alpha = 0, transition = easing.outBounce })
  delay = delay + (extraDelay and 1000 or 0)
end

-- Show what the TTF verison of this text is like will the same options
options = {
  text = "Hello World, it's nice here. I'd love to stay a while...",
  x = display.contentCenterX,
  y = display.contentCenterY + 150,
  width = 400,
  font = "fonts/Orienta-Regular.ttf", -- this
  fontSize = 52,
  align = "right",
}

local ttfText = display.newText(options)
