ModeSelect={}

function ModeSelect.update()
  local ml=2
  if savefile and save.players[savefile][cheatvalue].pandaemonium then
    ml=3
    if save.players[savefile][cheatvalue].activation then
      ml=4
    end
  end
  if cheat.maxspeed then
    ml=1
  end
  if cheatvalue~=2 then
    ml=math.min(ml,3)
  end
  if pressinp.menuup then
    menusfx[1]:stop()
    menusfx[1]:play()
    mode=(mode-2)%ml+1
  end
  if pressinp.menudown then
    menusfx[1]:stop()
    menusfx[1]:play()
    mode=mode%ml+1
  end
  if pressinp.accept then
    menusfx[2]:stop()
    menusfx[2]:play()
    gameState="RuleSelect"
    pressinp.accept=false
  end
  if pressinp.back then
    gameState="SaveSelect"
    savefile=1
    if mode>2 then mode=1 end
    menusfx[3]:stop()
    menusfx[3]:play()
  end
end

function ModeSelect.drawBGA(offset)
  love.graphics.setColor(0.7, 0.7, 0.7, 1)
  for x=0, 8 do
    love.graphics.circle("line", 320, 240+offset, 60*(x+love.timer.getTime()%1))
  end
end

function ModeSelect.draw()
  if not mode then mode=1 end
  drawGridOutline()
  drawPlayerStats()
  love.graphics.setColor(0.8, 0.8, 0.8, 1)
  love.graphics.printf("Mode Select", font_medium, 240, 106, 160, "center")

  love.graphics.setColor(0, 0, 0.8, mode==1 and 1 or 0.5)
  love.graphics.printf("HEAVEN", font_medium, 240, 154, 160, "center")

  if not cheat.maxspeed then
    love.graphics.setColor(0.8, 0, 0, mode==2 and 1 or 0.5)
    love.graphics.printf("HELL", font_medium, 240, 178, 160, "center")

    love.graphics.setColor(0.8, 0, 0.8, mode==3 and 1 or 0.5)
    if savefile and save.players[savefile][cheatvalue].pandaemonium then
      love.graphics.printf("PANDAEMONIUM", font_medium, 240, 202, 160, "center")
    elseif savefile then
      local points=save.players[savefile][cheatvalue].unlockpoints
      love.graphics.printf("["..math.floor(points/50).."."..(((points%50)*2)<10 and "0" or "")..((points%50)*2).."%]", font_medium, 240, 202, 160, "center")
    end

    if cheatvalue==2 then
      love.graphics.setColor(0, 0.8, 0, mode==4 and 1 or 0.5)
      if savefile and save.players[savefile][cheatvalue].activation then
        love.graphics.printf("ACTIVATION", font_medium, 240, 226, 160, "center")
      elseif savefile and save.players[savefile][cheatvalue].pandaemonium then
        local points=save.players[savefile][cheatvalue].unlockpoints
        love.graphics.printf("["..math.floor(points/100).."."..((points%100)<10 and "0" or "")..(points%100).."%]", font_medium, 240, 226, 160, "center")
      end
    else
      love.graphics.setColor(0.5, 0.5, 0.5)
      love.graphics.printf("ACTIVATION UNAVAILABLE WITH CHEATS", font_medium, 240, 238, 160, "center")
    end
  else
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.printf("OTHER MODES UNAVAILABLE IN 20G MODE", font_medium, 240, 190, 160, "center")
  end

  love.graphics.setColor(0.4, 0.4, 0.4, 1)
  love.graphics.rectangle("fill", 432, 120, 192, 120)
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", 440, 128, 176, 104)
  love.graphics.setColor(1, 1, 1)
  local text={
    "The standard mode, with a speed curve suitable for everyone. Go for top rank!",
    "A hyperspeed challenge, suited to expert players. Can you handle the speed?",
    "A challenge brought about with the essence of pure suffering. Only a god can complete this.",
    "Card challenge! A mode where everything is out to kill you except the things that aren't."
  }
  love.graphics.printf(text[mode], font_medium, 448, 136, 160)
end

return ModeSelect