elementWeapons = {}

function createWeapon ( player, itemID, isGiveWeapon )
    local inv_data = getInventoryItem ( itemID )
    if inv_data then
        local weapon_data = inv_data.weapon
        if weapon_data then
            local weapon_id = weapon_data.weapon_id
            local weapon_type = weapon_data.weaponType
            local weapon_modelid = weapon_data.modelid
            local weapon_scale = weapon_data.model_scale or 1
            local totalAmmo = 1
            local ammoInClip = 0

            if weapon_type == "melee" then
                totalAmmo = 1
                ammoInClip = 1
            else
                local weapon_ammoName = getPlayerWeaponAmnoByWeaponID ( player, itemID )
                if weapon_type == "gun" then
                    if weapon_ammoName then
                        totalAmmo = getElementData( player, weapon_ammoName ) or 0
                        ammoInClip = weapon_data.clip_ammo or 0
                    end
                elseif weapon_type == "bow" then
                    if weapon_ammoName then
                        totalAmmo = getElementData( player, weapon_ammoName ) or 0
                        ammoInClip = 1
                    else
                        totalAmmo = 0
                        ammoInClip = 0
                    end
                end
            end
            
            local weaponObject = exports.newmodels_reborn:createObject( weapon_modelid, 0, 0, 0 )
            if weaponObject then
                destroyElementWeapon ( player )
                elementWeapons[ player ] = weaponObject
                setElementData( player, "currentWeapon", itemID )
                setObjectScale( weaponObject, weapon_scale )
                exports.pAttach:attach( weaponObject, player, "weapon" )

                if isGiveWeapon then
                    giveWeapon( player, weapon_id, totalAmmo )
                    setWeaponAmmo( player, weapon_id, totalAmmo, ammoInClip )
                end
                return weaponObject
            end

        end
    end
    return false
end

function destroyElementWeapon ( player )
    takeAllWeapons( player )
    if elementWeapons[ player ] then
        if isElement( elementWeapons[ player ] ) then
            destroyElement( elementWeapons[ player ] )
        end
        elementWeapons[ player ] = nil
        setElementData( player, "currentWeapon", false )
        return true
    end
    return false
end

function setPlayerWeaponRearm ( player, itemID )
    local inv_data = getInventoryItem ( itemID )
    if inv_data then
        if createWeapon ( player, itemID, true ) then

            triggerEvent( "onPlayerWeaponRearmed", player, itemID )
            triggerClientEvent( root, "onClientPlayerWeaponRearmed", player, itemID )
            return true
        end
    end
    return false
end

function setPlayerWeaponRemove ( player, itemID )
    local inv_data = getInventoryItem ( itemID )
    if inv_data then
        local weapon_data = inv_data.weapon
        if weapon_data then
            destroyElementWeapon ( player )

            triggerEvent( "onPlayerWeaponRemoved", player, itemID )
            triggerClientEvent( root, "onClientPlayerWeaponRemoved", player, itemID )
            return true
        end
    end
    return false
end

addEventHandler( "onPlayerDead", root, 
function ( )
    
    local currentWeapon = getElementData( source, "currentWeapon" )
    if currentWeapon then
        setPlayerWeaponRemove( source, currentWeapon )
    end

end
)

addEventHandler( "onPlayerWeaponSwitch", root, 
function ( prevSlot, currentSlot )
    
    local currentWeapon = getElementData( source, "currentWeapon" )
    if not currentWeapon then return end

    local inv_data = getInventoryItem ( currentWeapon )
    if inv_data then
        local weapon_data = inv_data.weapon
        if weapon_data then
            local weapon_id = weapon_data.weapon_id
            local weapon_modelid = weapon_data.modelid

            if weapon_id then
                if weapon_id == currentSlot then
                    createWeapon ( source, currentWeapon, false )
                    triggerClientEvent( root, "onClientPlayerWeaponSwitched", source, currentWeapon )
                    triggerEvent( "onPlayerWeaponSwitched", source, currentWeapon )
                else
                    destroyElementWeapon ( source )
                    triggerClientEvent( root, "onClientPlayerWeaponSwitched", source, false )
                    triggerEvent( "onPlayerWeaponSwitched", source, false )
                end
            end
        end
    end

end
)