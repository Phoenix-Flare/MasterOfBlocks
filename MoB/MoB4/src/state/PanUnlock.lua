PanUnlock={}

function PanUnlock.update()
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

function PanUnlock.drawBGA()
end

function PanUnlock.draw()
  love.graphics.clear(0, 0, 0, 0)
  local c = 0.5 + 0.5*math.sin(love.timer.getTime())
  love.graphics.setColor(1, 0, c, 1)
  love.graphics.printf("PANDAEMONIUM MODE UNLOCKED!\n\nWarning: This mode is not intended to be\ncompleted by human players!\n\n\nPRESS "..(love._console_name and "A" or "ENTER").." TO CONTINUE", font_large, 0, 100, 640, "center")
end

return PanUnlock