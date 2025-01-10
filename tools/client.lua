
function getResize ( )
    local sw, sh = guiGetScreenSize(  )
    local qry = 0.00105
    if sh > 2160 then
        qry = 0.00078
    elseif sh > 1200 then
        qry = 0.0008
    end
    return sh * qry
end

function resizeUI ( resize, resize_max )
    local resize_interface = getElementData( getLocalPlayer(  ), "resize_ui" ) or config.resize
    local value = resize * resize_interface
    if resize_max and value * getResize ( ) >= resize_max then
        return resize_max
    end
    return value * getResize ( )
end
