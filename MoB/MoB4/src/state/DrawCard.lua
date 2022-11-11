DrawCard={}

function DrawCard.update()
  processDAS()
  cardframes=cardframes+1
  if cardframes==70 and cardstandby.thirteen and lastcard>13 and lastcard<21 then
    cardstandby.thirteen=false
    lastcard=lastcard-10
  end
  if cardframes==120 then
    activationfirstpass=false
    if (lastcard%2==0 or lastcard>20) and cardstandby.amulet then
      cardstandby.amulet=false
      amuletframes=0
      gameState="Amulet"
    else
      gameState="Activate"
    end
  end
end

function DrawCard.drawBGA(offset, cmoffset, bxa, bxb, bya, byb)
  InGame.drawBGA(offset, cmoffset, bxa, bxb, bya, byb)
end

function DrawCard.draw(offset)
  InGame.draw()
  love.graphics.setColor(1, 1, 1)
  local cw=math.abs(math.sin(math.rad(math.min(cardframes-30,30)*3)))
  if cardframes<30 then
    love.graphics.draw(cardgfx[0], 320-160*cw, 80, 0, 5*cw, 5)
  end
  if cardframes>29 then
    love.graphics.draw(cardgfx[lastcard], 320-160*cw, 80, 0, 5*cw, 5)
    if cardstandby.block and (lastcard%2==0 or lastcard>20) then
      love.graphics.setColor(0, 0, 1)
    else
      love.graphics.setColor(({{0.2, 0.8, 0.2}, {0.6, 0.1, 0.1}, {0.7, 0.1, 0.7}})[lastcard>20 and 3 or (lastcard-1)%2+1])
    end
    love.graphics.rectangle("fill", 320-(cardframes-30)*10-offset, 400, (cardframes-30)*20, 32)
  else
  end
  if cardframes>59 then
    love.graphics.setColor(0, 0, 0)
    if cardstandby.block and (lastcard%2==0 or lastcard>20) then
      love.graphics.printf("CARD BLOCKED", font_large, 0-offset, 408, 640, "center")
    else
      love.graphics.printf(cardnames[lastcard], font_large, 0-offset, 408, 640, "center")
    end
  end
end

return DrawCard