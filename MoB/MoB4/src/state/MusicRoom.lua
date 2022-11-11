MusicRoom={}

function MusicRoom.update()
  if pressinp.menuup then
    menu=(menu-1)%9
  end
  if pressinp.menudown then
    menu=(menu+1)%9
  end
  if pressinp.accept then
    for x=0, 8 do
      bgm[x]:stop()
    end
    bgm[menu]:play()
  end
  if pressinp.back then
    for x=1, 8 do
      bgm[x]:stop()
    end
    bgm[0]:play()
    gameState="Menu"
    menu=1
    submenu=1
  end
end

function MusicRoom.drawBGA(offset)
  love.graphics.setColor(0.5, 0.5, 0.5, 1)
  for x=0, 8 do
    love.graphics.circle("line", 320, 240+offset, 60*(x+love.timer.getTime()%1))
  end
end

function MusicRoom.draw()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.printf("Music Room", font_large, 0, 32, 640, "center")
  local usedIn=
  {
    [0]="Title Screen",
    "Heaven 0-599\nActivation I-II",
    "Heaven 600-1199\nActivation III-IV",
    "Heaven 1200-1799\nActivation V-VI",
    "Heaven 1800-2399\nHell 0-299\nActivation VII-IX",
    "Heaven 2400-2999\nHell 300-499\nPandaemonium 0-299\nActivation X-XII",
    "Hell 500-899\nPandaemonium 300-599\nActivation XIII",
    "Hell 900-999\nPandaemonium 600-999\nActivation XIV-XV",
    "Credit Roll",
  }
  for x=0, 8 do
    love.graphics.setColor(1, 1, menu==x and 0.4 or 1, 1)
    love.graphics.print("Track "..x..": "..({[0]="Meaningless World", "Black Dragon", "Descent Into Madness", "Burning", "Turbo Folk Legend", "Dying Sun", "Triskaidekaphobia", "Original Sin", "Ancient Prophecy"})[x], font_large, 75, 100+30*x)
    if menu==x then
      love.graphics.setColor(0.8, 0.8, 0.8, 1)
      love.graphics.printf(usedIn[x], font_medium, 0, 400, 640, "center")
    end
  end
end

return MusicRoom