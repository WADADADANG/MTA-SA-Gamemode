addCommandHandler( "use-item", function ( commnadName, commandValue )
    triggerServerEvent( "onPlayerInventoryUsingItem", resourceRoot, tostring( commandValue ), 1 )
end
)

-- เหตุการเมื่อผู้เล่นใช้ไอเท็ม รับเหตุการจาก client ในสคริปต์ชื่อ inventory เท่านั้น และจะถูกส่งไป server อีกครั้ง
addEvent( "onClientPlayerInventoryUsingItem", true )
addEventHandler( "onClientPlayerInventoryUsingItem", root, 
function ( itemID, amount )
    if sourceResource then
        if getResourceName( sourceResource ) == "inventory" then

            local block, anim = getPedAnimation( source )
            if block and anim then return false end

            local qty = getElementData( source, itemID ) or 0
            if qty and qty > 0 then

                local inv_data = inventoryItems[ itemID ]
                if inv_data then
                    triggerServerEvent( "onPlayerInventoryUsingItem", resourceRoot, itemID, amount )
                end
            end

        end
    end
end
)