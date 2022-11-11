Curtain={}

function Curtain.update()
  for x=1,8 do
    bgm[x]:stop()
  end
  --Change as the game gets more tracks
  curtain=curtain and (curtain + (holdinp.egg and 6 or 3)) or -80
  if curtain>=400 then
    curtain=nil
    gameState="EndGame"
  end
end

function Curtain.drawBGA(offset, cmoffset, bxa, bxb, bya, byb)
  InGame.drawBGA(offset, cmoffset, bxa, bxb, bya, byb)
end

function Curtain.draw()
  drawGridOutline()
  drawPlayerStats()
  drawGrid()
  drawNextQueue()
  drawGrade(432, 100)
  drawMedals()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.printf(formatTime(timer), font_medium, 240, 440, 160, "center")
  if mode<4 then
    love.graphics.print("LEVEL", font_medium, 436, 320)
    love.graphics.print(level==1000 and "@" or level or 0, font_large, 436, 350)
  else
    love.graphics.print("STAGE", font_medium, 436, 320)
    love.graphics.print(toRomanNumerals(activationstage), font_large, 436, 350)
    drawCards()
  end
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.rectangle("fill", 240, 100+320-math.max(0,math.min(320,curtain or 0)), 160, math.max(0,math.min(320,curtain or 0)))
end

return Curtain