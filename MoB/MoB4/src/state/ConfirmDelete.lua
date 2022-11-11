ConfirmDelete={}

function ConfirmDelete.update()
  if pressinp.accept then
    menusfx[2]:stop()
    menusfx[2]:play()
    save.players[players[savefile]]=nil
    table.remove(players, savefile)
    saveSave()
    savefile=1
    gameState="SaveDelete"
    pressinp.accept=false
    return
  end
  if pressinp.back then
    menusfx[3]:stop()
    menusfx[3]:play()
    gameState="SaveDelete"
    pressinp.back=false
  end
end

function ConfirmDelete.drawBGA(offset)
  love.graphics.setColor(0.7, 0.2, 0.2, 1)
  for x=0, 8 do
    love.graphics.circle("line", 320, 240+offset, 60*(x+love.timer.getTime()%1))
  end
end

function ConfirmDelete.draw()
  drawPlayerStats()
  love.graphics.setColor(1, 0.4, 0.4, 1)
  love.graphics.printf("Delete File\n"..players[savefile].."\nPermanently?", font_medium, 240, 180, 160, "center")

  love.graphics.printf("Press ENTER to Delete\nPress ESCAPE to Cancel", font_medium, 240, 260, 160, "center")
end

return ConfirmDelete