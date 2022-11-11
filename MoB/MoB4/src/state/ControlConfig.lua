ControlConfig={}

function ControlConfig.update()
  if pressinp.back then
    menusfx[3]:stop()
    menusfx[3]:play()
    for x=1,8 do
      keycodes[x]=save.keycodes[x]
    end
    submenu=1
    gameState="Menu"
  end
  if keyindex==9 and pressinp.accept then
    menusfx[2]:stop()
    menusfx[2]:play()
    submenu=1
    gameState="Menu"
    for x=1,8 do
      save.keycodes[x]=keycodes[x]
    end
    saveSave()
  end
end

function ControlConfig.drawBGA(offset)
  love.graphics.setColor(0.7, 0.7, 0.7, 1)
  for x=0, 8 do
    love.graphics.circle("line", 320, 240+offset, 60*(x+love.timer.getTime()%1))
  end
end

function ControlConfig.draw()
  drawGridOutline()
  love.graphics.setColor(0.8, 0.8, 0.8, 1)
  love.graphics.printf("Controls", font_medium, 246, 106, 160, "center")

  love.graphics.setColor(1, 1, keyindex==1 and 0.4 or 1, 1)
  love.graphics.print("CCW: "..keycodes[1], font_medium, 246, 154)

  love.graphics.setColor(1, 1, keyindex==2 and 0.4 or 1, 1)
  love.graphics.print("CW: "..keycodes[2], font_medium, 246, 178)

  love.graphics.setColor(1, 1, keyindex==3 and 0.4 or 1, 1)
  love.graphics.print("180: "..keycodes[3], font_medium, 246, 202)

  love.graphics.setColor(1, 1, keyindex==4 and 0.4 or 1, 1)
  love.graphics.print("Hold: "..keycodes[4], font_medium, 246, 226)

  love.graphics.setColor(1, 1, keyindex==5 and 0.4 or 1, 1)
  love.graphics.print("Up: "..keycodes[5], font_medium, 246, 250)

  love.graphics.setColor(1, 1, keyindex==6 and 0.4 or 1, 1)
  love.graphics.print("Down: "..keycodes[6], font_medium, 246, 274)

  love.graphics.setColor(1, 1, keyindex==7 and 0.4 or 1, 1)
  love.graphics.print("Left: "..keycodes[7], font_medium, 246, 298)

  love.graphics.setColor(1, 1, keyindex==8 and 0.4 or 1, 1)
  love.graphics.print("Right: "..keycodes[8], font_medium, 246, 322)

  love.graphics.setColor(0.8, 0.8, 0.8, 1)
  if keyindex==9 then
    love.graphics.print("Enter to Confirm", font_medium, 246, 382)
  end
  love.graphics.print("Escape to Cancel", font_medium, 246, 400)
end

return ControlConfig