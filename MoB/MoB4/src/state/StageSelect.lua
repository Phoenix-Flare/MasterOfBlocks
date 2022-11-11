StageSelect={}

function StageSelect.update()
  if pressinp.menuup then
    menusfx[1]:stop()
    menusfx[1]:play()
    activationstage=activationstage-5
  end
  if pressinp.menudown then
    menusfx[1]:stop()
    menusfx[1]:play()
    activationstage=activationstage+5
  end
  if pressinp.menuleft then
    menusfx[1]:stop()
    menusfx[1]:play()
    activationstage=activationstage-1
  end
  if pressinp.menuright then
    menusfx[1]:stop()
    menusfx[1]:play()
    activationstage=activationstage+1
  end
  activationstage=math.min(math.max(1, math.min(activationstage, save.players[savefile][cheatvalue][rotationrule].activation+1)), 15)
  if pressinp.accept then
    menusfx[2]:stop()
    menusfx[2]:play()
    gameState="StartGame"
    gameInit()
    bgm[0]:stop()
    timer=45
  end
  if pressinp.back then
    gameState="RuleSelect"
    menusfx[3]:stop()
    menusfx[3]:play()
  end
end

function StageSelect.drawBGA(offset)
  love.graphics.setColor(0.2, 0.7, 0.2, 1)
  for x=0, 8 do
    love.graphics.circle("line", 320, 240+offset, 60*(x+love.timer.getTime()%1))
  end
end

function StageSelect.draw()
  love.graphics.setColor(0.1, 1, 0.1)
  love.graphics.printf("Stage Select", font_large, 0, 100, 640, "center")
  for x=1,5 do
    for y=0,2 do
      love.graphics.setColor(0.2, 0.2, 0.2, 0.2)
      love.graphics.rectangle("fill", 48+80*x, 160+80*y, 64, 64)
      if activationstage==y*5+x then
        love.graphics.setColor(0, 1, 0)
      elseif save.players[savefile][cheatvalue][rotationrule].activation+1>=y*5+x then
        love.graphics.setColor(0.4, 0.4, 0.4)
      else
        love.graphics.setColor(0.7, 0, 0)
      end
      love.graphics.rectangle("fill", 48+80*x, 160+80*y, 64, 4)
      love.graphics.rectangle("fill", 48+80*x, 160+80*y, 4, 64)
      love.graphics.rectangle("fill", 48+80*x, 220+80*y, 64, 4)
      love.graphics.rectangle("fill", 108+80*x, 160+80*y, 4, 64)
      love.graphics.setColor(1, 1, 1)
      love.graphics.printf(toRomanNumerals(x+y*5), font_large, 48+80*x, 186+80*y, 64, "center")
    end
  end
end

return StageSelect