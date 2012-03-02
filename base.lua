Base = {}
Base.__index = Base

function Base.create(x)
	local self = {}
	setmetatable(self,Base)
	self.x = x
	self.frame = 0
	return self
end

function Base:update(dt)
	self.frame = (self.frame + dt*5)%4
end

local lg = love.graphics
function Base:draw()
	lg.drawq(imgSprites,quadBase,self.x-27,89)
	lg.drawq(imgSprites,quadRadar[math.floor(self.frame)], self.x-18,85)
end
