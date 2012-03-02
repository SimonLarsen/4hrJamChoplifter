local lg = love.graphics

function loadImages()
	imgSprites = lg.newImage("res/sprites.png")
	imgSprites:setFilter("nearest","nearest")

	local sprw, sprh = 256, 256

	quadChopperSide = {}
	quadChopperFront = {}
	for i = 0,3 do
		quadChopperSide[i] = lg.newQuad(i*32,0,32,16,sprw,sprh)
		quadChopperFront[i] = lg.newQuad(i*32,16,32,16,sprw,sprh)
	end

	quadMissile = lg.newQuad(0,32,6,3,sprw,sprh)

	quadGround = lg.newQuad(0,224,160,22,sprw,sprh)

	quadBase = lg.newQuad(160,176,52,53,sprw,sprh)
	quadRadar = {}
	for i = 0,3 do
		quadRadar[i] = lg.newQuad(160+i*6,236,6,4,sprw,sprh)
	end

	quadCamp = lg.newQuad(218,176,38,29,sprw,sprh)

	quadMeteor = {}
	for i = 0, 2 do
		quadMeteor[i] = lg.newQuad(i*32,48,32,32,sprw,sprh)
	end

	quadHuman = lg.newQuad(144,0,4,8,sprw,sprh)
	quadHumanGray = lg.newQuad(148,0,4,8,sprw,sprh)

	imgFont = lg.newImage("res/font.png")
	imgFont:setFilter("nearest","nearest")
	font = lg.newImageFont(imgFont," 0123456789abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ!-.,$")
	lg.setFont(font)
end

function loadSounds()
	sndExplosion = love.sound.newSoundData("sfx/explosion.wav")
	sndShoot = love.sound.newSoundData("sfx/shoot.wav")
	sndPickup = love.sound.newSoundData("sfx/pickup.wav")
end

function loadResources()
	loadImages()
	loadSounds()
end
