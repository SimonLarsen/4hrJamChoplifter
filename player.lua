Player = {}
Player.__index = Player

function Player.create(x,y)
	local self = {}
	setmetatable(self,Player)
	self.x = x
	self.y = y
	self.alive = true
	self.dir = 0 --    -1 left, 0 center, 1 right
	self.xspeed = 0
	self.frame = 0
	self.missiles = {}
	self.humans = 0
	self.unloadCooldown = 0
	return self
end

local lk = love.keyboard
function Player:update(dt,base)
	self.frame = (self.frame+dt*32)%4
	self.unloadCooldown = self.unloadCooldown - dt

	if lk.isDown("a") then
		self.xspeed = self.xspeed - dt*100
		if self.xspeed < -128 then self.xspeed = -128 end
	end
	if lk.isDown("d") then
		self.xspeed = self.xspeed + dt*100
		if self.xspeed > 128 then self.xspeed = 128 end
	end

	if lk.isDown("w") then
		self.y = self.y - dt*48 end
	if lk.isDown("s") then
		self.y = self.y + dt*48 end

	if self.xspeed < -32 then self.dir = -1
	elseif self.xspeed > 32 then self.dir = 1
	else self.dir = 0 end

	self.x = self.x + self.xspeed*dt
	self.y = self.y + dt*PL_GRAVITY

	-- hit ground
	if self.y > 132 then
		self.y = 132
		self.xspeed = 0
	end

	-- check home base
	if self.y == 132 and self.x > base.x-25 and self.x < base.x+25 then
		self:unloadHuman()
	end

	-- update missiles
	for i = #self.missiles, 1, -1 do
		if self.missiles[i].alive then
			self.missiles[i]:update(dt)
		else
			table.remove(self.missiles, i)
		end
	end
end

local lg = love.graphics
function Player:draw()
	if self.alive == false then
		return
	end

	local rot = self.xspeed / 256
	if self.dir == 0 then
		lg.drawq(imgSprites,quadChopperFront[math.floor(self.frame)], self.x, self.y,rot,1,1,16,8)
	else
		lg.drawq(imgSprites,quadChopperSide[math.floor(self.frame)], self.x, self.y,rot,self.dir,1,16,8)
	end

	-- draw missiles
	for i,v in ipairs(self.missiles) do
		v:draw()
	end
end

function Player:mousepressed(mx,my,button)
	if button == 'l' then
		local dx, dy = mx - self.x, my - self.y
		local dir = math.atan2(dy,dx)
		print("dx: " .. dx .. "  dy: " .. dy)
		table.insert(self.missiles,Missile.create(self.x,self.y,dir))
		TEsound.play(sndShoot)
	end
end

function Player:collideMeteors(meteors)
	for i=1,#meteors do
		-- check collision with meteor
		if meteors[i]:collidePlayer(self) then
			self.alive = false
			gamestate = STATE_DIED
			TEsound.play(sndExplosion)
		end
		-- check if missiles hit
		for j=1,#self.missiles do
			if meteors[i]:collideMissile(self.missiles[j]) then
				meteors[i]:destroy()
				self.missiles[j]:destroy()
			end
		end
	end
end

function Player:addHuman()
	if self.humans < CAPACITY and self.unloadCooldown <= 0 then
		self.unloadCooldown = 0.5
		self.humans = self.humans + 1
		return true
	else
		return false
	end
end

function Player:unloadHuman()
	if self.humans > 0 and self.unloadCooldown <= 0 then
		self.humans = self.humans - 1
		self.unloadCooldown = 0.5
		table.insert(humans, Human.create(self.x))
	end
end
