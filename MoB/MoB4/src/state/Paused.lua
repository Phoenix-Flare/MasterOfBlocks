Paused={}

function Paused.update()
  if (pressinp.accept and menu==1) or pressinp.pause then
    menusfx[2]:stop()
    menusfx[2]:play()
    gameState=oldGameState
    oldGameState=nil
    if pausedmusic then
      bgm[pausedmusic]:play()
      pausedmusic=nil
    end
  elseif pressinp.accept then
    menusfx[2]:stop()
    menusfx[2]:play()
    gameState="Curtain"
    oldGameState=nil
    menu=1
  end
  if pressinp.menuup or pressinp.menudown then
    menusfx[1]:stop()
    menusfx[1]:play()
    menu=menu%2+1
  end
end

function Paused.drawBGA(offset, cmoffset, bxa, bxb, bya, byb)
  InGame.drawBGA(offset, cmoffset, bxa, bxb, bya, byb)
end

function Paused.draw()
  drawGridOutline()
  drawPlayerStats()
  checkUpdateGrid()
  drawGrid()
  drawNextQueue()
  drawMedals()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.printf("PAUSED", font_large, 240, 250, 160, "center")
  love.graphics.printf(formatTime(timer), font_medium, 240, 440, 160, "center")
  for idx, text in pairs({"Resume","Give Up"}) do
    if menu==idx then
      love.graphics.setColor(1, 1, 1, 1)
    else
      love.graphics.setColor(0.8, 0.8, 0.8, 1)
    end
    love.graphics.printf(text, font_medium, 240, 260+24*idx, 160, "center")
  end
  love.graphics.setColor(1, 1, 1, 1)
  if mode<4 then
    love.graphics.print("LEVEL", font_medium, 436, 320)
    love.graphics.print(level==1000 and "@" or level or 0, font_large, 436, 350)
  else
    love.graphics.print("STAGE", font_medium, 436, 320)
    love.graphics.print(toRomanNumerals(activationstage), font_large, 436, 350)
    drawCards()
  end
end

return Paused