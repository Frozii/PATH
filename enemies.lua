local enemies = {}

-- loads enemy related things
function enemies:load()
	enemy_quads = {}
	enemy_image = love.graphics.newImage('Assets/Images/SlimeSpritesheet.png')
	enemy_animation_timer = 0

	for x = 1, 5 do
		enemy_quads[x] = love.graphics.newQuad((x - 1) * 32, 0, 32, 32, 160, 32)
	end
end

-- enters the given values into a table
function enemies:spawn_enemy(x, y)
	table.insert(enemies, {x = x, y = y, enemy_width = 32, enemy_height = 32, enemy_going_left = true, enemy_going_right = false, enemy_animation_timer = 0, current_enemy_quad = 1, rectangle_x = x - 32, rectangle_y = y, rectangle_width = 32, rectangle_height = 32, rectangle_yVel = 0, fall_sensing = 0, killed = false})
end

-- draws the enemies
function enemies:draw_enemy()
	for i,v in ipairs(enemies) do
		love.graphics.push()
		love.graphics.translate(-scroll_factor, 0)

		love.graphics.setColor(255, 255, 255, 255)

		if v.enemy_going_left == true then
			love.graphics.draw(enemy_image, enemy_quads[v.current_enemy_quad], v.x, v.y, 0, -1, 1, 32)
			love.graphics.setColor(0, 0, 0, 0)
			love.graphics.rectangle('fill', v.rectangle_x, v.rectangle_y, v.rectangle_width, v.rectangle_height)
		end

		if v.enemy_going_right == true then
			love.graphics.draw(enemy_image, enemy_quads[v.current_enemy_quad], v.x, v.y)
			love.graphics.setColor(0, 0, 0, 0)
			love.graphics.rectangle('fill', v.rectangle_x, v.rectangle_y, v.rectangle_width, v.rectangle_height)
		end
		
		love.graphics.pop()
	end
end

-- checks the collision between enemies and the player
function enemies:collision_to_player(player, popuptext)
	for i,v in ipairs(enemies) do
		if aabb(v.x + 10, v.y + 10, v.enemy_width - 10, v.enemy_height - 10, player.x, player.y, player.width, player.height) and
			player.yVel > 10 then
					v.killed = true
					popuptext:spawn_popuptext(v.x, v.y - 20, '100')
					enemy_hurt_audio:play()
					player_score = player_score + 100
					player.yVel = 0
					player.yVel = player.yVel - 125
					table.remove(enemies, i)
		end

		if aabb(v.x + 10, v.y + 20, v.enemy_width - 10, v.enemy_height - 10, player.x, player.y, player.width, player.height) and
			player_damaged == false then
					player_health = player_health - 1
					player_hurt_audio:play()
					player_damaged = true
		end
	end
end

-- moves the enemies
function enemies:move_enemy(dt)
	for i,v in ipairs(enemies) do
		if v.killed == true then
			v.x = v.x
			v.y = v.y

		else

		if v.enemy_going_left == true then
			v.rectangle_x = v.x - 32
			v.rectangle_y = v.y + 1
		end

		if v.enemy_going_right == true then
			v.rectangle_x = v.x + v.enemy_width
			v.rectangle_y = v.y + 1
		end

		if v.enemy_going_left == true then
			v.x = v.x - 125 * dt

			v.enemy_animation_timer = v.enemy_animation_timer + dt

			if v.enemy_animation_timer > .200 then
				v.enemy_animation_timer = 0
				v.current_enemy_quad = v.current_enemy_quad + 1	
			end

			if v.current_enemy_quad > 5 then
				v.current_enemy_quad = 1
			end
		end

		if v.enemy_going_right == true then
			v.x = v.x + 125 * dt

			v.enemy_animation_timer = v.enemy_animation_timer + dt

			if v.enemy_animation_timer > .200 then
				v.enemy_animation_timer = 0
				v.current_enemy_quad = v.current_enemy_quad + 1
			end

			if v.current_enemy_quad > 5 then
				v.current_enemy_quad = 1
			end
		end
		end
	end
end

-- calculates collision
function enemies:calculate_collision(v2)
	for i,v in ipairs(enemies) do
		if aabb(v.x, v.y, v.enemy_width, v.enemy_height, v2.x, v2.y, v2.width, v2.height) then
			if (v.x + v.enemy_width > v2.x or v.x < v2.x + v2.width) and (v.y + v.enemy_height > v2.y and v.y + v.enemy_height < v2.y + v2.height / 2) then
				v.y = v2.y - v.enemy_height -- bottom collision

			elseif (v.y + v.enemy_height > v2.y or v.y < v2.y + v2.height) and (v.x + v.enemy_width > v2.x and v.x + v.enemy_width < v2.x + v2.width / 2) then
				v.x = v2.x - v.enemy_width
				v.enemy_going_right = false
				v.enemy_going_left = true -- right collision

			elseif (v.y + v.enemy_height > v2.y or v.y < v2.y + v2.height) and (v.x < v2.x + v2.width and v.x > v2.x + v2.width / 2) then
				v.x = v2.x + v2.width
				v.enemy_going_left = false
				v.enemy_going_right = true -- left collision
			end
		end
	end
end

-- relates to the enemy patrolling
function enemies:calculate_turn(v2)
	for i,v in ipairs(enemies) do
		if aabb(v.rectangle_x, v.rectangle_y, v.rectangle_width, v.rectangle_height, v2.x, v2.y, v2.width, v2.height) then
			if (v.rectangle_x + v.rectangle_width > v2.x or v.rectangle_x < v2.x + v2.width) and (v.rectangle_y + v.rectangle_height > v2.y and v.rectangle_y + v.rectangle_height < v2.y + v2.height / 2) then
				v.fall_sensing = 0 -- bottom collision
			end
		end
	end
end

return enemies