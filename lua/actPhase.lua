require("lua/game/actions/killActionTab")
require("lua/game/actions/endHuntAction")
require("lua/game/actions/canvasAction")

ActPhase = {}
ActPhase.__index = ActPhase

setmetatable(ActPhase, {
  __index = ActPhase,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function ActPhase:_init()
	self.sfx = "menu"

	self.selections = {
		["back"]          = UIElement("back", 5, 560, "endHuntAction", "back", "back", "confirm",
									  function() toState = game.preparationPhase end, "buttonBackground", "buttonHighlight", "Back", 10, 5),
		["confirm"]       = UIElement("confirm", 685, 560, "killAction", "confirm", "back", "confirm",
									  function() game.actPhase.readyToExecute = true end, "buttonBackground", "buttonHighlight", "Confirm", 10, 5),
		["killAction"]    = UIElement("killAction", 25, 128, "canvasAction", "endHuntAction", "killAction", "killAction",
									  function() game.actPhase.selectedTab = "killAction" end, "actionBackground", "actionHighlight", "Kill", 50, 40),
		["canvasAction"]  = UIElement("canvasAction", 25, 25, "canvasAction", "killAction", "canvasAction", "canvasAction",
									  function() table.insert(game.actPhase.actionsToExecute, CanvasAction()) end, "actionBackground", "actionHighlight", "Canvas Town", 50, 40),
		["endHuntAction"] = UIElement("endHuntAction", 25, 256, "killAction", "back", "endHuntAction", "endHuntAction",
									  function() table.insert(game.actPhase.actionsToExecute, EndHuntAction()) end, "actionBackground", "actionHighlight", "End Hunt", 50, 40)
	}
	self.selected = self.selections["confirm"]

	self.selectedTab = ""
	self.killActionTab = KillActionTab()

	self.readyToExecute = false
	self.actionsToExecute = {}
end

function ActPhase.new(self)

end

function ActPhase.draw(self)
	screen:drawPhaseBackground()

	for _,uiElement in pairs(self.selections) do
			if uiElement == self.selected then
				love.graphics.draw(images:getImage(uiElement.highlight), uiElement.x, uiElement.y)
			else
				love.graphics.draw(images:getImage(uiElement.image), uiElement.x, uiElement.y)
			end
			love.graphics.print(uiElement.text, uiElement.x + uiElement.textXOffset, uiElement.y + uiElement.textYOffset)
	end

	if self.selectedTab == "" then
		screen:drawCursor(self.selected.x, self.selected.y)
	elseif self.selectedTab == "killAction" then
		self.killActionTab:draw()
	end
end

function ActPhase.processControls(self, input)
	if self.selectedTab ~= "" then
		if controls:isBack(input) then
			self.selectedTab = ""
		elseif self.selectedTab == "killAction" then
			self.killActionTab:processControls(input)
		end
	else
		if controls:isLeft(input) then
			self.selected = self.selections[self.selected.left]
		elseif controls:isRight(input) then	
			self.selected = self.selections[self.selected.right]
		elseif controls:isUp(input) then
			self.selected = self.selections[self.selected.up]
		elseif controls:isDown(input) then
			self.selected = self.selections[self.selected.down]
		elseif controls:isConfirm(input) then
			self.selected.confirm()
		end
		soundEffects:playSoundEffect(self.sfx)
	end
end

function ActPhase.keyreleased(self, key )
	--
end

function ActPhase.mousepressed(self, x, y, button)
	--
end

function ActPhase.update(self, dt)
	if self.readyToExecute then
		self.readyToExecute = false
		toState = game.resultsPhase

		game.town.day = game.town.day + 1
		--Go through each action selected and perform it
		for _,action in pairs(self.actionsToExecute) do
			action:act()
		end

		self.actionsToExecute = {}
	end
end
