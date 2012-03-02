Missile = {}
Missile.__index = Missile

function Missile.create(x,y,dir)
	local self = {}
	setmetatable(self,Missile)

	self.x = x
	self.y = y
	self.alive = true
	self.rot = dir
	self.xspeed = math.cos(dir)*100
	self.yspeed = math.sin(dir)*100

	return self
end

function Missile:update(dt)
	self.x = self.x + self.xspeed*dt
	self.y = self.y + self.yspeed*dt

	if self.x < 0 or self.y > MAPW or self.y < 0 or self.y > HEIGHT then
		self.alive = false
	end
end

local lg = love.graphics
function Missile:draw()
	lg.drawq(imgSprites,quadMissile,self.x,self.y,self.rot,1,1,3,1.5)
end

function Missile:destroy()
	self.alive = false
end
