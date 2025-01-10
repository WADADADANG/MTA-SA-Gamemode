
function onPlayerColShapeHit ( thePlayer )
    if thePlayer and isElement( thePlayer ) and getElementType( thePlayer ) == "player" then
        if isPedInVehicle( thePlayer ) then return false end
        setElementData( thePlayer, "loot", source )
    end
end

function onPlayerColShapeLeave ( thePlayer )
    if thePlayer and isElement( thePlayer ) and getElementType( thePlayer ) == "player" then
        setElementData( thePlayer, "loot", false )
    end
end

function createLootColTube ( x, y, z, MAX_Slots, loot_name, destroyTimer, modelid )
    local fRadius = 2
    local fHeight = 1
    MAX_Slots = MAX_Slots or 2
    loot_name = loot_name or "other"
    local theCol = createColTube( x, y, z, fRadius, fHeight )
    if theCol then
        local theObject = createObject( modelid or 1371, x, y, z + 0.2 )
        setObjectScale( theObject, 0.2 )

        setElementData( theCol, "loot", true )
        setElementData( theCol, "loot_name", loot_name )
        setElementData( theCol, "parent", theObject )
        setElementData( theCol, "MAX_Slots", MAX_Slots )

        setElementData( theObject, "loot", true )
        setElementData( theObject, "parent", theCol )

        addEventHandler ( "onColShapeHit", theCol, onPlayerColShapeHit )
        addEventHandler ( "onColShapeLeave", theCol, onPlayerColShapeLeave )

        if destroyTimer and type( destroyTimer ) == "number" and destroyTimer > 0 then
            setTimer( destroyLoot, 1000 * destroyTimer, 1, theCol )
        end
        return theCol
    end
    return false
end

function getLootByItemID ( element, itemID )
    if element and isElement( element ) then
        if getElementData( element, "loot" ) == true then
            local items = getElementData( element, "items" )
            if items and type( items ) == "table" then
                return items[ itemID ]
            end
        end
    end
    return false
end

function destroyLoot ( element )
    if element and isElement( element ) then
        if getElementData( element, "loot" ) == true then
            local loot_object = getElementData( element, "parent" )
            if loot_object and isElement( loot_object ) and getElementType( loot_object ) == "object" then 
                destroyElement( loot_object ) 
            end
            return destroyElement( element )
        end
    end
    return false
end

local loot_location = {
    { 
        location = { 92.795, -52.787, 0.944 - 0.96 },
        items = {},
        MAX_Slots = 1000000,
        loot_name = "High Loot",
    }
}

for i,v in ipairs( loot_location ) do
    if v.items then
        for itemID,invData in pairs( inventoryItems ) do
            table.insert( v.items, { itemID, 9999 } )
        end
    end
end

setTimer( function ( )
    for i,v in ipairs( loot_location ) do
        local theLoot = createLootColTube ( v.location[ 1 ], v.location[ 2 ], v.location[ 3 ], v.MAX_Slots, v.loot_name )
        if theLoot then
            if v.items then
                for _,item in ipairs( v.items ) do
                    setElementData ( theLoot, item[ 1 ], item[ 2 ] )
                end
            end
        end
    end
end, 1000 * 2, 1 )
