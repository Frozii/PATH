local player = {}


-- loads player related things
function player:load()
	player.x = 1
	player.y = 448
	player.width = 32
	player.height = 32
	player.xVel = 0
	player.yVel = 0
	player_damaged = false
	player_damaged_state = 0
	player_damaged_timer = 0
	player_opacity = 255
	player_image = love.graphics.newImage('Assets/Images/PlayerSpritesheet.png')
	player_quads = {}
	player_animation_timer = 0
	player_breathing_timer = 0
	current_player_quad = 0
	scroll_factor = 0
	is_jumping = false
	jump_extension_timer = 0

	for x = 1, 6 do
		player_quads[x] = love.graphics.newQuad((x - 1) * 32, 0, 32, 32, 192, 32)
	end
end

-- draws the player
function player:draw_player()
	love.graphics.push()
	love.graphics.translate(-scroll_factor, 0)

	love.graphics.setColor(255, 255, 255, player_opacity)

	if not love.keyboard.isDown('left') then
		love.graphics.draw(player_image, player_quads[current_player_quad], player.x, player.y)
	end

	if love.keyboard.isDown('left') then
		love.graphics.draw(player_image, player_quads[current_player_quad], player.x, player.y, 0, -1, 1, 32)
	end

	love.graphics.pop()
end

-- move the player depending on the key pressed, draws the correct quad of the player
function player:movement(dt)	
	player_breathing_timer = player_breathing_timer + dt

	if player.yVel ~= 0 then
		is_jumping = true
	else
		is_jumping = false
		jump_extension_timer = 0
	end

	if is_jumping == true then
			current_player_quad = 3
	end

	if love.keyboard.isDown('right') and
		is_jumping == true then

		current_player_quad = 3
	end

	if love.keyboard.isDown('left') and
		is_jumping == true then

		current_player_quad = 3
	end

	if not love.keyboard.isDown('right') and
		not love.keyboard.isDown('left') and
		not love.keyboard.isDown('space') and
		is_jumping == false then

		if player_breathing_timer < 0.6 then
			current_player_quad = 2
		end

		if player_breathing_timer > 0.6 then
			current_player_quad = 1
		end

		if player_breathing_timer > 1.2 then
			player_breathing_timer = 0
		end
	
	else

		player_breathing_timer = 0
	end


	if love.keyboard.isDown('right') and
		love.keyboard.isDown('left') then

		stay_still = true
		current_player_quad = 2

	else

		stay_still = false
	end

	if player.x < 1 then
		current_player_quad = 2
		player_animation_timer = 0
	end

	if love.keyboard.isDown('right') then

		player.x = player.x + 175 * dt

		if is_jumping == false then
			player_animation_timer = player_animation_timer + dt

			if stay_still == false then
				if player_animation_timer > .150 then
					player_animation_timer = 0
					current_player_quad = current_player_quad + 1
				end

				if current_player_quad > 6 then
					current_player_quad = 3
				end
			end
		end
	end

	if love.keyboard.isDown('left') then

		if player.x > 1 then

			player.x = player.x - 175 * dt

			if is_jumping == false then
				player_animation_timer = player_animation_timer + dt

				if stay_still == false then
					if player_animation_timer > .150 then
						player_animation_timer = 0
						current_player_quad = current_player_quad + 1
					end

					if current_player_quad > 6 then
						current_player_quad = 3
					end
				end
			end
		end
	end

	if love.keyboard.isDown('space') and 
		is_jumping == true then	
	
		jump_extension_timer = jump_extension_timer + dt

		if jump_extension_timer < 0.5 then
			player.yVel = player.yVel - 500 * dt
		end
	end

	player.yVel = player.yVel + 400 * dt

-- sets the amount of how much everything on the screen will move after the player passes a certain point
	if player.x > 400 then
		scroll_factor = player.x - 400
	end
	
end

function player:player_death()
	if player_health == 0 then
		game_state = 'Level_1_Complete'
	end
end

function player:player_damaged(dt)
	if player_damaged == true then
		if player_damaged_state == 0 then
			if player_opacity > 0 then
			   	player_opacity = player_opacity - 800 * dt
			end

			if player_opacity < 1 then
			   	player_damaged_state = 1
			end
		end

		if player_damaged_state == 1 then
			if player_opacity < 255 then
			   	player_opacity = player_opacity + 800 * dt
			end
					
			if player_opacity > 254 then
			   	player_damaged_state = 0
			end
		end

		player_damaged_timer = player_damaged_timer + 100 * dt

		if player_damaged_timer > 50 then
			player_damaged = false
			player_opacity = 255
			player_damaged_timer = 0
		end
	end
end

-- decides what happens when the player falls
function player:react_to_fall()
	if player.y > 600 then
		player.y = 448
		player.x = player.x - 150
	end
end

-- checks the collision between the given parameters
function player:calculate_collision(v1, v2)
	if aabb(v1.x, v1.y, v1.width, v1.height, v2.x, v2.y, v2.width, v2.height) then
		if (v1.x + v1.width > v2.x or v1.x < v2.x + v2.width) and (v1.y + v1.height > v2.y and v1.y + v1.height < v2.y + v2.height / 2) and v1.yVel > 0 then
			v1.yVel = 0
			v1.y = v2.y - v1.height -- bottom collision

		elseif (v1.x + v1.width > v2.x + 5 and v1.x < v2.x + v2.width - 5) and (v1.y < v2.y + v2.height and v1.y > v2.y + v2.height / 2) then
			v1.yVel = 100
			v1.y = v2.y + v2.height -- top collision

		elseif (v1.y + v1.height > v2.y or v1.y < v2.y + v2.height) and (v1.x + v1.width > v2.x and v1.x + v1.width < v2.x + v2.width / 2) then
			v1.xVel = 0
			v1.x = v2.x - v1.width -- right collision

		elseif (v1.y + v1.height > v2.y or v1.y < v2.y + v2.height) and (v1.x < v2.x + v2.width and v1.x > v2.x + v2.width / 2) then
			v1.xVel = 0
			v1.x = v2.x + v2.width -- left collision
		end
	end
end

return player
