Human = {}
Human.__index = Human

function Human.create(x)
	local self = {}
	setmetatable(self,Human)

	self.x = x

	print("human created at " .. self.x)
	self.alive = true

	return self
end

function Human:update(dt, pl, base)
	if self.x > base.x-26 and self.x < base.x+26 then
		if self.x > base.x + 2 then
			self.x = self.x - dt*HUMAN_SPEED
		elseif self.x < base.x - 2 then
			self.x = self.x + dt*HUMAN_SPEED
		else
			self:saved()
		end
	elseif pl.y == 132 then
		if self.x > pl.x-26 and self.x < pl.x+26 and pl.unloadCooldown <= 0 then
			if self.x > pl.x+2 then
				self.x = self.x - dt*HUMAN_SPEED
			elseif self.x < pl.x-2 then
				self.x = self.x + dt*HUMAN_SPEED
			else
				if pl:addHuman() then
					self.alive = false
					TEsound.play(sndPickup)
				end
			end
		end
	end
end

local lg = love.graphics
function Human:draw()
	lg.drawq(imgSprites,quadHuman, self.x, 131, 0, 1, 1, 2)
end

function Human:saved()
	print("HUMAN SAVED!")
	self.alive = false
	TEsound.play(sndPickup)
end
