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
local TRAIL_LENGTH,SPEED = 10,5
local Streamers = {}
local Symbols = `0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ~!@#$%^&*()-_=+{"{}"}[]\|;:'"<,>.?/`


StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All,false)

local function RandomSymbol()
	local rng = math.random(1,#Symbols)
	return Symbols:sub(rng,rng)
end

local function AnimateStreamer(index:number)
	local Table = Streamers[index]
	local Streamer = Table[1]
	local Trail = Table[2]
	
	local duration = RNG:NextNumber(SPEED*0.25,SPEED*1.25)+(-Streamer.Position.Y.Scale)*10
	local goal = 1+Particle.Size.Y.Scale*TRAIL_LENGTH+(-Streamer.Position.Y.Scale)
	Tween:Create(Streamer,TweenInfo.new(duration,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut),{Position = UDim2.fromScale(Streamer.Position.X.Scale,goal)}):Play()

	for i = 1,TRAIL_LENGTH do
		local TrailPart = Trail[i]
		local particleGoal = 1+Particle.Size.Y.Scale*(TRAIL_LENGTH-i)+(-Streamer.Position.Y.Scale)
		local TrailTween = Tween:Create(TrailPart,TweenInfo.new(duration,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut),{Position = UDim2.fromScale(TrailPart.Position.X.Scale,particleGoal)})
		TrailTween:Play()
		
		if i == TRAIL_LENGTH then
			local con
			con = TrailTween.Completed:Connect(function()
				Streamer.Position = UDim2.fromScale(index*StreamerWidth,RNG:NextNumber(-0.3,-0.05))
				
				for x = 1,TRAIL_LENGTH do
					local T = Trail[x]
					T.Position = Streamer.Position + UDim2.fromScale(0,-(Streamer.Size.Y.Scale/2)*x)
				end
				
				AnimateStreamer(index)
				
				con:Disconnect()
				con = nil
			end)
		end
	end
end

for i = 0,MAX_STREAMERS do
	local Clone = Particle:Clone()
	Clone.Visible = true
	Clone.Parent = Main
	Clone.Name = "Streamer"
	Clone.Text = RandomSymbol()
	Clone.Position = UDim2.fromScale(i*StreamerWidth,RNG:NextNumber(-1,-0.125))
	Streamers[i] = {Clone,{}}
	for x = 1,TRAIL_LENGTH do
		local Trail = Clone:Clone()
		Trail.Parent = Main
		Trail.Name = "Trail"
		Trail.Text = RandomSymbol()
		Trail.Position = Clone.Position + UDim2.fromScale(0,-(Clone.Size.Y.Scale/2)*x)
		Trail.UIStroke.Color = Color3.fromRGB(7, 72, 1)
		Trail.TextColor3 = Color3.fromRGB(20, 218, 2)
		table.insert(Streamers[i][2],Trail)
	end
end

for index = 0,MAX_STREAMERS do
	AnimateStreamer(index)
end

RunService.RenderStepped:Connect(function()
	for i = 0,MAX_STREAMERS do
		local Streamer = Streamers[i][1]
		Streamer.Text = RandomSymbol()
		for x = 1,TRAIL_LENGTH do
			local Trail = Streamers[i][2][x]
			Trail.Text = RandomSymbol()
		end
	end
end)