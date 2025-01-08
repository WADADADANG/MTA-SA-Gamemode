newEvent = { "onPlayerLoginGamemode", "onPlayerRegisterGamemode", "onPlayerRespawned", "onPlayerPlayerDowned", "onPlayerDead", "onPlayerInventoryItemUsed", "onPlayerWeaponRearmed", "onPlayerWeaponRemoved", "onPlayerWeaponSwitched" } -- ตารางสร้างเหตุการณ์ใหม่
for i, event in ipairs( newEvent ) do
    addEvent( event, true ) -- สร้างเหตุการณ์ใหม่
end

configServer = {}
configServer[ "Default_ModelID" ] = 73 -- สกินรุ่นเริ่มต้น
configServer[ "Default_PositionSpawn" ] = { 1543.5, -1675.5, 13.5 } -- ตำแหน่งเกิด
configServer[ "Default_RotationSpawn" ] = { 0, 360 } -- สุ่มมุมหัน
configServer[ "HeightSpawnLogin" ] = 1 -- ความสูงเกิดเข้าเกม

configServer[ "SuperArmorLoginTimer" ] = 1000 * 30 -- เวลาเสริมเกราะเมื่อเข้าเกม และ สมัครสมาชิก ( หน่วยเป็นมิลลิวินาที )
configServer[ "RespawnTimer" ] = 1000 * 10 -- เวลาเกิดใหม่ ( หน่วยเป็นมิลลิวินาที )

-- สถานะทั้งหมด
StatusElements = {
    [ "SilverCoin" ] = "เงิน",
    [ "ZenyxCoin" ] = "เครดิตเติมเงิน",
    
    [ "health" ] = "ชีวิต",
    [ "armor" ] = "เกราะ",

    [ "PlayerDown" ] = "สถานะผู้เล่นล่ม",
    [ "PlayerDown:Attacker" ] = "ผู้โจมตี",
    [ "PlayerDown:Weapon" ] = "อาวุธ",
    [ "PlayerDown:BodyPart" ] = "ส่วนของร่างกาย",

    [ "MAX_Slots" ] = "ช่องเก็บของสูงสุด",
    [ "MAX_Weight" ] = "น้ำหนักสูงสุด",

    [ "currentWeapon" ] = "อาวุธปัจจุบัน",
}

-- สถานะเมื่อผู้เล่นสมัครสมาชิก
givePlayerRegisterElements = {
    [ "SilverCoin" ] = 1000,
    [ "ZenyxCoin" ] = 0,
    
    [ "health" ] = 100,
    [ "armor" ] = 0,

    [ "MAX_Slots" ] = 12,
    [ "MAX_Weight" ] = 100,
}

-- สถานะเมื่อผู้เล่นเกิดใหม่
resetPlayerRespawnElements = {
    [ "health" ] = 50,
    [ "armor" ] = 0,
}

-- ตำแหน่งเกิดใหม่
respawnPlayerLocation = {
    { 1543.5, -1675.5, 13.5 },
}