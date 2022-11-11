StartGame={}

function StartGame.update()
  processDAS()
  timer=timer-1
  if timer<1 then
    gameState="InGame"
    if mode<4 then
      bgm[({1, 4, 5})[mode]]:play()
    else
      bgm[({1, 1, 2, 2, 3, 3, 4, 4, 4, 5, 5, 5, 6, 7, 7})[activationstage]]:play()
    end
  end
end

function StartGame.drawBGA(offset, cmoffset, bxa, bxb, bya, byb)
  InGame.drawBGA(offset, cmoffset, bxa, bxb, bya, byb)
end

function StartGame.draw()
  drawGridOutline()
  drawPlayerStats()
  drawNextQueue()
  love.graphics.setColor(0.8, 0.8, 0.8, 1)
end

return StartGame