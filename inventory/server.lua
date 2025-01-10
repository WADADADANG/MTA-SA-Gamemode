
addEvent( "onPlayerInventoryUsingItem", true )
addEventHandler( "onPlayerInventoryUsingItem", resourceRoot, 
function ( itemID, amount )
    if not client then return end
    if not itemID then return end
    if not amount then return end

    local inventoryData = inventoryItems[ itemID ]
    if inventoryData then
        local qty = getElementData( client, itemID ) or 0
        if qty and qty >= amount then

            if inventoryData.cooldown then
                local cooldown = getElementData( client, inventoryData.cooldown.name ) or 0
                if cooldown and cooldown > 0 then
                    return false
                end
            end

            if inventoryData.itemUsageLoss and inventoryData.itemUsageLoss >= 1 then
                qty = qty - inv_data.itemUsageLoss
                if qty < 0 then qty = 0 end
                setElementData( client, itemID, qty )
            end

            if inventoryData.anim then
                local anim_args = inventoryData.anim.arg
                if anim_args and type( anim_args ) == "table" then
                    setPedAnimation( client, unpack( anim_args ) )
                end
            end

            if inventoryData.frozen and inventoryData.frozen >= 1 then
                setElementFrozen( client, true )
                setTimer( setElementFrozen, 1000 * inventoryData.frozen, 1, client, false )
            end

            if inventoryData.event then
                local event_name = inventoryData.event.name
                local event_args = inventoryData.event.arg
                if event_name and event_args and type( event_args ) == "table" then
                    triggerEvent( event_name, client, itemID, amount, unpack( event_args ) )
                end
            end

            triggerEvent( "onPlayerInventoryItemUsed", client, itemID, amount )
            triggerClientEvent( client, "onClientPlayerInventoryItemUsed", client, itemID, amount )
        end

    end

end
)

addEventHandler( "onPlayerInventoryItemUsed", root, 
function ( itemID, amount )
    if client then return end

    local inventoryData = inventoryItems[ itemID ]
    if inventoryData then

        if inventoryData.cooldown then
            setElementData( source, inventoryData.cooldown.name, inventoryData.cooldown.interval )
            setTimer( setElementData, 1000 * inventoryData.cooldown.interval, 1, source, inventoryData.cooldown.name, false )
        end
        
    end
end
)

-- เหตุการณ์เมื่อผู้เล่นใช้ไอเทม และได้รับสถานะ ( ตัวอย่างเช่น การกินอาหาร จะได้รับสถานะอาหารเพิ่ม ) เหตุการนี้ ส่งมาจาก server เท่านั้น
addEvent( "onPlayerGiveStatusElementEating", true )
addEventHandler( "onPlayerGiveStatusElementEating", root, 
function ( itemID, amount, statusElement, value )
    if client then return end

    if not itemID then return end
    if not amount then return end
    if not statusElement then return end
    if not value then return end

    if statusLimitElements[ statusElement ] then
        if inventoryItems[ itemID ] then
            local status = getElementData( source, statusElement ) or 0
            status = status + value
            if status > statusLimitElements[ statusElement ] then
                status = statusLimitElements[ statusElement ]
            end
            setElementData( source, statusElement, status )
        end
    end

end
)

addEvent( "onPlayerUsingWeapon", true )
addEventHandler( "onPlayerUsingWeapon", root, 
function ( itemID )
    if client then return end

    local currentWeapon = getElementData( source, "currentWeapon" )
    if currentWeapon then
        if currentWeapon == itemID then
            setPlayerWeaponRemove( source, itemID )
        else
            setPlayerWeaponRearm( source, itemID )
        end
    else
        setPlayerWeaponRearm( source, itemID )
    end

end
)