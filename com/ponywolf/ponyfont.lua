-- ponyfont 0.1

-- A bitmap font loader/render for CoronaSDK

local M = {}
M.cache = {} -- cache for loaded fonts

-- property update events by Jonathan Beebe
-- https://coronalabs.com/blog/2012/05/01/tutorial-property-callbacks/

local function addPropertyUpdate( obj )
  local t = {}
  t.raw = obj

  local mt = {
    __index = function(tb,k)
      if k == "raw" then
        return rawget( t, "raw" )
      end

      -- pass method and property requests to the display object
      if type(obj[k]) == 'function' then
        return function(...) arg[1] = obj; obj[k](unpack(arg)) end
      else
        return obj[k]
      end
    end,

    __newindex = function(tb,k,v)
      -- dispatch event before property update
      local event = {
        name = "propertyUpdate",
        target=tb,
        key=k,
        value=v
      }
      obj:dispatchEvent( event )

      -- update the property on the display object
      obj[k] = v
    end
  }
  setmetatable( t, mt )
  return t
end

local function parseFilename(filename)
  return string.match(filename,"(.-)([^\\/]-%.?([^%.\\/]*))$")
end

local function extract(s, p)
  return string.match(s, p), string.gsub(s, p, '', 1)
end

function M.newText(options)
  options = options or {}

  -- Modified .fnt loading code from bmf.lua
  -- Contacted author and he released under CC0

  local function loadFont(name)

    -- load the fnt
    local path, filename, ext = parseFilename(name)
    local font = { info = {}, spritesheets = {}, sprites = {}, chars = {}, kernings = {} }
    local contents = io.lines(system.pathForFile(path .. filename, system.ResourceDirectory))
    for line in contents do
      local t = {}
      local tag
      tag, line = extract(line, '^%s*([%a_]+)%s*')
      while string.len(line) > 0 do
        local k, v
        k, line = extract(line, '^([%a_]+)=')
        if not k then break end
        v, line = extract(line, '^"([^"]*)"%s*')
        if not v then
          v, line = extract(line, '^([^%s]*)%s*')
        end
        if not v then break end
        t[k] = v
      end
      if tag == 'info' or tag == 'common' then
        for k, v in pairs(t) do font.info[k] = v end
      elseif tag == 'page' then
        font.spritesheets[1 + t.id] = { file = t.file, frames = {} }
      elseif tag == 'char' then
        t.letter = string.char(t.id)
        font.chars[t.letter] = {}
        for k, v in pairs(t) do font.chars[t.letter][k] = v end
        if 0 + font.chars[t.letter].width > 0 and 0 + font.chars[t.letter].height > 0 then
          font.spritesheets[1 + t.page].frames[#font.spritesheets[1 + t.page].frames + 1] = {
            x = 0 + t.x,
            y = 0 + t.y,
            width = 0 + t.width,
            height = 0 + t.height,
          }
          font.sprites[t.letter] = {
            spritesheet = 1 + t.page,
            frame = #font.spritesheets[1 + t.page].frames
          }
        end
      elseif tag == 'kerning' then
        font.kernings[string.char(t.first) .. string.char(t.second)] = 0 + t.amount
      end
    end
    for k, v in pairs(font.spritesheets) do
      font.spritesheets[k].sheet = graphics.newImageSheet(path .. v.file, v)
    end
    for k, v in pairs(font.sprites) do
      font.sprites[k].frame = v.frame
    end
    return font
  end

  -- create displayGroup instance
  local instance = display.newGroup()

  -- load font if not in cache
  local fontFile = options.font or "default"
  if not M.cache[fontFile] then
    M.cache[fontFile] = loadFont(fontFile)
  end  
  instance.bitmapFont = M.cache[fontFile]

  function instance:render()
    local text = self.text
    local font = self.bitmapFont
    local info = font.info
    local scale = self.fontSize / info.size

    -- clear previous text
    for i = self.numChildren, 1, -1 do display.remove(self[i]) end

    -- locals
    local x, y = 0, 0
    local last = '', 0, 0
    local lastWord, lastX = 0, 0

    if text then
      for chr in string.gmatch(text..'\n', '(.)') do
        if chr == '\n' then -- newline
          x = 0; y = y + info.lineHeight
        elseif font.chars[chr] then
          if tonumber(font.chars[chr].width) > 0 and tonumber(font.chars[chr].height) > 0 then
            local glyph = display.newImage(font.spritesheets[font.sprites[chr].spritesheet].sheet, font.sprites[chr].frame)
            glyph.anchorX, glyph.anchorY = 0, 0
            if font.kernings[last .. chr] then
              x = x + font.kernings[last .. chr]
            end
            glyph.x = scale * (font.chars[chr].xoffset + x)
            glyph.y = scale * (font.chars[chr].yoffset + y)
            glyph.xScale = scale
            glyph.yScale = scale
            glyph._x = glyph.x - self.x -- orginal offset from self's x
            glyph._y = glyph.y - self.y -- orginal offset from self's y 
            self:insert(glyph)
            last = chr
            lastWord = lastWord + 1
          elseif chr==' ' then
            lastWord = 0 -- save x of last word
            lastX = x
          end
          x = x + font.chars[chr].xadvance
--          if self.maxWidth and x > self.maxWidth then
--            x = 0; y = y + info.lineHeight
--            for i = self.numChildren - lastWord, self.numChildren do
--              self[i].x, self[i].y = x, y
--              self[i]._x = self[i].x - self.x -- orginal offset from self's x
--              self[i]._y = self[i].y - self.y -- orginal offset from self's y 
--            end
--          end
        end
      end
    end
  end

  function instance:anchor(x,y)
    local w,h = self.contentWidth, self.contentHeight
    x,y = x or self.anchorX or 0.5, y or self.anchorY or 0.5
    for i = self.numChildren, 1, -1 do
      self[i].x = self.x + self[i]._x
      self[i].y = self.y + self[i]._y
      self[i].x = self[i].x - w * x
      self[i].y = self[i].y - h * y
    end
    self.anchorX, self.anchorY = x,y
  end

--  function instance:realign()
--    local groupRight = self.contentBounds.xMax
--    local right = instance[i].contentBounds.xMax
--    local groupLeft = self.contentBounds.xMax
--    local left = instance[i].contentBounds.xMax
--    local diff
--    if self.align == "right" then
--      diff = groupRight - right
--    elseif self.align == "center" then
--      diff = 0.5 * (groupRight - right)
--    end 
--    for i = instance.numChildren, 1, -1 do
--      self[i].x = self.x + self[i]._x
--      self[i].y = self.y + self[i]._y
--      self[i].x = self[i].x + diff      
--    end
--  end

  instance = addPropertyUpdate(instance)
  function instance:propertyUpdate( event )
    if event.key == "text" then
      self.text = event.value
      self:render()
      self:anchor()
    elseif event.key == "anchorX" then
      self.anchorX = event.value
      self:anchor()
    elseif event.key == "anchorY" then
      self.anchorY = event.value
      self:anchor()
--    elseif event.key == "align" then
--      self.align = event.value
--      self:realign()
    end
  end

  function instance:finalize(event)
    self:removeEventListener("propertyUpdate")
  end

-- set options
  instance.align = options.align or "left"
  instance.fontSize = options.fontSize or 24
  instance.x = options.x or 0
  instance.y = options.y or 0
  instance.maxWidth = options.width
  instance.text = options.text
  instance:render()
  instance:anchor()

  instance:addEventListener( "propertyUpdate" )
  instance:addEventListener( "finalize" )
  return instance

end

return M