RuleSelect={}

function RuleSelect.update()
  if pressinp.menuup then
    menusfx[1]:stop()
    menusfx[1]:play()
    rotationrule=(rotationrule-2)%3+1
  end
  if pressinp.menudown then
    menusfx[1]:stop()
    menusfx[1]:play()
    rotationrule=rotationrule%3+1
  end
  if pressinp.accept then
    menusfx[2]:stop()
    menusfx[2]:play()
    if mode<4 then
      gameState="StartGame"
      gameInit()
      bgm[0]:stop()
      timer=45
    else
      gameState="StageSelect"
      activationstage=save.players[savefile][cheatvalue][rotationrule].activation+1
    end
  end
  if pressinp.back then
    gameState="ModeSelect"
    menusfx[3]:stop()
    menusfx[3]:play()
  end
end

function RuleSelect.drawBGA(offset)
  love.graphics.setColor(0.7, 0.7, 0.7, 1)
  for x=0, 8 do
    love.graphics.circle("line", 320, 240+offset, 60*(x+love.timer.getTime()%1))
  end
end

function RuleSelect.draw()
  if not rotationrule then rotationrule=1 end
  drawGridOutline()
  drawPlayerStats()
  love.graphics.setColor(0.8, 0.8, 0.8, 1)
  love.graphics.printf("Select Rotation", font_medium, 240, 106, 160, "center")

  love.graphics.setColor(1, 0.3, 0.3, rotationrule==1 and 1 or 0.5)
  love.graphics.printf("DRS", font_medium, 240, 154, 160, "center")

  love.graphics.setColor(0.5, 0.5, 1, rotationrule==2 and 1 or 0.5)
  love.graphics.printf("SRS-X", font_medium, 240, 178, 160, "center")

  love.graphics.setColor(1, 0.5, 1, rotationrule==3 and 1 or 0.5)
  love.graphics.printf("KRS", font_medium, 240, 202, 160, "center")
  
  love.graphics.setColor(0.4, 0.4, 0.4, 1)
  love.graphics.rectangle("fill", 432, 120, 192, 120)
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", 440, 128, 176, 104)
  love.graphics.setColor(1, 1, 1)
  local text={
    "Like Classic. The rule isn't too terribly permissive. For experts.",
    "Like World. The 180 kicks are particularly powerful. For all players.",
    "Like Deluxe. DASKick is very unwieldy, yet powerful. For chaos enthusiasts."
  }
  love.graphics.printf(text[rotationrule], font_medium, 448, 136, 160)
end

return RuleSelect