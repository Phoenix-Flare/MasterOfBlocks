love.graphics.setDefaultFilter("linear", "nearest")
--init fonts
ext = love._console_name=="3DS" and "bcfnt" or "ttf"
font_medium=love.graphics.newFont("resources/masterofblocks."..ext, 16)
font_large=love.graphics.newFont("resources/masterofblocks."..ext, 24)

--init graphics
ext = love._console_name=="3DS" and "t3x" or "png"
local is3DS = love._console_name=="3DS"
blockgfx=love.graphics.newImage("resources/sprites/block."..ext)

--init grade sprites
local grades={
  "nine","eight","seven","six","five","four","three","two","one",
  "smallone","smalltwo","smallthree","smallfour","smallfive","smallsix","smallseven","smalleight","smallnine", "smallzero",
  "smallminus","smallplus","numbersign",
  "F","D","C","B","A","S","X","V","omega","ankh","M","G","leviathan","smallm"}

gradegfx={}
for x=1,#grades do
  gradegfx[grades[x]]=love.graphics.newImage("resources/sprites/grades/"..grades[x].."."..ext)
end

--init medal sprites
local medals={"skl","spn","rfx","cmb","chn"}

medalgfx={}
for x=1,#medals do
  medalgfx[x]=love.graphics.newImage("resources/sprites/medals/"..medals[x].."."..ext)
end

local cheats={"absurd", "expert", "novice", "beginner", "maxspeed", "bigblock"}

cheatgfx={}
for x=1,#cheats do
  cheatgfx[x]=love.graphics.newImage("resources/sprites/modes/"..cheats[x].."."..ext)
end

cardgfx={}
for x=1,24 do
  cardgfx[x]=love.graphics.newImage("resources/sprites/cards/card"..x.."."..ext)
end
cardgfx[0]=love.graphics.newImage("resources/sprites/cards/cardback."..ext)

--init sfx
local queues={"J","I","Z","L","O","T","S"}
queuesfx={}
for x=1, #queues do
  queuesfx[x]=love.audio.newSource("resources/sounds/"..queues[x]..".wav", "static")
end

menusfx={}
menusfx[1]=love.audio.newSource("resources/sounds/menu.wav", "static")
menusfx[2]=love.audio.newSource("resources/sounds/accept.wav", "static")
menusfx[3]=love.audio.newSource("resources/sounds/back.wav", "static")

gamesfx={}
gamesfx.pause=love.audio.newSource("resources/sounds/pause.wav", "static")
gamesfx.levelstop=love.audio.newSource("resources/sounds/levelstop.wav", "static")
gamesfx.lock=love.audio.newSource("resources/sounds/lock.wav", "static")
gamesfx.lines=
  {
    love.audio.newSource("resources/sounds/single.wav", "static"),
    love.audio.newSource("resources/sounds/double.wav", "static"),
    love.audio.newSource("resources/sounds/triple.wav", "static"),
    love.audio.newSource("resources/sounds/jaftaw.wav", "static"),
  }
gamesfx.sectionadvance=love.audio.newSource("resources/sounds/sectionadvance.wav", "static")

--init bgm

bgm={}
for idx, track in pairs(({[0]="Meaningless World", "Black Dragon", "Descent Into Madness", "Burning", "Turbo Folk Legend", "Dying Sun", "Triskaidekaphobia", "Original Sin", "Ancient Prophecy", "The Depths"})) do
  track="resources/music/"..track..".it"
  bgm[idx]=love.audio.newSource(track, "stream")
end

for x=0,8 do
  bgm[x]:setLooping(true)
end