local score_and_lives = {}

-- load score related things
function score_and_lives:load()
	coin_quads = {}
	coin_image = love.graphics.newImage('Assets/Images/CoinSpritesheet.png')
	coin_animation_timer = 0
	coin_stay_still_timer = 0
	current_coin_quad = 1
	player_score = 0
	player_health = 3

	font2 = love.graphics.newFont('Assets/Fonts/ArcadeClassic.ttf', 42)
	font3 = love.graphics.newFont('Assets/Fonts/ArcadeClassic.ttf', 16)

	for x = 1, 5 do
		coin_quads[x] = love.graphics.newQuad((x - 1) * 16, 0, 16, 16, 64, 16)
	end
end

-- enters the given values into a table
function score_and_lives:spawn_coin(x, y)
	table.insert(score_and_lives, {x = x, y = y, coin_width = 16, coin_height = 16})
end

-- everytime a certain amount of time passes we change the current picture of the coin
function score_and_lives:update_coin(dt)
	coin_animation_timer = coin_animation_timer + dt

	if current_coin_quad == 1 then
		coin_stay_still_timer = coin_stay_still_timer + dt
		coin_animation_timer = 0

		if coin_stay_still_timer > 1 then
			current_coin_quad = 2
			coin_stay_still_timer = 0
		end
	end

	if coin_animation_timer > .200 then
		coin_animation_timer = 0
		current_coin_quad = current_coin_quad + 1
	end

	if current_coin_quad > 4 then
		current_coin_quad = 1
	end
end

-- checks collision between coins and the player
function score_and_lives:coin_to_player_collision(player, popuptext)
	for i,v in ipairs(score_and_lives) do
		if aabb(v.x, v.y, v.coin_width, v.coin_height, player.x + 5, player.y + 5, player.height - 5, player.width - 5) then
				popuptext:spawn_popuptext(v.x, v.y - 20, '50')
				coin_audio:play()
				player_score = player_score + 50
				table.remove(score_and_lives, i)
		end

	end
end

-- draw the coins
function score_and_lives:draw_coin()
	for i,v in ipairs(score_and_lives) do
		love.graphics.push()
		love.graphics.translate(-scroll_factor, 0)	

		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.draw(coin_image, coin_quads[current_coin_quad], v.x, v.y)

		love.graphics.pop()
	end
end

-- draw the player score and lives on the screen
function score_and_lives:draw_score_and_lives()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setFont(font2)
	love.graphics.print('SCORE   '..player_score, 20, 15)

	love.graphics.print('LIVES   '..player_health, 620, 15)
end

return score_and_lives
