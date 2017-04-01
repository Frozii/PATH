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
	player_death = false
	player_flip = false
	player_flip_timer = 0
	player_opacity = 255
	player_image = love.graphics.newImage('Assets/Images/PlayerSpritesheet.png')
	player_quads = {}
	player_animation_timer = 0
	player_breathing_timer = 0
	current_player_quad = 0
	scroll_factor = 0
	is_jumping = false
	jump_extension_timer = 0
	jump_extension_max = false

	for x = 1, 7 do
		player_quads[x] = love.graphics.newQuad((x - 1) * 32, 0, 32, 32, 224, 32)
	end
end

-- draws the player
function player:draw_player()
	love.graphics.push()
	love.graphics.translate(-scroll_factor, 0)

	love.graphics.setColor(255, 255, 255, player_opacity)

	if not love.keyboard.isDown('left') and
			player_death == false then
				love.graphics.draw(player_image, player_quads[current_player_quad], player.x, player.y)
	end

	if love.keyboard.isDown('left') and
			player_death == false then
				love.graphics.draw(player_image, player_quads[current_player_quad], player.x, player.y, 0, -1, 1, 32)
	end

	if player_death == true then
		love.graphics.draw(player_image, player_quads[7], player.x, player.y, 0, 1, -1, 0, 32)
	end

	love.graphics.pop()
end

-- move the player depending on the key pressed, draws the correct quad of the player
function player:movement(dt)
	if player_death == false then

		player_breathing_timer = player_breathing_timer + dt

		if player.yVel ~= 0 then
			is_jumping = true
		else
			is_jumping = false
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

		if love.keyboard.isDown('space') and
			is_jumping == false then

			current_player_quad = 2
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

		if is_jumping == false and
			not love.keyboard.isDown('space') then
			jump_extension_max = false
			jump_extension_timer = 0
		end

		if is_jumping == true and
			not love.keyboard.isDown('space') then
			jump_extension_max = true
			jump_extension_timer = 0.4
		end

		if is_jumping == true and
			love.keyboard.isDown('space') then

			if jump_extension_max == false then
				jump_extension_timer = jump_extension_timer + dt

				if jump_extension_timer < 0.3 then
					player.yVel = player.yVel - 800 * dt
				end
			end
		end

		player.yVel = player.yVel + 500 * dt

-- sets the amount of how much everything on the screen will move after the player passes a certain point
		if player.x > 400 then
			scroll_factor = player.x - 400
		end
	end
end

-- executes when the player dies
function player:player_death(dt)
	if player_health == 0 then
		player_death = true
	end

	if player_death == true then
		player_flip_timer = player_flip_timer + dt

		if player_flip == false then
			player.y = player.y - 100 * dt
		end
	end

	if player_flip_timer > 0.5 then
		player_flip = true
		player.y = player.y + 200 * dt
	end
end

-- the response from the player to taking damage
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
	if player.y > 600 and
		player_death == false then
			player.y = 448
			player.x = player.x - 150
			player_health = player_health - 1
			player:player_hurt_audio()
			player_damaged = true
	end

	if player.y > 600 and
		player_death == true then
			love.event.quit()
	end
end

-- plays when the player gets hurt
function player:player_hurt_audio()
	local full = true

		for i=1, #player_hurt_audio do
			if not player_hurt_audio[i]:isPlaying() then
				full = false
				player_hurt_audio[i]:play()
			break
			end
		end

		if full then
			player_hurt_audio[#player_hurt_audio+1] = player_hurt_audio[1]:clone()
			player_hurt_audio[#player_hurt_audio]:play()
		end
end

-- checks the collision between the given parameters
function player:calculate_collision(v1, v2)
	if aabb(v1.x, v1.y, v1.width, v1.height, v2.x, v2.y, v2.width, v2.height) and player_death == false then
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
