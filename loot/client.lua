
local distance = 30
local height = 0.6
local size = 64

local lootDisplay = {}
local postGUI = false

local dp = {}
dp.box = {}
dp.box.w = resizeUI ( 4 )
dp.box.h = resizeUI ( 1 )

dp.text = {}
dp.text.scale = 1
dp.text.font = "default-bold"
dp.text.distY = 0
dp.text.sizeShadow = dp.text.scale

addEventHandler( "onClientRender", root, 
function ( )

    for element,_ in pairs( lootDisplay ) do
        if element and isElement( element ) then
            if getElementData( element, "loot" ) then

                local px, py, pz = getCameraMatrix( )
                local tx, ty, tz = getElementPosition( element )

                local dist = getDistanceBetweenPoints3D( tx, ty, tz, px, py, pz )
                if dist <= distance then
                    local x, y = getScreenFromWorldPosition( tx, ty, tz + height )
                    if x and y then

                        -- local resize = ( size ) - ( ( size * dist ) / distance )
                        -- if resize < 0 then resize = 0 end
                        -- local rotation = 0
                        -- dxDrawImage( ( x - resize/2 ), ( y - resize/2 ), resize, resize, "files/images/loot.png", rotation, 0, 0, tocolor( 255, 255, 255, 160 ), postGUI )

                        local loot_name = getElementData( element, "loot_name" )
                        if loot_name then
                            local text = loot_name
                            local scale = ( dp.text.scale ) - ( ( dp.text.scale * dist ) / distance )
                            local distYText = ( dp.text.distY ) - ( ( dp.text.distY * dist ) / distance )
                            local font = dp.text.font
                        
                            local textWidth = dxGetTextWidth( string.gsub( text, "#%x%x%x%x%x%x", "" ), scale, font )
                            local textHeight = dxGetFontHeight( scale, font )

                            local boxWidth = dp.box.w + textWidth + dp.box.w
                            local boxHeight = dp.box.h + textHeight + dp.box.h
                            local colorBox = tocolor( 26, 26, 26, 255 )
                            dxDrawRectangle( x - ( textWidth/2 ) - dp.box.w, y + distYText - dp.box.h, boxWidth, boxHeight, colorBox, postGUI )
        
                            dxDrawText( string.gsub( text, "#%x%x%x%x%x%x", "" ), x - ( textWidth/2 ) + dp.text.sizeShadow, y + distYText + dp.text.sizeShadow, textWidth, textHeight, tocolor( 26, 26, 26, 160 ), scale, font, "left", "top", false, false, postGUI, true, false, 0, 0, 0 )
                            dxDrawText( text, x - textWidth/2, y + distYText, textWidth, textHeight, tocolor( 220, 220, 220, 255 ), scale, font, "left", "top", false, false, postGUI, true, false, 0, 0, 0 )
                        end

                    end
                end

            end
        end
    end
    
end
)

function onClientElementDestroyCol ( )
    if lootDisplay[ source ] then
        lootDisplay[ source ] = nil
    end
end
function onClientElementStreamOutLootObject ( )
    local col = getElementData( source, "parent" )
    if col then
        if lootDisplay[ col ] then
            lootDisplay[ col ] = nil
        end
    end
end

function createElementLootDisplay ( element )
    if element and isElement( element ) then
        local lootElement = getElementData( element, "loot" )
        if lootElement then
            if not lootDisplay[ element ] then
                lootDisplay[ element ] = true

                if not isEventHandlerAdded( "onClientElementDestroy", element, onClientElementDestroyCol ) then
                    addEventHandler( "onClientElementDestroy", element, onClientElementDestroyCol )
                end

                return true
            end
        end
    end
    return false
end

addEventHandler( "onClientElementStreamIn", root, 
function ( )

    if source and isElement( source ) then
        local elementType = getElementType( source )
        if elementType ~= "player" then
            if getElementData( source, "loot" ) then
                local col = getElementData( source, "parent" )
                if col then
                    if createElementLootDisplay ( col ) then

                        if not isEventHandlerAdded( "onClientElementStreamOut", source, onClientElementStreamOutLootObject ) then
                            addEventHandler( "onClientElementStreamOut", source, onClientElementStreamOutLootObject )
                        end

                    end
                end
            end
        end
    end

end
)

addCommandHandler( "client-set-item", 
function ( )
    setElementData( getLocalPlayer(  ), "food_001", math.random( 1, 100 ) )
    outputChatBox( "Set item success", 0, 255, 0 )
end
)
