newEvent = { "onPlayerLoginGamemode", "onPlayerRegisterGamemode" } -- ตารางสร้างเหตุการณ์ใหม่
for i, event in ipairs( newEvent ) do
    addEvent( event, true ) -- สร้างเหตุการณ์ใหม่
end

configServer = {}
configServer[ "Default_ModelID" ] = 73 -- สกินรุ่นเริ่มต้น
configServer[ "Default_PositionSpawn" ] = { 1543.5, -1675.5, 13.5 } -- ตำแหน่งเกิด
configServer[ "Default_RotationSpawn" ] = { 0, 360 } -- สุ่มมุมหัน
configServer[ "HeightSpawnLogin" ] = 1 -- ความสูงเกิดเข้าเกม

configServer[ "SuperArmorLoginTimer" ] = 1000 * 30 -- เวลาเสริมเกราะเมื่อเข้าเกม และ สมัครสมาชิก ( หน่วยเป็นมิลลิวินาที )

StatusElements = {
    [ "SilverCoin" ] = "เงิน",
    [ "ZenyxCoin" ] = "เครดิตเติมเงิน",
    
    [ "health" ] = "ชีวิต",
    [ "armor" ] = "เกราะ",
}

givePlayerRegisterElements = {
    [ "SilverCoin" ] = 1000,
    [ "ZenyxCoin" ] = 0,
    
    [ "health" ] = 100,
    [ "armor" ] = 0,
    [ "ModelID" ] = configServer[ "Default_ModelID" ],
}

resetPlayerRespawnElements = {
    [ "health" ] = 50,
    [ "armor" ] = 0,
}
