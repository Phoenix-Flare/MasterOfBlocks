EndGame={}

function EndGame.update()
  if pressinp.accept
  or ((mode==2 or mode==3) and level<100)
  then
    place=4
    rank=capGrade(totalrank)
    if rank>100 then
      rank=rank-(rank%5)
    end
    if cheatvalue==2 then
      for x=3,1,-1 do
        if mode==1 then
          if rank>=save.records[mode][rotationrule][x][2] then
            if rank>save.records[mode][rotationrule][x][2] then
              place=x
            elseif level>=save.records[mode][rotationrule][x][3] then
              if level>save.records[mode][rotationrule][x][3] then
                place=x
              elseif timer<save.records[mode][rotationrule][x][4] then
                place=x
              end
            end
          end
        elseif mode==2 or mode==3 then
          if level>=save.records[mode][rotationrule][x][3] then
            if level>save.records[mode][rotationrule][x][3] then
              place=x
            elseif timer<save.records[mode][rotationrule][x][4] then
              place=x
            end
          end
        end
      end
      if place~=4 then
        if savefile then
          for x=3,place,-1 do
            save.records[mode][rotationrule][x]=save.records[mode][rotationrule][x-1]
          end
          if mode==1 then
            save.records[mode][rotationrule][place]={savefile, rank, level, timer}
          elseif mode==2 or mode==3 then
            save.records[mode][rotationrule][place]={savefile, math.floor(level/100), level, timer}
          end
        end
      end
    end
    if savefile then
      if mode<4 then
        ({
            function() save.players[savefile][cheatvalue].unlockpoints=save.players[savefile][cheatvalue].unlockpoints+rank*5 end,
            function() save.players[savefile][cheatvalue].unlockpoints=save.players[savefile][cheatvalue].unlockpoints+math.floor(level/2) end,
            function() save.players[savefile][cheatvalue].unlockpoints=save.players[savefile][cheatvalue].unlockpoints+level*2 end
        })[mode]()
      end
      if mode==1 then
        save.players[savefile][cheatvalue][rotationrule].best=math.max(save.players[savefile][cheatvalue][rotationrule].best,rank)
        save.players[savefile][cheatvalue][rotationrule].lastfive[#save.players[savefile][cheatvalue][rotationrule].lastfive+1]=getClass(rank)

        -- Check for precedent pass
        if save.players[savefile][cheatvalue][rotationrule].precedent then
          local precedent = (save.players[savefile][cheatvalue][rotationrule].precedent>save.players[savefile][cheatvalue][rotationrule].qualify) and save.players[savefile][cheatvalue][rotationrule].precedent or save.players[savefile][cheatvalue][rotationrule].qualify-2
          local recentgames={}
          local average=0
          for x=1,#save.players[savefile][cheatvalue][rotationrule].lastfive do
            recentgames[x]=save.players[savefile][cheatvalue][rotationrule].lastfive[x]
          end
          for x=#recentgames,2,-1 do
            for y=1,x-1 do
              if recentgames[y]<recentgames[y+1] then
                local t=recentgames[y]
                recentgames[y]=recentgames[y+1]
                recentgames[y+1]=t
              end
            end
          end
          for x=1,3 do
            if #recentgames<x then break end
            average=average+recentgames[x]
          end
          average=math.floor(average/3+0.5)
          if average>=precedent then
            if precedent>save.players[savefile][cheatvalue][rotationrule].qualify then
              save.players[savefile][cheatvalue][rotationrule].qualify=precedent
              promoted=1
            end
            save.players[savefile][cheatvalue][rotationrule].precedent=nil
            save.players[savefile][cheatvalue][rotationrule].lastfive={}
          end
        end

        -- Check for precedent set/fail
        if #save.players[savefile][cheatvalue][rotationrule].lastfive>4 then
          local recentgames={}
          local average=0
          for x=1,#save.players[savefile][cheatvalue][rotationrule].lastfive do
            recentgames[x]=save.players[savefile][cheatvalue][rotationrule].lastfive[x]
          end
          for x=#recentgames,2,-1 do
            for y=1,x-1 do
              if recentgames[y]<recentgames[y+1] then
                local t=recentgames[y]
                recentgames[y]=recentgames[y+1]
                recentgames[y+1]=t
              end
            end
          end
          for x=1,3 do
            if #recentgames<x then break end
            average=average+recentgames[x]
          end
          average=math.floor(average/3+0.5)
          if save.players[savefile][cheatvalue][rotationrule].precedent then
            local precedent = (save.players[savefile][cheatvalue][rotationrule].precedent>save.players[savefile][cheatvalue][rotationrule].qualify) and save.players[savefile][cheatvalue][rotationrule].precedent or save.players[savefile][cheatvalue][rotationrule].qualify-2
            if precedent<save.players[savefile][cheatvalue][rotationrule].qualify and average<precedent then
              save.players[savefile][cheatvalue][rotationrule].qualify=save.players[savefile][cheatvalue][rotationrule].qualify-1
              demoted=1
            end
            save.players[savefile][cheatvalue][rotationrule].precedent=nil
          else
            if average>save.players[savefile][cheatvalue][rotationrule].qualify or save.players[savefile][cheatvalue][rotationrule].qualify>average+2 then
              save.players[savefile][cheatvalue][rotationrule].precedent=average
            end
          end
          save.players[savefile][cheatvalue][rotationrule].lastfive={}
        end
        mode=nil
        gameState="StatsScreen"
      else
        gameState="Menu"
        if mode==2 then
          save.players[savefile][cheatvalue][rotationrule].hell=math.max(save.players[savefile][cheatvalue][rotationrule].hell, math.floor(level/100))
          save.players[savefile][cheatvalue][rotationrule].hlevel=math.max(save.players[savefile][cheatvalue][rotationrule].hlevel, level)
          if level>499 and not save.players[savefile][cheatvalue].pandaemonium then
            save.players[savefile][cheatvalue].unlockpoints=2500+save.players[savefile][cheatvalue].unlockpoints
            save.players[savefile][cheatvalue].pandaemonium=true
            gameState="PanUnlock"
            saveSave()
            return
          end
        end
        if mode==3 then
          save.players[savefile][cheatvalue][rotationrule].pandaemonium=math.max(save.players[savefile][cheatvalue][rotationrule].pandaemonium, math.floor(level/100))
          save.players[savefile][cheatvalue][rotationrule].plevel=math.max(save.players[savefile][cheatvalue][rotationrule].plevel, level)
        end
        if mode==4 then
          if rolltimer==0 and #deck==0 then
            save.players[savefile][cheatvalue][rotationrule].activation=math.max(save.players[savefile][cheatvalue][rotationrule].activation, activationstage)
          end
        end
        mode=nil
        bgm[0]:play()
      end
      if save.players[savefile][cheatvalue].unlockpoints>=5000 and not cheat.maxspeed and not save.players[savefile][cheatvalue].pandaemonium then
        bgm[0]:stop()
        save.players[savefile][cheatvalue].pandaemonium=true
        gameState="PanUnlock"
        saveSave()
        return
      elseif save.players[savefile][cheatvalue].unlockpoints>=10000 and cheatvalue==2 and not save.players[savefile][cheatvalue].activation then
        bgm[0]:stop()
        save.players[savefile][cheatvalue].activation=true
        gameState="ActUnlock"
        saveSave()
        return
      end
      saveSave()
      pressinp.accept=false
    else
      if place~=4 then
        gameState="NameEntry"
        name=""
      else
        mode=nil
        gameState="Menu"
        bgm[0]:play()
      end
      pressinp.accept=false
    end
  end
end

function EndGame.drawBGA(offset, cmoffset, bxa, bxb, bya, byb)
  InGame.drawBGA(offset, cmoffset, bxa, bxb, bya, byb)
end

function EndGame.draw()
  drawGridOutline()
  drawPlayerStats()
  drawNextQueue()
  drawMedals()
  if mode<4 then
    drawGrade(288, 208)
  else
    love.graphics.setColor(1, 1, 1, 1)
    local s = "STAGE "..toRomanNumerals(activationstage).."\n"
    if rolltimer==0 and #deck==0 then
      s=s.."PASSED"
    else
      s=s.."FAILED"
    end
    love.graphics.printf(s, font_medium, 0, 200, 640, "center")
  end
  love.graphics.setColor(1, 1, 1, 1)
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

return EndGame