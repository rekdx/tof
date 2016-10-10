local acutil = require("acutil");

function SHOWPETSTAMINA_ON_INIT(addon, frame)
	acutil.setupHook(UPDATE_COMPANION_TITLE_HOOKED, "UPDATE_COMPANION_TITLE");
	acutil.setupHook(ON_RIDING_VEHICLE_HOOKED, "ON_RIDING_VEHICLE");
end

local function showMountedStamina()
    local pc = GetMyPCObject();
    local ridingAttributeCheck = GetAbility(pc, "CompanionRide");
    local petInfo = session.pet.GetSummonedPet();
    local obj = GetIES(petInfo:GetObject());
    local myActor = GetMyActor();
    local charBaseFrame = ui.GetFrame("charbaseinfo1_my");

    if ridingAttributeCheck ~= nil then
        if myActor:GetVehicleState() then
            local staminaGauge = charBaseFrame:CreateOrGetControl("gauge", "mountedStaminaGauge", 0, 0, 104, 10);
            tolua.cast(staminaGauge, "ui::CGauge");

            staminaGauge:SetPoint(obj.Stamina, obj.MaxStamina);
            staminaGauge:SetGravity(ui.CENTER_HORZ, ui.TOP)
            staminaGauge:SetSkinName('pcinfo_gauge_sta2');
            staminaGauge:Resize(staminaGauge:GetWidth(), staminaGauge:GetHeight())
            staminaGauge:Invalidate();
        else
            charBaseFrame:RemoveChild('mountedStaminaGauge');
        end

        charBaseFrame:Invalidate();
    end
end

function UPDATE_COMPANION_TITLE_HOOKED(frame, handle)
    _G["UPDATE_COMPANION_TITLE_OLD"](frame, handle);
    showMountedStamina();
end

function ON_RIDING_VEHICLE_HOOKED(onoff)
    _G["ON_RIDING_VEHICLE_OLD"](onoff)
    showMountedStamina();
end
