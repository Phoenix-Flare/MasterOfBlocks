NameEntry={}

function NameEntry.update()
  updateNameInput()
  if nameEntryCompleted then
    for x=3,place,-1 do
      save.records[mode][rotationrule][x]=save.records[mode][rotationrule][x-1]
    end
    if mode==1 then
      save.records[mode][rotationrule][place]={string.len(name)==0 and "Mortal" or name, rank, level, timer}
    elseif mode==2 or mode==3 then
      save.records[mode][rotationrule][place]={string.len(name)==0 and "Mortal" or name, math.floor(level/100), level, timer}
    end
    saveSave()
    mode=nil
    gameState="Menu"
    bgm[0]:play()
  end
end

function NameEntry.drawBGA(offset)
  InGame.drawBGA(offset)
end

function NameEntry.draw()
  love.graphics.clear(0, 0, 0, 1)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.printf("EXCELLENT!!\nENTER YOUR NAME", font_large, 0, 100, 640, "center")
  love.graphics.print(({"1st. ", "2nd. ", "3rd. "})[place]..name, font_large, 200, 150)
  love.graphics.print("Lv. "..level, font_medium, 300, 190)
  love.graphics.print(formatTime(timer), font_medium, 300, 215)
  drawGrade(220, 175)
  drawNameEntry()
end

return NameEntry