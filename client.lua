

addEventHandler( "onClientPlayerDamage", getLocalPlayer(  ), 
function ( attacker, weapon, bodypart, loss )
    cancelEvent(  )
    if getElementData( source, "SuperArmor" ) then return false end
    
    triggerServerEvent( "onPlayerDamageFromClient", resourceRoot, attacker, weapon, bodypart, loss )
end
)