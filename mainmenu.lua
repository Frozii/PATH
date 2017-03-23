local mainmenu = {}

-- loads the needed resources for the main menu
function mainmenu:load()
	background_image = love.graphics.newImage('Assets/Images/Background.png')
	cloud1_dark = love.graphics.newImage('Assets/Images/Cloud1_dark.png')
	cloud2_dark = love.graphics.newImage('Assets/Images/Cloud2_dark.png')
	cloud3_dark = love.graphics.newImage('Assets/Images/Cloud3_dark.png')
	cloud4_dark = love.graphics.newImage('Assets/Images/Cloud4_dark.png')
	star1_1 = love.graphics.newImage('Assets/Images/Star1.1.png')
	star1_2 = love.graphics.newImage('Assets/Images/Star1.2.png')
	star2_1 = love.graphics.newImage('Assets/Images/Star2.1.png')
	star2_2 = love.graphics.newImage('Assets/Images/Star2.2.png')
	star3_1 = love.graphics.newImage('Assets/Images/Star3.1.png')
	star3_2 = love.graphics.newImage('Assets/Images/Star3.2.png')
	star3_3 = love.graphics.newImage('Assets/Images/Star3.3.png')
	star3_4 = love.graphics.newImage('Assets/Images/Star3.4.png')
	game_title = love.graphics.newImage('Assets/Images/Title.png')
	game_cursor = love.mouse.newCursor('Assets/Images/GameCursor.png', 0, 0)
	game_cursor_click = love.mouse.newCursor('Assets/Images/GameCursorClick.png', 0, 0)

	font1 = love.graphics.newFont('Assets/Fonts/ArcadeClassic.ttf', 62)

	cloud1_x1 = 50
	cloud1_y1 = 75
	cloud1_x2 = 750
	cloud1_y2 = 170
	cloud2_x1 = 170
	cloud2_y1 = 200
	cloud2_x2 = 600
	cloud2_y2 = 140
	cloud3_x1 = 300
	cloud3_y1 = 100
	cloud3_x2 = 500
	cloud3_y2 = 20
	cloud4_x1 = 100
	cloud4_y1 = - 10
	star1_picture = star1_1
	star2_picture = star2_1
	star3_picture = star3_1
	star1_animation_timer = 0
	star2_animation_timer = 0
	star3_animation_timer = 0
	vertice1, vertice2, vertice_timer = 35, 15, 0 

	mainmenu:spawn_button(330, 200, 'Play', 'Level_1')
	mainmenu:spawn_button(330, 250, 'Exit', 'Exit')
end

-- enters the given values into a table
function mainmenu:spawn_button(x, y, text, id)
	table.insert(mainmenu, {x = x, y = y, text = text, id = id, mouse_over = false})
end

-- moves the triangles on the sides of the menu items
function mainmenu:move_button_triangles(dt)
	for i,v in ipairs(mainmenu) do
		if v.mouse_over == true then
			vertice_timer = vertice_timer + dt

			if vertice_timer < 0.4 then
				vertice1 = vertice1 + 50 * dt
				vertice2 = vertice2 + 50 * dt
			end

			if vertice_timer > 0.4 then
				vertice1 = vertice1 - 50 * dt
				vertice2 = vertice2 - 50 * dt
			end
			
			if vertice_timer > 0.8 then 
				vertice_timer = 0
			end
		end
	end
end

-- draws a lot of the menu related things
function mainmenu:draw_title_and_buttons()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(game_title, 259, 80)

	for i,v in ipairs(mainmenu) do
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.setFont(font1)
		love.graphics.print(v.text, v.x, v.y)

		if v.mouse_over == false then
		end

		if v.mouse_over == true then
			love.graphics.setColor(2, 136, 209, 255)
			love.graphics.polygon('fill', v.x - vertice1, v.y + 20, v.x - vertice1, v.y + 40, v.x - vertice2, v.y + 30)
			love.graphics.polygon('fill', v.x + font1:getWidth(v.text) - 5 + vertice1, v.y + 20, v.x + font1:getWidth(v.text) - 5 + vertice1, v.y + 40, v.x + font1:getWidth(v.text) - 5 + vertice2, v.y + 30)

			love.graphics.setColor(0, 70, 126, 255)
			love.graphics.polygon('line', v.x - vertice1, v.y + 20, v.x - vertice1, v.y + 40, v.x - vertice2, v.y + 30)
			love.graphics.polygon('line', v.x + font1:getWidth(v.text) - 5 + vertice1, v.y + 20, v.x + font1:getWidth(v.text) - 5 + vertice1, v.y + 40, v.x + font1:getWidth(v.text) - 5 + vertice2, v.y + 30)
		end
	end
end

-- checks if the mouse is over the menu items
function mainmenu:buttons_mouse_overlap_check()
	for i,v in ipairs(mainmenu) do
		local mouse_x = love.mouse.getX()
		local mouse_y = love.mouse.getY()

		if aabb(mouse_x, mouse_y, 0, 0, v.x, v.y + 13, font1:getWidth(v.text), font1:getHeight(v.text) - 30) then

			v.mouse_over = true
		else
			v.mouse_over = false
		end
	end
end

-- decides what is done when a menu item is clicked upon
function mainmenu:buttons_mouse_click_check()
	for i,v in ipairs(mainmenu) do
		if v.mouse_over == true then
			if v.id == 'Level_1' then
				game_state = 'Level_1'
			end

			if v.id == 'Exit' then
				love.event.push('quit')
			end
		end	
	end
end

-- draws the clouds and stars seen on the main menu
function mainmenu:draw_clouds_and_stars()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(background_image, 0, 0)

	love.graphics.setColor(255, 255, 255, 200)
	love.graphics.draw(star1_picture, 150, 50)
	love.graphics.draw(star1_picture, 670, 100)
	love.graphics.draw(star2_picture, 700, 10)
	love.graphics.draw(star2_picture, 80, 120)
	love.graphics.draw(star3_picture, 500, 160)

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(cloud1_dark, cloud1_x1, cloud1_y1)
	love.graphics.draw(cloud1_dark, cloud1_x2, cloud1_y2)
	love.graphics.draw(cloud2_dark, cloud2_x1, cloud2_y1)
	love.graphics.draw(cloud2_dark, cloud2_x2, cloud2_y2)
	love.graphics.draw(cloud3_dark, cloud3_x1, cloud3_y1)
	love.graphics.draw(cloud3_dark, cloud3_x2, cloud3_y2)
	love.graphics.draw(cloud4_dark, cloud4_x1, cloud4_y1)
end

-- moves the clouds and stars at certain speeds
function mainmenu:update_clouds_and_stars(dt)
	cloud1_x1 = cloud1_x1 - 14 * dt
	cloud1_x2 = cloud1_x2 - 14 * dt
	cloud2_x1 = cloud2_x1 - 12 * dt
	cloud2_x2 = cloud2_x2 - 12 * dt
	cloud3_x1 = cloud3_x1 - 8 * dt
	cloud3_x2 = cloud3_x2 - 8 * dt
	cloud4_x1 = cloud4_x1 - 8 * dt

	if cloud1_x1 < -20 then
		cloud1_x1 = 820
	end

	if cloud1_x2 < -20 then
		cloud1_x2 = 820
	end

	if cloud2_x1 < -29 then
		cloud2_x1 = 849
	end

	if cloud2_x2 < -29 then
		cloud2_x2 = 849
	end

	if cloud3_x1 < -128 then
		cloud3_x1 = 800
	end

	if cloud3_x2 < -128 then
		cloud3_x2 = 800
	end

	if cloud4_x1 < -128 then
		cloud4_x1 = 800
	end

	star1_animation_timer = star1_animation_timer + dt
	star2_animation_timer = star2_animation_timer + dt
	star3_animation_timer = star3_animation_timer + dt

	if star1_animation_timer >= 0.25 then
		star1_picture = star1_2
	end

	if star1_animation_timer >= 0.75 then
		star1_picture = star1_1
		star1_animation_timer = 0
	end

	if star2_animation_timer >= 0.75 then
		star2_picture = star2_2
	end

	if star2_animation_timer >= 1.25 then
		star2_picture = star2_1
		star2_animation_timer = 0
	end

	if star3_animation_timer < 1.00 then
		star3_picture = star1_1
	end

	if star3_animation_timer >= 1.00 then
		star3_picture = star3_2
	end

	if star3_animation_timer >= 1.50 then
		star3_picture = star3_3
	end

	if star3_animation_timer >= 2.00 then
		star3_picture = star3_4
		star3_animation_timer = 0
	end
end

return mainmenu