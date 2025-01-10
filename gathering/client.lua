clientGatheringElements = {}

function onClientElementDestroyGathering ( )
    destroyGatheringDisplay ( source )
end

function onClientElementStreamOutGathering ( )
    destroyGatheringDisplay ( source )
end

function createGatheringDisplay ( element )
    clientGatheringElements[ element ] = true
    if not isEventHandlerAdded( "onClientElementDestroy", element, onClientElementDestroyGathering ) then
        addEventHandler( "onClientElementDestroy", element, onClientElementDestroyGathering )
    end

    if not isEventHandlerAdded( "onClientElementStreamOut", element, onClientElementStreamOutGathering ) then
        addEventHandler( "onClientElementStreamOut", element, onClientElementStreamOutGathering )
    end

    createNameTag ( element )   
end

function destroyGatheringDisplay ( element )
    clientGatheringElements[ element ] = nil
    destroyNameTag ( element )
end

addEventHandler( "onClientElementStreamIn", root, 
function ( )

    if source and isElement( source ) then
        local elementType = getElementType( source )
        if elementType == "object" then
            if getElementData( source, "Gathering") then
                createGatheringDisplay ( source )
            end
        end
    end

end
)