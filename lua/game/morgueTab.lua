MorgueTab = {}
MorgueTab.__index = MorgueTab

setmetatable(MorgueTab, {
  __index = MorgueTab,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function MorgueTab:_init()
	self:resetSelection()
end

function MorgueTab.new(self)

end

function MorgueTab.draw(self)
	local xOffset = 50
	local yOffset = 50
	for k,citizen in pairs(game.town.morgue) do
		if k >= self.rowDisplayed and k < self.rowDisplayed + 3 then
			screen:drawPortrait(xOffset, yOffset, citizen, alpha)
			local detailsString = "Name: " .. citizen.name .. " Occupation: " .. citizen.occupation .. "\n"
			detailsString = detailsString .. "Suspicion Level: " .. citizen.suspicious
			if citizen.alive == 0 then
				detailsString = detailsString .. " DEAD"
			end
			love.graphics.setColor(0, 0, 0, 255)
			love.graphics.printf(detailsString, 200, yOffset, love.graphics.getWidth() - 200, "left")
			yOffset = yOffset + 150
		end
	end

	local selectionX = 50
	local selectionY = 150 * self.rowSelected
	screen:drawCursor(selectionX, selectionY)
end

function MorgueTab.processControls(self, input)
	if controls:isUp(input) then
		if self.rowDisplayed > 1 and self.rowSelected == 1 then
			self.rowDisplayed = self.rowDisplayed - 1
			self.citizenSelected = self.citizenSelected - 1
		elseif self.rowSelected > 1 then
			self.rowSelected = self.rowSelected - 1
			self.citizenSelected = self.citizenSelected - 1
		end
	elseif controls:isDown(input) then
		if self.citizenSelected < table.getn(game.town.morgue) and self.rowSelected == 3 then
			self.rowDisplayed = self.rowDisplayed + 1
			self.citizenSelected = self.citizenSelected + 1
		elseif self.rowSelected < 3 then
			self.rowSelected = self.rowSelected + 1
			self.citizenSelected = self.citizenSelected + 1
		end
	elseif controls:isConfirm(input) then
		print(game.town.morgue[self.citizenSelected].name)
	end
end

function MorgueTab.keyreleased(self, key )
	--
end

function MorgueTab.mousepressed(self, x, y, button)
	--noop
end

function MorgueTab.update(self, dt)

end

function MorgueTab.resetSelection(self)
	self.rowDisplayed = 1
	self.rowSelected = 1
	self.citizenSelected = 1
end
