Camp = {}
Camp.__index = Camp

function Camp.create(x)
	local self = {}
	setmetatable(self,Camp)

	self.x = x

	return self
end

local lg = love.graphics
function Camp:draw()
	lg.drawq(imgSprites,quadCamp, self.x-19, 112)
end

function Camp:spawnHuman()
	table.insert(humans, Human.create(self.x + math.random(-15,15)))
end
