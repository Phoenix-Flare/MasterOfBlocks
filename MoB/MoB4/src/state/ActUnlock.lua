ActUnlock={}

function ActUnlock.update()
  if pressinp.accept then
    gameState="Menu"
    if mode==1 then
      gameState="StatsScreen"
    end
    mode=nil
    menu=1
    submenu=1
    bgm[0]:play()
  end
end

function ActUnlock.drawBGA()
end

function ActUnlock.draw()
  love.graphics.clear(0, 0, 0, 0)
  local c = 0.5 + 0.5*math.sin(love.timer.getTime()*3)
  love.graphics.setColor(c, 1, c, 1)
  love.graphics.printf("ACTIVATION MODE UNLOCKED!\n\n\nPRESS "..(love._console_name and "A" or "ENTER").." TO CONTINUE", font_large, 0, 200, 640, "center")
end

return ActUnlock