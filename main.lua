--[[
	Author: Rami Reini
	Description: A 2D platformer with one level, enemies and coins.
	All pixel art was made by me with ideas and inspiration acquired from different sources on the Internet.
]]


local popuptext = require 'popuptext'
local enemies = require 'enemies'
local score_and_lives = require 'score_and_lives'
local level1 = require 'level1'
local levels = require 'levels'
local player = require 'player'
local mainmenu = require 'mainmenu'
local conf = require 'conf'

function love.load()
	enemies:load()
	levels:level1_load(score_and_lives, enemies)
	mainmenu:load()
	player:load()
	score_and_lives:load()

	game_state = 'Main_Menu'

	love.mouse.setCursor(game_cursor)
end

function love.update(dt)
	player.x = player.x + player.xVel * dt
	player.y = player.y + player.yVel * dt

	if game_state == 'Main_Menu' then
		love.mouse.setVisible(true)
		mainmenu:update_clouds_and_stars(dt)
		mainmenu:buttons_mouse_overlap_check()
		mainmenu:move_button_triangles(dt)
	end

	if game_state == 'Level_1' then
		for i,v in ipairs(levels) do
			player:calculate_collision(player, v)
			enemies:calculate_collision(v)
			enemies:calculate_turn(v)
		end

		for i,v in ipairs(enemies) do
			v.fall_sensing = v.fall_sensing + 50 * dt

			if v.enemy_going_right == true and
				v.fall_sensing > 5 then
				v.enemy_going_right = false
				v.enemy_going_left = true
			end

			if v.enemy_going_left == true and
				v.fall_sensing > 6 then
				v.enemy_going_left = false
				v.enemy_going_right = true
			end
		end

		love.mouse.setVisible(false)
		player:movement(dt)
		enemies:move_enemy(dt)
		enemies:collision_to_player(player, popuptext)
		player:player_damaged(dt)
		player:player_death(dt)
		score_and_lives:update_coin(dt)
		score_and_lives:coin_to_player_collision(player, popuptext)
		popuptext:update_popuptext(dt)
		player:react_to_fall()
		levels:level1_end_update(player, dt)
		level1_audio:play()
	end

	if game_state == 'Level_1_Complete' then
		levels:level1_complete_update(dt)
	end
end

function love.draw()
	if game_state == 'Main_Menu' then
		mainmenu:draw_clouds_and_stars()
		mainmenu:draw_title_and_buttons()
	end

	if game_state == 'Level_1' then
		levels:level1_draw()
		score_and_lives:draw_coin()
		score_and_lives:draw_score_and_lives()
		player:draw_player()
		enemies:draw_enemy()
		levels:level1_end_draw()
		popuptext:draw_popuptext()
	end

	
	if game_state == 'Level_1_Complete' then
		levels:level1_complete_draw()
	end
end

function love.keypressed(key_pressed)
	if game_state == 'Level_1' then
		if key_pressed == 'right' and
			player_death == false then
				player_animation_timer = 0
				current_player_quad = 3
		end
		
		if key_pressed == 'left' and
			player_death == false then
				player_animation_timer = 0
				current_player_quad = 4
		end

		if key_pressed == 'space' and
			is_jumping == false and
				player_death == false then
					jump_audio:play()
					player.yVel = -140
		end
	end
end

function love.mousepressed(x, y, mouse_pressed)
	if game_state == 'Main_Menu' then
		if mouse_pressed == 1 then
			love.mouse.setCursor(game_cursor_click)
			mainmenu:buttons_mouse_click_check()
		end
	end
end

function love.mousereleased(x, y, mouse_released)
	if mouse_released == 1 then
		love.mouse.setCursor(game_cursor)
	end
end

function aabb(x1, y1, w1, h1, x2, y2, w2, h2)
	return x1 < x2 + w2 and
		   x2 < x1 + w1 and
		   y1 < y2 + h2 and
		   y2 < y1 + h1
end
