local Tween = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local RNG = Random.new()
local StarterGui = game:GetService("StarterGui")


local Main = script.Parent
local Particle = Main.Particle

local MainAbs = Vector2.new(Main.AbsoluteSize.X,Main.AbsoluteSize.Y)
local StreamerAbs = Vector2.new(Particle.AbsoluteSize.X,Particle.AbsoluteSize.Y)
local MAX_STREAMERS = math.ceil(MainAbs.X/StreamerAbs.X)
local Height = math.ceil(MainAbs.Y/StreamerAbs.Y)
local StreamerWidth = (MainAbs.X/MAX_STREAMERS)/MainAbs.X
local TRAIL_LENGTH,SPEED = 10,0.01
local Streamers = {}
local Symbols = `0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ~!@#$%^&*()-_=+{"{}"}[]\|;:'"<,>.?/`


StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All,false)

local function RandomSymbol()
	local rng = math.random(1,#Symbols)
	return Symbols:sub(rng,rng)
end

for i = 0,MAX_STREAMERS do
	local Clone = Particle:Clone()
	Clone.Visible = true
	Clone.Parent = Main
	Clone.Name = "Streamer"
	Clone.Text = RandomSymbol()
	Clone.Position = UDim2.fromScale(i*StreamerWidth,RNG:NextNumber(-0.2,-0.05))
	Streamers[i] = {Clone,RNG:NextNumber(SPEED*0.25,SPEED*1.5),{}}
	for x = 1,TRAIL_LENGTH do
		local Trail = Clone:Clone()
		Trail.Parent = Main
		Trail.Name = "Trail"
		Trail.Text = RandomSymbol()
		Trail.Position = Clone.Position + UDim2.fromScale(0,-0.05*i)
		Trail.UIStroke.Color = Color3.fromRGB(7, 72, 1)
		Trail.TextColor3 = Color3.fromRGB(20, 218, 2)
		table.insert(Streamers[i][3],Trail)
	end
end

RunService.RenderStepped:Connect(function()
	for i = 1,#Streamers do
		local Streamer = Streamers[i-1]
		local Position = Streamer[1].Position
		Streamer[1].Text = RandomSymbol()
		Streamer[1].Position = Position + UDim2.fromScale(0,Streamer[2])

		if Streamer[1].Position.Y.Scale >= 1+Particle.Size.Y.Scale*TRAIL_LENGTH then
			Streamer[1].Position = UDim2.fromScale((i-1)*StreamerWidth,RNG:NextNumber(-0.2,-0.05))
			Streamer[2] = RNG:NextNumber(SPEED*0.5,SPEED*1.5)
		end

		for a = 1,TRAIL_LENGTH do
			local Trail = Streamer[3][a]
			Trail.Text = RandomSymbol()
			Trail.Position = Position + UDim2.fromScale(0,-Streamer[1].Size.Y.Scale*a/2)
		end
	end
end)
