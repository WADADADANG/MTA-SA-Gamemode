newEvent = { "onClientPlayerLoginGamemode", "onClientPlayerRegisterGamemode", "onClientPlayerRespawned", "onClientPlayerPlayerDowned", "onClientPlayerDead", "onClientPlayerInventoryItemUsed" } -- ตารางสร้างเหตุการณ์ใหม่
for i, event in ipairs( newEvent ) do
    addEvent( event, true ) -- สร้างเหตุการณ์ใหม่
end