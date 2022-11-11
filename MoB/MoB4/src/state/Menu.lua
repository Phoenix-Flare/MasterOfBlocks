Menu={}

function Menu.update()
  menus={9,8,4,nil,7}
  if pressinp.accept and submenu==1 then
    menusfx[2]:stop()
    menusfx[2]:play()
    submenu=menu
    menu=1
    if submenu==1 then
      gameState="SaveSelect"
      savefile=1
      players={}
      for idx, data in pairs(save.players) do
        players[#players+1]=idx
      end
    end
    if submenu==4 then
      gameState="ControlConfig"
      oldkeycodes={}
      for x=1,8 do
        oldkeycodes[x]=keycodes[x]
      end
      keyindex=1
    end
    if submenu==6 then
      gameState="MusicRoom"
      menu=0
    end
    if submenu==7 then
      recordsIndex={1, 1}
      gameState="Records"
    end
    if submenu==8 then
      gameState="Credits"
    end
    if submenu==9 then
      love.event.quit()
    end
    pressinp.accept=false
  end
  if submenu==2 then
    if pressinp.accept then
      if menu==8 then
        menusfx[2]:stop()
        menusfx[2]:play()
        saveSave()
        menu=2
        submenu=1
      end
    end
    if (pressinp.menuleft or pressinp.menuright) and menu<8 then
      menusfx[1]:stop()
      menusfx[1]:play()
      if menu<4 then
        save.conf.sonic[menu] = not save.conf.sonic[menu]
      elseif menu<7 then
        save.conf.reverse[(menu-1)%3+1] = not save.conf.reverse[(menu-1)%3+1]
      elseif menu==7 then
        save.conf.enableBGAs = not save.conf.enableBGAs
      end
    end
  end
  if submenu==3 then
    if pressinp.accept then
      if menu==4 then
        menusfx[2]:stop()
        menusfx[2]:play()
        saveSave()
        menu=3
        submenu=1
      end
    end
    if (pressinp.menuleft or pressinp.menuright) and menu<4 then
      menusfx[1]:stop()
      menusfx[1]:play()
      if pressinp.menuleft then
        save.conf[({"master","sfx","bgm"})[menu].."Volume"]=math.max(0,save.conf[({"master","sfx","bgm"})[menu].."Volume"]-5)
      else
        save.conf[({"master","sfx","bgm"})[menu].."Volume"]=math.min(100,save.conf[({"master","sfx","bgm"})[menu].."Volume"]+5)
      end
      volumeUpdate()
    end
  end
  if submenu==5 then
    if pressinp.accept then
      if menu==7 then
        menusfx[2]:stop()
        menusfx[2]:play()
        for x=1,6 do
          save.padcodes[({"a","b","x","y","leftshoulder","rightshoulder"})[x]]=btncodes[({"a","b","x","y","leftshoulder","rightshoulder"})[x]]
        end
        menu=5
        submenu=1
      end
      saveSave()
    end
    if pressinp.menuleft then
      btncodes[({"a","b","x","y","leftshoulder","rightshoulder"})[menu]]=(btncodes[({"a","b","x","y","leftshoulder","rightshoulder"})[menu]]-1)%5
    end
    if pressinp.menuright then
      btncodes[({"a","b","x","y","leftshoulder","rightshoulder"})[menu]]=(btncodes[({"a","b","x","y","leftshoulder","rightshoulder"})[menu]]+1)%5
    end
  end
  if pressinp.back then
    menusfx[3]:stop()
    menusfx[3]:play()
    if submenu~=1 then
      submenu=1
      menu=1
      save=loadSave()
      for idx, btn in pairs(save.padcodes) do
        btncodes[idx]=btn
      end
    else
      menu=9
    end
  end
  if pressinp.menuup then
    menusfx[1]:stop()
    menusfx[1]:play()
    menu=(menu-2)%menus[submenu]+1
  end
  if pressinp.menudown then
    menusfx[1]:stop()
    menusfx[1]:play()
    menu=menu%menus[submenu]+1
  end
  if submenu==1 and holdinp.cheat then
    ctimer=ctimer and (ctimer+1) or 1
    if ctimer>299 then
      bgm[0]:stop()
      bgm[9]:play()
      menu=1
      gameState="CheatMenu"
      ctimer=0
    end
  else
    ctimer=0
  end
end

function Menu.drawBGA(offset)
  love.graphics.setColor(0.7, 0.7, 0.7, 1)
  for x=0, 8 do
    love.graphics.circle("line", 320, 240+offset, 60*(x+love.timer.getTime()%1))
  end
end

function Menu.draw()
  drawGridOutline()
  love.graphics.setColor(0.8, 0.8, 0.8, 1)
  if submenu==1 then
    love.graphics.printf("Main Menu", font_medium, 240, 106, 160, "center")

    love.graphics.setColor(1, 1, 1, menu==1 and 1 or 0.7)
    love.graphics.printf("Start Game", font_medium, 240, 154, 160, "center")

    love.graphics.setColor(1, 1, 1, menu==2 and 1 or 0.7)
    love.graphics.printf("Game Options", font_medium, 240, 178, 160, "center")

    love.graphics.setColor(1, 1, 1, menu==3 and 1 or 0.7)
    love.graphics.printf("Sound Options", font_medium, 240, 202, 160, "center")

    love.graphics.setColor(1, 1, 1, menu==4 and 1 or 0.7)
    love.graphics.printf("Key Config", font_medium, 240, 226, 160, "center")

    love.graphics.setColor(1, 1, 1, menu==5 and 1 or 0.7)
    love.graphics.printf("Gamepad Config", font_medium, 240, 250, 160, "center")

    love.graphics.setColor(1, 1, 1, menu==6 and 1 or 0.7)
    love.graphics.printf("Music Room", font_medium, 240, 274, 160, "center")

    love.graphics.setColor(1, 1, 1, menu==7 and 1 or 0.7)
    love.graphics.printf("Records", font_medium, 240, 298, 160, "center")

    love.graphics.setColor(1, 1, 1, menu==8 and 1 or 0.7)
    love.graphics.printf("Credits", font_medium, 240, 322, 160, "center")

    love.graphics.setColor(1, 1, 1, menu==9 and 1 or 0.7)
    love.graphics.printf("Exit Game", font_medium, 240, 346, 160, "center")
    
    love.graphics.setColor(0.4, 0.4, 0.4, 1)
    love.graphics.rectangle("fill", 432, 120, 192, 120)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 440, 128, 176, 104)
    love.graphics.setColor(1, 1, 1)
    local text={
      "Choose a gamemode to start the game.",
      "Change the way certain controls operate with different rotation systems here.",
      "Change the volume of the music and sound effects of the game.",
      "Tell the game what key you want to use for what purpose in-game.",
      "Tell the game what you want each button on your gamepad to do.",
      "Listen to the soundtrack of the game... from within the game!",
      "View the high scores in various gamemodes.",
      "View the credits again, in case you somehow missed them the first time.",
      "Exit the game, straying from your destiny."
    }
    love.graphics.printf(text[menu], font_medium, 448, 136, 160)
  elseif submenu==2 then
    love.graphics.printf("Game Settings", font_medium, 240, 106, 160, "center")

    love.graphics.setColor(1, 1, 1, menu<4 and 1 or 0.7)
    love.graphics.printf("Sonic Drop", font_medium, 240, 142, 160, "center")

    love.graphics.setColor(1, 1, 1, menu==1 and 1 or 0.7)
    love.graphics.printf("DRS: "..(save.conf.sonic[1] and "ON" or "OFF"), font_medium, 240, 166, 160, "center")

    love.graphics.setColor(1, 1, 1, menu==2 and 1 or 0.7)
    love.graphics.printf("SRS-X: "..(save.conf.sonic[2] and "ON" or "OFF"), font_medium, 240, 182, 160, "center")

    love.graphics.setColor(1, 1, 1, menu==3 and 1 or 0.7)
    love.graphics.printf("KRS: "..(save.conf.sonic[3] and "ON" or "OFF"), font_medium, 240, 198, 160, "center")

    love.graphics.setColor(1, 1, 1, menu<7 and menu>3 and 1 or 0.7)
    love.graphics.printf("Reverse", font_medium, 240, 226, 160, "center")

    love.graphics.setColor(1, 1, 1, menu==4 and 1 or 0.7)
    love.graphics.printf("DRS: "..(save.conf.reverse[1] and "ON" or "OFF"), font_medium, 240, 250, 160, "center")

    love.graphics.setColor(1, 1, 1, menu==5 and 1 or 0.7)
    love.graphics.printf("SRS-X: "..(save.conf.reverse[2] and "ON" or "OFF"), font_medium, 240, 266, 160, "center")

    love.graphics.setColor(1, 1, 1, menu==6 and 1 or 0.7)
    love.graphics.printf("KRS: "..(save.conf.reverse[3] and "ON" or "OFF"), font_medium, 240, 282, 160, "center")

    love.graphics.setColor(1, 1, 1, menu==7 and 1 or 0.7)
    love.graphics.printf("BGAs: "..(save.conf.enableBGAs and "ON" or "OFF"), font_medium, 240, 310, 160, "center")

    love.graphics.setColor(1, 1, 1, menu==8 and 1 or 0.7)
    love.graphics.printf("Back", font_medium, 240, 336, 160, "center")
    
    love.graphics.setColor(0.4, 0.4, 0.4, 1)
    love.graphics.rectangle("fill", 432, 120, 192, 120)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 440, 128, 176, 104)
    love.graphics.setColor(1, 1, 1)
    local text={
      "Sonic Drop changes locking behavior from the up button to the down button. For a more classic feel.",
      "Sonic Drop changes locking behavior from the up button to the down button. For a more classic feel.",
      "Sonic Drop changes locking behavior from the up button to the down button. For a more classic feel.",
      "Rotation reverse causes the CCW button to act as CW and vice versa. Not for use on DRS, but it's here.",
      "Rotation reverse causes the CCW button to act as CW and vice versa.",
      "Rotation reverse causes the CCW button to act as CW and vice versa.",
      "Background animations; turn this off if you find them distracting.",
      "Return to the main menu, saving the changes made here."
    }
    love.graphics.printf(text[menu], font_medium, 448, 136, 160)
  elseif submenu==3 then
    love.graphics.printf("Sound Settings", font_medium, 240, 106, 160, "center")

    love.graphics.setColor(1, 1, 1, menu==1 and 1 or 0.7)
    love.graphics.printf("MASTER: "..save.conf.masterVolume.."%", font_medium, 240, 166, 160, "center")

    love.graphics.setColor(1, 1, 1, menu==2 and 1 or 0.7)
    love.graphics.printf("SOUND: "..save.conf.sfxVolume.."%", font_medium, 240, 186, 160, "center")

    love.graphics.setColor(1, 1, 1, menu==3 and 1 or 0.7)
    love.graphics.printf("MUSIC: "..save.conf.bgmVolume.."%", font_medium, 240, 206, 160, "center")

    love.graphics.setColor(1, 1, 1, menu==4 and 1 or 0.7)
    love.graphics.printf("Back", font_medium, 240, 226, 160, "center")
  elseif submenu==5 then
    love.graphics.printf("Gamepad Config", font_medium, 240, 106, 160, "center")
    local btns = {"a","b","x","y","leftshoulder","rightshoulder"}
    local btnns = {"A","B","X","Y","L","R"}
    for x=1,6 do
      love.graphics.setColor(1, 1, 1, menu==x and 1 or 0.7)
      love.graphics.print(btnns[x]..": "..({[0]="None","CCW","CW","180","HOLD"})[btncodes[btns[x]]], font_medium, 246, 130+24*x)
    end
    love.graphics.setColor(1, 1, 1, menu==7 and 1 or 0.7)
    love.graphics.print("Back", font_medium, 246, 298)
  end
  love.graphics.setColor(0.8, 0.8, 0.8, 1)
  love.graphics.print("Up/Down to Select", font_medium, 246, 382)
  love.graphics.print((love._console_name and "A" or "Enter").." to Confirm", font_medium, 246, 400)
end

return Menu