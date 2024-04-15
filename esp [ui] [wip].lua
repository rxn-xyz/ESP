-- esp [ui] [wip]

getgenv().global = getgenv()

function global.declare(self, index, value, check)
	if self[index] == nil then
		self[index] = value
	elseif check then
		local methods = { "remove", "Disconnect" }

		for _, method in methods do
			pcall(function()
				value[method](value)
			end)
		end
	end

	return self[index]
end

declare(global, "features", {})

features.toggle = function(self, feature, boolean)
	if self[feature] then
		if boolean == nil then
			self[feature].enabled = not self[feature].enabled
		else
			self[feature].enabled = boolean
		end

		if self[feature].toggle then
			task.spawn(function()
				self[feature]:toggle()
			end)
		end
	end
end

declare(features, "visuals", {
	["enabled"] = true,
	["teamCheck"] = false,
    ["teamColor"] = true,
	["renderDistance"] = 2000,

	["boxes"] = {
		["enabled"] = true,
		["color"] = Color3.fromRGB(255, 255, 255),
		["outline"] = {
			["enabled"] = true,
			["color"] = Color3.fromRGB(0, 0, 0),
		},
		["filled"] = {
			["enabled"] = true,
			["color"] = Color3.fromRGB(255, 255, 255),
			["transparency"] = 0.25
		},
	},
	["names"] = {
		["enabled"] = true,
		["color"] = Color3.fromRGB(255, 255, 255),
		["outline"] = {
			["enabled"] = true,
			["color"] = Color3.fromRGB(0, 0, 0),
		},
	},
	["health"] = {
		["enabled"] = true,
		["color"] = Color3.fromRGB(0, 255, 0),
		["colorLow"] = Color3.fromRGB(255, 0, 0),
		["outline"] = {
			["enabled"] = true,
			["color"] = Color3.fromRGB(0, 0, 0)
		},
		["text"] = {
			["enabled"] = true,
			["outline"] = {
				["enabled"] = true,
			},
		}
	},
	["distance"] = {
		["enabled"] = true,
		["color"] = Color3.fromRGB(255, 255, 255),
		["outline"] = {
			["enabled"] = true,
			["color"] = Color3.fromRGB(0, 0, 0),
		},
	}
})

local visuals = features.visuals

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"))()

local Window = Library:CreateWindow({
	Title = "lovers",
	Center = true,
	AutoShow = true,
})

local Tabs = {
	Visuals = Window:AddTab("visuals"),
	Settings = Window:AddTab("settings"),
}

local Boxes = {
	Settings = Tabs.Visuals:AddLeftGroupbox("settings"),
	Boxes = Tabs.Visuals:AddRightGroupbox("boxes"),
	Names = Tabs.Visuals:AddLeftGroupbox("names"),
	Health = Tabs.Visuals:AddRightGroupbox("health"),
	Distance = Tabs.Visuals:AddLeftGroupbox("distance"),
	Menu   = Tabs.Settings:AddLeftGroupbox("menu"),
}

local Tabboxes = {
}

Boxes.Settings:AddToggle("Visuals", {
	Text = "enabled",
	Default = false,
})

Toggles.Visuals:OnChanged(function()
	features:toggle("visuals", Toggles.Visuals.Value)
end)

Boxes.Settings:AddToggle("VisualsTeamCheck", {
	Text = "team check",
	Default = false,
})

Toggles.VisualsTeamCheck:OnChanged(function()
	visuals.teamCheck = Toggles.VisualsTeamCheck.Value
end)

Boxes.Settings:AddToggle("VisualsTeamColor", {
	Text = "team color",
	Default = false,
})

Toggles.VisualsTeamColor:OnChanged(function()
	visuals.teamColor = Toggles.VisualsTeamColor.Value
end)

Boxes.Settings:AddSlider("VisualsRenderDistance", {
	Text = "render distance",
	Default = 2000,
	Min = 0,
	Max = 2000,
	Rounding = 0,
	Compact = true,
})

Options.VisualsRenderDistance:OnChanged(function()
	visuals.renderDistance = Options.VisualsRenderDistance.Value
end)

Boxes.Boxes:AddToggle("Boxes", {
	Text = "enabled",
	Default = false,
}):AddColorPicker("BoxesColor", {
	Default = Color3.fromRGB(255, 255, 255),
	Title = "box color",
})

Toggles.Boxes:OnChanged(function()
	visuals.boxes.enabled = Toggles.Boxes.Value
end)

Options.BoxesColor:OnChanged(function()
	visuals.boxes.color = Options.BoxesColor.Value
end)

Boxes.Boxes:AddToggle("BoxesOutline", {
	Text = "outline",
	Default = false,
}):AddColorPicker("BoxesOutlineColor", {
	Default = Color3.fromRGB(0, 0, 0),
	Title = "outline color",
})

Toggles.BoxesOutline:OnChanged(function()
	visuals.boxes.outline.enabled = Toggles.BoxesOutline.Value
end)

Options.BoxesOutlineColor:OnChanged(function()
	visuals.boxes.outline.color = Options.BoxesOutlineColor.Value
end)

Boxes.Boxes:AddToggle("BoxesFilled", {
	Text = "filled",
	Default = false,
}):AddColorPicker("BoxesFilledColor", {
	Default = Color3.fromRGB(255, 255, 255),
	Title = "fill color",
})

Toggles.BoxesFilled:OnChanged(function()
	visuals.boxes.filled.enabled = Toggles.BoxesFilled.Value
end)

Options.BoxesFilledColor:OnChanged(function()
	visuals.boxes.filled.color = Options.BoxesFilledColor.Value
end)

Boxes.Boxes:AddSlider("BoxesFilledTransparency", {
	Text = "transparency",
	Default = 0.25,
	Min = 0,
	Max = 1,
	Rounding = 1,
	Compact = true,
})

Options.BoxesFilledTransparency:OnChanged(function()
	visuals.boxes.filled.transparency = Options.BoxesFilledTransparency.Value
end)

Boxes.Names:AddToggle("Names", {
	Text = "enabled",
	Default = false,
}):AddColorPicker("NamesColor", {
	Default = Color3.fromRGB(255, 255, 255),
	Title = "names color",
})

Toggles.Names:OnChanged(function()
	visuals.names.enabled = Toggles.Names.Value
end)

Options.NamesColor:OnChanged(function()
	visuals.names.color = Options.NamesColor.Value
end)

Boxes.Names:AddToggle("NamesOutline", {
	Text = "outline",
	Default = false,
}):AddColorPicker("NamesOutlineColor", {
	Default = Color3.fromRGB(0, 0, 0),
	Title = "outline color",
})

Toggles.NamesOutline:OnChanged(function()
	visuals.names.outline.enabled = Toggles.NamesOutline.Value
end)

Options.NamesOutlineColor:OnChanged(function()
	visuals.names.outline.color = Options.NamesOutlineColor.Value
end)

Boxes.Health:AddToggle("Health", {
	Text = "enabled",
	Default = false,
}):AddColorPicker("HealthColor", {
	Default = Color3.fromRGB(0, 255, 0),
	Title = "health color",
}):AddColorPicker("HealthLowColor", {
	Default = Color3.fromRGB(255, 0, 0),
	Title = "low health color",
})

Toggles.Health:OnChanged(function()
	visuals.health.enabled = Toggles.Health.Value
end)

Options.HealthColor:OnChanged(function()
	visuals.health.color = Options.HealthColor.Value
end)

Options.HealthLowColor:OnChanged(function()
	visuals.health.colorLow = Options.HealthLowColor.Value
end)

Boxes.Health:AddToggle("HealthOutline", {
	Text = "outline",
	Default = false,
}):AddColorPicker("NamesOutlineColor", {
	Default = Color3.fromRGB(0, 0, 0),
	Title = "outline color",
})

Toggles.HealthOutline:OnChanged(function()
	visuals.health.outline.enabled = Toggles.HealthOutline.Value
end)

Options.NamesOutlineColor:OnChanged(function()
	visuals.health.outline.color = Options.NamesOutlineColor.Value
end)

Boxes.Health:AddToggle("HealthText", {
	Text = "text",
	Default = false,
})

Toggles.HealthText:OnChanged(function()
	visuals.health.text.enabled = Toggles.HealthText.Value
end)

Boxes.Health:AddToggle("HealthTextOutline", {
	Text = "text outline",
	Default = false,
})

Toggles.HealthTextOutline:OnChanged(function()
	visuals.health.text.outline.enabled = Toggles.HealthTextOutline.Value
end)

Boxes.Distance:AddToggle("Distance", {
	Text = "enabled",
	Default = false,
}):AddColorPicker("DistanceColor", {
	Default = Color3.fromRGB(255, 255, 255),
	Title = "distance color",
})

Toggles.Distance:OnChanged(function()
	visuals.distance.enabled = Toggles.Distance.Value
end)

Options.DistanceColor:OnChanged(function()
	visuals.distance.color = Options.DistanceColor.Value
end)

Boxes.Distance:AddToggle("DistanceOutline", {
	Text = "outline",
	Default = false,
}):AddColorPicker("DistanceOutlineColor", {
	Default = Color3.fromRGB(0, 0, 0),
	Title = "outline color",
})

Toggles.DistanceOutline:OnChanged(function()
	visuals.distance.outline.enabled = Toggles.DistanceOutline.Value
end)

Options.DistanceOutlineColor:OnChanged(function()
	visuals.distance.outline.color = Options.DistanceOutlineColor.Value
end)

Boxes.Menu:AddLabel("hide keybind"):AddKeyPicker("Hide", { Default = "KeypadOne", NoUI = true }); Library.ToggleKeybind = Options.Hide
Boxes.Menu:AddLabel("unload keybind"):AddKeyPicker("Unload", { Default = "Delete", NoUI = true })
Boxes.Menu:AddButton("unload", function() Library:Unload() end)

Library.Colors = {
	MainColor       = Color3.fromHex("1e1e1e"),
	AccentColor     = Color3.fromHex("db4467"),
	OutlineColor    = Color3.fromHex("141414"),
	BackgroundColor = Color3.fromHex("232323")
}

for property, color in Library.Colors do
	Library[property] = color
end

Library.AccentColorDark = Library:GetDarkerColor(Library.AccentColor) Library:UpdateColorsUsingRegistry()