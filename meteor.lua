Meteor = {}
Meteor.__index = Meteor

function Meteor.create(x)
	local self = {}
	setmetatable(self,Meteor)

	self.x = 10 + math.random(MAPW-1)
	self.y = -16

	print("Meteor created at x = " .. self.x)
	self.alive = true

	self.xspeed = math.random()-0.5
	self.yspeed = math.random(4,8)

	self.size = math.random(0,2)
	self.rot = math.random(0,math.pi*2)

	return self
end

function Meteor:update(dt)
	self.x = self.x + self.xspeed * dt
	self.y = self.y + self.yspeed * dt

	if self.x < 0 or self.x > MAPW then
		self.alive = false
	end

	if self.y > 140 then
		self.alive = false
		gamestate = STATE_METEOR
		TEsound.play(sndExplosion)
	end
end

local lg = love.graphics
function Meteor:draw()
	lg.drawq(imgSprites,quadMeteor[self.size], self.x, self.y, self.rot, 1, 1, 16,16)
end

function Meteor:collideMissile(m)
	local sqdist = math.pow(self.x-m.x,2) + math.pow(self.y-m.y,2)
	if self.size == 0 then
		if sqdist < 64 then
			return true
		end
	elseif self.size == 1 then
		if sqdist < 100 then
			return true
		end
	elseif self.size == 2 then
		if sqdist < 144 then
			return true
		end
	end
	return false
end

function Meteor:collidePlayer(pl)
	local sqdist = math.pow(self.x - pl.x,2) + math.pow(self.y - pl.y,2)
	if self.size == 0 and sqdist < 180 then
		return true
	elseif self.size == 1 and sqdist < 190 then
		return true
	elseif self.size == 2 and sqdist < 240 then
		return true
	else
		return false
	end
end

function Meteor:destroy()
	self.alive = false
	TEsound.play(sndExplosion)
end
