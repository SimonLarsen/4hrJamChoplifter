require("defines")
require("resources")
require("player")
require("base")
require("meteor")
require("missile")
require("camp")
require("human")
require("TEsound")

local lg = love.graphics

function love.load()
	lg.setMode(WIDTH*SCALEX, HEIGHT*SCALEY, false)
	lg.setBackgroundColor(111,183,213)
	math.randomseed(os.time())

	loadResources()

	restart()
end

function restart()
	pl = Player.create(MAPW/2, 75)
	base = Base.create(MAPW/2-10)
	
	nextMeteor = math.random()*METEOR_SPAWNTIME

	meteors = {}
	camps = {
		Camp.create(MAPW*0.08),
		Camp.create(MAPW*0.25),
		Camp.create(MAPW*0.75),
		Camp.create(MAPW*0.92),
	}
	humans = {}
	for i = 1, NUM_HUMANS do
		camps[math.random(1,#camps)]:spawnHuman()
	end

	translatex = math.min(math.max(0, pl.x - WIDTH/2), MAPW-WIDTH)

	gamestate = STATE_INGAME
end

function nextLevel()
	NUM_HUMANS = NUM_HUMANS*1.2
	MAPW = MAPW*1.2
	METEOR_SPAWNTIME = METEOR_SPAWNTIME * 0.9
	restart()
end

function love.update(dt)
	TEsound.cleanup()

	if gamestate == STATE_INGAME then
		pl:update(dt,base)
		base:update(dt)

		for i = #meteors, 1, -1 do
			if meteors[i].alive then
				meteors[i]:update(dt)
			else
				table.remove(meteors,i)
			end
		end

		for i = #humans, 1, -1 do
			if humans[i].alive then
				humans[i]:update(dt,pl,base)
			else
				table.remove(humans,i)
			end
		end

		pl:collideMeteors(meteors)

		nextMeteor = nextMeteor - dt
		if nextMeteor < 0 then
			nextMeteor = 1 + math.random()*METEOR_SPAWNTIME
			table.insert(meteors, Meteor.create())
		end
	end

	if #humans == 0 and pl.humans == 0 then
		gamestate = STATE_WON
	end
end

function love.draw()
	if gamestate == STATE_INGAME then
		drawIngame()
	elseif gamestate == STATE_DIED then
		drawIngame()
		lg.printf("You died!",0,60,WIDTH,"center")
		lg.printf("Press R to restart",0,80,WIDTH,"center")
	elseif gamestate == STATE_METEOR then
		drawIngame()
		lg.printf("A meteor has hit the earth!",0,60,WIDTH,"center")
		lg.printf("Press R to restart",0,80,WIDTH,"center")
	elseif gamestate == STATE_WON then
		drawIngame()
		lg.printf("Level completed!",0,60,WIDTH,"center")
		lg.printf("Press return to continue",0,80,WIDTH,"center")
	end
end

function drawIngame()
	lg.setColor(255,255,255,255)
	lg.scale(SCALEX,SCALEY)
	lg.push()

	local off = -translatex % WIDTH
	lg.drawq(imgSprites,quadGround,-WIDTH+off,HEIGHT-22)
	lg.drawq(imgSprites,quadGround,off,HEIGHT-22)

	translatex = math.min(math.max(0, pl.x - WIDTH/2), MAPW-WIDTH)
	lg.translate(-translatex,0)

	base:draw()

	for i = #camps, 1, -1 do
		camps[i]:draw()
	end

	for i = #meteors, 1, -1 do
		meteors[i]:draw()
	end

	pl:draw()

	for i = #humans, 1, -1 do
		humans[i]:draw()
	end

	lg.pop()

	for i = 0, 4 do
		if i < pl.humans then
			lg.drawq(imgSprites,quadHuman,5+i*7, 6)
		else
			lg.drawq(imgSprites,quadHumanGray,5+i*7, 6)
		end
	end
	drawMinimap()
end

function drawMinimap()
	lg.push()
	lg.translate(WIDTH-55,5)
	lg.setColor(0,0,0,128)
	lg.rectangle("fill",0,0,50,25)

	-- draw player
	lg.setColor(105,213,22,255)
	lg.rectangle("fill",pl.x*(50/MAPW)-1,pl.y*(25/HEIGHT)-1,2,2)

	-- draw meteors
	lg.setColor(195,15,15,255)
	for i=#meteors, 1, -1 do
		lg.rectangle("fill",meteors[i].x*(50/MAPW)-1,meteors[i].y*(25/HEIGHT)-1,2,2)
	end

	lg.setColor(255,255,255,255)
	lg.pop()
end

function love.keypressed(k,uni)
	if k == "escape" then
		love.event.push('q')
	elseif k == 'r' then
		restart()
	elseif k == 'return' and gamestate == STATE_WON then
		nextLevel()
	end
end

function love.mousepressed(x,y,button)
	local mx = x/SCALEX + translatex
	local my = y/SCALEY
	pl:mousepressed(mx,my,button)
end
