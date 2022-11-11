InGame={}

function InGame.update()
  if pressinp.pause then
    gamesfx.pause:play()
    oldGameState=gameState
    gameState="Paused"
    for x=1,8 do
      if bgm[x]:isPlaying() then
        if love._console_name then
          bgm[x]:stop()
        else
          bgm[x]:pause()
        end
        pausedmusic=x
        break
      end
    end
    menu=1
    pressinp.pause=false
  end
  if ARE<1 or timer>0 then
    timer=timer+1
    activationtimer=math.min(activationtimer+1, 21600) --Caps at 6 minutes, despite the speed curve only going up to 5. This prevents line clears from causing the player to wobble back and forth between 20G and 3G as much.
    if level%100<90 then stime=stime+1 end
  end
  if internalscore>0 then
    internalscore=math.max(0,internalscore-getDecayRate())
  end
  ARE=ARE-1
  LCF=LCF-1
  if LCF==0 then
    clearLines()
  end
  if ARE==0 then
    spawnBlock()
    if mode<4 and timer~=0 and level%100~=99 and gameState=="InGame" then level=level+1 end
    bagDraw()
    queuesfx[(queue[1]-1)%7+1]:stop()
    queuesfx[(queue[1]-1)%7+1]:play()
  end
  if mode==4 and #deck==0 then
    rolltimer=1200
    rollLines=0
    gameState="Roll"
  end
  if gameState~="Curtain" then
    moveBlock()
  end
end

function InGame.drawBGA(offset, cmoffset, bxa, bxb, bya, byb)
  local level=(mode<4 and level or activationstage*100-99)
  if level<100 then
    love.graphics.setColor(({{0.2, 0.2, 0.8}, {0.6, 0.1, 0.1}, {0.7, 0.1, 0.7}, {0.2, 0.8, 0.2}})[mode])
    for x=-1, 15 do
      local h=x*32+(math.floor(love.timer.getTime()*20)%32)
      love.graphics.rectangle("fill", 0+offset, h, 640, 4)
    end
    for x=-1, 20 do
      local h=x*32+(math.floor(love.timer.getTime()*40)%32)
      love.graphics.rectangle("fill", h+offset, 0, 4, 480)
    end
  elseif level<200 then
    love.graphics.setColor({0.5, 0.5, 1})
    for x=1,20 do
      local hx = math.cos(math.rad(18*x + love.timer.getTime()*4))
      local hy = math.sin(math.rad(18*x + love.timer.getTime()*4))
      love.graphics.line(224+offset, 84, math.max(0, math.min(640, 320+hx*400))+offset, math.max(0, math.min(480, 240+hy*400)))
      love.graphics.line(224+offset, 436, math.max(0, math.min(640, 320+hx*400))+offset, math.max(0, math.min(480, 240+hy*400)))
      love.graphics.line(416+offset, 84, math.max(0, math.min(640, 320+hx*400))+offset, math.max(0, math.min(480, 240+hy*400)))
      love.graphics.line(416+offset, 436, math.max(0, math.min(640, 320+hx*400))+offset, math.max(0, math.min(480, 240+hy*400)))
    end
  elseif level<300 then
    love.graphics.setColor({1, 1, 0.3})
    for x=0,10 do
      for y=1,3 do
        local angle = ({[0]=-1,1})[x%2] * math.rad(120*y + love.timer.getTime()*6)
        local hx = 40*x*math.cos(angle)
        local hy = 40*x*math.sin(angle)
        love.graphics.line(320+(hx+1000*math.cos(angle+math.rad(90)))+offset, 240+(hy+1000*math.sin(angle+math.rad(90))), 320+(hx+1000*math.cos(angle-math.rad(90)))+offset, 240+(hy+1000*math.sin(angle-math.rad(90))))
        love.graphics.line(320-(hx+1000*math.cos(angle+math.rad(90)))+offset, 240-(hy+1000*math.sin(angle+math.rad(90))), 320-(hx+1000*math.cos(angle-math.rad(90)))+offset, 240-(hy+1000*math.sin(angle-math.rad(90))))
      end
    end
  elseif level<400 then
    love.graphics.setColor({0.5, 1, 0})
    for x=1,15 do
      local h = 320+320*math.sin(math.rad(24*x + love.timer.getTime()*5.5))
      love.graphics.line(h+offset, 0, 640-h+offset, 480)
    end
  elseif level<500 then
    love.graphics.setColor(currentBlock and blockcolors[blockindex[currentBlock.block]] or blockcolors[blockindex[queue[1]]])
    if cheat.difficulty==1 then
      love.graphics.setColor(0.4, 0.4, 0.4, 1)
      if currentBlock then
        local red=1-0.04*(currentBlock.resetFrames/currentBlock.maxLockDelay)
        local nonred=0.4*(currentBlock.resetFrames/currentBlock.maxLockDelay)/15
        love.graphics.setColor(red, nonred, nonred, 1)
      end
    end
    for x=0, 8 do
      local h = 60*(x+love.timer.getTime()*2%1)
      love.graphics.line(320+offset+h, 0, 320+offset+h, 480)
      love.graphics.line(320+offset-h, 0, 320+offset-h, 480)
      love.graphics.line(0+offset, 240+h, 640+offset, 240+h)
      love.graphics.line(0+offset, 240-h, 640+offset, 240-h)
    end
  elseif level<600 then
    love.graphics.setColor({0.4, 0.4, 0.4})
    for x=-3, 17 do
      local h=x*32+64*(math.sin(math.rad(love.timer.getTime()*50)))
      love.graphics.rectangle("fill", offset-2, h-2, 640, 4)
    end
    for x=-3, 22 do
      local h=x*32+64*(math.cos(math.rad(love.timer.getTime()*50)))
      love.graphics.rectangle("fill", h+offset-2, -2, 4, 480)
    end
  elseif level<700 then
    for x=1,7 do
      for y=1,3 do
        for z=1,2 do
          local hd=40+40*z
          local hr=({1, 2, 3, 5, 7, 11, 13})[x]/2
          love.graphics.setColor(({{1, 0, 0}, {1, 1, 0}, {0, 1, 0}, {0, 1, 1}, {0, 0, 1}, {1, 0, 1}, {1, 1, 1}})[x])
          local hx={120+hd*math.cos(math.rad(y*120+hr*(love.timer.getTime()*30))),120+hd*math.cos(math.rad((y+1)*120+hr*(love.timer.getTime()*30)))}
          local hy={240+hd*math.sin(math.rad(y*120+hr*(love.timer.getTime()*30))),240+hd*math.sin(math.rad((y+1)*120+hr*(love.timer.getTime()*30)))}
          love.graphics.line(offset+hx[1], hy[1], offset+hx[2], hy[2])
          love.graphics.line(offset+640-hx[1], hy[1], offset+640-hx[2], hy[2])
        end
      end
    end
  elseif level<800 then
    for x=1,20 do
      local hc=math.sin(math.rad(18*x+love.timer.getTime()*18))
      local hy=math.cos(math.rad(18*x+love.timer.getTime()*18))
      if hc>0 then
        love.graphics.setColor(hc, hc, hc)
        love.graphics.line(-20+offset, 240+240*hy, 660+offset, 240+240*hy)
      end
    end
  elseif level<900 then
    love.graphics.setColor(({{0.2, 0.2, 0.8}, {0.6, 0.1, 0.1}, {0.7, 0.1, 0.7}, {0.2, 0.8, 0.2}})[mode])
    for x=1, 9 do
      local h = 60*(x-love.timer.getTime()*3%1)
      love.graphics.line(320+offset+h, 0, 320+offset+h, 480)
      love.graphics.line(320+offset-h, 0, 320+offset-h, 480)
      love.graphics.line(0+offset, 240+h, 640+offset, 240+h)
      love.graphics.line(0+offset, 240-h, 640+offset, 240-h)
    end
  elseif level<1001 then
    if #clearedLines>0 then
      love.graphics.setColor(({{0.1, 0.1, 0.1}, {0.3, 0.3, 0.3}, {0.6, 0.6, 0.6}, {1, 1, 1}})[math.min(4, math.ceil(#clearedLines/(cheat.bigblock and 2 or 1)))])
      love.graphics.rectangle("fill", 0, 0, 640, 480)
      love.graphics.setColor(#clearedLines>3 and {0, 0, 0} or {1, 1, 1})
      for idx, ln in pairs(clearedLines) do
        love.graphics.rectangle("fill", 320+offset, 84+16*ln, (1-(LCF-1)/getLCF())*320+offset, 16)
        love.graphics.rectangle("fill", 320-(1-(LCF-1)/getLCF())*320+offset, 84+16*ln, (1-(LCF-1)/getLCF())*320+offset, 16)
      end
    end
  elseif level<1100 then
    for x=1,5 do
      local hx=math.cos(math.rad(72*x+love.timer.getTime()*18))
      local hy=math.sin(math.rad(72*x+love.timer.getTime()*18))
      love.graphics.setColor(0.3, 1, 0.3)
      love.graphics.line(320+offset, 240+240*hy, 320+offset+320*hx, 240, 320+offset, 240-240*hy, 320+offset-320*hx, 240, 320+offset, 240+240*hy)
    end
  elseif level<1200 then
    love.graphics.setColor(0.5, 0.5, 0.5)
    for x=1,15 do
      local h={
        x=320+400*math.cos(math.rad(24*x+15*love.timer.getTime()))+offset,
        y=240+400*math.sin(math.rad(24*x+15*love.timer.getTime()))+offset,
        a1=math.rad(24*x-6*love.timer.getTime()),
        a2=math.rad(120+24*x-6*love.timer.getTime()),
        a3=math.rad(240+24*x-6*love.timer.getTime()),
      }
      love.graphics.line(h.x-400*math.cos(h.a1), h.y-400*math.sin(h.a1), h.x-400*math.cos(h.a2), h.y-400*math.sin(h.a2), h.x-400*math.cos(h.a3), h.y-400*math.sin(h.a3), h.x-400*math.cos(h.a1), h.y-400*math.sin(h.a1))
    end
  elseif level<1300 then
    for x=1,24 do
      local h=(love.timer.getTime()%1)*15>7.5 and love.timer.getTime()*30 or 0
      love.graphics.setColor(1, 0, 1)
      love.graphics.line(320, 240, 320+400*math.cos(math.rad(x*15+h)), 240+400*math.sin(math.rad(x*15+h)))
    end
  elseif level<1400 then
    for x=0,5 do
      love.graphics.setColor(1, 1, 1, 0.3+(x/10))
      love.graphics.draw(s14background, 0+offset*(14-x)/10, x*80, 0, 1, 1, love.timer.getTime()*50*(x+2)%560, 0)
    end
  else
    CheatMenu.drawBGA(offset, cmoffset, bxa, bxb, bya, byb)
  end
end

function InGame.draw()
  drawGridOutline()
  drawPlayerStats()
  checkUpdateGrid()
  drawGrid()
  drawNextQueue()
  drawGrade(432, 100)
  drawMedals()
  love.graphics.setColor(1, 1, 1, 1)
  if lineData then
    love.graphics.printf(lineData[1], font_medium, 420, 200, 120, "left")
    lineData[2]=lineData[2]-1
    if lineData[2]==0 then
      lineData=nil
    end
  end
  love.graphics.printf(formatTime(timer), font_medium, 240, 440, 160, "center")
  if mode<4 then
    love.graphics.print("LEVEL", font_medium, 436, 320)
    love.graphics.print(level==1000 and "@" or level or 0, font_large, 436, 350)
  else
    love.graphics.print("STAGE", font_medium, 436, 320)
    love.graphics.print(toRomanNumerals(activationstage), font_large, 436, 350)
    drawCards()
  end
end

return InGame