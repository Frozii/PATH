local levels = {}
local TILE_AIR = 0
local TILE_SIGN = 10

-- loads level variables
function levels:level1_load(score_and_lives, enemies)
	love.graphics.setBackgroundColor(90, 154, 255, 255)
	level1_end = false
	level1_end_opacity = 0
	level_1_complete_timer = 0

	tileset_image = love.graphics.newImage('Assets/Images/GroundTileset.png')
	cloud1 = love.graphics.newImage('Assets/Images/Cloud1.png')
	cloud2 = love.graphics.newImage('Assets/Images/Cloud2.png')
	cloud3 = love.graphics.newImage('Assets/Images/Cloud3.png')
	cloud4 = love.graphics.newImage('Assets/Images/Cloud4.png')
	bush = love.graphics.newImage('Assets/Images/Bush.png')

	coin_audio = love.audio.newSource('Assets/Audio/Coin.wav', 'static')
	jump_audio = love.audio.newSource('Assets/Audio/Jump.wav', 'static')
	player_hurt_audio = love.audio.newSource('Assets/Audio/PlayerHurt.wav', 'static')
	enemy_hurt_audio = love.audio.newSource('Assets/Audio/EnemyHurt.wav', 'static')

	font4 = love.graphics.newFont('Assets/Fonts/ArcadeClassic.ttf', 52)

	score_and_lives:spawn_coin(808, 364)
	score_and_lives:spawn_coin(935, 332)
	score_and_lives:spawn_coin(1040, 332)
	score_and_lives:spawn_coin(1160, 268)
	score_and_lives:spawn_coin(1255, 268)
	score_and_lives:spawn_coin(2565, 332)
	score_and_lives:spawn_coin(2602, 332)
	score_and_lives:spawn_coin(2696, 268)
	score_and_lives:spawn_coin(2795, 204)
	score_and_lives:spawn_coin(2955, 204)
	score_and_lives:spawn_coin(3220, 204)
	score_and_lives:spawn_coin(3528, 364)
	score_and_lives:spawn_coin(3656, 236)
	score_and_lives:spawn_coin(3783, 364)
	score_and_lives:spawn_coin(4550, 364)

	enemies:spawn_enemy(1000, 320)
	enemies:spawn_enemy(1300, 448)
	enemies:spawn_enemy(1520, 448)
	enemies:spawn_enemy(1620, 448)
	enemies:spawn_enemy(2045, 448)
	enemies:spawn_enemy(2670, 448)
	enemies:spawn_enemy(2830, 192)
	enemies:spawn_enemy(2930, 192)
	enemies:spawn_enemy(3190, 192)
	enemies:spawn_enemy(3510, 448)
	enemies:spawn_enemy(3780, 448)
	enemies:spawn_enemy(4560, 352)
	enemies:spawn_enemy(4600, 448)

	tileset_quads = {}

	for x = 1, 10 do
		tileset_quads[x] = love.graphics.newQuad((x - 1) * 32, 0, 32, 32, 320, 32)
	end

	local map_function = love.filesystem.load('level1.lua')
	local map_datatable = map_function()

	map_tilesetdata = {}
	for x = 1, map_datatable.layers[1].width do
		map_tilesetdata[x] = {}
		for y = 1, map_datatable.layers[1].height do
			map_tilesetdata[x][y] = map_datatable.layers[1].data[(y - 1) * map_datatable.layers[1].width + x]
		end
	end

	function levels:create_tile(x, y)
		table.insert(levels, {x = x, y = y, width = 32, height = 32})
	end

	for x = 1, #map_tilesetdata do
		for y = 1, #map_tilesetdata[x] do
			if map_tilesetdata[x][y] ~= TILE_AIR and map_tilesetdata[x][y] ~= TILE_SIGN then
				levels:create_tile((x - 1) * 32, (y - 1) * 32)
			end
		end
	end
end

-- draw the map and decide some tile based decisions
function levels:level1_draw()
	love.graphics.push()

	love.graphics.translate(math.floor(-scroll_factor), 0)

	love.graphics.setColor(255, 255, 255, 255)

	love.graphics.draw(cloud1, 1550, 200)
	love.graphics.draw(cloud1, 3250, 330)
	love.graphics.draw(cloud1, 3500, 180)
	love.graphics.draw(cloud2, 850, 300)
	love.graphics.draw(cloud2, 1300, 350)
	love.graphics.draw(cloud2, 2250, 380)
	love.graphics.draw(cloud2, 2800, 260)
	love.graphics.draw(cloud2, 4200, 250)
	love.graphics.draw(cloud2, 4700, 350)
	love.graphics.draw(cloud3, 400, 100)
	love.graphics.draw(cloud3, 1200, -10)
	love.graphics.draw(cloud3, 2950, 20)
	love.graphics.draw(cloud3, 4000, 70)
	love.graphics.draw(cloud3, 5250, 150)
	love.graphics.draw(cloud4, -30, 5)
	love.graphics.draw(cloud4, 1900, 80)
	love.graphics.draw(cloud4, 4700, 10)
	love.graphics.draw(bush, 100, 463)
	love.graphics.draw(bush, 700, 463)
	love.graphics.draw(bush, 1150, 463)
	love.graphics.draw(bush, 1620, 463)
	love.graphics.draw(bush, 2100, 463)
	love.graphics.draw(bush, 2500, 463)
	love.graphics.draw(bush, 3400, 463)
	love.graphics.draw(bush, 3900, 463)

	for x = 1, #map_tilesetdata do
		for y = 1, #map_tilesetdata[x] do

			if map_tilesetdata[x][y] ~= TILE_AIR then
				love.graphics.draw(tileset_image, tileset_quads[map_tilesetdata[x][y]], (x - 1) * 32, (y - 1) * 32)
			end
		end
	end
	love.graphics.pop()
end

-- draws something
function levels:level1_end_draw()
	if level1_end == true then
		love.graphics.setColor(0, 0, 0, level1_end_opacity)
		love.graphics.rectangle('fill', 0, 0, 800, 600)
	end	
end

-- if the player if past a certain point, the level is completed
function levels:level1_end_update(player, dt)
	if player.x + player.width > 5260 then
		level1_end = true
	end

	if level1_end == true and
		level1_end_opacity < 255 then
		level1_end_opacity = level1_end_opacity + 320 * dt
	end
	
	if level1_end_opacity >= 255 then
		level1_end_opacity = 0
		game_state = 'Level_1_Complete'
	end
end

-- updates a timer
function levels:level1_complete_update(dt)
	level_1_complete_timer = level_1_complete_timer + dt

	if level_1_complete_timer > 3 then
		love.event.quit()
	end
end

-- draws the score gained during the level and the lives left
function levels:level1_complete_draw()
	love.graphics.setBackgroundColor(0, 0, 0, 255)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setFont(font4)
	love.graphics.print('SCORE    '..player_score, 125, 250)
	love.graphics.print('LIVES    '..player_health, 475, 250)
end

return levels
