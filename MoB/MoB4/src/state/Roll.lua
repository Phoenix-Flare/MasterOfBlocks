Roll={}

function Roll.update()
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
  rolltimer=rolltimer-1
  if rolltimer==0 then
    gameState="Curtain"
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
    bagDraw()
    queuesfx[(queue[1]-1)%7+1]:stop()
    queuesfx[(queue[1]-1)%7+1]:play()
  end
  if gameState~="Curtain" then
    moveBlock()
  end
end

function Roll.drawBGA(offset, cmoffset, bxa, bxb, bya, byb)
  InGame.drawBGA(offset, cmoffset, bxa, bxb, bya, byb)
end

function Roll.draw()
  InGame.draw()
end

return Roll