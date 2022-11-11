Records={}

function Records.update()
  if pressinp.menuup then
    recordsIndex[1]=(recordsIndex[1]-2)%3+1
  end
  if pressinp.menudown then
    recordsIndex[1]=recordsIndex[1]%3+1
  end
  if pressinp.menuleft then
    recordsIndex[2]=(recordsIndex[2]-2)%3+1
  end
  if pressinp.menuright then
    recordsIndex[2]=recordsIndex[2]%3+1
  end
  if pressinp.back then
    menusfx[3]:stop()
    menusfx[3]:play()
    submenu=1
    gameState="Menu"
    recordsIndex=nil
  end
end

function Records.drawBGA(offset)
  love.graphics.setColor(0.5, 0.5, 0.5, 1)
  for x=0, 8 do
    love.graphics.circle("line", 320, 240+offset, 60*(x+love.timer.getTime()%1))
  end
end

function Records.draw()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.printf(({"HEAVEN","HELL","PANDAEMONIUM"})[recordsIndex[1]].." MODE "..({"DRS", "SRS-X", "KRS"})[recordsIndex[2]], font_large, 0, 32, 640, "center")
  for idx, data in pairs(save.records[recordsIndex[1]][recordsIndex[2]]) do
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(({"1st. ", "2nd. ", "3rd. "})[idx]..data[1], font_large, 200, 100*idx)
    love.graphics.print("Lv. "..data[3], font_medium, 300, 40+100*idx)
    love.graphics.print(formatTime(data[4]), font_medium, 300, 65+100*idx)
    if recordsIndex[1]==1 then
      drawHGrade(data[2], 220, 25+100*idx)
    elseif recordsIndex[1]==2 then
      drawLGrade(data[2], 220, 25+100*idx)
    elseif recordsIndex[1]==3 then
      drawPGrade(data[2], 220, 25+100*idx)
    end
  end
end

return Records