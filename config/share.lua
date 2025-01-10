resourceName = getResourceName( getThisResource( ) )

config = {}
config.resize = 1
config.resize_max = 1.5
config.resize_min = 0.5

cooldownElements = {
    [ "cooldown_food" ] = true,
    [ "cooldown_thirst" ] = true,
    [ "cooldown_armor" ] = true,
    [ "cooldown_blood" ] = true,
}

statusLimitElements = {
    [ "food" ] = 100,
    [ "thirst" ] = 100,
    [ "armor" ] = 100,
    [ "blood" ] = 100,
}

sounds_effect = {
    [ "equip1" ] = "files/sounds/equip1.wav",
    [ "equip2" ] = "files/sounds/equip2.wav",
    [ "equip3" ] = "files/sounds/equip3.wav",
    [ "equip4" ] = "files/sounds/equip4.mp3",
}

inventoryItems = {
    [ "food_001" ] = { itemName = "Apple", weight = 1, itemUsageLoss = 1, path_image = ":" .. resourceName .. "/inventory/images/food_001.png", cooldown = { name = "cooldown_food", interval = 4 }, event = { name = "onPlayerGiveStatusElementEating", arg = { "food", 50 } }, frozen = 0, anim = { interval = 1, arg = { "FOOD", "EAT_Burger", -1, false, false, nil, false } } },
    [ "food_002" ] = { itemName = "Blueberries", weight = 1, itemUsageLoss = 1, path_image = ":" .. resourceName .. "/inventory/images/food_002.png", cooldown = { name = "cooldown_food", interval = 4 }, event = { name = "onPlayerGiveStatusElementEating", arg = { "food", 50 } }, frozen = 0, anim = { interval = 1, arg = { "FOOD", "EAT_Burger", -1, false, false, nil, false } } },
    
    [ "food_003" ] = { itemName = "Small Water Bottle", weight = 1, itemUsageLoss = 1, path_image = ":" .. resourceName .. "/inventory/images/food_003.png", cooldown = { name = "cooldown_thirst", interval = 4 }, event = { name = "onPlayerGiveStatusElementEating", arg = { "thirst", 30 } }, frozen = 0, anim = { interval = 1, arg = { "FOOD", "EAT_Burger", -1, false, false, nil, false } } },
    [ "food_004" ] = { itemName = "Bota Bag", weight = 1, itemUsageLoss = 1, path_image = ":" .. resourceName .. "/inventory/images/food_004.png", cooldown = { name = "cooldown_thirst", interval = 4 }, event = { name = "onPlayerGiveStatusElementEating", arg = { "thirst", 30 } }, frozen = 0, anim = { interval = 1, arg = { "FOOD", "EAT_Burger", -1, false, false, nil, false } } },

    [ "resources_001" ] = { itemName = "Wood", weight = 0.1, path_image = ":" .. resourceName .. "/inventory/images/resources_001.png" },
    [ "resources_002" ] = { itemName = "Stones", weight = 0.1, path_image = ":" .. resourceName .. "/inventory/images/resources_002.png" },

    [ "ammo_001" ] = { itemName = "Wooden Arrow", weight = 0.002, path_image = ":" .. resourceName .. "/inventory/images/ammo_001.png" },
    [ "ammo_002" ] = { itemName = "Ammo", weight = 0.002, path_image = ":" .. resourceName .. "/inventory/images/ammo_002.png" },

    [ "melee_001" ] = { 
        itemName = "Moon Flame", weight = 1, path_image = ":" .. resourceName .. "/inventory/images/melee_001.png", 
        weapon = { 
            weaponType = "melee", weapon_id = 8, emotion = "knife", sound_emotion = { [1] = "sword-swing-01", [2] = "sword-swing-02", [3] = "sword-swing-02" }, model_scale = 1, modelid = 50001, damage = 20,
            [ "rearm" ] = { path_sound = sounds_effect["equip3"], bone = 25, volume = 0.6, max_distance = 20, min_distance = 1, interval = 1 },
            [ "remove" ] = { path_sound = sounds_effect["equip3"], bone = 25, volume = 0.4, max_distance = 20, min_distance = 1, interval = 1 },
            [ "switch" ] = { path_sound = sounds_effect["equip4"], bone = 25, volume = 0.4, max_distance = 20, min_distance = 1, interval = 1 },
        }, 
        cooldown = { name = "cooldown_weapon", interval = 1 }, 
        event = { name = "onPlayerUsingWeapon", arg = { } },
    },

}

gatheringConfig = {}
gatheringConfig.respawnMining = 1000 * 60 * 10
gatheringConfig.respawnWood = 1000 * 60 * 10

gatheringConfig.Mining = {
    { modelID = 1304, name = "Rock", model_height = 0.4, display_height = 1, position = { 79, 15, -0.390625 } },
}

gatheringConfig.CuttingWood = {
    { modelID = 622, name = "Tree", model_height = 1.5, display_height = 2, position = { -96, -172, 1.3128939 } },
}

damageSpecial = {
	[19] = 0, -- เครื่องยิงจรวด
	[37] = 0, -- เผา
	[49] = { ["original"] = 0 }, -- กระแทก
	[50] = { ["original"] = 1 }, -- Ranover / ใบพัดเฮลิคอปเตอร์
	[51] = 0, -- จรวด/รถระเบิด
	[52] = { ["original"] = false }, -- ไม่มีการใช้งาน
	[53] = 1, -- จมน้ำ
	[54] = { ["original"] = false }, -- ตก
	[55] = { ["original"] = false }, -- ไม่มีการใช้งาน
	[56] = { ["original"] = false }, -- ไม่มีการใช้งาน
	[57] = { ["original"] = false }, -- ไม่มีการใช้งาน
	[59] = 0, -- Tank Grenade / รถถัง
    [63] = { ["original"] = false }, -- Blown / รถระเบิด
    [0] = 0 ,
}

damageBodyPart = {
    [3] = 1,
    [4] = 1,
    [5] = 1,
    [6] = 1,
    [7] = 1,
    [8] = 1,
    [9] = 1.5,
}

function getDamageBodyPart ( bodyID )
    if damageBodyPart[ bodyID ] then
        return damageBodyPart[ bodyID ]
    end
    return 1
end

function getInvnetoryItems ( )
    return inventoryItems
end

function getInventoryItem ( itemID )
    if inventoryItems[ itemID ] then
        return inventoryItems[ itemID ]
    end
    return false
end

function getInventoryItemID ( itemName )
    local tb = {}
    for itemID, invData in pairs( inventoryItems ) do
        if invData.itemName == itemName then
            table.insert( tb, itemID )
        end
    end
    return tb
end

function getInventoryItemName ( itemID )
    local inv_data = getInventoryItem ( itemID )
    if inv_data then
        return inv_data.itemName
    end
    return false
end

function getInvnetoryWeightByID ( itemID )
    local inv_data = getInventoryItem ( itemID )
    if inv_data then
        return tonumber( inv_data.weight )
    end
    return false
end

function getInventoryItemPathImage ( itemID )
    local inv_data = getInventoryItem ( itemID )
    if inv_data then
        return inv_data.path_image
    end
    return false
end

function getInventoryItemUsageLoss ( itemID )
    local inv_data = getInventoryItem ( itemID )
    if inv_data then
        return tonumber( inv_data.itemUsageLoss )
    end
    return false
end

function getInventoryItemWeapon ( itemID )
    local inv_data = getInventoryItem ( itemID )
    if inv_data then
        if inv_data.weapon then
            return inv_data.weapon
        end
    end
    return false
end

function getInventoryItemWeaponType ( itemID )
    local inv_data = getInventoryItemWeapon ( itemID )
    if inv_data then
        return inv_data.weaponType
    end
    return false
end

function getPlayerInventoryWeight ( player )
    local weight = 0
    for itemID, invData in pairs( inventoryItems ) do
        local qty = getElementData( player, itemID ) or 0
        if qty > 0 then
            weight = weight + ( invData.weight * qty )
        end
    end
    return weight
end

function getInventoryItemByWeaponID ( weaponID )
    for itemID, inv_data in pairs( inventoryItems ) do
        if inv_data.weapon then
            if inv_data.weapon.weapon_id and inv_data.weapon.weapon_id == weaponID then
                return itemID
            end
        end
    end
    return false
end

function getWeaponDataByWeaponID ( player, weaponID )
    local currentWeapon = getElementData( player, "currentWeapon" )
    if currentWeapon then
        local inv_data = inventoryItems[ currentWeapon ]
        if inv_data then
            local qty = getElementData( player, currentWeapon )
            if qty and qty > 0 then
                local weaponData = inv_data.weapon
                if weaponData and weaponData.weapon_id and weaponData.weapon_id == weaponID then
                    return weaponData, currentWeapon
                end
            end
        end
    end
    return false
end

function getPlayerWeaponAmnoByWeaponID ( player, weaponID )
    local weapData, itemID = getWeaponDataByWeaponID ( player, weaponID )
    if weapData then
        local ammoID = weapData.ammoID
        if ammoID then
            if type( ammoID ) == "table" then
                for i,v in ipairs( ammoID ) do
                    local qty = getElementData( player, v ) or 0
                    if qty >= 1 then
                        return v
                    end
                end
            else
                local qty = getElementData( player, ammoID ) or 0
                if qty >= 1 then
                    return k
                end
            end
        end
    end
    return false
end

function getWeaponAmmoFromPedByItemID ( player, itemID )
    local inv_data = inventoryItems[ itemID ]
    if inv_data then
        local weapon_data = inv_data.weapon
        if weapon_data then
            local ammoID = weapon_data.ammoID
            
            if ammoID then
                if type( ammoID ) == "table" then
                    for i,v in ipairs( ammoID ) do
                        local qty = getElementData( player, v ) or 0
                        if qty >= 1 then
                            return v
                        end
                    end
                else
                    local qty = getElementData( player, ammoID ) or 0
                    if qty >= 1 then
                        return k
                    end
                end
            end

        end
    end
    return false
end

function getWeaponDamageByWeaponID ( player, weaponID )
    local weapData, weapID = getWeaponDataByWeaponID ( player, weaponID )
    if weapData then
        if weapData.weapon_id and weapData.weapon_id == weaponID then
            return weapData.damage, weapID
        end
    end
    return false
end

function getWeaponDamage ( itemID )
    local inv_data = inventoryItems[ itemID ]
    if inv_data then
        local weaponData = inv_data.weapon
        if weaponData then
            return weaponData.damage
        end
    end
    return 0
end

function getPlayerWeaponID ( player )
    local weaponID = getPedWeapon( player )
    local weapData, itemID = getWeaponDataByWeaponID ( player, weaponID )
    if weapData and itemID then
        return itemID
    end
    return false
end
