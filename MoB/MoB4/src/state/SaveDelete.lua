SaveDelete={}

function SaveDelete.update()
  if pressinp.menuup then
    menusfx[1]:stop()
    menusfx[1]:play()
    savefile=(savefile-2)%(#players+1)+1
  end
  if pressinp.menudown then
    menusfx[1]:stop()
    menusfx[1]:play()
    savefile=savefile%(#players+1)+1
  end
  if pressinp.accept then
    if savefile==#players+1 then
      menusfx[3]:stop()
      menusfx[3]:play()
      gameState="SaveSelect"
      pressinp.accept=false
      return
    else
      menusfx[2]:stop()
      menusfx[2]:play()
      gameState="ConfirmDelete"
      pressinp.accept=false
      return
    end
  end
end

function SaveDelete.drawBGA(offset)
  love.graphics.setColor(0.7, 0.2, 0.2, 1)
  for x=0, 8 do
    love.graphics.circle("line", 320, 240+offset, 60*(x+love.timer.getTime()%1))
  end
end

function SaveDelete.draw()
  drawGridOutline()
  drawPlayerStats()
  love.graphics.setColor(0.8, 0.8, 0.8, 1)
  love.graphics.printf("File Erase", font_medium, 240, 106, 160, "center")

  for x=1,#players do
    love.graphics.setColor(1, savefile==x and 0.4 or 1, savefile==x and 0.4 or 1, 1)
    love.graphics.printf(players[x], font_medium, 240, 130+24*x, 160, "center")
  end

  love.graphics.setColor(1, 1, savefile==#players+1 and 0.4 or 1, 1)
  love.graphics.printf("Back", font_medium, 240, 154+24*#players, 160, "center")
end

return SaveDelete