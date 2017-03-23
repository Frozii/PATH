
local popuptext = {}

-- enters the given values into a table
function popuptext:spawn_popuptext(x, y, str)
	table.insert(popuptext, {x = x, y = y, str = str, a = 255})
end

-- moves and fades the text, when the text is translucent we remove it
function popuptext:update_popuptext(dt)
	for i,v in ipairs(popuptext) do
		v.y = v.y - 10 * dt
		v.a = v.a - 100 * dt

		if v.a < 1 then
			table.remove(popuptext, i)
		end
	end
end

-- draws the popuptext
function popuptext:draw_popuptext()
	for i,v in ipairs(popuptext) do
		love.graphics.push()
		love.graphics.translate(-scroll_factor, 0)

		love.graphics.setColor(255, 255, 255, v.a)
		love.graphics.setFont(font3)
		love.graphics.print(v.str, v.x, v.y)

		love.graphics.pop()
	end
end

return popuptext