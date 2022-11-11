Credits={}

function Credits.update()
  if pressinp.accept then
    gameState="Menu"
    bgm[0]:play()
    if not menu then menu=1 end
    submenu=1
    pressinp.accept=false
  end
  if pressinp.back and holdinp.egg then
    initAltSFX()
  end
end

function Credits.drawBGA(offset)
  love.graphics.setColor(0.5, 0.5, 0.5, 1)
  for x=0, 8 do
    love.graphics.circle("line", 320, 240+offset, 60*(x+love.timer.getTime()%1))
  end
end

function Credits.draw()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.printf("Master of Blocks: Apotheosis", font_large, 0, 24, 640, "center")
  love.graphics.setColor(0.7, 0.7, 0.7, 1)
  love.graphics.printf("Program, Music, and BGAs By Phoenix Flare", font_medium, 0, 78, 640, "center")
  love.graphics.printf("Sprites and Font By MarkGamed7794", font_medium, 0, 102, 640, "center")
  love.graphics.printf("--Special Thanks--", font_medium, 0, 138, 640, "center")
  love.graphics.printf("Milla", font_medium, 120, 162, 200, "center")
  love.graphics.printf("Willess12", font_medium, 320, 162, 200, "center")
  love.graphics.printf("Bucephalus", font_medium, 120, 186, 200, "center")
  love.graphics.printf("Nehemek", font_medium, 320, 186, 200, "center")
  love.graphics.printf("TAP Discord Server", font_medium, 120, 210, 200, "center")
  love.graphics.printf("Badger eSports", font_medium, 320, 210, 200, "center")
  love.graphics.printf("Everyone who played the MoB trilogy", font_medium, 0, 234, 640, "center")
  love.graphics.printf("--Beta Testers--", font_medium, 0, 270, 640, "center")
  love.graphics.printf("Mizu", font_medium, 220, 294, 100, "center")
  love.graphics.printf("Trixciel", font_medium, 320, 294, 100, "center")
  love.graphics.printf("UnderRay", font_medium, 220, 320, 100, "center")
  love.graphics.printf("Hita", font_medium, 320, 320, 100, "center")
  love.graphics.setColor(1, 1, 1, math.floor(math.sin(math.rad(love.timer.getTime()*360))+1))
  love.graphics.printf("Press "..(love._console_name and "A" or "Enter").." to Begin", font_medium, 0, 360, 640, "center")
end

return Credits