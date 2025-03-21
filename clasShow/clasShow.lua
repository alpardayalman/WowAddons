local frame = CreateFrame("Frame", "TargetInfoFrame", UIParent)
frame:SetSize(250, 40)  -- Set the frame size
frame:SetPoint("LEFT", UIParent, "LEFT", 0, 100)  -- Position the frame at the center of the screen

-- Create a text object to display the information
local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
text:SetPoint("CENTER")
text:SetText("Class: N/A")

-- Function to get the target's class and spec
local function GetTargetClassSpec()
    local target = UnitName("target")
    if target then
        -- Get the target's class
        local className, classFileName = UnitClass("target")

        -- Get the target's specialization (spec)
        local specID = GetSpecialization("target")
        local specName = specID and GetSpecializationInfo(specID)

        return className or "N/A"
    else
        return "No Target", "N/A"
    end
end

-- Function to update the target info
local function UpdateTargetInfo()
    local target = UnitName("target")
    
    if target then
        -- Get class and spec for the target
        local className, specName = GetTargetClassSpec()

        -- Update the displayed text
        text:SetText("Class: " .. className)
    else
        text:SetText("No Target")
    end
end

-- Set up events
frame:RegisterEvent("PLAYER_TARGET_CHANGED")  -- Fires when the target changes
frame:RegisterEvent("UNIT_PET")               -- To ensure it checks if the pet is targeted too

-- Update on load
frame:SetScript("OnEvent", UpdateTargetInfo)

-- Optionally, check the target every 1 second in case of updates while in combat or other circumstances
C_Timer.NewTicker(1, function()
    if UnitExists("target") then
        UpdateTargetInfo()
    end
end)



-- Dragging functionality
frame:SetMovable(true)
frame:EnableMouse(true)
frame:SetClampedToScreen(true)  -- Keeps the frame within the screen bounds

-- When the mouse is pressed, we start dragging
frame:SetScript("OnMouseDown", function(self, button)
    if button == "LeftButton" then
        isDragging = true
        startX, startY = self:GetCenter()
        self:StartMoving()
    end
end)

-- When the mouse is released, we stop dragging
frame:SetScript("OnMouseUp", function(self, button)
    if button == "LeftButton" then
        isDragging = false
        self:StopMovingOrSizing()
    end
end)

-- To update the position of the frame while dragging
frame:SetScript("OnUpdate", function(self)
    if isDragging then
        local x, y = GetCursorPosition()
        local scale = UIParent:GetEffectiveScale()
        local centerX = x / scale
        local centerY = y / scale
        self:SetPoint("CENTER", UIParent, "BOTTOMLEFT", centerX - self:GetWidth() / 2, centerY - self:GetHeight() / 2)
    end
end)
