local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local ParentGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local Library = {Flags = {}, Windows = {}, LastWindow = nil, MinimizeKey = Enum.KeyCode.LeftControl}

local MinimizeNotif = false
local Mobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

function Library:SafeCallback(Function, ...)
	if not Function then
		return
	end

	local Success, Event = pcall(Function, ...)
	if not Success then
		Event = tostring(Event)
		local _, i = Event:find(":%d+: ")

		if not i then
			return Library:Notify({
				Title = "Interface",
				Content = "Callback error",
				SubContent = Event,
				Duration = 5,
			})
		end

		return Library:Notify({
			Title = "Interface",
			Content = "Callback error",
			SubContent = Event:sub(i + 1),
			Duration = 5,
		})
	end
end

Library.ThemeOrder = {
	"Dark",
	"Darker",
	"AMOLED",
	"Light",
	"Balloon",
	"SoftCream",
	"Aqua",
	"Amethyst",
	"Rose",
	"Midnight",
	"Forest",
	"Sunset",
	"Ocean",
	"Emerald",
	"Sapphire",
	"Cloud",
	"Grape",
	"Bloody",
	"Arctic",
}

Library.Themes = {
	Dark = {
		Background = Color3.fromRGB(32, 32, 32),
		Sidebar = Color3.fromRGB(27, 27, 27),
		Card = Color3.fromRGB(44, 44, 44),
		CardHover = Color3.fromRGB(54, 54, 54),
		Stroke = Color3.fromRGB(66, 66, 66),
		Text = Color3.fromRGB(255, 255, 255),
		SubText = Color3.fromRGB(172, 172, 172),
		Accent = Color3.fromRGB(96, 205, 255),
		AccentText = Color3.fromRGB(0, 0, 0),
		Track = Color3.fromRGB(88, 88, 88),
	},
	Darker = {
		Background = Color3.fromRGB(20, 20, 20),
		Sidebar = Color3.fromRGB(15, 15, 15),
		Card = Color3.fromRGB(30, 30, 30),
		CardHover = Color3.fromRGB(40, 40, 40),
		Stroke = Color3.fromRGB(52, 52, 52),
		Text = Color3.fromRGB(255, 255, 255),
		SubText = Color3.fromRGB(160, 160, 160),
		Accent = Color3.fromRGB(96, 205, 255),
		AccentText = Color3.fromRGB(0, 0, 0),
		Track = Color3.fromRGB(70, 70, 70),
	},
	AMOLED = {
		Background = Color3.fromRGB(0, 0, 0),
		Sidebar = Color3.fromRGB(0, 0, 0),
		Card = Color3.fromRGB(14, 14, 14),
		CardHover = Color3.fromRGB(24, 24, 24),
		Stroke = Color3.fromRGB(38, 38, 38),
		Text = Color3.fromRGB(255, 255, 255),
		SubText = Color3.fromRGB(150, 150, 150),
		Accent = Color3.fromRGB(80, 200, 255),
		AccentText = Color3.fromRGB(0, 0, 0),
		Track = Color3.fromRGB(60, 60, 60),
	},
	Light = {
		Background = Color3.fromRGB(243, 243, 243),
		Sidebar = Color3.fromRGB(235, 235, 235),
		Card = Color3.fromRGB(252, 252, 252),
		CardHover = Color3.fromRGB(244, 244, 244),
		Stroke = Color3.fromRGB(215, 215, 215),
		Text = Color3.fromRGB(27, 27, 27),
		SubText = Color3.fromRGB(96, 96, 96),
		Accent = Color3.fromRGB(0, 103, 192),
		AccentText = Color3.fromRGB(255, 255, 255),
		Track = Color3.fromRGB(160, 160, 160),
	},
	Balloon = {
		Background = Color3.fromRGB(255, 243, 248),
		Sidebar = Color3.fromRGB(252, 232, 242),
		Card = Color3.fromRGB(255, 255, 255),
		CardHover = Color3.fromRGB(255, 238, 246),
		Stroke = Color3.fromRGB(240, 206, 222),
		Text = Color3.fromRGB(58, 32, 48),
		SubText = Color3.fromRGB(150, 108, 130),
		Accent = Color3.fromRGB(255, 92, 160),
		AccentText = Color3.fromRGB(255, 255, 255),
		Track = Color3.fromRGB(230, 190, 208),
	},
	SoftCream = {
		Background = Color3.fromRGB(250, 246, 236),
		Sidebar = Color3.fromRGB(243, 237, 223),
		Card = Color3.fromRGB(255, 252, 244),
		CardHover = Color3.fromRGB(246, 240, 226),
		Stroke = Color3.fromRGB(225, 216, 196),
		Text = Color3.fromRGB(52, 46, 36),
		SubText = Color3.fromRGB(128, 118, 98),
		Accent = Color3.fromRGB(196, 138, 60),
		AccentText = Color3.fromRGB(255, 255, 255),
		Track = Color3.fromRGB(206, 196, 174),
	},
	Aqua = {
		Background = Color3.fromRGB(232, 248, 250),
		Sidebar = Color3.fromRGB(220, 240, 244),
		Card = Color3.fromRGB(246, 253, 254),
		CardHover = Color3.fromRGB(230, 246, 248),
		Stroke = Color3.fromRGB(188, 224, 230),
		Text = Color3.fromRGB(16, 52, 60),
		SubText = Color3.fromRGB(80, 124, 134),
		Accent = Color3.fromRGB(0, 160, 176),
		AccentText = Color3.fromRGB(255, 255, 255),
		Track = Color3.fromRGB(168, 208, 216),
	},
	Amethyst = {
		Background = Color3.fromRGB(30, 20, 44),
		Sidebar = Color3.fromRGB(23, 15, 35),
		Card = Color3.fromRGB(45, 32, 66),
		CardHover = Color3.fromRGB(57, 42, 82),
		Stroke = Color3.fromRGB(78, 60, 110),
		Text = Color3.fromRGB(244, 236, 255),
		SubText = Color3.fromRGB(170, 152, 200),
		Accent = Color3.fromRGB(190, 120, 255),
		AccentText = Color3.fromRGB(24, 6, 46),
		Track = Color3.fromRGB(84, 66, 116),
	},
	Rose = {
		Background = Color3.fromRGB(36, 24, 30),
		Sidebar = Color3.fromRGB(29, 18, 24),
		Card = Color3.fromRGB(51, 35, 43),
		CardHover = Color3.fromRGB(63, 43, 53),
		Stroke = Color3.fromRGB(86, 58, 72),
		Text = Color3.fromRGB(255, 240, 245),
		SubText = Color3.fromRGB(185, 150, 163),
		Accent = Color3.fromRGB(255, 121, 160),
		AccentText = Color3.fromRGB(40, 6, 18),
		Track = Color3.fromRGB(92, 66, 78),
	},
	Midnight = {
		Background = Color3.fromRGB(13, 17, 28),
		Sidebar = Color3.fromRGB(9, 12, 21),
		Card = Color3.fromRGB(22, 28, 45),
		CardHover = Color3.fromRGB(31, 39, 63),
		Stroke = Color3.fromRGB(42, 52, 82),
		Text = Color3.fromRGB(236, 240, 255),
		SubText = Color3.fromRGB(140, 152, 184),
		Accent = Color3.fromRGB(122, 162, 255),
		AccentText = Color3.fromRGB(8, 12, 24),
		Track = Color3.fromRGB(52, 62, 92),
	},
	Forest = {
		Background = Color3.fromRGB(16, 28, 20),
		Sidebar = Color3.fromRGB(11, 21, 15),
		Card = Color3.fromRGB(25, 42, 31),
		CardHover = Color3.fromRGB(33, 54, 40),
		Stroke = Color3.fromRGB(46, 72, 54),
		Text = Color3.fromRGB(232, 248, 236),
		SubText = Color3.fromRGB(130, 164, 140),
		Accent = Color3.fromRGB(110, 200, 90),
		AccentText = Color3.fromRGB(8, 26, 6),
		Track = Color3.fromRGB(52, 80, 60),
	},
	Sunset = {
		Background = Color3.fromRGB(34, 20, 24),
		Sidebar = Color3.fromRGB(27, 15, 19),
		Card = Color3.fromRGB(52, 32, 36),
		CardHover = Color3.fromRGB(66, 40, 42),
		Stroke = Color3.fromRGB(92, 56, 56),
		Text = Color3.fromRGB(255, 240, 232),
		SubText = Color3.fromRGB(196, 152, 140),
		Accent = Color3.fromRGB(255, 128, 72),
		AccentText = Color3.fromRGB(40, 12, 0),
		Track = Color3.fromRGB(98, 64, 60),
	},
	Ocean = {
		Background = Color3.fromRGB(12, 27, 38),
		Sidebar = Color3.fromRGB(8, 20, 29),
		Card = Color3.fromRGB(20, 42, 57),
		CardHover = Color3.fromRGB(28, 56, 75),
		Stroke = Color3.fromRGB(38, 72, 94),
		Text = Color3.fromRGB(232, 248, 252),
		SubText = Color3.fromRGB(137, 170, 184),
		Accent = Color3.fromRGB(56, 214, 200),
		AccentText = Color3.fromRGB(4, 24, 24),
		Track = Color3.fromRGB(46, 80, 100),
	},
	Emerald = {
		Background = Color3.fromRGB(20, 30, 25),
		Sidebar = Color3.fromRGB(15, 24, 19),
		Card = Color3.fromRGB(30, 45, 37),
		CardHover = Color3.fromRGB(38, 57, 47),
		Stroke = Color3.fromRGB(52, 76, 62),
		Text = Color3.fromRGB(236, 252, 242),
		SubText = Color3.fromRGB(142, 176, 155),
		Accent = Color3.fromRGB(80, 220, 130),
		AccentText = Color3.fromRGB(4, 28, 14),
		Track = Color3.fromRGB(58, 84, 68),
	},
	Sapphire = {
		Background = Color3.fromRGB(14, 22, 46),
		Sidebar = Color3.fromRGB(9, 16, 36),
		Card = Color3.fromRGB(22, 34, 68),
		CardHover = Color3.fromRGB(30, 46, 88),
		Stroke = Color3.fromRGB(44, 64, 118),
		Text = Color3.fromRGB(232, 240, 255),
		SubText = Color3.fromRGB(138, 158, 204),
		Accent = Color3.fromRGB(64, 128, 255),
		AccentText = Color3.fromRGB(255, 255, 255),
		Track = Color3.fromRGB(50, 72, 126),
	},
	Cloud = {
		Background = Color3.fromRGB(238, 242, 248),
		Sidebar = Color3.fromRGB(228, 234, 243),
		Card = Color3.fromRGB(250, 252, 255),
		CardHover = Color3.fromRGB(238, 243, 250),
		Stroke = Color3.fromRGB(208, 217, 230),
		Text = Color3.fromRGB(28, 36, 52),
		SubText = Color3.fromRGB(100, 112, 134),
		Accent = Color3.fromRGB(70, 120, 220),
		AccentText = Color3.fromRGB(255, 255, 255),
		Track = Color3.fromRGB(176, 188, 208),
	},
	Grape = {
		Background = Color3.fromRGB(36, 18, 40),
		Sidebar = Color3.fromRGB(28, 12, 32),
		Card = Color3.fromRGB(56, 30, 62),
		CardHover = Color3.fromRGB(70, 40, 78),
		Stroke = Color3.fromRGB(98, 56, 106),
		Text = Color3.fromRGB(255, 238, 255),
		SubText = Color3.fromRGB(190, 150, 196),
		Accent = Color3.fromRGB(220, 100, 230),
		AccentText = Color3.fromRGB(40, 4, 44),
		Track = Color3.fromRGB(104, 62, 112),
	},
	Bloody = {
		Background = Color3.fromRGB(24, 8, 10),
		Sidebar = Color3.fromRGB(17, 4, 6),
		Card = Color3.fromRGB(42, 14, 18),
		CardHover = Color3.fromRGB(56, 18, 24),
		Stroke = Color3.fromRGB(84, 26, 32),
		Text = Color3.fromRGB(255, 232, 232),
		SubText = Color3.fromRGB(188, 128, 132),
		Accent = Color3.fromRGB(220, 20, 40),
		AccentText = Color3.fromRGB(255, 255, 255),
		Track = Color3.fromRGB(92, 30, 36),
	},
	Arctic = {
		Background = Color3.fromRGB(244, 249, 252),
		Sidebar = Color3.fromRGB(232, 242, 248),
		Card = Color3.fromRGB(255, 255, 255),
		CardHover = Color3.fromRGB(238, 246, 251),
		Stroke = Color3.fromRGB(204, 222, 234),
		Text = Color3.fromRGB(20, 40, 56),
		SubText = Color3.fromRGB(90, 116, 134),
		Accent = Color3.fromRGB(40, 150, 220),
		AccentText = Color3.fromRGB(255, 255, 255),
		Track = Color3.fromRGB(180, 202, 218),
	},
}

Library.Fonts = {
	Regular = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
	Medium = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
	SemiBold = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
}

Library.Icons = {
	Min = "rbxassetid://9886659276",
	Max = "rbxassetid://9886659406",
	Restore = "rbxassetid://9886659001",
	Close = "rbxassetid://9886659671",
}

local function resolveTheme(value)
	if type(value) == "string" and Library.Themes[value] then
		return Library.Themes[value], value
	end
	if type(value) == "table" then
		local merged = {}
		for k, v in pairs(Library.Themes.Dark) do
			merged[k] = v
		end
		for k, v in pairs(value) do
			merged[k] = v
		end
		return merged, tostring(value.Name or "Custom")
	end
	return Library.Themes.Dark, "Dark"
end

function Library:GetThemes()
	local names = {}
	for _, name in ipairs(self.ThemeOrder) do
		if self.Themes[name] then
			table.insert(names, name)
		end
	end
	return names
end

local function create(class, props, children)
	local inst = Instance.new(class)
	local parent
	if props then
		for k, v in pairs(props) do
			if k == "Parent" then
				parent = v
			else
				inst[k] = v
			end
		end
	end
	if children then
		for _, child in ipairs(children) do
			child.Parent = inst
		end
	end
	inst.Parent = parent
	return inst
end

local activeTweens = setmetatable({}, {__mode = "k"})

local function cancelTweens(inst)
	local list = activeTweens[inst]
	if list then
		activeTweens[inst] = nil
		for running in pairs(list) do
			running:Cancel()
		end
	end
end

local function tween(inst, duration, props)
	if not duration or duration <= 0 then
		cancelTweens(inst)
		for k, v in pairs(props) do
			inst[k] = v
		end
		return
	end
	local t = TweenService:Create(inst, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
	local list = activeTweens[inst]
	if not list then
		list = {}
		activeTweens[inst] = list
	end
	list[t] = true
	t.Completed:Connect(function()
		list[t] = nil
		if next(list) == nil and activeTweens[inst] == list then
			activeTweens[inst] = nil
		end
	end)
	t:Play()
	return t
end

local function corner(parent, radius)
	return create("UICorner", {CornerRadius = UDim.new(0, radius), Parent = parent})
end

local function stroke(parent, thickness, transparency)
	return create("UIStroke", {
		Thickness = thickness or 1,
		Transparency = transparency or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = parent,
	})
end

local function pad(parent, top, bottom, left, right)
	return create("UIPadding", {
		PaddingTop = UDim.new(0, top),
		PaddingBottom = UDim.new(0, bottom),
		PaddingLeft = UDim.new(0, left),
		PaddingRight = UDim.new(0, right),
		Parent = parent,
	})
end

local ColorNames = {
	red = "#FF5555",
	green = "#55DD77",
	blue = "#5599FF",
	yellow = "#FFD94A",
	orange = "#FF9A3C",
	purple = "#B280FF",
	pink = "#FF79A8",
	cyan = "#4DE0E0",
	white = "#FFFFFF",
	gray = "#AAAAAA",
	black = "#000000",
}

local function rich(value)
	value = tostring(value == nil and "" or value)
	value = string.gsub(value, "<color=([^>]-)>", function(c)
		local key = string.lower((string.gsub(c, "[\"'%s]", "")))
		return '<font color="' .. (ColorNames[key] or key) .. '">'
	end)
	value = string.gsub(value, "</color>", "</font>")
	return value
end

local function stripTags(value)
	return (string.gsub(tostring(value == nil and "" or value), "<[^>]*>", ""))
end

local function ensureFolders(path)
	if typeof(isfolder) ~= "function" or typeof(makefolder) ~= "function" then
		return
	end
	local parts = string.split(path, "/")
	table.remove(parts)
	local current = ""
	for _, part in ipairs(parts) do
		if part ~= "" then
			current = current == "" and part or (current .. "/" .. part)
			local ok, exists = pcall(isfolder, current)
			if ok and not exists then
				pcall(makefolder, current)
			end
		end
	end
end
local function text(props)
	local p = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		FontFace = Library.Fonts.Regular,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		Text = "",
	}
	for k, v in pairs(props) do
		p[k] = v
	end
	if p.RichText == true then
		p.Text = rich(p.Text)
	end
	return create("TextLabel", p)
end

local function fire(callback, ...)
	if typeof(callback) == "function" then
		task.spawn(Library.SafeCallback, Library, callback, ...)
	end
end

local DigitKeys = {
	["0"] = "Zero", ["1"] = "One", ["2"] = "Two", ["3"] = "Three", ["4"] = "Four",
	["5"] = "Five", ["6"] = "Six", ["7"] = "Seven", ["8"] = "Eight", ["9"] = "Nine",
	[" "] = "Space", ["-"] = "Minus", ["="] = "Equals", ["["] = "LeftBracket",
	["]"] = "RightBracket", [";"] = "Semicolon", ["'"] = "Quote", [","] = "Comma",
	["."] = "Period", ["/"] = "Slash", ["\\"] = "BackSlash", ["`"] = "Backquote",
}

local function resolveKeyCode(key)
	if typeof(key) == "EnumItem" then
		if key.EnumType == Enum.KeyCode then
			return key
		end
		return nil
	end
	if type(key) ~= "string" or key == "" then
		return nil
	end
	local mapped = DigitKeys[key]
	if mapped then
		return Enum.KeyCode[mapped]
	end
	local lowered = string.lower(key)
	for _, item in ipairs(Enum.KeyCode:GetEnumItems()) do
		if string.lower(item.Name) == lowered then
			return item
		end
	end
	return nil
end

local function isPress(input)
	return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
end

local function isMove(input)
	return input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch
end

local function protectGui(gui)
	local candidates = {
		function()
			return syn and syn.protect_gui
		end,
		function()
			return protect_gui
		end,
		function()
			return protectgui
		end,
		function()
			return gethui_protect
		end,
	}
	for _, getter in ipairs(candidates) do
		local okGet, fn = pcall(getter)
		if okGet and typeof(fn) == "function" then
			if pcall(fn, gui) then
				return true
			end
		end
	end
	return false
end

local function makeDraggable(handle, target, connect, onClick, threshold, canDrag)
	local dragging = false
	local moved = false
	local startMouse
	local startPos
	threshold = threshold or 0

	connect(handle.InputBegan, function(input)
		if isPress(input) and (not canDrag or canDrag()) then
			dragging = true
			moved = false
			startMouse = input.Position
			startPos = target.Position
		end
	end)

	connect(UserInputService.InputChanged, function(input)
		if dragging and isMove(input) then
			local delta = input.Position - startMouse
			if delta.Magnitude > threshold then
				moved = true
			end
			if moved then
				target.Position = UDim2.new(
					startPos.X.Scale,
					startPos.X.Offset + delta.X,
					startPos.Y.Scale,
					startPos.Y.Offset + delta.Y
				)
			end
		end
	end)

	connect(UserInputService.InputEnded, function(input)
		if dragging and isPress(input) then
			dragging = false
			if not moved and onClick then
				onClick()
			end
		end
	end)
end

local function chevron(parent, rotation, bind)
	local holder = create("Frame", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(14, 8),
		Rotation = rotation or 0,
		Parent = parent,
	})
	for _, data in ipairs({{4, 45}, {10, -45}}) do
		local arm = create("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromOffset(data[1], 4),
			Size = UDim2.fromOffset(8, 2),
			Rotation = data[2],
			BorderSizePixel = 0,
			Parent = holder,
		})
		corner(arm, 1)
		bind(arm, {BackgroundColor3 = "SubText"})
	end
	return holder
end

function Library:CreateWindow(config)
	config = config or {}

	local Window = {
		Tabs = {},
		Binds = {},
		Glass = {},
		PopupClosers = {},
		Connections = {},
		Visible = true,
		HoverLocks = 0,
		Destroyed = false,
		CurrentTab = nil,
		Minimizer = nil,
		Maximized = false,
		Minimized = false,
	}

	local title = tostring(config.Title or "Window")
	local subTitle = tostring(config.SubTitle or config.Description or "")
	local tabWidth = math.clamp(tonumber(config.TabWidth) or 140, 80, 260)
	local size = config.Size or UDim2.fromOffset(640, 420)
	local minimizeKey = config.MinimizeKey
	if minimizeKey == nil then
		minimizeKey = config.ToggleKey
	end
	minimizeKey = resolveKeyCode(minimizeKey)
	if minimizeKey then
		Library.MinimizeKey = minimizeKey
	end

	local searchEnabled = config.Search
	if searchEnabled == nil then
		searchEnabled = true
	end
	searchEnabled = searchEnabled ~= false
	local searchOffset = searchEnabled and 48 or 0
	local searchQuery = ""

	local transparentConfig = config.Transparent
	if transparentConfig == nil then
		transparentConfig = config.Transparency
	end
	Window.Transparent = transparentConfig ~= false

	Window.Theme, Window.ThemeName = resolveTheme(config.Theme)

	Window.FlagGroups = {}
	Window.FlagKeys = {}
	Window.FlagList = {}
	Window.SaveData = {}
	Window.SaveToken = 0
	Window.SuspendSave = false
	Window.SavePending = false
	Window.HasSave = false

	local savePath = config.SavePath
	if type(savePath) ~= "string" or savePath == "" then
		savePath = (string.gsub(stripTags(title), '[<>:"|?*/\\]', "_")) .. ".json"
	end
	savePath = (string.gsub(savePath, "\\", "/"))
	Window.SavePath = savePath

	local SaveManager = {}
	local warnedFs = false

	local function fsReady()
		return typeof(writefile) == "function" and typeof(readfile) == "function" and typeof(isfile) == "function"
	end

	local function saveRecords()
		local list = {}
		for _, rec in ipairs(Window.FlagList) do
			if rec.Save and rec.Get and rec.Set then
				table.insert(list, rec)
			end
		end
		return list
	end

	local function collectFlags()
		local flags = {}
		for _, rec in ipairs(saveRecords()) do
			local ok, value = pcall(rec.Get)
			if ok and value ~= nil then
				flags[rec.Key] = value
			end
		end
		return flags
	end

	local function extractFlags(decoded)
		if type(decoded.Flags) == "table" then
			return decoded.Flags
		end
		return decoded
	end

	local function readSaveFile()
		if not fsReady() then
			return {}
		end
		local okExists, exists = pcall(isfile, savePath)
		if not okExists or not exists then
			return {}
		end
		local okRead, raw = pcall(readfile, savePath)
		if not okRead or type(raw) ~= "string" or raw == "" then
			return {}
		end
		local okDecode, decoded = pcall(function()
			return HttpService:JSONDecode(raw)
		end)
		if not okDecode or type(decoded) ~= "table" then
			return {}
		end
		return extractFlags(decoded)
	end

	function SaveManager:ExportSave()
		return HttpService:JSONEncode({Flags = collectFlags()})
	end

	function SaveManager:ClearSave()
		Window.SuspendSave = true
		for _, rec in ipairs(saveRecords()) do
			pcall(rec.Set, rec.Default, false)
		end
		Window.SuspendSave = false
		Window.SaveData = {}
		Window.SavePending = false
		Window.SaveToken += 1
		if fsReady() then
			local okExists, exists = pcall(isfile, savePath)
			if okExists and exists then
				if typeof(delfile) == "function" then
					pcall(delfile, savePath)
				else
					pcall(writefile, savePath, HttpService:JSONEncode({Flags = {}}))
				end
			end
		end
		return true
	end

	function SaveManager:ImportSave(raw)
		if type(raw) ~= "string" or raw == "" then
			error("empty save string", 0)
		end
		local okDecode, decoded = pcall(function()
			return HttpService:JSONDecode(raw)
		end)
		if not okDecode or type(decoded) ~= "table" then
			error("invalid save string", 0)
		end
		local flags = extractFlags(decoded)
		Window.SuspendSave = true
		for _, rec in ipairs(saveRecords()) do
			local value = flags[rec.Key]
			if value ~= nil then
				pcall(rec.Set, value, false)
			end
		end
		Window.SuspendSave = false
		Window.SaveData = flags
		Window:_QueueSave()
		return true
	end

	function Window:ImportSave(raw)
		return SaveManager:ImportSave(raw)
	end

	function Window:ExportSave()
		return SaveManager:ExportSave()
	end

	function Window:ClearSave()
		return SaveManager:ClearSave()
	end

	function Window:_WriteSave()
		if not self.HasSave then
			return false
		end
		self.SavePending = false
		if not fsReady() then
			if not warnedFs then
				warnedFs = true
				warn("FluentUI: writefile unavailable, SaveManager disabled")
			end
			return false
		end
		ensureFolders(savePath)
		return (pcall(writefile, savePath, SaveManager:ExportSave()))
	end

	function Window:_QueueSave(rec)
		if self.SuspendSave or not self.HasSave then
			return
		end
		if rec and not rec.Save then
			return
		end
		self.SavePending = true
		self.SaveToken += 1
		local token = self.SaveToken
		task.delay(0.4, function()
			if token == self.SaveToken and not self.Destroyed and self.SavePending then
				self:_WriteSave()
			end
		end)
	end

	Window.SaveManager = SaveManager
	Library.SaveManager = SaveManager
	Window.SaveData = readSaveFile()

	local camera = workspace.CurrentCamera
	if camera and size.X.Scale == 0 and size.Y.Scale == 0 then
		local viewport = camera.ViewportSize
		if viewport.X > 100 and viewport.Y > 100 then
			size = UDim2.fromOffset(math.min(size.X.Offset, viewport.X - 24), math.min(size.Y.Offset, viewport.Y - 24))
		end
	end

	local gui = create("ScreenGui", {
		Name = "FluentUI_" .. tostring(math.random(1000, 9999)),
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		IgnoreGuiInset = true,
		DisplayOrder = 100,
	})
	protectGui(gui)
	gui.Parent = ParentGui
	Window.Gui = gui

	local function connect(signal, fn)
		local connection = signal:Connect(fn)
		table.insert(Window.Connections, connection)
		return connection
	end

	local function register(inst, fn)
		table.insert(Window.Binds, {Instance = inst, Fn = fn})
		fn(Window.Theme)
	end

	local function bindFn(inst, fn)
		register(inst, fn)
	end

	local function bind(inst, props)
		register(inst, function(th)
			cancelTweens(inst)
			for prop, value in pairs(props) do
				if type(value) == "function" then
					inst[prop] = value(th)
				else
					inst[prop] = th[value]
				end
			end
		end)
	end

	local function glass(inst, solid, clear)
		table.insert(Window.Glass, {Instance = inst, Solid = solid, Clear = clear})
		inst.BackgroundTransparency = Window.Transparent and clear or solid
	end

	local main = create("Frame", {
		Name = "Main",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = size,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = gui,
	})
	local mainCorner = corner(main, 9)
	local mainStroke = stroke(main, 1, 0.3)
	bind(main, {BackgroundColor3 = "Background"})
	glass(main, 0, 0.2)
	bind(mainStroke, {Color = "Stroke"})
	Window.Main = main

	local header = create("Frame", {
		Name = "Header",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 46),
		Parent = main,
	})

	local headerTitle = create("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(12, 0),
		Size = UDim2.new(1, -150, 1, 0),
		ClipsDescendants = true,
		Parent = header,
	})
	create("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding = UDim.new(0, 5),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = headerTitle,
	})

	local iconValue = config.Icon and tostring(config.Icon) or ""
	local hasIcon = iconValue ~= ""
	if hasIcon then
		local titleIcon = create("ImageLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(20, 20),
			Image = iconValue,
			LayoutOrder = 1,
			Parent = headerTitle,
		})
		bind(titleIcon, {ImageColor3 = "Text"})
	end

	local titleLabel = text({
		Size = UDim2.fromScale(0, 1),
		AutomaticSize = Enum.AutomaticSize.X,
		FontFace = Library.Fonts.SemiBold,
		TextSize = 13,
		RichText = true,
		Text = title,
		LayoutOrder = hasIcon and 2 or 1,
		Parent = headerTitle,
	})
	bind(titleLabel, {TextColor3 = "Text"})

	local subTitleLabel = text({
		Size = UDim2.fromScale(0, 1),
		AutomaticSize = Enum.AutomaticSize.X,
		FontFace = Library.Fonts.Regular,
		TextSize = 13,
		TextTransparency = 0.4,
		RichText = true,
		Text = subTitle,
		Visible = subTitle ~= "",
		LayoutOrder = hasIcon and 3 or 2,
		Parent = headerTitle,
	})
	bind(subTitleLabel, {TextColor3 = "Text"})

	local headerLine = create("Frame", {
		Position = UDim2.fromOffset(0, 46),
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundTransparency = 0.4,
		BorderSizePixel = 0,
		Parent = main,
	})
	bind(headerLine, {BackgroundColor3 = "Stroke"})

	local body = create("Frame", {
		Name = "Body",
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, 47),
		Size = UDim2.new(1, 0, 1, -47),
		Parent = main,
	})

	local sidebar = create("Frame", {
		Name = "Sidebar",
		BackgroundTransparency = 1,
		Size = UDim2.new(0, tabWidth, 1, 0),
		Parent = body,
	})

	local sideLine = create("Frame", {
		Position = UDim2.fromOffset(tabWidth, 0),
		Size = UDim2.new(0, 1, 1, 0),
		BackgroundTransparency = 0.4,
		BorderSizePixel = 0,
		Parent = body,
	})
	bind(sideLine, {BackgroundColor3 = "Stroke"})

	local tabList = create("ScrollingFrame", {
		Name = "TabList",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(0, searchOffset),
		Size = UDim2.new(1, 0, 1, -searchOffset),
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 0,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ElasticBehavior = Enum.ElasticBehavior.Never,
		Parent = sidebar,
	})
	pad(tabList, searchEnabled and 2 or 10, 10, 8, 8)
	create("UIListLayout", {
		Padding = UDim.new(0, 4),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = tabList,
	})

	local searchInput
	if searchEnabled then
		local searchHolder = create("Frame", {
			Name = "Search",
			Position = UDim2.fromOffset(8, 10),
			Size = UDim2.new(1, -16, 0, 30),
			BorderSizePixel = 0,
			Parent = sidebar,
		})
		corner(searchHolder, 6)
		local searchStroke = stroke(searchHolder, 1, 0.4)
		bind(searchHolder, {BackgroundColor3 = "CardHover"})
		glass(searchHolder, 0, 0.5)
		bind(searchStroke, {Color = "Stroke"})
		local searchIcon = create("ImageLabel", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 9, 0.5, 0),
			Size = UDim2.fromOffset(16, 16),
			Image = "rbxassetid://10734943674",
			Parent = searchHolder,
		})
		bind(searchIcon, {ImageColor3 = "SubText"})
		searchInput = create("TextBox", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(32, 0),
			Size = UDim2.new(1, -38, 1, 0),
			FontFace = Library.Fonts.Regular,
			TextSize = 13,
			PlaceholderText = "Search...",
			Text = "",
			ClearTextOnFocus = false,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = searchHolder,
		})
		bind(searchInput, {TextColor3 = "Text", PlaceholderColor3 = "SubText"})
	end

	local content = create("Frame", {
		Name = "Content",
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(tabWidth + 1, 0),
		Size = UDim2.new(1, -(tabWidth + 1), 1, 0),
		Parent = body,
	})

	local topBar = create("Frame", {
		Name = "TopBar",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 52),
		Parent = content,
	})

	local headingTitle = text({
		Position = UDim2.fromOffset(20, 14),
		Size = UDim2.new(1, -40, 0, 22),
		FontFace = Library.Fonts.SemiBold,
		TextSize = 18,
		RichText = true,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = topBar,
	})
	bind(headingTitle, {TextColor3 = "Text"})

	local headingDesc = text({
		Position = UDim2.fromOffset(20, 31),
		Size = UDim2.new(1, -40, 0, 14),
		TextSize = 11,
		Visible = false,
		RichText = true,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = topBar,
	})
	bind(headingDesc, {TextColor3 = "SubText"})

	local pages = create("Frame", {
		Name = "Pages",
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, 52),
		Size = UDim2.new(1, 0, 1, -52),
		ClipsDescendants = true,
		Parent = content,
	})

	local noResults = text({
		Position = UDim2.fromOffset(0, 24),
		Size = UDim2.new(1, 0, 0, 24),
		Text = "No results",
		TextXAlignment = Enum.TextXAlignment.Center,
		Visible = false,
		Parent = pages,
	})
	bind(noResults, {TextColor3 = "SubText"})

	local function captionButton(offsetX)
		local button = create("TextButton", {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, offsetX, 0, 9),
			Size = UDim2.fromOffset(36, 28),
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			Text = "",
			BorderSizePixel = 0,
			ZIndex = 6,
			Parent = main,
		})
		corner(button, 6)
		return button
	end

	local minButton = captionButton(-88)
	bind(minButton, {BackgroundColor3 = "CardHover"})
	local minIcon = create("ImageLabel", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(20, 20),
		Image = Library.Icons.Min,
		ZIndex = 7,
		Parent = minButton,
	})
	bind(minIcon, {ImageColor3 = "Text"})

	local maxButton = captionButton(-48)
	bind(maxButton, {BackgroundColor3 = "CardHover"})
	local maxIcon = create("ImageLabel", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(20, 20),
		Image = Library.Icons.Max,
		ZIndex = 7,
		Parent = maxButton,
	})
	bind(maxIcon, {ImageColor3 = "Text"})

	local closeButton = captionButton(-8)
	bind(closeButton, {BackgroundColor3 = "CardHover"})
	local closeIcon = create("ImageLabel", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(20, 20),
		Image = Library.Icons.Close,
		ZIndex = 7,
		Parent = closeButton,
	})
	bind(closeIcon, {ImageColor3 = "Text"})

	connect(minButton.MouseEnter, function()
		tween(minButton, 0.12, {BackgroundTransparency = 0})
	end)
	connect(minButton.MouseLeave, function()
		tween(minButton, 0.12, {BackgroundTransparency = 1})
	end)
	connect(maxButton.MouseEnter, function()
		tween(maxButton, 0.12, {BackgroundTransparency = 0})
	end)
	connect(maxButton.MouseLeave, function()
		tween(maxButton, 0.12, {BackgroundTransparency = 1})
	end)
	connect(closeButton.MouseEnter, function()
		tween(closeButton, 0.12, {BackgroundTransparency = 0})
	end)
	connect(closeButton.MouseLeave, function()
		tween(closeButton, 0.12, {BackgroundTransparency = 1})
	end)

	makeDraggable(header, main, connect, nil, 0, function()
		return not Window.Maximized
	end)

	function Window:ClosePopups()
		for _, closer in ipairs(self.PopupClosers) do
			closer()
		end
	end

	function Window:SetVisible(state)
		if self.Destroyed then
			return
		end
		state = state == true
		self.Visible = state
		self.Minimized = not state
		if not state then
			self:ClosePopups()
		end
		main.Visible = state
	end

	function Window:SetMinimizeKey(key)
		local item = resolveKeyCode(key)
		if not item then
			warn("Window:SetMinimizeKey: invalid key " .. tostring(key))
			return false
		end
		Library.MinimizeKey = item
		Library.MinimizeKeybind = nil
		return true
	end

	function Window:GetMinimizeKey()
		local custom = Library.MinimizeKeybind
		if type(custom) == "table" and custom.Type == "Keybind" then
			local item = resolveKeyCode(custom.Value)
			if item then
				return item
			end
		end
		return Library.MinimizeKey
	end

	function Window:Minimize()
		if self.Destroyed then
			return
		end
		self:SetVisible(not self.Visible)

		if self.Minimized and not MinimizeNotif then
			MinimizeNotif = true
			if not Mobile then
				self:Notification({
					Title = "Interface",
					Content = "Press " .. self:GetMinimizeKey().Name .. " to toggle the interface.",
					Duration = 6,
				})
			else
				self:Notification({
					Title = "Interface",
					Content = "Tap the button to toggle the interface.",
					Duration = 6,
				})
			end
		end
	end

	function Window:Toggle()
		self:Minimize()
	end

	local restoreSize = main.Size
	local restorePosition = main.Position

	function Window:SetMaximized(state)
		if self.Destroyed then
			return
		end
		if state == nil then
			state = not self.Maximized
		end
		state = state == true
		if state == self.Maximized then
			return
		end
		self:ClosePopups()
		self.Maximized = state
		if state then
			restoreSize = main.Size
			restorePosition = main.Position
			tween(main, 0.2, {
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.fromScale(0.5, 0.5),
			})
			tween(mainCorner, 0.2, {CornerRadius = UDim.new(0, 0)})
			maxIcon.Image = Library.Icons.Restore
		else
			tween(main, 0.2, {
				Size = restoreSize,
				Position = restorePosition,
			})
			tween(mainCorner, 0.2, {CornerRadius = UDim.new(0, 9)})
			maxIcon.Image = Library.Icons.Max
		end
	end

	function Window:SetTransparency(state)
		if state == nil then
			state = not self.Transparent
		end
		self.Transparent = state == true
		local alive = {}
		for _, entry in ipairs(self.Glass) do
			if entry.Instance and entry.Instance:IsDescendantOf(gui) then
				tween(entry.Instance, 0.25, {
					BackgroundTransparency = self.Transparent and entry.Clear or entry.Solid,
				})
				table.insert(alive, entry)
			end
		end
		self.Glass = alive
		for _, tab in ipairs(self.Tabs) do
			tab.Paint(true)
		end
	end

	function Window:Destroy()
		if self.Destroyed then
			return
		end
		if self.SavePending then
			self:_WriteSave()
		end
		self.Destroyed = true
		for _, connection in ipairs(self.Connections) do
			pcall(function()
				connection:Disconnect()
			end)
		end
		self.Connections = {}
		gui:Destroy()
	end

	function Window:SetTheme(value)
		local theme, name = resolveTheme(value)
		self.Theme = theme
		self.ThemeName = name
		local alive = {}
		for _, entry in ipairs(self.Binds) do
			if entry.Instance and entry.Instance:IsDescendantOf(gui) then
				entry.Fn(theme)
				table.insert(alive, entry)
			end
		end
		self.Binds = alive
	end

	function Window:Dialog(cfg)
		if self.Destroyed then
			return nil
		end
		cfg = cfg or {}
		if self.ActiveDialog then
			self.ActiveDialog:Close(true)
		end
		self:ClosePopups()

		local Dialog = {}
		local closed = false
		local buttons = cfg.Buttons
		if type(buttons) ~= "table" or #buttons == 0 then
			buttons = {{Title = "OK"}}
		end
		local count = #buttons

		local tint = create("TextButton", {
			Name = "Dialog",
			AutoButtonColor = false,
			Active = true,
			Text = "",
			BackgroundColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 80,
			Parent = main,
		})
		corner(tint, mainCorner.CornerRadius.Offset)

		local root = create("CanvasGroup", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.new(0, math.clamp(tonumber(cfg.Width) or 300, 240, 520), 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			GroupTransparency = 1,
			BorderSizePixel = 0,
			Parent = tint,
		})
		corner(root, 8)
		local rootStroke = stroke(root, 1, 0.5)
		bind(root, {BackgroundColor3 = "Card"})
		bind(rootStroke, {Color = "Stroke"})
		local rootScale = create("UIScale", {Scale = 1.1, Parent = root})
		create("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = root,
		})

		local top = create("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 1,
			Parent = root,
		})
		pad(top, 24, 22, 20, 20)
		create("UIListLayout", {
			Padding = UDim.new(0, 10),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = top,
		})

		local titleObj = text({
			Size = UDim2.new(1, 0, 0, 22),
			FontFace = Library.Fonts.SemiBold,
			TextSize = 20,
			RichText = true,
			Text = tostring(cfg.Title or "Dialog"),
			TextTruncate = Enum.TextTruncate.AtEnd,
			LayoutOrder = 1,
			Parent = top,
		})
		bind(titleObj, {TextColor3 = "Text"})

		local contentValue = tostring(cfg.Content or "")
		local contentObj = text({
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextSize = 14,
			TextWrapped = true,
			TextYAlignment = Enum.TextYAlignment.Top,
			RichText = true,
			Text = contentValue,
			Visible = contentValue ~= "",
			LayoutOrder = 2,
			Parent = top,
		})
		bind(contentObj, {TextColor3 = "SubText"})

		local bottom = create("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 70),
			LayoutOrder = 2,
			Parent = root,
		})
		bind(bottom, {BackgroundColor3 = "Sidebar"})
		local bottomLine = create("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 1),
			Parent = bottom,
		})
		bind(bottomLine, {BackgroundColor3 = "Stroke"})

		local row = create("Frame", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.new(1, -40, 0, 32),
			Parent = bottom,
		})
		create("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 10),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = row,
		})

		function Dialog:Close(instant)
			if closed then
				return
			end
			closed = true
			if Window.ActiveDialog == Dialog then
				Window.ActiveDialog = nil
			end
			if instant then
				tint:Destroy()
				return
			end
			tween(tint, 0.2, {BackgroundTransparency = 1})
			tween(root, 0.2, {GroupTransparency = 1})
			tween(rootScale, 0.2, {Scale = 1.1})
			task.delay(0.22, function()
				if tint.Parent then
					tint:Destroy()
				end
			end)
		end

		for index, info in ipairs(buttons) do
			if type(info) == "string" then
				info = {Title = info}
			end
			local btn = create("TextButton", {
				AutoButtonColor = false,
				BorderSizePixel = 0,
				Text = stripTags(info.Title or "Button"),
				FontFace = Library.Fonts.Medium,
				TextSize = 13,
				Size = UDim2.new(1 / count, -(10 * (count - 1)) / count, 1, 0),
				LayoutOrder = index,
				Parent = row,
			})
			corner(btn, 6)
			local btnStroke = stroke(btn, 1, 0.3)
			bind(btnStroke, {Color = "Stroke"})
			local hovering = false
			local function paintButton(th, animate)
				tween(btn, animate and 0.12 or 0, {BackgroundColor3 = hovering and th.Stroke or th.CardHover})
				btn.TextColor3 = th.Text
			end
			bindFn(btn, function(th)
				paintButton(th, false)
			end)
			connect(btn.MouseEnter, function()
				hovering = true
				paintButton(Window.Theme, true)
			end)
			connect(btn.MouseLeave, function()
				hovering = false
				paintButton(Window.Theme, true)
			end)
			connect(btn.MouseButton1Click, function()
				Dialog:Close()
				fire(info.Callback)
			end)
		end

		self.ActiveDialog = Dialog
		tween(tint, 0.2, {BackgroundTransparency = 0.75})
		tween(root, 0.2, {GroupTransparency = 0})
		tween(rootScale, 0.2, {Scale = 1})
		return Dialog
	end

	local notifyHolder
	local notifyOrder = 0

	local function getNotifyHolder()
		if notifyHolder and notifyHolder.Parent then
			return notifyHolder
		end
		notifyHolder = create("Frame", {
			Name = "Notifications",
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.new(1, -16, 1, -16),
			Size = UDim2.new(0, 300, 1, -32),
			ZIndex = 100,
			Parent = gui,
		})
		create("UIListLayout", {
			Padding = UDim.new(0, 8),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			Parent = notifyHolder,
		})
		return notifyHolder
	end

	function Window:Notification(cfg)
		if self.Destroyed then
			return nil
		end
		if type(cfg) == "string" then
			cfg = {Content = cfg}
		end
		cfg = cfg or {}
		local titleValue = tostring(cfg.Title or "Title")
		local contentValue = tostring(cfg.Content or "Content")
		local subValue = tostring(cfg.SubContent or "")
		local duration = tonumber(cfg.Duration)

		notifyOrder += 1
		local wrapper = create("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = notifyOrder,
			ZIndex = 100,
			Parent = getNotifyHolder(),
		})

		local card = create("Frame", {
			BorderSizePixel = 0,
			Position = UDim2.new(1, 60, 0, 0),
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			ZIndex = 101,
			Parent = wrapper,
		})
		corner(card, 8)
		local cardStroke = stroke(card, 1, 0.2)
		bind(card, {BackgroundColor3 = "Card"})
		glass(card, 0, 0.08)
		bind(cardStroke, {Color = "Stroke"})

		local inner = create("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			ZIndex = 102,
			Parent = card,
		})
		pad(inner, 15, 16, 14, 40)
		create("UIListLayout", {
			Padding = UDim.new(0, 6),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = inner,
		})

		local function line(value, order, font, size, colorKey)
			local label = text({
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				FontFace = font,
				TextSize = size,
				TextWrapped = true,
				TextYAlignment = Enum.TextYAlignment.Top,
				RichText = true,
				Text = value,
				Visible = value ~= "",
				LayoutOrder = order,
				ZIndex = 103,
				Parent = inner,
			})
			bind(label, {TextColor3 = colorKey})
		end

		line(titleValue, 1, Library.Fonts.Medium, 13, "Text")
		line(contentValue, 2, Library.Fonts.Regular, 14, "Text")
		line(subValue, 3, Library.Fonts.Regular, 13, "SubText")

		local closeButton = create("TextButton", {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -10, 0, 10),
			Size = UDim2.fromOffset(20, 20),
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			Text = "",
			ZIndex = 104,
			Parent = card,
		})
		for _, rotation in ipairs({45, -45}) do
			local arm = create("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(12, 1),
				Rotation = rotation,
				BorderSizePixel = 0,
				ZIndex = 105,
				Parent = closeButton,
			})
			bind(arm, {BackgroundColor3 = "Text"})
		end

		local Notification = {}
		local closed = false

		function Notification:Close()
			if closed then
				return
			end
			closed = true
			tween(card, 0.3, {Position = UDim2.new(1, 60, 0, 0)})
			task.delay(0.35, function()
				if wrapper.Parent then
					wrapper:Destroy()
				end
			end)
		end

		connect(closeButton.MouseButton1Click, function()
			Notification:Close()
		end)

		tween(card, 0.3, {Position = UDim2.new(0, 0, 0, 0)})

		if duration and duration > 0 then
			task.delay(duration, function()
				Notification:Close()
			end)
		end

		return Notification
	end

	function Window:Notify(cfg)
		return self:Notification(cfg)
	end

	connect(minButton.MouseButton1Click, function()
		if not Window.Minimizer then
			Window:CreateMinimizer({})
		end
		Window.Minimizer:SetVisible(true)
		if Window.Visible then
			Window:Minimize()
		end
	end)

	connect(maxButton.MouseButton1Click, function()
		Window:SetMaximized()
	end)

	connect(closeButton.MouseButton1Click, function()
		Window:Dialog({
			Title = "Close",
			Content = "Are you sure you want to unload the interface?",
			Buttons = {
				{
					Title = "Yes",
					Callback = function()
						Library:Destroy()
					end,
				},
				{
					Title = "No",
				},
			},
		})
	end)

	connect(UserInputService.InputBegan, function(input)
		if UserInputService:GetFocusedTextBox() then
			return
		end
		if input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode == Window:GetMinimizeKey() then
			Window:Minimize()
		end
	end)

	function Window:CreateMinimizer(cfg)
		cfg = cfg or {}
		if self.Minimizer then
			self.Minimizer:Destroy()
		end

		local Minimizer = {}
		local button = create("ImageButton", {
			Name = "Minimizer",
			AutoButtonColor = false,
			BorderSizePixel = 0,
			Size = cfg.Size or UDim2.fromOffset(56, 56),
			Position = cfg.Position or UDim2.fromOffset(20, 20),
			Image = tostring(cfg.Icon or ""),
			ScaleType = Enum.ScaleType.Crop,
			Visible = cfg.Visible ~= false,
			ZIndex = 20,
			Parent = gui,
		})
		corner(button, tonumber(cfg.Corner) or 12)
		bind(button, {BackgroundColor3 = "Card"})

		local fallback = text({
			Size = UDim2.fromScale(1, 1),
			Text = string.upper(string.sub(stripTags(title), 1, 1)),
			FontFace = Library.Fonts.SemiBold,
			TextSize = 22,
			TextXAlignment = Enum.TextXAlignment.Center,
			Visible = button.Image == "",
			ZIndex = 21,
			Parent = button,
		})
		bind(fallback, {TextColor3 = "Text"})

		if cfg.Draggable ~= false then
			makeDraggable(button, button, connect, function()
				Window:Toggle()
			end, 5)
		else
			connect(button.MouseButton1Click, function()
				Window:Toggle()
			end)
		end

		function Minimizer:SetVisible(state)
			button.Visible = state == true
		end

		function Minimizer:Destroy()
			button:Destroy()
			if Window.Minimizer == Minimizer then
				Window.Minimizer = nil
			end
		end

		self.Minimizer = Minimizer
		return Minimizer
	end

	function Window:SelectTab(tab)
		if not tab then
			return
		end
		self:ClosePopups()
		for _, t in ipairs(self.Tabs) do
			local current = t == tab
			t.Selected = current
			t.Page.Visible = current
			t.Paint(true)
		end
		self.CurrentTab = tab
		headingTitle.Text = rich(tab.Title)
		headingTitle.Position = UDim2.fromOffset(20, tab.Description == "" and 15 or 8)
		headingDesc.Text = rich(tab.Description)
		headingDesc.Visible = tab.Description ~= ""
	end

	function Window:ApplySearch()
		local query = string.lower((string.gsub(searchQuery, "^%s*(.-)%s*$", "%1")))
		local searching = query ~= ""
		local firstMatch
		local total = 0

		local function scan(items)
			local matches = 0
			local section
			for _, item in ipairs(items) do
				if item.Kind == "Section" then
					section = item
					item.Card.Visible = not searching
				else
					local show = true
					if searching then
						local haystack = string.lower(stripTags(item.TitleObj.Text .. " " .. item.DescObj.Text))
						show = string.find(haystack, query, 1, true) ~= nil
					end
					item.Card.Visible = show
					if show and searching then
						matches += 1
						local owner = item.Section or section
						if owner then
							owner.Card.Visible = true
						end
					end
				end
			end
			return matches
		end

		for _, tab in ipairs(self.Tabs) do
			local matches = scan(tab.Items)
			for _, sub in ipairs(tab.Subs) do
				sub.Own = scan(sub.Items)
				sub.Total = sub.Own
				matches += sub.Own
			end
			for _, sub in ipairs(tab.Subs) do
				local ancestor = sub.Parent
				while ancestor do
					ancestor.Total += sub.Own
					ancestor = ancestor.Parent
				end
			end
			if searching then
				for _, group in ipairs(tab.Groups) do
					local current
					for _, sub in ipairs(group.Subs) do
						if sub.Selected then
							current = sub
						end
					end
					if current and current.Total == 0 then
						for _, sub in ipairs(group.Subs) do
							if sub.Total > 0 then
								sub:Select()
								break
							end
						end
					end
				end
			end
			tab.Matches = matches
			tab.Button.Visible = (not searching) or matches > 0
			if matches > 0 and not firstMatch then
				firstMatch = tab
			end
			total += matches
		end
		noResults.Visible = searching and total == 0
		if searching and firstMatch and self.CurrentTab and self.CurrentTab.Matches == 0 then
			self:SelectTab(firstMatch)
		end
	end

	if searchInput then
		connect(searchInput:GetPropertyChangedSignal("Text"), function()
			searchQuery = searchInput.Text
			Window:ApplySearch()
		end)
	end

	function Window:AddTab(cfg)
		if type(cfg) == "string" then
			cfg = {Title = cfg}
		end
		cfg = cfg or {}

		local Tab = {Selected = false, Items = {}, Subs = {}, Groups = {}}
		Tab.Title = tostring(cfg.Title or cfg.Text or cfg.Name or "Tab")
		Tab.SaveManager = cfg.SaveManager == true
		if Tab.SaveManager then
			Window.HasSave = true
		end
		Tab.Description = tostring(cfg.Description or "")

		local button = create("TextButton", {
			Name = Tab.Title,
			Text = "",
			AutoButtonColor = false,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 36),
			LayoutOrder = #Window.Tabs + 1,
			Parent = tabList,
		})
		corner(button, 6)
		bind(button, {BackgroundColor3 = "Card"})

		local indicator = create("Frame", {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 0, 0.5, 0),
			Size = UDim2.fromOffset(3, 0),
			BorderSizePixel = 0,
			Parent = button,
		})
		corner(indicator, 2)
		bind(indicator, {BackgroundColor3 = "Accent"})

		local textOffset = 14
		local icon
		if cfg.Icon and tostring(cfg.Icon) ~= "" then
			icon = create("ImageLabel", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 12, 0.5, 0),
				Size = UDim2.fromOffset(18, 18),
				Image = tostring(cfg.Icon),
				Parent = button,
			})
			textOffset = 38
		end

		local label = text({
			Position = UDim2.fromOffset(textOffset, 0),
			Size = UDim2.new(1, -textOffset - 8, 1, 0),
			FontFace = Library.Fonts.Medium,
			RichText = true,
			Text = Tab.Title,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = button,
		})

		local hovering = false

		local function paintTab(th, animate)
			local duration = animate and 0.15 or 0
			local selectedAlpha = Window.Transparent and 0.45 or 0
			local hoverAlpha = Window.Transparent and 0.75 or 0.6
			local bgTransparency = Tab.Selected and selectedAlpha or (hovering and hoverAlpha or 1)
			tween(button, duration, {BackgroundTransparency = bgTransparency})
			tween(label, duration, {TextColor3 = Tab.Selected and th.Text or th.SubText})
			tween(indicator, duration, {Size = UDim2.fromOffset(3, Tab.Selected and 16 or 0)})
			if icon then
				tween(icon, duration, {ImageColor3 = Tab.Selected and th.Accent or th.SubText})
			end
		end

		Tab.Paint = function(animate)
			paintTab(Window.Theme, animate)
		end

		bindFn(button, function(th)
			paintTab(th, false)
		end)

		connect(button.MouseEnter, function()
			hovering = true
			Tab.Paint(true)
		end)
		connect(button.MouseLeave, function()
			hovering = false
			Tab.Paint(true)
		end)
		connect(button.MouseButton1Click, function()
			Window:SelectTab(Tab)
		end)

		local page = create("ScrollingFrame", {
			Name = Tab.Title,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			CanvasSize = UDim2.new(),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollBarThickness = 3,
			ScrollBarImageTransparency = 0.4,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			ElasticBehavior = Enum.ElasticBehavior.Never,
			Visible = false,
			Parent = pages,
		})
		bind(page, {ScrollBarImageColor3 = "SubText"})
		pad(page, 4, 18, 20, 20)
		create("UIListLayout", {
			Padding = UDim.new(0, 6),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = page,
		})

		Tab.Button = button
		Tab.Page = page

		local ctx = {Container = page, Items = Tab.Items, Order = 0}

		local function nextOrder()
			ctx.Order += 1
			return ctx.Order
		end

		local function withContext(context, fn, ...)
			local previous = ctx
			ctx = context
			local ok, result = pcall(fn, ...)
			ctx = previous
			if not ok then
				error(result, 0)
			end
			return result
		end

		local function splitArgs(a, b)
			if type(a) == "table" and b == nil then
				return nil, a
			end
			return a, b or {}
		end

		local function renameFlag(rec, newKey)
			Window.FlagKeys[rec.Key] = nil
			Library.Flags[newKey] = Library.Flags[rec.Key]
			Library.Flags[rec.Key] = nil
			rec.Key = newKey
			Window.FlagKeys[newKey] = rec
			if rec.Save and rec.Set and Window.SaveData[newKey] ~= nil then
				rec.Saved = Window.SaveData[newKey]
				Window.SuspendSave = true
				pcall(rec.Set, rec.Saved, false)
				Window.SuspendSave = false
			end
		end

		local function newFlag(flag, data)
			local base
			if flag ~= nil and tostring(flag) ~= "" then
				base = tostring(flag)
			else
				base = stripTags(data.Title or data.Name or "")
			end
			if base == "" then
				base = "Flag"
			end
			local group = Window.FlagGroups[base]
			if not group then
				group = {}
				Window.FlagGroups[base] = group
			end
			local rec = {Base = base, Save = Tab.SaveManager == true}
			table.insert(group, rec)
			if #group == 1 then
				rec.Key = base
			else
				if #group == 2 then
					renameFlag(group[1], base .. "_1")
				end
				rec.Key = base .. "_" .. #group
			end
			Window.FlagKeys[rec.Key] = rec
			table.insert(Window.FlagList, rec)
			if rec.Save then
				rec.Saved = Window.SaveData[rec.Key]
			end
			return rec
		end

		local function commit(rec, value, silent)
			Library.Flags[rec.Key] = value
			if not silent then
				Window:_QueueSave(rec)
			end
		end
		local function newCard()
			local card = create("Frame", {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BorderSizePixel = 0,
				LayoutOrder = nextOrder(),
				Parent = ctx.Container,
			})
			corner(card, 6)
			local cardStroke = stroke(card, 1, 0.5)
			bind(card, {BackgroundColor3 = "Card"})
			glass(card, 0, 0.4)
			bind(cardStroke, {Color = "Stroke"})
			return card
		end

		local function newRow(parent, layoutOrder)
			local container = create("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = layoutOrder or 1,
				Parent = parent,
			})
			local row = create("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Parent = container,
			})
			pad(row, 12, 12, 14, 14)
			create("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 12),
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = row,
			})
			local overlay = create("TextButton", {
				BackgroundTransparency = 1,
				AutoButtonColor = false,
				Text = "",
				Size = UDim2.fromScale(1, 1),
				ZIndex = 5,
				Parent = container,
			})
			return container, row, overlay
		end

		local function newText(parent, data, width)
			local stack = create("Frame", {
				BackgroundTransparency = 1,
				Size = width,
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = 1,
				Parent = parent,
			})
			create("UIListLayout", {
				Padding = UDim.new(0, 2),
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = stack,
			})
			local titleText = tostring(data.Title or data.Name or "")
			local descText = tostring(data.Description or data.Desc or "")
			local titleObj = text({
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				FontFace = Library.Fonts.Medium,
				TextSize = 14,
				TextWrapped = true,
				RichText = true,
				Text = titleText,
				LayoutOrder = 1,
				Parent = stack,
			})
			bind(titleObj, {TextColor3 = "Text"})
			local descObj = text({
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				TextSize = 12,
				TextWrapped = true,
				RichText = true,
				Text = descText,
				Visible = descText ~= "",
				LayoutOrder = 2,
				Parent = stack,
			})
			bind(descObj, {TextColor3 = "SubText"})
			return stack, titleObj, descObj
		end

		local function finish(obj, card, titleObj, descObj)
			local items = ctx.Items
			local entry = {Kind = "Element", Card = card, TitleObj = titleObj, DescObj = descObj, Section = ctx.Section}
			table.insert(items, entry)
			local removed = false

			local function setLabel(label, value)
				value = tostring(value == nil and "" or value)
				local shown = rich(value)
				if label.Text ~= shown then
					label.Text = shown
				end
				label.Visible = value ~= ""
				if searchQuery ~= "" then
					Window:ApplySearch()
				end
			end

			function obj:SetTitle(value)
				setLabel(titleObj, value)
			end

			function obj:SetDesc(value)
				setLabel(descObj, value)
			end

			function obj:Destroy()
				if removed then
					return
				end
				removed = true
				for index, item in ipairs(items) do
					if item == entry then
						table.remove(items, index)
						break
					end
				end
				if obj.OnDestroy then
					pcall(obj.OnDestroy, obj)
				end
				card:Destroy()
				if searchQuery ~= "" then
					Window:ApplySearch()
				end
			end

			if searchQuery ~= "" then
				Window:ApplySearch()
			end
			return obj
		end

		local function hoverCard(card, overlay)
			connect(overlay.MouseEnter, function()
				if Window.HoverLocks > 0 then
					return
				end
				tween(card, 0.12, {BackgroundColor3 = Window.Theme.CardHover})
			end)
			connect(overlay.MouseLeave, function()
				tween(card, 0.12, {BackgroundColor3 = Window.Theme.Card})
			end)
		end

		function Tab:AddSection(data)
			local textValue
			if type(data) == "table" then
				textValue = tostring(data.Title or data.Name or "")
			else
				textValue = tostring(data or "")
			end
			local holder = create("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 32),
				LayoutOrder = nextOrder(),
				Parent = ctx.Container,
			})
			local bar = create("Frame", {
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new(0, 2, 1, -4),
				Size = UDim2.fromOffset(3, 14),
				BorderSizePixel = 0,
				Parent = holder,
			})
			corner(bar, 2)
			bind(bar, {BackgroundColor3 = "Accent"})
			local label = text({
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new(0, 12, 1, -2),
				Size = UDim2.new(1, -14, 0, 18),
				FontFace = Library.Fonts.SemiBold,
				TextSize = 13,
				RichText = true,
				Text = textValue,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Parent = holder,
			})
			bind(label, {TextColor3 = "Text"})
			local entry = {Kind = "Section", Card = holder, TitleObj = label}
			table.insert(ctx.Items, entry)
			local parent = ctx
			local contentOrder = nextOrder()
			local sectionContext
			local Section = {}
			for _, name in ipairs({"AddButton", "AddParagraph", "AddToggle", "AddSlider", "AddInput", "AddDropdown", "AddKeybind"}) do
				Section[name] = function(_, ...)
					if not sectionContext then
						local container = create("Frame", {
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y,
							LayoutOrder = contentOrder,
							Parent = parent.Container,
						})
						create("UIListLayout", {
							Padding = UDim.new(0, 6),
							SortOrder = Enum.SortOrder.LayoutOrder,
							Parent = container,
						})
						sectionContext = {Container = container, Items = parent.Items, Order = 0, Sub = parent.Sub, Section = entry}
					end
					return withContext(sectionContext, Tab[name], Tab, ...)
				end
			end
			return Section
		end

		function Tab:AddButton(data)
			data = data or {}
			local Button = {}
			local card = newCard()
			local _, row, overlay = newRow(card)
			local _, titleObj, descObj = newText(row, data, UDim2.new(1, -26, 0, 0))
			local arrowHolder = create("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(14, 14),
				LayoutOrder = 2,
				Parent = row,
			})
			chevron(arrowHolder, -90, bind)
			hoverCard(card, overlay)

			connect(overlay.MouseButton1Click, function()
				if Window.HoverLocks > 0 then
					return
				end
				tween(card, 0.08, {BackgroundColor3 = Window.Theme.Stroke})
				task.delay(0.1, function()
					if card.Parent then
						tween(card, 0.15, {BackgroundColor3 = Window.Theme.CardHover})
					end
				end)
				fire(data.Callback)
			end)

			return finish(Button, card, titleObj, descObj)
		end

		function Tab:AddParagraph(data)
			if type(data) == "string" then
				data = {Content = data}
			end
			data = data or {}
			local Paragraph = {}
			local card = newCard()
			local body = create("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Parent = card,
			})
			pad(body, 12, 12, 14, 14)
			local info = {
				Title = data.Title or data.Name or "",
				Description = data.Content or data.Description or data.Desc or "",
			}
			local _, titleObj, descObj = newText(body, info, UDim2.new(1, 0, 0, 0))
			titleObj.Visible = tostring(info.Title) ~= ""
			titleObj.TextSize = 13

			function Paragraph:SetContent(value)
				self:SetDesc(value)
			end

			Paragraph.SetValue = Paragraph.SetContent
			Paragraph.SetText = Paragraph.SetContent

			return finish(Paragraph, card, titleObj, descObj)
		end

		function Tab:AddToggle(a, b)
			local flag, data = splitArgs(a, b)
			local rec = newFlag(flag, data)
			local value = data.Default == true
			if rec.Saved ~= nil then
				value = rec.Saved == true
			end
			local Toggle = {}
			local card = newCard()
			local _, row, overlay = newRow(card)
			local _, titleObj, descObj = newText(row, data, UDim2.new(1, -52, 0, 0))
			local holder = create("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(40, 20),
				LayoutOrder = 2,
				Parent = row,
			})
			local switch = create("Frame", {
				Size = UDim2.fromScale(1, 1),
				BorderSizePixel = 0,
				Parent = holder,
			})
			corner(switch, 10)
			local switchStroke = stroke(switch, 1, 0)
			local knob = create("Frame", {
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 4, 0.5, 0),
				Size = UDim2.fromOffset(12, 12),
				BorderSizePixel = 0,
				Parent = switch,
			})
			corner(knob, 7)

			local function paint(animate)
				local th = Window.Theme
				local duration = animate and 0.15 or 0
				tween(switch, duration, {
					BackgroundColor3 = th.Accent,
					BackgroundTransparency = value and 0 or 1,
				})
				tween(switchStroke, duration, {Color = value and th.Accent or th.SubText})
				tween(knob, duration, {
					Position = value and UDim2.new(0, 22, 0.5, 0) or UDim2.new(0, 4, 0.5, 0),
					Size = value and UDim2.fromOffset(14, 14) or UDim2.fromOffset(12, 12),
					BackgroundColor3 = value and th.AccentText or th.SubText,
				})
			end

			bindFn(switch, function()
				paint(false)
			end)
			hoverCard(card, overlay)

			commit(rec, value, true)

			function Toggle:Set(newValue, silent)
				newValue = newValue == true
				if newValue == value then
					return
				end
				value = newValue
				paint(true)
				commit(rec, value, silent)
				if not silent then
					fire(data.Callback, value)
				end
			end

			function Toggle:SetValue(v, silent)
				Toggle:Set(v, silent)
			end

			connect(overlay.MouseButton1Click, function()
				Toggle:Set(not value)
			end)

			rec.Default = data.Default == true
			rec.Get = function()
				return value
			end
			rec.Set = function(v, silent)
				Toggle:Set(v, silent)
			end

			task.defer(fire, data.Callback, value)

			return finish(Toggle, card, titleObj, descObj, rec)
		end

		function Tab:AddSlider(a, b)
			local flag, data = splitArgs(a, b)
			local rec = newFlag(flag, data)
			local min = tonumber(data.Min) or 0
			local max = tonumber(data.Max) or 100
			if max <= min then
				max = min + 1
			end
			local increment = tonumber(data.Increment)
			if not increment and data.Rounding ~= nil then
				increment = 10 ^ -math.max(0, math.floor(tonumber(data.Rounding) or 0))
			end
			increment = increment or 1
			if increment <= 0 then
				increment = 1
			end
			local fraction = string.match(string.format("%.6f", increment), "%.(%d+)") or ""
			fraction = string.gsub(fraction, "0+$", "")
			local decimals = #fraction
			local suffix = tostring(data.Suffix or "")
			local dragging = false
			local Slider = {}

			local function snap(v)
				v = math.clamp(v, min, max)
				v = min + math.floor((v - min) / increment + 0.5) * increment
				v = math.clamp(v, min, max)
				return tonumber(string.format("%." .. decimals .. "f", v))
			end

			local defaultValue = snap(tonumber(data.Default) or min)
			local value = defaultValue
			if rec.Saved ~= nil then
				value = snap(tonumber(rec.Saved) or defaultValue)
			end

			local card = newCard()
			local bodyFrame = create("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Parent = card,
			})
			pad(bodyFrame, 10, 10, 14, 14)
			create("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 12),
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = bodyFrame,
			})

			local _, titleObj, descObj = newText(bodyFrame, data, UDim2.new(1, -292, 0, 0))

			local area = create("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(280, 24),
				LayoutOrder = 2,
				Parent = bodyFrame,
			})

			local valueLabel = text({
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, 0, 0.5, 0),
				Size = UDim2.fromOffset(52, 16),
				FontFace = Library.Fonts.Medium,
				TextXAlignment = Enum.TextXAlignment.Right,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Parent = area,
			})
			bind(valueLabel, {TextColor3 = "Accent"})

			local hit = create("TextButton", {
				BackgroundTransparency = 1,
				AutoButtonColor = false,
				Text = "",
				Size = UDim2.new(1, -58, 1, 0),
				Parent = area,
			})
			local track = create("Frame", {
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 8, 0.5, 0),
				Size = UDim2.new(1, -16, 0, 4),
				BorderSizePixel = 0,
				Parent = hit,
			})
			corner(track, 2)
			bind(track, {BackgroundColor3 = "Track"})
			local fill = create("Frame", {
				Size = UDim2.fromScale(0, 1),
				BorderSizePixel = 0,
				Parent = track,
			})
			corner(fill, 2)
			bind(fill, {BackgroundColor3 = "Accent"})
			local knob = create("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0, 0, 0.5, 0),
				Size = UDim2.fromOffset(16, 16),
				BorderSizePixel = 0,
				ZIndex = 2,
				Parent = track,
			})
			corner(knob, 10)
			local knobStroke = stroke(knob, 2, 0)
			bind(knob, {BackgroundColor3 = "Accent"})
			bind(knobStroke, {Color = "Card"})

			local function render()
				local rel = (value - min) / (max - min)
				fill.Size = UDim2.fromScale(rel, 1)
				knob.Position = UDim2.new(rel, 0, 0.5, 0)
				valueLabel.Text = tostring(value) .. suffix
			end

			render()

			commit(rec, value, true)

			function Slider:Set(newValue, silent)
				newValue = tonumber(newValue)
				if not newValue then
					return
				end
				newValue = snap(newValue)
				if newValue == value then
					return
				end
				value = newValue
				render()
				commit(rec, value, silent)
				if not silent then
					fire(data.Callback, value)
				end
			end

			function Slider:SetValue(v, silent)
				Slider:Set(v, silent)
			end

			local function updateFromX(x)
				local width = track.AbsoluteSize.X
				if width <= 0 then
					return
				end
				local rel = math.clamp((x - track.AbsolutePosition.X) / width, 0, 1)
				Slider:Set(min + (max - min) * rel)
			end

			connect(hit.InputBegan, function(input)
				if isPress(input) then
					dragging = true
					tween(knob, 0.1, {Size = UDim2.fromOffset(20, 20)})
					updateFromX(input.Position.X)
				end
			end)
			connect(UserInputService.InputChanged, function(input)
				if dragging and isMove(input) then
					updateFromX(input.Position.X)
				end
			end)
			connect(UserInputService.InputEnded, function(input)
				if dragging and isPress(input) then
					dragging = false
					tween(knob, 0.1, {Size = UDim2.fromOffset(16, 16)})
				end
			end)

			rec.Default = defaultValue
			rec.Get = function()
				return value
			end
			rec.Set = function(v, silent)
				Slider:Set(v, silent)
			end

			task.defer(fire, data.Callback, value)

			return finish(Slider, card, titleObj, descObj, rec)
		end

		function Tab:AddInput(a, b)
			local flag, data = splitArgs(a, b)
			local rec = newFlag(flag, data)
			local Input = {}
			local numeric = data.Numeric == true
			local finished = data.Finished == true
			local formatter = (numeric and typeof(data.Format) == "function") and data.Format or nil
			local maxLength = tonumber(data.MaxLength)
			local displaying = false
			local programmatic = false

			local function accept(raw, fallback)
				raw = tostring(raw == nil and "" or raw)
				if maxLength and #raw > maxLength then
					raw = string.sub(raw, 1, maxLength)
				end
				if numeric and #raw > 0 and tonumber(raw) == nil then
					return fallback
				end
				return raw
			end

			local defaultValue = accept(data.Default, "")
			local value = defaultValue
			if rec.Saved ~= nil then
				value = accept(rec.Saved, defaultValue)
			end

			local card = newCard()
			local _, row, overlay = newRow(card)
			overlay:Destroy()
			local _, titleObj, descObj = newText(row, data, UDim2.new(1, -172, 0, 0))

			local box = create("Frame", {
				Size = UDim2.fromOffset(160, 30),
				BorderSizePixel = 0,
				LayoutOrder = 2,
				Parent = row,
			})
			corner(box, 6)
			local boxStroke = stroke(box, 1, 0.2)
			bind(box, {BackgroundColor3 = "CardHover"})
			glass(box, 0, 0.3)
			bind(boxStroke, {Color = "Stroke"})

			local input = create("TextBox", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.fromOffset(10, 0),
				Size = UDim2.new(1, -20, 1, 0),
				FontFace = Library.Fonts.Regular,
				TextSize = 13,
				PlaceholderText = tostring(data.Placeholder or "Type here..."),
				Text = "",
				ClearTextOnFocus = data.ClearTextOnFocus == true,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Parent = box,
			})
			bind(input, {TextColor3 = "Text", PlaceholderColor3 = "SubText"})

			local function setText(content)
				programmatic = true
				input.Text = content
				programmatic = false
			end

			local function applyFormat()
				if formatter and value ~= "" then
					local number = tonumber(value)
					if not number then
						return
					end
					local ok, result = pcall(formatter, number)
					if ok and type(result) == "string" and result ~= "" then
						displaying = true
						setText(result)
					end
				end
			end

			local function restoreRaw()
				if displaying then
					displaying = false
					setText(value)
				end
			end

			setText(value)

			function Input:Set(v, silent)
				local text = accept(v, value)
				displaying = false
				value = text
				setText(text)
				commit(rec, value, silent)
				if not silent then
					fire(data.Callback, value)
				end
				if not input:IsFocused() then
					task.defer(applyFormat)
				end
			end

			function Input:SetValue(v, silent)
				Input:Set(v, silent)
			end

			connect(input.Focused, function()
				restoreRaw()
				tween(boxStroke, 0.15, {Color = Window.Theme.Accent})
			end)

			connect(input:GetPropertyChangedSignal("Text"), function()
				if programmatic or displaying or finished then
					return
				end
				local raw = input.Text
				local text = accept(raw, value)
				if text ~= raw then
					setText(text)
				end
				if text ~= value then
					value = text
					commit(rec, value)
					fire(data.Callback, value)
				end
			end)

			connect(input.FocusLost, function(enterPressed)
				tween(boxStroke, 0.15, {Color = Window.Theme.Stroke})
				if finished then
					value = accept(input.Text, value)
					displaying = false
					setText(value)
					commit(rec, value)
					if enterPressed then
						fire(data.Callback, value)
					end
				end
				applyFormat()
			end)

			commit(rec, value, true)
			rec.Default = defaultValue
			rec.Get = function()
				return value
			end
			rec.Set = function(v, silent)
				Input:Set(v, silent)
			end

			if value ~= "" then
				task.defer(fire, data.Callback, value)
				task.defer(applyFormat)
			end

			return finish(Input, card, titleObj, descObj, rec)
		end

		function Tab:AddDropdown(a, b)
			local flag, data = splitArgs(a, b)
			local rec = newFlag(flag, data)
			local multi = data.Multi == true
			local placeholder = tostring(data.Placeholder or "Select")
			local options = {}
			local selected = multi and {} or nil
			local objects = {}
			local open = false
			local hasValue = false
			local popupToken = 0
			local popupWidth = 160
			local popupHeight = 0
			local direction = "Down"
			local renderConnection
			local Dropdown = {}

			local function setOptions(list)
				options = {}
				local seen = {}
				local function add(v)
					local name = tostring(v)
					if not seen[name] then
						seen[name] = true
						table.insert(options, name)
					end
				end
				list = list or {}
				if #list > 0 then
					for _, v in ipairs(list) do
						add(v)
					end
				else
					local keys = {}
					if list == Library.Themes then
						for _, key in ipairs(Library.ThemeOrder) do
							if list[key] then
								table.insert(keys, key)
							end
						end
					else
						for key in pairs(list) do
							table.insert(keys, tostring(key))
						end
						table.sort(keys)
					end
					for _, key in ipairs(keys) do
						add(key)
					end
				end
			end

			setOptions(data.Options or data.Values)

			local function hasSearch()
				return data.Search ~= false
			end

			local card = newCard()
			local _, row, overlay = newRow(card)
			local _, titleObj, descObj = newText(row, data, UDim2.new(1, -172, 0, 0))

			local box = create("Frame", {
				Size = UDim2.fromOffset(160, 30),
				BorderSizePixel = 0,
				LayoutOrder = 2,
				Parent = row,
			})
			corner(box, 6)
			local boxStroke = stroke(box, 1, 0.2)
			bind(box, {BackgroundColor3 = "CardHover"})
			glass(box, 0, 0.3)
			bind(boxStroke, {Color = "Stroke"})

			local valueLabel = text({
				Position = UDim2.fromOffset(10, 0),
				Size = UDim2.new(1, -34, 1, 0),
				TextSize = 14,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Parent = box,
			})

			local chevHolder = create("Frame", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -10, 0.5, 0),
				Size = UDim2.fromOffset(14, 14),
				Parent = box,
			})
			local chev = chevron(chevHolder, 0, bind)

			local function paintValue(th)
				valueLabel.TextColor3 = hasValue and th.Text or th.SubText
			end

			bindFn(valueLabel, paintValue)

			local blocker = create("TextButton", {
				BackgroundTransparency = 1,
				AutoButtonColor = false,
				Active = true,
				Text = "",
				Size = UDim2.fromScale(1, 1),
				ZIndex = 60,
				Visible = false,
				Parent = gui,
			})

			local popup = create("TextButton", {
				BorderSizePixel = 0,
				AutoButtonColor = false,
				Active = true,
				Text = "",
				Size = UDim2.fromOffset(160, 0),
				ClipsDescendants = true,
				Visible = false,
				ZIndex = 61,
				Parent = gui,
			})
			corner(popup, 8)
			local popupStroke = stroke(popup, 1, 0.2)
			bind(popup, {BackgroundColor3 = "Card"})
			glass(popup, 0, 0.06)
			bind(popupStroke, {Color = "Stroke"})

			local searchHolder = create("Frame", {
				Position = UDim2.fromOffset(6, 6),
				Size = UDim2.new(1, -12, 0, 28),
				BorderSizePixel = 0,
				Visible = false,
				ZIndex = 62,
				Parent = popup,
			})
			corner(searchHolder, 6)
			bind(searchHolder, {BackgroundColor3 = "CardHover"})

			local searchIcon = create("ImageLabel", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 8, 0.5, 0),
				Size = UDim2.fromOffset(14, 14),
				Image = "rbxassetid://10734943674",
				ZIndex = 63,
				Parent = searchHolder,
			})
			bind(searchIcon, {ImageColor3 = "SubText"})

			local searchBox = create("TextBox", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.fromOffset(28, 0),
				Size = UDim2.new(1, -34, 1, 0),
				FontFace = Library.Fonts.Regular,
				TextSize = 13,
				PlaceholderText = "Search...",
				Text = "",
				ClearTextOnFocus = false,
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 63,
				Parent = searchHolder,
			})
			bind(searchBox, {TextColor3 = "Text", PlaceholderColor3 = "SubText"})

			local listFrame = create("ScrollingFrame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Active = true,
				Position = UDim2.fromOffset(6, 6),
				Size = UDim2.new(1, -12, 0, 30),
				CanvasSize = UDim2.new(),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollBarThickness = 3,
				ScrollBarImageTransparency = 0.4,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				ElasticBehavior = Enum.ElasticBehavior.Never,
				ZIndex = 62,
				Parent = popup,
			})
			bind(listFrame, {ScrollBarImageColor3 = "SubText"})
			create("UIListLayout", {
				Padding = UDim.new(0, 2),
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = listFrame,
			})

			local emptyLabel = text({
				Position = UDim2.fromOffset(6, 6),
				Size = UDim2.new(1, -12, 0, 30),
				Text = "No results",
				TextXAlignment = Enum.TextXAlignment.Center,
				Visible = false,
				ZIndex = 62,
				Parent = popup,
			})
			bind(emptyLabel, {TextColor3 = "SubText"})

			local function isSelected(name)
				if multi then
					return selected[name] == true
				end
				return selected == name
			end

			local function visibleCount()
				local count = 0
				for _, o in pairs(objects) do
					if o.Button.Visible then
						count += 1
					end
				end
				return count
			end

			local function getSpace()
				local bpos = box.AbsolutePosition - gui.AbsolutePosition
				local bsize = box.AbsoluteSize
				local viewport = gui.AbsoluteSize
				local below = viewport.Y - (bpos.Y + bsize.Y) - 10
				local above = bpos.Y - 10
				return below, above
			end

			local function applyLayout(animate)
				local search = hasSearch()
				local top = search and 40 or 6
				local count = visibleCount()
				local wanted = math.clamp(count * 34 - 2, 30, 192)
				local below, above = getSpace()
				local space = direction == "Up" and above or below
				local listHeight = math.clamp(wanted, 30, math.max(30, math.min(192, space - top - 6)))
				searchHolder.Visible = search
				listFrame.Position = UDim2.fromOffset(6, top)
				listFrame.Size = UDim2.new(1, -12, 0, listHeight)
				emptyLabel.Position = UDim2.fromOffset(6, top)
				emptyLabel.Visible = count == 0
				popupHeight = top + listHeight + 6
				if open then
					tween(popup, animate and 0.16 or 0, {Size = UDim2.fromOffset(popupWidth, popupHeight)})
				end
			end

			local function reposition()
				if not box.Parent then
					return
				end
				local bpos = box.AbsolutePosition - gui.AbsolutePosition
				local bsize = box.AbsoluteSize
				local viewport = gui.AbsoluteSize
				local x = math.clamp(bpos.X, 0, math.max(0, viewport.X - popupWidth))
				local y = direction == "Up" and (bpos.Y - 4) or (bpos.Y + bsize.Y + 4)
				popup.AnchorPoint = Vector2.new(0, direction == "Up" and 1 or 0)
				popup.Position = UDim2.fromOffset(x, y)
			end

			local function paintOption(name, animate)
				local o = objects[name]
				if not o then
					return
				end
				local th = Window.Theme
				local on = isSelected(name)
				local duration = animate and 0.12 or 0
				tween(o.Label, duration, {TextColor3 = th.Text})
				tween(o.Indicator, duration, {Size = UDim2.fromOffset(3, on and 14 or 0)})
				tween(o.Button, duration, {
					BackgroundColor3 = on and th.Accent or th.CardHover,
					BackgroundTransparency = on and 0.82 or 1,
				})
			end

			function Dropdown:Get()
				if multi then
					local list = {}
					for _, name in ipairs(options) do
						if selected[name] then
							table.insert(list, name)
						end
					end
					return list
				end
				return selected
			end

			local function refreshText()
				if multi then
					local list = Dropdown:Get()
					hasValue = #list > 0
					valueLabel.Text = hasValue and table.concat(list, ", ") or placeholder
				else
					hasValue = selected ~= nil
					valueLabel.Text = selected or placeholder
				end
				paintValue(Window.Theme)
			end

			function Dropdown:Set(v, silent)
				if multi then
					selected = {}
					if type(v) == "table" then
						for k, val in pairs(v) do
							local name
							if type(k) == "number" then
								name = tostring(val)
							elseif val == true then
								name = tostring(k)
							end
							if name and objects[name] then
								selected[name] = true
							end
						end
					end
				else
					selected = (v ~= nil and objects[tostring(v)]) and tostring(v) or nil
				end
				for name in pairs(objects) do
					paintOption(name, true)
				end
				refreshText()
				commit(rec, Dropdown:Get(), silent)
				if not silent then
					fire(data.Callback, Dropdown:Get())
				end
			end

			function Dropdown:SetValue(v, silent)
				Dropdown:Set(v, silent)
			end

			local function closePopup()
				if not open then
					return
				end
				open = false
				popupToken += 1
				local myToken = popupToken
				task.delay(0.35, function()
					Window.HoverLocks = math.max(0, Window.HoverLocks - 1)
				end)
				tween(popup, 0.14, {Size = UDim2.fromOffset(popupWidth, 0)})
				tween(chev, 0.18, {Rotation = 0})
				tween(boxStroke, 0.15, {Color = Window.Theme.Stroke})
				task.delay(0.12, function()
					if myToken == popupToken and not open and blocker.Parent then
						blocker.Visible = false
					end
				end)
				task.delay(0.16, function()
					if myToken == popupToken and not open then
						if popup.Parent then
							popup.Visible = false
						end
						if renderConnection then
							renderConnection:Disconnect()
							renderConnection = nil
						end
					end
				end)
			end

			local function openPopup()
				if open then
					return
				end
				Window:ClosePopups()
				open = true
				Window.HoverLocks += 1
				popupToken += 1
				popupWidth = box.AbsoluteSize.X
				searchBox.Text = ""
				for _, o in pairs(objects) do
					o.Button.Visible = true
				end
				local below, above = getSpace()
				local needed = (hasSearch() and 40 or 6) + math.clamp(#options * 34 - 2, 30, 192) + 6
				if below >= needed then
					direction = "Down"
				elseif above > below then
					direction = "Up"
				else
					direction = "Down"
				end
				listFrame.CanvasPosition = Vector2.zero
				blocker.Visible = true
				popup.Size = UDim2.fromOffset(popupWidth, 0)
				popup.Visible = true
				applyLayout(true)
				reposition()
				tween(chev, 0.18, {Rotation = 180})
				tween(boxStroke, 0.15, {Color = Window.Theme.Accent})
				if not renderConnection then
					renderConnection = RunService.RenderStepped:Connect(reposition)
					table.insert(Window.Connections, renderConnection)
				end
			end

			function Dropdown:OnDestroy()
				closePopup()
				if renderConnection then
					renderConnection:Disconnect()
					renderConnection = nil
				end
				blocker:Destroy()
				popup:Destroy()
			end

			table.insert(Window.PopupClosers, closePopup)

			local function rebuild()
				for _, o in pairs(objects) do
					o.Button:Destroy()
				end
				objects = {}
				for index, name in ipairs(options) do
					local btn = create("TextButton", {
						Name = name,
						Text = "",
						AutoButtonColor = false,
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						BackgroundColor3 = Window.Theme.CardHover,
						Size = UDim2.new(1, 0, 0, 32),
						LayoutOrder = index,
						ZIndex = 63,
						Parent = listFrame,
					})
					corner(btn, 5)
					local indicator = create("Frame", {
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(0, 0, 0.5, 0),
						Size = UDim2.fromOffset(3, 0),
						BorderSizePixel = 0,
						ZIndex = 64,
						Parent = btn,
					})
					corner(indicator, 2)
					bind(indicator, {BackgroundColor3 = "Accent"})
					local label = text({
						Position = UDim2.fromOffset(12, 0),
						Size = UDim2.new(1, -20, 1, 0),
						TextSize = 14,
						Text = name,
						TextTruncate = Enum.TextTruncate.AtEnd,
						ZIndex = 64,
						Parent = btn,
					})
					objects[name] = {Button = btn, Label = label, Indicator = indicator}

					bindFn(btn, function()
						paintOption(name, false)
					end)

					connect(btn.MouseEnter, function()
						if not isSelected(name) then
							tween(btn, 0.1, {BackgroundTransparency = 0.6})
						end
					end)
					connect(btn.MouseLeave, function()
						paintOption(name, true)
					end)
					connect(btn.MouseButton1Click, function()
						if multi then
							local copy = {}
							for k, v in pairs(selected) do
								copy[k] = v
							end
							copy[name] = not copy[name] or nil
							Dropdown:Set(copy)
						else
							Dropdown:Set(name)
							closePopup()
						end
					end)
				end
				applyLayout(true)
				refreshText()
			end

			hoverCard(card, overlay)

			connect(overlay.MouseButton1Click, function()
				if open then
					closePopup()
				else
					openPopup()
				end
			end)

			connect(blocker.MouseButton1Click, closePopup)

			connect(searchBox:GetPropertyChangedSignal("Text"), function()
				local query = string.lower(searchBox.Text)
				for name, o in pairs(objects) do
					o.Button.Visible = query == "" or string.find(string.lower(name), query, 1, true) ~= nil
				end
				listFrame.CanvasPosition = Vector2.zero
				applyLayout(true)
			end)

			rebuild()

			local initial = data.Default
			if rec.Saved ~= nil then
				initial = rec.Saved
			end
			if initial ~= nil then
				Dropdown:Set(initial, true)
				task.defer(fire, data.Callback, Dropdown:Get())
			else
				refreshText()
			end
			commit(rec, Dropdown:Get(), true)

			rec.Default = data.Default
			if multi and rec.Default == nil then
				rec.Default = {}
			end
			rec.Get = function()
				return Dropdown:Get()
			end
			rec.Set = function(v, silent)
				Dropdown:Set(v, silent)
			end

			return finish(Dropdown, card, titleObj, descObj)
		end

		function Tab:AddKeybind(a, b)
			local flag, data = splitArgs(a, b)
			if data.Title == nil and data.Name == nil then
				data.Title = "Keybind"
			end
			local rec = newFlag(flag, data)
			local defaultKey = tostring(data.Default or "None")
			local defaultMode = tostring(data.Mode or "Toggle")
			local Keybind = {
				Value = defaultKey,
				Mode = defaultMode,
				Toggled = false,
				Type = "Keybind",
			}
			local picking = false

			if type(rec.Saved) == "table" then
				Keybind.Value = tostring(rec.Saved.Key or defaultKey)
				Keybind.Mode = tostring(rec.Saved.Mode or defaultMode)
			elseif rec.Saved ~= nil then
				Keybind.Value = tostring(rec.Saved)
			end

			local card = newCard()
			local _, row, overlay = newRow(card)
			overlay:Destroy()
			local _, titleObj, descObj = newText(row, data, UDim2.new(1, -172, 0, 0))

			local display = create("TextButton", {
				AutoButtonColor = false,
				Text = "",
				Size = UDim2.fromOffset(160, 30),
				BorderSizePixel = 0,
				LayoutOrder = 2,
				Parent = row,
			})
			corner(display, 6)
			local displayStroke = stroke(display, 1, 0.2)
			bind(display, {BackgroundColor3 = "CardHover"})
			glass(display, 0, 0.3)
			bind(displayStroke, {Color = "Stroke"})

			local keyLabel = text({
				Position = UDim2.fromOffset(10, 0),
				Size = UDim2.new(1, -20, 1, 0),
				TextXAlignment = Enum.TextXAlignment.Center,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Text = Keybind.Value,
				Parent = display,
			})
			bind(keyLabel, {TextColor3 = "Text"})

			local function matches(input, key)
				if key == "MouseLeft" then
					return input.UserInputType == Enum.UserInputType.MouseButton1
				elseif key == "MouseRight" then
					return input.UserInputType == Enum.UserInputType.MouseButton2
				end
				return input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == key
			end

			function Keybind:GetState()
				if UserInputService:GetFocusedTextBox() and Keybind.Mode ~= "Always" then
					return false
				end
				if Keybind.Mode == "Always" then
					return true
				elseif Keybind.Mode == "Hold" then
					local key = Keybind.Value
					if key == "None" then
						return false
					end
					if key == "MouseLeft" then
						return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
					elseif key == "MouseRight" then
						return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
					end
					local okKey, code = pcall(function()
						return Enum.KeyCode[key]
					end)
					if okKey and code then
						return UserInputService:IsKeyDown(code)
					end
					return false
				end
				return Keybind.Toggled
			end

			function Keybind:SetValue(newKey, newMode)
				if newKey ~= nil then
					Keybind.Value = tostring(newKey)
				end
				if newMode ~= nil then
					Keybind.Mode = tostring(newMode)
				end
				keyLabel.Text = Keybind.Value
				commit(rec, Keybind.Value)
			end

			function Keybind:OnClick(callback)
				Keybind.Clicked = callback
			end

			function Keybind:OnChanged(callback)
				Keybind.Changed = callback
				fire(callback, Keybind.Value)
			end

			function Keybind:DoClick()
				fire(Keybind.Clicked, Keybind.Toggled)
			end

			connect(display.MouseButton1Click, function()
				if picking then
					return
				end
				picking = true
				keyLabel.Text = "..."
				task.delay(0.2, function()
					if Window.Destroyed then
						return
					end
					local began
					began = connect(UserInputService.InputBegan, function(input)
						local name
						if input.UserInputType == Enum.UserInputType.Keyboard then
							name = input.KeyCode.Name
						elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
							name = "MouseLeft"
						elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
							name = "MouseRight"
						else
							return
						end
						began:Disconnect()
						local ended
						ended = connect(UserInputService.InputEnded, function(endInput)
							if not matches(endInput, name) then
								return
							end
							ended:Disconnect()
							picking = false
							Keybind:SetValue(name)
							local changed = endInput.UserInputType == Enum.UserInputType.Keyboard and endInput.KeyCode or endInput.UserInputType
							fire(data.Callback, changed)
							fire(data.ChangedCallback, changed)
							fire(Keybind.Changed, changed)
						end)
					end)
				end)
			end)

			connect(UserInputService.InputBegan, function(input)
				if picking or Keybind.Mode ~= "Toggle" or UserInputService:GetFocusedTextBox() then
					return
				end
				if matches(input, Keybind.Value) then
					Keybind.Toggled = not Keybind.Toggled
					Keybind:DoClick()
				end
			end)

			commit(rec, Keybind.Value, true)
			rec.Default = defaultKey
			rec.Get = function()
				return Keybind.Value
			end
			rec.Set = function(v)
				if type(v) == "table" then
					Keybind:SetValue(v.Key, v.Mode)
				else
					Keybind:SetValue(v)
				end
			end

			return finish(Keybind, card, titleObj, descObj, rec)
		end

		function Tab:AddSubTab(cfg)
			if type(cfg) == "string" then
				cfg = {Title = cfg}
			end
			cfg = cfg or {}
			local owner = ctx
			local SubTab = {
				Title = tostring(cfg.Title or cfg.Name or "Sub tab"),
				Items = {},
				Parent = owner.Sub,
				Selected = false,
				Own = 0,
				Total = 0,
			}

			if not (owner.Group and owner.Order == owner.ContentOrder) then
				owner.Bar = create("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					LayoutOrder = nextOrder(),
					Parent = owner.Container,
				})
				create("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					Wraps = true,
					Padding = UDim.new(0, 6),
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = owner.Bar,
				})
				owner.ContentOrder = nextOrder()
				owner.Group = {Subs = {}}
				table.insert(Tab.Groups, owner.Group)
			end
			local group = owner.Group

			local button = create("TextButton", {
				AutoButtonColor = false,
				BorderSizePixel = 0,
				Text = stripTags(SubTab.Title),
				FontFace = Library.Fonts.Medium,
				TextSize = 13,
				Size = UDim2.fromOffset(0, 30),
				AutomaticSize = Enum.AutomaticSize.X,
				LayoutOrder = #group.Subs + 1,
				Parent = owner.Bar,
			})
			corner(button, 6)
			pad(button, 0, 0, 14, 14)
			local buttonStroke = stroke(button, 1, 0.5)
			bind(buttonStroke, {Color = "Stroke"})

			local container = create("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = owner.ContentOrder,
				Visible = false,
				Parent = owner.Container,
			})
			create("UIListLayout", {
				Padding = UDim.new(0, 6),
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = container,
			})

			local hovering = false
			local function paint(th, animate)
				local selected = SubTab.Selected
				tween(button, animate and 0.12 or 0, {
					BackgroundColor3 = selected and th.Accent or (hovering and th.CardHover or th.Card),
					TextColor3 = selected and th.AccentText or th.SubText,
				})
			end
			bindFn(button, function(th)
				paint(th, false)
			end)
			connect(button.MouseEnter, function()
				hovering = true
				paint(Window.Theme, true)
			end)
			connect(button.MouseLeave, function()
				hovering = false
				paint(Window.Theme, true)
			end)

			function SubTab:Select()
				Window:ClosePopups()
				for _, other in ipairs(group.Subs) do
					other.Selected = other == SubTab
					other.Container.Visible = other.Selected
					other.Paint(true)
				end
			end

			SubTab.Container = container
			SubTab.Paint = function(animate)
				paint(Window.Theme, animate)
			end

			connect(button.MouseButton1Click, function()
				SubTab:Select()
			end)

			local subContext = {Container = container, Items = SubTab.Items, Order = 0, Sub = SubTab}
			for _, name in ipairs({"AddSection", "AddButton", "AddParagraph", "AddToggle", "AddSlider", "AddInput", "AddDropdown", "AddKeybind", "AddSubTab"}) do
				SubTab[name] = function(_, ...)
					return withContext(subContext, Tab[name], Tab, ...)
				end
			end

			table.insert(group.Subs, SubTab)
			table.insert(Tab.Subs, SubTab)
			if #group.Subs == 1 then
				SubTab:Select()
			end

			return SubTab
		end

		table.insert(Window.Tabs, Tab)
		if not Window.CurrentTab then
			Window:SelectTab(Tab)
		end

		return Tab
	end

	table.insert(Library.Windows, Window)
	Library.LastWindow = Window

	Window:SetVisible(true)

	return Window
end

function Library:Destroy()
	for _, window in ipairs(self.Windows) do
		window:Destroy()
	end
	self.Windows = {}
	self.LastWindow = nil
end

function Library:Notification(cfg)
	local window = type(cfg) == "table" and cfg.Window or self.LastWindow
	if not window or window.Destroyed then
		warn("Library:Notification: no active Window")
		return nil
	end
	return window:Notification(cfg)
end

function Library:Notify(cfg)
    return self:Notification(cfg)
end

function Library:SetTheme(value)
    for _, window in ipairs(self.Windows) do
        window:SetTheme(value)
    end
end

function Library:CreateMinimizer(cfg)
	cfg = cfg or {}
	local window = cfg.Window or self.LastWindow
	if not window or window.Destroyed then
		warn("Library:CreateMinimizer: no active Window")
		return nil
	end
	return window:CreateMinimizer(cfg)
end

return Library
