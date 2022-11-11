CheatMenu={}

function CheatMenu.update()
  if pressinp.menuup then
    menusfx[1]:stop()
    menusfx[1]:play()
    menu=(menu-2)%3+1
  end
  if pressinp.menudown then
    menusfx[1]:stop()
    menusfx[1]:play()
    menu=menu%3+1
  end
  if pressinp.menuleft or pressinp.menuright then
    if menu==1 then
      cheat.bigblock=not cheat.bigblock
    elseif menu==2 then
      cheat.maxspeed=not cheat.maxspeed
    elseif menu==3 then
      if pressinp.menuright then
        cheat.difficulty=(cheat.difficulty-1)%5
      else
        cheat.difficulty=(cheat.difficulty+1)%5
      end
    end
    cheatvalue=cheat.difficulty+(cheat.maxspeed and 3 or 0)+(cheat.bigblock and 6 or 0)
  end
  if pressinp.back or pressinp.accept then
    menusfx[2]:stop()
    menusfx[2]:play()
    menu=1
    gameState="Menu"
    bgm[9]:stop()
    bgm[0]:play()
  end
end

function CheatMenu.drawBGA(offset, cmoffset, bxa, bxb, bya, byb)
  love.graphics.setColor(1, 0, 0)
  for x=1,30 do
    love.graphics.line(bxa[x]+cmoffset, bya[x], bxb[x]+cmoffset, byb[x])
  end
end

function CheatMenu.draw()
  love.graphics.setColor(0.4, 0.4, 0.4)
  love.graphics.rectangle("fill", 40, 40, 20, 400)
  love.graphics.rectangle("fill", 40, 40, 560, 20)
  love.graphics.rectangle("fill", 40, 420, 560, 20)
  love.graphics.rectangle("fill", 580, 40, 20, 400)
  
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", 45, 45, 10, 390)
  love.graphics.rectangle("fill", 45, 45, 550, 10)
  love.graphics.rectangle("fill", 45, 425, 550, 10)
  love.graphics.rectangle("fill", 585, 45, 10, 390)
  
  love.graphics.setColor(0, 0, 0, 0.3)
  love.graphics.rectangle("fill", 60, 60, 520, 360)

  love.graphics.setColor(1, 0, 0)
  love.graphics.printf("CHEAT MENU", font_large, 100, 100, 440, "center")

  love.graphics.setColor(1, 1, menu==1 and 0 or 1, menu==1 and 1 or 0.7)
  love.graphics.printf("BIG BLOCK MODE: ", font_large, 100, 160, 440, "center")
  love.graphics.setColor(0.6, 0.6, 0.6)
  love.graphics.printf((cheat.bigblock and "ON" or "OFF"), font_large, 100, 185, 440, "center")

  love.graphics.setColor(1, 1, menu==2 and 0 or 1, menu==2 and 1 or 0.7)
  love.graphics.printf("MAX GRAVITY (20G) MODE: ", font_large, 100, 220, 440, "center")
  love.graphics.setColor(0.6, 0.6, 0.6)
  love.graphics.printf((cheat.maxspeed and "ON" or "OFF"), font_large, 100, 245, 440, "center")

  love.graphics.setColor(1, 1, menu==3 and 0 or 1, menu==3 and 1 or 0.7)
  love.graphics.printf("DIFFICULTY LEVEL: ", font_large, 100, 280, 440, "center")
  love.graphics.setColor(0.6, 0.6, 0.6)
  love.graphics.printf(({[0]="what even is life\n\"heaven\" <-- swift lie ", "EXPERT", "STANDARD", "NOVICE", "BEGINNER"})[cheat.difficulty], font_large, 100, 305, 440, "center")
end

return CheatMenu