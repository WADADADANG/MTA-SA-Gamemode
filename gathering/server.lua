
function createGatheringMining ( id )
    local gatheringData = gatheringConfig.Mining[ id ]
    if gatheringData then

        local modelid = gatheringData.modelID
        local x, y, z = gatheringData.position[ 1 ], gatheringData.position[ 2 ], gatheringData.position[ 3 ]
        local rz = math.random( 0, 360 )
        local name = gatheringData.name or "Rock"
        local model_height = gatheringData.model_height
        local display_height = gatheringData.display_height

        local theObject = createObject ( modelID, x, y, z + model_height, 0, 0, rz, false )
        if theObject then
            setObjectBreakable( theObject, true )
            setElementFrozen( theObject, true )

            local theBlip = createBlipAttachedTo( theObject, 0, 1, 153, 153, 153, 160, 0, 80 )
            setElementData( theBlip, "Gathering", "Mining" )
            setElementData( theBlip, "Gathering > Mining", id )
            setElementData( theBlip, "parent", theObject )

            setElementData( theObject, "Gathering", "Mining" )
            setElementData( theObject, "Gathering > Mining", id )
            setElementData( theObject, "blip", theBlip )
            setElementData( theObject, "nametag_display", name )

            setElementData( theObject, "configDisplay", 
                {
                    height = display_height,
                    distance = 30,
                    scale = 1,
                    font = "default-bold",
                    sizeShadow = { x = 1, y = 1 },
                    color = { 220, 220, 220, 220 },
                    colorShadow = { 26, 26, 26, 160 },
                    distYTextLoop = 1,
                }
            )

            setElementData( theObject, "blood", 50 )
            setElementData( theObject, "MAX_Blood", 50 )

            setElementData( theObject, "armor", 50 )
            setElementData( theObject, "MAX_Armor", 50 )

            addEventHandler( "onElementDestroy", theObject, 
            function ( )
                local miningID = getElementData( source, "Gathering > Mining" )
                if miningID then
                    setTimer( createGatheringMining, gatheringConfig.respawnMining, 1, miningID )
                end
                local blip = getElementData( source, "blip" )
                if blip and isElement( blip ) then
                    destroyElement( blip )
                end
            end
            )

            return theObject
        end
    end
    return false
end

setTimer( function ( )
    
    for index,value in ipairs( gatheringConfig.Mining ) do
        createGatheringMining ( gatheringConfig.Mining )
    end

end, 1000 * 1, 1 )