
local elementNamtagDisplay = {}
local postGUI = false
local default_display = {}
default_display.height = 2
default_display.distance = 30

default_display.text = {}
default_display.text.scale = resizeUI ( 1.2 )
default_display.text.font = "default-bold"
default_display.text.sizeShadow = { x = default_display.text.scale, y = default_display.text.scale }
default_display.text.color = { 220, 220, 220, 220 }
default_display.text.colorShadow = { 26, 26, 26, 160 }
default_display.text.distYTextLoop = resizeUI ( 2 )

default_display.blood = {}
default_display.blood.w = resizeUI ( 120 )
default_display.blood.h = resizeUI ( 8 )
default_display.blood.distY = resizeUI ( 0 )
default_display.blood.sizeShadow = { x = resizeUI ( 2 ), y = resizeUI ( 2 ) }
default_display.blood.color = tocolor( 255, 60, 60, 255 )
default_display.blood.colorBg = tocolor( 26, 26, 26, 60 )
default_display.blood.colorShadow = tocolor( 26, 26, 26, 120 )

default_display.armor = {}
default_display.armor.color = tocolor( 123, 104, 238, 255 )

addEventHandler( "onClientRender", root, 
function ( )

    for element,v in pairs( elementNamtagDisplay ) do
        if element and isElement( element ) then
            local configDisplay = getElementData( element, "configDisplay" )
            local distance = default_display.distance
            local height = default_display.height
            local dp_scale = default_display.text.scale
            local dp_font = default_display.text.font
            local sizeShadow = default_display.text.sizeShadow
            local color = default_display.text.color
            local colorShadow = default_display.text.colorShadow
            local distYText = default_display.text.distYText
            local bone = false
            local heightNameTag = 0

            if configDisplay and type( configDisplay ) == "table" then
                if configDisplay.distance then distance = configDisplay.distance end
                if configDisplay.height then height = configDisplay.height end
                if configDisplay.scale then dp_scale = resizeUI ( configDisplay.scale ) end
                if configDisplay.font then dp_font = configDisplay.font end
                if configDisplay.sizeShadow then sizeShadow = { x = resizeUI ( configDisplay.sizeShadow.x ), y = resizeUI ( configDisplay.sizeShadow.y ) } end
                if configDisplay.color then color = configDisplay.color end
                if configDisplay.colorShadow then colorShadow = configDisplay.colorShadow end
                if configDisplay.distYTextLoop then distYTextLoop = resizeUI( configDisplay.distYTextLoop ) end
                if configDisplay.bone then bone = configDisplay.bone end
            end

            local px, py, pz = getCameraMatrix( )
            local tx, ty, tz = getElementPosition( element )

            local elementType = getElementType( element )
            if elementType == "player" or elementType == "ped" then
                if bone then
                    tx, ty, tz = getPedBonePosition( element, bone )
                end
            end

            local dist = getDistanceBetweenPoints3D( tx, ty, tz, px, py, pz )
            if dist <= distance then
                local x, y = getScreenFromWorldPosition( tx, ty, tz + height )
                if x and y then

                    local nametag_display = getElementData( element, "nametag_display" )
                    if nametag_display then
                        if type( nametag_display ) == "string" then

                            local text = tostring( nametag_display )
                            local scale = ( dp_scale ) - ( ( dp_scale * dist ) / distance )
                            if scale > dp_scale then scale = dp_scale end
                            local font = dp_font

                            local textWidth = dxGetTextWidth( string.gsub( text, "#%x%x%x%x%x%x", "" ), scale, font )
                            local textHeight = dxGetFontHeight( scale, font )

                            local posX = x - textWidth/2
                            local posY = y

                            dxTextShadow ( text, posX, posY, true, true, "left", "alignY", scale, font, color, colorShadow, sizeShadow, true, false, false, postGUI )
                            heightNameTag = heightNameTag + textHeight
                        elseif type( nametag_display ) == "table" then
                            for i,nametag in ipairs( nametag_display ) do
                                
                                local text = tostring( nametag )
                                local scale = ( dp_scale ) - ( ( dp_scale * dist ) / distance )
                                if scale > dp_scale then scale = dp_scale end
                                local font = dp_font

                                local textWidth = dxGetTextWidth( string.gsub( text, "#%x%x%x%x%x%x", "" ), scale, font )
                                local textHeight = dxGetFontHeight( scale, font )
                                local distYText = resizeDistance ( distYTextLoop, dist, distance )

                                local posX = x - textWidth/2
                                local posY = y + ( textHeight + distYText ) * ( i - 1 )

                                dxTextShadow ( text, posX, posY, true, true, "left", "alignY", scale, font, color, colorShadow, sizeShadow, true, false, false, postGUI )

                                heightNameTag = heightNameTag + ( textHeight + distYText )
                            end
                        end
                    end

                    local blood = getElementData( element, "blood" )
                    local MAX_Blood = getElementData( element, "MAX_Blood" )

                    if blood and MAX_Blood then
                        local distY = resizeDistance ( default_display.blood.distY, dist, distance )
                        local bw = resizeDistance ( default_display.blood.w, dist, distance )
                        local bh = resizeDistance ( default_display.blood.h, dist, distance )

                        local posX = x - bw/2
                        local posY = y + heightNameTag
                        
                    
                        dxDrawRectangle( posX + default_display.blood.sizeShadow.x, posY + default_display.blood.sizeShadow.y, bw, bh, default_display.blood.colorShadow, postGUI )
                        dxDrawRectangle( posX, posY, bw, bh, default_display.blood.colorBg, postGUI )
                        dxDrawRectangle( posX, posY, bw/MAX_Blood*blood, bh, default_display.blood.color, postGUI )

                        local armor = getElementData( element, "armor" )
                        local MAX_Armor = getElementData( element, "MAX_Armor" )
                        if armor and MAX_Armor then
                            dxDrawRectangle( posX, posY, bw/MAX_Armor*armor, bh, default_display.armor.color, postGUI )
                        end
                    end
                    
                end
            end
        end
    end

end
)

function resizeDistance ( n, dist, distance )
    return ( n ) - ( ( n * dist ) / distance )
end

function onClientElementDestroyNameTag ( )
    elementNamtagDisplay[ source ] = true
end

function createNameTag ( element )
    elementNamtagDisplay[ element ] = true
    if not isEventHandlerAdded( "onClientElementDestroy", element, onClientElementDestroyNameTag ) then
        addEventHandler( "onClientElementDestroy", element, onClientElementDestroyNameTag )
    end
end

function destroyNameTag ( element )
    elementNamtagDisplay[ element ] = nil
end

function setElementNameTag ( element, enabled )
    if element then
        createNameTag ( element )
    else
        destroyNameTag ( element )
    end
end
addEvent( "setElementNameTag", true )
addEventHandler( "setElementNameTag", root, setElementNameTag )