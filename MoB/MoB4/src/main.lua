function love.load()
  --hardcoded game data
  require "data.blockdata"
  require "data.speeddata"
  require "data.otherdata"

  --load categorized functions
  require "function.grade"
  require "function.values"
  require "function.logic"
  require "function.grid"
  require "function.name"
  require "function.interface"

  --init version number
  versionnum="v1.5"
  saveversion="v1.3"

  require "load"

  states={}
  for idx, name in pairs(love.filesystem.getDirectoryItems("state")) do
    name=string.sub(name, 1, -5)
    states[name]=require ("state."..name)
  end

  --init gamestate
  gameState="Credits"

  --init cheats
  cheat={
    difficulty=2,
    maxspeed=false,
    bigblock=false
  }
  cheatvalue=cheat.difficulty+(cheat.maxspeed and 5 or 0)+(cheat.bigblock and 10 or 0)

  --init/load save
  binser=require "binser"
  save=loadSave()
  keycodes={}
  for x=1,8 do
    keycodes[x]=save.keycodes[x]
  end
  btncodes={}
  for idx, btn in pairs(save.padcodes) do
    btncodes[idx]=btn
  end
  navigationkeys={"return","escape","up","down","left","right"}
  navigationbtns={"a", "b", "dpup", "dpdown", "dpleft", "dpright", "start", "leftshoulder"}
  volumeUpdate()
  
  --init Stage 14 BGA
  s14background=love.graphics.newCanvas(1280, 80)
  s14background:renderTo(
    function()
      for x=1,7 do
        local dy=({48, 40, 40, 40, 40, 40, 40})[x]
        local dx=({40, 40, 48, 48, 48, 48, 48})[x]
        drawBlock(dx+(x-1)*80, dy, 28+({2, 5, 4, 7, 3, 1, 6})[x], 0, 3)
        drawBlock(560+dx+(x-1)*80, dy, 28+({2, 5, 4, 7, 3, 1, 6})[x], 0, 3)
        drawBlock(1120+dx+(x-1)*80, dy, 28+({2, 5, 4, 7, 3, 1, 6})[x], 0, 3)
      end
    end
  )
  
  pressinp={}
  holdinp={}
  keypress={}
  keyheld={}
  navbuttons={}
  navbuttonsh={}
  navkeys={}
  navkeysh={}
end

function initAltSFX()
  local queues={"J","I","Z","L","O","T","S"}
  queuesfx={}
  for x=1, #queues do
    queuesfx[x]=love.audio.newSource("resources/sounds/s"..queues[x]..".wav", "static")
  end
end

function love.quit()
  for idx, x in pairs({"InGame","Roll","Curtain","EndGame","Paused", "StatsScreen"}) do
    if gameState==x then
      if savefile then
        return true
      end
    end
  end
end

function initSave()
  local save={
    version=saveversion,
    keycodes={"z","x","c","space","up","down","left","right"},
    padcodes={a=2, b=1, x=0, y=3, leftshoulder=4, rightshoulder=4, dpup=5, dpdown=6, dpleft=7, dpright=8},
    conf={
      reverse={false, false, false},
      sonic={false, false, false},
      enableBGAs=true,
      masterVolume=100,
      sfxVolume=100,
      bgmVolume=100
    },
    players={},
    records={
      {
        {
          {"Osiris", 27, 300, 36000},
          {"Ra", 18, 200, 36000},
          {"Thoth", 9, 100, 36000},
        },
        {
          {"Zeus", 27, 300, 36000},
          {"Poseidon", 18, 200, 36000},
          {"Hermes", 9, 100, 36000},
        },
        {
          {"Eris", 27, 300, 36000},
          {"Malaclypse", 18, 200, 36000},
          {"Omar", 9, 100, 36000},
        },
      },
      {
        {
          {"Set", 3, 300, 10800},
          {"Apep", 2, 200, 7200},
          {"Anubis", 1, 100, 3600},
        },
        {
          {"Cronus", 3, 300, 10800},
          {"Hyperion", 2, 200, 7200},
          {"Hades", 1, 100, 3600},
        },
        {
          {"Cthulhu", 3, 300, 10800},
          {"Sheb-Teth", 2, 200, 7200},
          {"Azathoth", 1, 100, 3600},
        },
      },
      {
        {
          {"Satan", 3, 300, 10800},
          {"Lucifer", 2, 200, 7200},
          {"Abaddon", 1, 100, 3600},
        },
        {
          {"Tezcatlipoca", 3, 300, 10800},
          {"Yaotzin", 2, 200, 7200},
          {"Mictian", 1, 100, 3600},
        },
        {
          {"Asmodeus", 3, 300, 10800},
          {"Astaroth", 2, 200, 7200},
          {"Bast", 1, 100, 3600},
        },
      },
    },
  }
  return save
end

function loadSave()
  local save_data, len = binser.readFile(((love.system.getOS()=="OS X" and love.filesystem.isFused()) and (love.filesystem.getSaveDirectory().."/") or ("")).."save.mob4")
  if save_data == nil or save_data[1].version~=saveversion then
    return initSave()
  end
  return save_data[1]
end

function saveSave()
  binser.writeFile(((love.system.getOS()=="OS X" and love.filesystem.isFused()) and (love.filesystem.getSaveDirectory().."/") or ("")).."save.mob4", save)
end

function love.keypressed(key, scancode, isrepeat)
  if gameState=="ControlConfig" and scancode~="escape" and keyindex~=9 then
    keycodes[keyindex]=scancode
    keyindex=keyindex+1
    return
  end
  for x=1,8 do
    if scancode==navigationkeys[x] then
      navkeys[x]=true
      navkeysh[x]=true
    end
    if scancode==keycodes[x] then
      keypress[x]=true
      keyheld[x]=true
    end
  end
end

function love.keyreleased(key, scancode)
  for x=1,8 do
    if scancode==navigationkeys[x] then
      navkeysh[x]=false
    end
    if scancode==keycodes[x] then
      keyheld[x]=false
    end
  end
end

function love.gamepadpressed(joystick, button)
  for x=1,8 do
    if button==navigationbtns[x] then
      navbuttons[x]=true
      navbuttonsh[x]=true
    end
  end
  if btncodes[button] then
    keypress[btncodes[button]]=true
    keyheld[btncodes[button]]=true
  end
end

function love.gamepadreleased(joystick, button)
  for x=1,8 do
    if button==navigationbtns[x] then
      navbuttonsh[x]=false
    end
  end
  if btncodes[button] then
    keyheld[btncodes[button]]=false
  end
end

function processInputs()
  pressinp=
  {
    accept=navkeys[1] or navbuttons[1],
    back=navkeys[2] or navbuttons[2],
    menuup=navkeys[3] or navbuttons[3] or (checkGamepadLeftstick(2)<-0.5 and not holdinp.menuup),
    menudown=navkeys[4] or navbuttons[4] or (checkGamepadLeftstick(2)>0.5 and not holdinp.menudown),
    menuleft=navkeys[5] or navbuttons[5] or (checkGamepadLeftstick(1)<-0.5 and not holdinp.menuleft),
    menuright=navkeys[6] or navbuttons[6] or (checkGamepadLeftstick(1)>0.5 and not holdinp.menuright),
    pause=navkeys[2] or navbuttons[7],
    keyboard=navbuttons[8],
    game=
    {
      ccw=keypress[1],
      cw=keypress[2],
      dbl=keypress[3],
      hold=keypress[4],
      up=keypress[5] or (checkGamepadLeftstick(2)<-0.5 and not holdinp.game.up),
      down=keypress[6] or (checkGamepadLeftstick(2)>0.5 and not holdinp.game.down),
      left=keypress[7] or (checkGamepadLeftstick(1)<-0.5 and not holdinp.game.left),
      right=keypress[8] or (checkGamepadLeftstick(1)>0.5 and not holdinp.game.right)
    }
  }
  holdinp=
  {
    egg=navkeysh[1] or navbuttonsh[1],
    cheat=navkeysh[2] or navbuttonsh[2],
    menuup=navkeysh[3] or navbuttonsh[3] or checkGamepadLeftstick(2)<-0.5,
    menudown=navkeysh[4] or navbuttonsh[4] or checkGamepadLeftstick(2)>0.5,
    menuleft=navkeysh[5] or navbuttonsh[5] or checkGamepadLeftstick(1)<-0.5,
    menuright=navkeysh[6] or navbuttonsh[6] or checkGamepadLeftstick(1)>0.5,
    game=
    {
      ccw=keyheld[1],
      cw=keyheld[2],
      dbl=keyheld[3],
      hold=keyheld[4],
      up=keyheld[5] or checkGamepadLeftstick(2)<-0.5,
      down=keyheld[6] or checkGamepadLeftstick(2)>0.5,
      left=keyheld[7] or checkGamepadLeftstick(1)<-0.5,
      right=keyheld[8] or checkGamepadLeftstick(1)>0.5
    }
  }
  keypress={}
  navkeys={}
  navbuttons={}
end

function checkGamepadButton(btn)
  for idx, pad in pairs(love.joystick.getJoysticks()) do
    for button, code in pairs(btncodes) do
      if pad:isGamepadDown(button) and code==btn then
        return true
      end
    end
  end
  return false
end

function checkGamepadLeftstick(axis)
  local v=0
  local adjust=0
  for idx, pad in pairs(love.joystick.getJoysticks()) do
    v=v+pad:getAxis(axis)
    if pad:getAxis(axis)==0 then
      adjust=adjust+1
    end
  end
  return v/(love.joystick.getJoystickCount()-adjust)
end

function love.update(dt)
  sigma=math.min(sigma and dt+sigma or dt, 10)
  while sigma>=1/60 do
    sigma=sigma-1/60

    processInputs()

    if states[gameState] then
      states[gameState].update()
    end
  end
end

function love.resize(w, h)
  gridCanvas=
  {
    love.graphics.newCanvas(),
    love.graphics.newCanvas(),
    love.graphics.newCanvas(),
  }
  for x = 1,3 do
    gridCanvas[x]:setFilter("linear", "nearest")
  end
  updateGrid=true
end

function love.draw(screen)
  if screen=="bottom" then return end

  love.graphics.setDefaultFilter("nearest", "nearest")
  wdth = love.graphics.getWidth()
  hght = love.graphics.getHeight()
  scale = math.min(wdth/640, hght/480)
  love.graphics.translate((wdth-scale*640)/2,(hght-scale*480)/2)
  love.graphics.scale(scale)

  offset=(({left=-6,right=6})[screen] or 0)*(love._console_name=="3DS" and love.graphics.get3DDepth() or 0)

  if states[gameState] then
    love.graphics.clear(0, 0, 0)
    if save.conf.enableBGAs then
      if gameState=="CheatMenu" or activationstage==15 then
        bxa=bxa or {}
        bxb=bxb or {}
        bya=bya or {}
        byb=byb or {}
        cmoffset=offset*(math.random(100)/100)
        if screen~="right" then
          for x=1,30 do
            bxa[x]=math.random(640)
            bxb[x]=math.random(640)
            bya[x]=math.random(480)
            byb[x]=math.random(480)
          end
        end
      end
      states[gameState].drawBGA(offset, cmoffset, bxa, bxb, bya, byb)
    end
    states[gameState].draw(offset)
  end

  if gameState~="CheatMenu" then
    love.graphics.setColor(1, 1, 1, 1)
    local x=592
    if cheat.difficulty~=2 then
      if cheat.difficulty<2 then
        love.graphics.draw(cheatgfx[cheat.difficulty+1], x, 432)
        x=x-32
      else
        love.graphics.draw(cheatgfx[cheat.difficulty], x, 432)
        x=x-32
      end
    end
    if cheat.maxspeed then
      love.graphics.draw(cheatgfx[5], x, 432)
      x=x-32
    end
    if cheat.bigblock then
      love.graphics.draw(cheatgfx[6], x, 432)
      x=x-32
    end

  end

  --box
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.rectangle("fill", 0, -2000, 640, 2000)
  love.graphics.rectangle("fill", -2000+offset, 0, 2000, 480)
  love.graphics.rectangle("fill", 0, 480, 640, 2000)
  love.graphics.rectangle("fill", 640+offset, 0, 2000, 480)

  love.graphics.setColor(0.5, 0.5, 0.5, 1)
  love.graphics.print(versionnum, font_medium, 10, 458)

  love.graphics.reset()
end

function volumeUpdate()
  sv=save.conf.masterVolume*save.conf.sfxVolume/10000
  mv=save.conf.masterVolume*save.conf.bgmVolume/10000
  for idx, src in pairs(queuesfx) do
    src:setVolume(sv)
  end
  for idx, src in pairs(menusfx) do
    src:setVolume(sv)
  end
  for idx, src in pairs(gamesfx) do
    if idx=="lines" then
      for idx, src in pairs(src) do
        src:setVolume(sv)
      end
    else
      src:setVolume(sv)
    end
  end
  for idx, src in pairs(bgm) do
    src:setVolume(mv)
  end
end

function formatTime(t)
  local min=math.floor(t/3600)
  local sec=math.floor(t/60)%60
  local cs=math.floor(t/0.6)%100
  return (min<10 and "0" or "")..min..":"..(sec<10 and "0" or "")..sec.."."..(cs<10 and 0 or "")..cs
end

function toRomanNumerals(n)
  -- This function is a bit slapdash, and it'll probably stay this way until a later Sigma version.
  return ({"I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X", "XI", "XII", "XIII", "XIV", "XV", "?", "?", "?", "?", "?"})[n]
end