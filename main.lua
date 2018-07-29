function love.load()
	g = love.graphics
	k = love.keyboard
	t = love.timer
	
	window = {width = 800, height = 480}
	
	font = g.newFont("res/Font.ttf", 20)
	g.setFont(font)
	
	--title = g.newImage("res/title.png")
	bubble = g.newImage("res/bubble.png")
	blorgon = g.newImage("res/blorgon.png")
	
	STAND = 0
	MOVE = 1
	GONE = 2
	
	DREAM = 2
	SPACE = 3
	PLANET = 4
	PLANET_BLORGONS = 5
	
	stage = DREAM
	keys_active = true
	players = true	
	
	text = {
		timebooth_0 = "Reggie, to the time booth! We haven't much... space.", timebooth_0_dsp = false,
		blimey_1 = "Blimey! Where have we wound up this time Inspector?", blimey_1_dsp = false,
		when_2 = "The question isn't where, constable, but when.", when_2_dsp = false,
		lookout_3 = "Inspector, look out! Blorgons!", lookout_3_dsp = false,
		blorgon_4 = "ERADICATE! ERADICATE!", blorgon_4_dsp = false
	}
	
	dreamatorium = {
		image = g.newImage("res/dreamatorium.png"), x = 0, y = 0
	}
	
	outerspace = {
		image = g.newImage("res/space.png"), x = 0, y = 0
	}
	
	planet = {
		image = g.newImage("res/planet.png"), x = 0, y = 0
	}
	
	timebooth = {
		image = g.newImage("res/timebooth.png"),
		image_active = g.newImage("res/timebooth_active.png"),
		width = 168, height = 344,
		x = 560, 
		y = 136,
		offset = 4,
		scale = 1,
		spin = 0,
		spin_factor = 0.16,
		state = STAND
	}
	
	inspector = {
		image_left = g.newImage("res/inspector_left.png"),
		image_right = g.newImage("res/inspector_right.png"),
		width = 96, height = 184, move = 2,
		x = 40, y = 296,
		dir = 0,
		state = STAND
	}
	
	reggie = {
		image_left = g.newImage("res/reggie_left.png"),
		image_right = g.newImage("res/reggie_right.png"),
		width = 80, height = 176, move = 2,
		x = 160, y = 304,
		dir = 0,
		state = STAND
	}
	
	load_stage()
end

function load_stage()
	if stage == DREAM then
		players = true
		inspector.x = 40
		inspector.y = 296
		timebooth.x = 560
		timebooth.y = 136
		timebooth.state = STAND
		timebooth.spin = 0
	elseif stage == SPACE then
		timebooth.state = MOVE
		players = false
		timebooth.x = -100
		timebooth.y = 110
		timebooth.spin = 0
	elseif stage == PLANET then
		timebooth.state = STAND
		timebooth.spin = 0
		timebooth.x = 100 -- unspecified
		timebooth.y = 136
		players = true
		inspector.x = 40
		inspector.y = 296
		reggie.x = 160
		reggie.y = 304
		inspector.image = inspector.image_right
		reggie.image = reggie.image_right
	elseif stage == PLANET_BLORGONS then
	end
end

function love.update(dt)
	if keys_active then -- walking
		inspector.move_left = k.isDown("a")
		inspector.move_right = k.isDown("d")
		reggie.move_left = k.isDown("j")
		reggie.move_right = k.isDown("l")
		if stage > 0 then
			if inspector.move_left 
			  and inspector.x > 0 - inspector.width / 2 then -- move inspector left
				inspector.x = inspector.x - inspector.move
				inspector.dir = 1
			elseif inspector.move_right 
			  and inspector.x < window.width - inspector.width / 2 then -- move inspector right
				inspector.x = inspector.x + inspector.move
				inspector.dir = 0
			end
			if reggie.move_left 
			  and reggie.x > 0 - reggie.width / 2 then -- move reggie left
				reggie.x = reggie.x - reggie.move
				reggie.dir = 1
			elseif reggie.move_right 
			  and reggie.x < window.width - reggie.width / 2 then -- move reggie right
				reggie.x = reggie.x + reggie.move
				reggie.dir = 0
			end
		end --  movement
	end -- keys_active
	
	if stage == DREAM then
		if timebooth.state == MOVE and timebooth.y > -300 then
			timebooth.spin = timebooth.spin + timebooth.spin_factor
			timebooth.y = timebooth.y - 3
		elseif timebooth.y <= -300 and timebooth.state == MOVE then
			stage = SPACE
			load_stage()
		end
	end
	
	if stage == SPACE then
		timebooth.spin = timebooth.spin + timebooth.spin_factor
		timebooth.x = timebooth.x + 5
		if timebooth.x > window.width + 150 then
			stage = PLANET
			load_stage()
		end
	end
	
	if stage == PLANET then
		if reggie.x > 350 or inspector.x > 350 then
			stage = PLANET_BLORGONS
			load_stage()
		end
	end
	
	--[[if blorgons == true and blorgons_active == true then -- move blorgons
		blorgon_1_x = blorgon_1_x - 0.1
		blorgon_2_x = blorgon_2_x - 0.1
		lazer_x = lazer_x - 0.4
	end
	if (blorgon_1_x + 16 < reggie_x + 80 and reggie_dir == 1) or (blorgon_1_x + 16 < reggie_x and reggie_dir == -1 and blorgons_active == true) then -- if blorgon gets reggie then dead
		keys_active = false
		dead = true
		blorgons_active = false
	end
	if (blorgon_1_x + 16 < inspector_x + 96 and inspector_dir == 1) or (blorgon_1_x + 16 < inspector_x and inspector_dir == -1 and blorgons_active == true) then -- if blorgon gets inspector then dead
		keys_active = false
		dead = true
		blorgons_active = false
	end]]
end

function in_timebooth()
	return (reggie.x >= timebooth.x + timebooth.offset
	  and reggie.x + reggie.width <= timebooth.x + timebooth.width - timebooth.offset
	  and inspector.x >= timebooth.x + timebooth.offset
	  and inspector.x + inspector.width <= timebooth.x + timebooth.width - timebooth.offset)
end

function check_text(dsp, key)
	if dsp == false then
		keys_active = false
		if key == selector then
			keys_active = true
			return true
		end
		return false
	else 
		return true
	end
end
	

function love.keypressed(key, scancode, isrepeat)
	selector = "space"
	if stage == DREAM then
		if key == selector 
		  and timebooth.state == STAND and in_timebooth() then
			keys_active = false
			players = false
			timebooth.state = MOVE
		end
		
		text.timebooth_0_dsp = check_text(text.timebooth_0_dsp, key)
	elseif stage == PLANET then
		if text.blimey_1_dsp == true then
			text.when_2_dsp = check_text(text.when_2_dsp, key)
		end
		text.blimey_1_dsp = check_text(text.blimey_1_dsp, key)
	elseif stage == PLANET_BLORGONS then
		text.lookout_3_dsp = check_text(text.lookout_3_dsp, key)
	end
end

function draw_players()
	if reggie.dir == 0 then
		g.draw(reggie.image_right, reggie.x, reggie.y)
	else
		g.draw(reggie.image_left, reggie.x, reggie.y)
	end
	if inspector.dir == 0 then
		g.draw(inspector.image_right, inspector.x, inspector.y)
	else
		g.draw(inspector.image_left, inspector.x, inspector.y)
	end
end

function draw_timebooth()
	if timebooth.state == STAND then
		drawable = timebooth.image
		if in_timebooth() then
			drawable = timebooth.image_active
		end
		g.draw(drawable, timebooth.x+timebooth.width/2, timebooth.y+timebooth.height/2, timebooth.spin, 1, 1, timebooth.width/2, timebooth.height/2)
	elseif timebooth.state == MOVE then
		g.draw(timebooth.image_active, timebooth.x+timebooth.width/2, timebooth.y+timebooth.height/2, timebooth.spin, 1, 1, timebooth.width/2, timebooth.height/2)
	end
end

function draw_bubble(drawtext, x, y)	
	text_offset_x = 16
	text_offset_y = 48
	text_width = 300
	g.draw(bubble, x, y)
	g.setColor(0, 0, 0, 255)
	g.printf(drawtext, x + text_offset_x, y + text_offset_y, text_width, "center")
	g.setColor(255, 255, 255, 255)
end

function draw_dreamatorium()
	g.draw(dreamatorium.image, dreamatorium.x, dreamatorium.y)
	if players then
		draw_players()
	end
	draw_timebooth()
end

function draw_outerspace()
	g.draw(outerspace.image, outerspace.x, outerspace.y)
	g.draw(timebooth.image, timebooth.x+timebooth.width/2, timebooth.y+timebooth.height/2, timebooth.spin, 0.7, 0.7, timebooth.width/2, timebooth.height/2)
end

function draw_planet()
	g.draw(planet.image, planet.x, planet.y)
	if players then
		draw_players()
	end
end

function love.draw()
	if stage == DREAM then
		draw_dreamatorium()
		if text.timebooth_0_dsp == false then
			draw_bubble(text.timebooth_0, inspector.x + (inspector.width/2), 100)
		end
	elseif stage == SPACE then
		draw_outerspace()
	elseif stage == PLANET then
		draw_planet()
		if text.blimey_1_dsp == false then
			draw_bubble(text.blimey_1, reggie.x + (reggie.width/2), 100)
		elseif text.when_2_dsp == false then
			draw_bubble(text.when_2, inspector.x + (inspector.width/2), 100)
		end
	elseif stage == PLANET_BLORGONS then
		draw_planet()
		if text.lookout_3_dsp == false then
			draw_bubble(text.lookout_3, reggie.x + (reggie.width/2), 100)
		end
		
		--[[
		if blorgons == true then
			g.draw(bubble, blorgon_1_x + 20, 100, 0, -1, 1)
			g.setColor(0, 0, 0, 255)
			g.printf(text.blorgon_4, blorgon_1_x - 300, 160, 300, "center")
			g.setColor(255, 255, 255, 255)
			
			g.draw(lazer, lazer_x, 304)
			g.draw(blorgon, blorgon_1_x, 304)
			g.draw(blorgon, blorgon_2_x, 304)
		end
		--]]
	end
end