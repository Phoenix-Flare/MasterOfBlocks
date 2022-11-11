NewFile={}

function NewFile.update()
  updateNameInput()
  if nameEntryCompleted then
    menusfx[2]:stop()
    menusfx[2]:play()
    if name~="" then
      if save.players[name] then 
        gameState="SaveSelect"
        return
      end
      save.players[name]={}
      for x=0,19 do
        save.players[name][x]={
          {best=0, qualify=0, precedent=nil, lastfive={}, hell=0, hlevel=0, pandaemonium=0, plevel=0, activation=0},
          {best=0, qualify=0, precedent=nil, lastfive={}, hell=0, hlevel=0, pandaemonium=0, plevel=0, activation=0},
          {best=0, qualify=0, precedent=nil, lastfive={}, hell=0, hlevel=0, pandaemonium=0, plevel=0, activation=0},
          pandaemonium=false,
          activation=false,
          unlockpoints=0
        }
      end
      saveSave()
      players={}
      for idx, data in pairs(save.players) do
        players[#players+1]=idx
      end
    end
    gameState="SaveSelect"
  end
end

function NewFile.drawBGA(offset)
  love.graphics.setColor(0.7, 0.7, 0.7, 1)
  for x=0, 8 do
    love.graphics.circle("line", 320, 240+offset, 60*(x+love.timer.getTime()%1))
  end
end

function NewFile.draw()
  drawGridOutline()
  love.graphics.setColor(0.8, 0.8, 0.8, 1)
  love.graphics.printf("New File", font_medium, 240, 106, 160, "center")
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print(name, font_medium, 246, 154)
  drawNameEntry()
end

return NewFile