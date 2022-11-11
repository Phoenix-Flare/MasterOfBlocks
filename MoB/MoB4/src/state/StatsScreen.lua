StatsScreen={}

function StatsScreen.update()
  if pressinp.accept then
    promoted=nil
    demoted=nil
    gameState="Menu"
    bgm[0]:play()
  end
end

function StatsScreen.drawBGA(offset)
  love.graphics.setColor(0.5, 0.5, 0.5, 1)
  for x=0, 8 do
    love.graphics.circle("line", 320, 240+offset, 60*(x+love.timer.getTime()%1))
  end
end

function StatsScreen.draw()
  love.graphics.clear(0, 0, 0, 0)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.printf(savefile, font_large, 00, 100, 640, "center")
  if promoted then
    love.graphics.setColor(0.7, 0.7, 0, 1)
    love.graphics.printf("PROMOTED!", font_large, 0, 150, 640, "center")
    drawQualifyGrade(save.players[savefile][cheatvalue][rotationrule].qualify, 288, 180)
  elseif demoted then
    love.graphics.setColor(0, 0, 0.7, 1)
    love.graphics.printf("DEMOTED...", font_large, 0, 150, 640, "center")
    drawQualifyGrade(save.players[savefile][cheatvalue][rotationrule].qualify, 288, 180)
  else
    love.graphics.printf("Current Rank", font_large, 0, 150, 640, "center")
    love.graphics.printf("History", font_large, 0, 350, 640, "center")
    if save.players[savefile][cheatvalue][rotationrule].precedent and save.players[savefile][cheatvalue][rotationrule].precedent>save.players[savefile][cheatvalue][rotationrule].qualify then
      love.graphics.printf("Current Precedent", font_large, 0, 250, 640, "center")
      drawQualifyGrade(save.players[savefile][cheatvalue][rotationrule].precedent, 288, 280)
    end
    drawQualifyGrade(save.players[savefile][cheatvalue][rotationrule].qualify, 288, 180)
    for x=1,#save.players[savefile][cheatvalue][rotationrule].lastfive do
      drawQualifyGrade(save.players[savefile][cheatvalue][rotationrule].lastfive[x], 238-50*#save.players[savefile][cheatvalue][rotationrule].lastfive+100*x, 380)
    end
  end
end

return StatsScreen