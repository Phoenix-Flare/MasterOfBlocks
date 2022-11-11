SaveSelect={}

function SaveSelect.update()
  if pressinp.menuup then
    menusfx[1]:stop()
    menusfx[1]:play()
    savefile=(savefile-2)%(#players+3)+1
  end
  if pressinp.menudown then
    menusfx[1]:stop()
    menusfx[1]:play()
    savefile=savefile%(#players+3)+1
  end
  if pressinp.accept then
    menusfx[2]:stop()
    menusfx[2]:play()
    if savefile==#players+2 then
      name=""
      gameState="NewFile"
      pressinp.accept=false
      return
    elseif savefile==#players+3 then
      savefile=1
      gameState="SaveDelete"
      pressinp.accept=false
      return
    end
    gameState="ModeSelect"
    savefile=players[savefile]
  end
  if pressinp.back then
    gameState="Menu"
    menu=1
    mode=nil
    menusfx[3]:stop()
    menusfx[3]:play()
  end
end

function SaveSelect.drawBGA(offset)
  love.graphics.setColor(0.7, 0.7, 0.7, 1)
  for x=0, 8 do
    love.graphics.circle("line", 320, 240+offset, 60*(x+love.timer.getTime()%1))
  end
end

function SaveSelect.draw()
  drawGridOutline()
  drawPlayerStats()
  love.graphics.setColor(0.8, 0.8, 0.8, 1)
  love.graphics.printf("File Select", font_medium, 240, 106, 160, "center")

  for x=1,#players do
    love.graphics.setColor(1, 1, savefile==x and 0.4 or 1, 1)
    love.graphics.printf(players[x], font_medium, 240, 130+24*x, 160, "center")
  end

  love.graphics.setColor(1, 1, savefile==#players+1 and 0.4 or 1, 1)
  love.graphics.printf("No File", font_medium, 240, 154+24*#players, 160, "center")

  love.graphics.setColor(1, 1, savefile==#players+2 and 0.4 or 1, 1)
  love.graphics.printf("Create File", font_medium, 240, 178+24*#players, 160, "center")

  love.graphics.setColor(1, savefile==#players+3 and 0.4 or 1, savefile==#players+3 and 0.4 or 1, 1)
  love.graphics.printf("Delete File", font_medium, 240, 202+24*#players, 160, "center")
  
  love.graphics.setColor(0.4, 0.4, 0.4, 1)
  love.graphics.rectangle("fill", 432, 120, 192, 120)
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", 440, 128, 176, 104)
  love.graphics.setColor(1, 1, 1)
  local text={
    "Play using the chosen file.",
    "Play without using a save file.",
    "Create a new save file to play with.",
    "Cast a save file into the abyss, from which it shall never return."
  }
  love.graphics.printf(text[math.max(savefile-#players+1, 1)], font_medium, 448, 136, 160)
end

return SaveSelect