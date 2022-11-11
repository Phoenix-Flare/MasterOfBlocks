function gameInit()
  love.math.setRandomSeed(os.time())
  levelstopped=false
  activationtimer=0
  level=0
  score=0
  internalrank=0
  internalscore=0
  speedrank=0
  stime=0
  segmentThreshold=30
  skillrank=0
  semiJaftaw=0
  sectionJaftaw=0
  survivalrank=0
  totalrank=0
  medals={0,0,0,0,0}
  medalreqs={}
  lineData=nil
  for x=1,5 do
    medalreqs[x]=valuesMedalReqs[x][1]
  end
  sklCount=0
  spnCount=0
  rfxCount=0
  cmbCount=0
  chnCount=0
  speedup=0
  chain=0
  combo=0
  spins=0
  history={7,3,7,3}
  holdblock=nil
  fakeholdblock=nil
  currentBlock=nil
  queue={}
  fakequeue={}
  bagDraw()
  bagDraw()
  bagDraw()
  gridInit()
  clearedLines={}
  lDAS=getDAS()
  rDAS=getDAS()
  ARE=getARE()
  LCF=0
  updateGrid=true
  cardtimer=15
  if mode==4 then
    lastcard=nil
    cardqueue={}
    deck={}
    for x=1,activationstage+9 do
      deck[3*x-2]=x
      deck[3*x-1]=x
      deck[3*x]=x
    end
  end
  cardstandby={
    infinite = 0,
    block = false,
    thirteen = false,
    instant = 0,
    amulet = false,
    big = false
  }
end

function gridInit()
  if not grid then grid={} end
  for x=1,10 do
    if not grid[x] then grid[x]={} end
    for y=-2,20 do
      grid[x][y]=0
    end
  end
end

function bagReset()
  bag={}
  for x=1,7 do
    for y=1,4 do
      bag[(x-1)*4+y]=x
    end
  end
end

function bagDraw()
  if not bag or #bag==0 then bagReset() end
  local drawn=love.math.random(#bag+(#bag<15 and 1 or 0))
  if drawn>#bag then
    bagReset()
    return bagDraw()
  end
  local needsRedrawn=false
  local draws=0
  while draws<6 do
    for x=1,4 do
      if bag[drawn]==history[x] then
        needsRedrawn=true
      end
    end
    if not needsRedrawn then
      break
    end
    drawn=love.math.random(#bag)
    needsRedrawn=false
    draws=draws+1
  end
  fakequeue[1], fakequeue[2], fakequeue[3] = fakequeue[2], fakequeue[3], love.math.random(7)+(rotationrule-1)*14
  queue[1], queue[2], queue[3] = queue[2], queue[3], table.remove(bag,drawn)+(rotationrule-1)*14
  table.remove(history,1)
  history[4]=queue[3]-(rotationrule-1)*14
end

function spawnBlock()
  if not holdinp.game.hold then
    currentBlock={
      x=5,
      y=2,
      rotation=(holdinp.game.ccw and 3 or holdinp.game.cw and 1 or holdinp.game.dbl and 2 or 0),
      block=queue[1]+(cheat.bigblock and 7 or 0),
      fakeblock=fakequeue[1]+(cheat.bigblock and 7 or 0),
      gravity=0,
      resetFrames=getLockDelay()*15,
      lockDelay=getLockDelay(),
      maxLockDelay=getLockDelay(),
      activeFrames=0
    }
    held=false
  else
    if holdblock then
      currentBlock={
        x=5,
        y=2,
        rotation=(holdinp.game.ccw and 3 or holdinp.game.cw and 1 or holdinp.game.dbl and 2 or 0),
        block=holdblock+(cheat.bigblock and 7 or 0),
        fakeblock=fakeholdblock+(cheat.bigblock and 7 or 0),
        gravity=0,
        resetFrames=getLockDelay()*15,
        lockDelay=getLockDelay(),
        maxLockDelay=getLockDelay(),
        activeFrames=0
      }
      holdblock=queue[1]
	  fakeholdblock=fakequeue[1]
    else
      holdblock=queue[1]
      fakeholdblock=fakequeue[1]
      bagDraw()
      currentBlock={
        x=5,
        y=2,
        rotation=(holdinp.game.ccw and 3 or holdinp.game.cw and 1 or holdinp.game.dbl and 2 or 0),
        block=queue[1]+(cheat.bigblock and 7 or 0),
        fakeblock=fakequeue[1]+(cheat.bigblock and 7 or 0),
        gravity=0,
        resetFrames=getLockDelay()*15,
        lockDelay=getLockDelay(),
        maxLockDelay=getLockDelay(),
        activeFrames=0
      }
    end
    held=true
  end
  
  if mode==4 then
    if currentBlock.rotation==2 then currentBlock.rotation=0 end
    if cardstandby.infinite > 0 then
      cardstandby.infinite = cardstandby.infinite - 1
      currentBlock.resetFrames=math.huge
    end
    if cardstandby.instant > 0 then
      cardstandby.instant = cardstandby.instant - 1
      currentBlock.maxLockDelay = 0
      currentBlock.lockDelay = 0
    end
    if cardstandby.big then
      cardstandby.big = false
      currentBlock.block = currentBlock.block+7
    end
  end
  
  if save.conf.reverse[rotationrule] then currentBlock.rotation = (4 - currentBlock.rotation)%4 end
  if not checkPosition(0, 0) then
    currentBlock.rotation=0
    if not checkPosition(0, 0) then
      gameState="Curtain"
    end
  end
  for x=1,3 do
    pressinp.game[({"ccw","cw","dbl"})[x]]=false
  end
end

function processDAS()
  if pressinp.game.left then
    priority="LEFT"
  elseif pressinp.game.right then
    priority="RIGHT"
  end

  if holdinp.game.left then
    if lDAS~=0 then
      lDAS=lDAS-1
    end
  else
    lDAS=getDAS()
  end
  if holdinp.game.right then
    if rDAS~=0 then
      rDAS=rDAS-1
    end
  else
    rDAS=getDAS()
  end
end

function processCard()
  if #deck==0 or cardtimer>0 then return end
  cardtimer=15
  lastcard=table.remove(deck, love.math.random(#deck))
  cardframes=0
  gameState="DrawCard"
  return
end

function moveBlock()
  processDAS()

  if not currentBlock then return end
  if currentBlock.lockDelay==0 and not checkPosition(0,1) then return lock() end

  currentBlock.activeFrames=currentBlock.activeFrames+1

  currentBlock.gravity=currentBlock.gravity+getGravity()
  if pressinp.game.down then currentBlock.safelock=true end
  if holdinp.game.down then currentBlock.gravity=math.max(currentBlock.gravity, 128) end
  if checkPosition(0,1) then
    while checkPosition(0,1) and currentBlock.gravity>=128 do
      currentBlock.gravity=currentBlock.gravity-128
      currentBlock.y=currentBlock.y+1
      currentBlock.lockDelay=currentBlock.maxLockDelay
    end
  else
    if holdinp.game.down and currentBlock.safelock and save.conf.sonic[rotationrule] then
      return lock()
    end
    currentBlock.gravity=0
    currentBlock.lockDelay=currentBlock.lockDelay-1
  end

  if pressinp.game.up then
    while checkPosition(0,1) do
      currentBlock.y=currentBlock.y+1
    end
    if not save.conf.sonic[rotationrule] then
      return lock()
    end
  end

  if pressinp.game.hold and not held then
    return hold()
  end

  dasKicked=false

  if mode==4 and cardtimer<=-14 then
    return processCard()
  end

  if pressinp.game.ccw or pressinp.game.cw or pressinp.game.dbl then
    for x=1,3 do
      if pressinp.game[({"ccw","cw","dbl"})[x]] then
        if pressinp.game.dbl and mode==4 then
          return processCard()
        end
        if rotate(({3,1,2})[x]) then
          moveReset()
          break
        end
      end
    end
  end

  if not dasKicked then
    local bdx=(cheat.bigblock and 2 or 1)
    if (pressinp.game.left or lDAS==0 and holdinp.game.left) and checkPosition(-bdx,0) and priority=="LEFT" then
      currentBlock.x=currentBlock.x-bdx
      moveReset()
    elseif (pressinp.game.right or rDAS==0 and holdinp.game.right) and checkPosition(bdx,0) and priority=="RIGHT" then
      currentBlock.x=currentBlock.x+bdx
      moveReset()
    end
  end
end

function rotate(relative)
  if save.conf.reverse[rotationrule] then relative=4-relative end
  local oldRotation=currentBlock.rotation
  local blocked={
    left=not checkPosition(-1, 0),
    right=not checkPosition(1, 0),
  }
  currentBlock.rotation=(currentBlock.rotation+relative)%4
  local kicks=kicks[currentBlock.block][oldRotation][currentBlock.rotation]
  if rotationrule==3 and checkDASKick(blocked) then
    local bdx=(cheat.bigblock and 2 or 1)
    if holdinp.game.left then
      bdx=-bdx
    end
    if checkPosition(bdx,0) then
      currentBlock.x=currentBlock.x+bdx
      dasKicked=true
      return true
    else
      for x=1,#kicks do
        if checkPosition(kicks[x][1]+bdx, kicks[x][2]) then
          currentBlock.x=currentBlock.x+kicks[x][1]+bdx
          currentBlock.y=currentBlock.y+kicks[x][2]
          dasKicked=true
          return true
        end
      end
    end
  end
  if checkPosition(0,0) then
    return true
  else
    for x=1,#kicks do
      if checkPosition(kicks[x][1], kicks[x][2]) then
        currentBlock.x=currentBlock.x+kicks[x][1]
        currentBlock.y=currentBlock.y+kicks[x][2]
        return true
      end
    end
    if rotationrule==1 and checkPosition(0,-1) and not currentBlock.upKicked then
      currentBlock.y=currentBlock.y-1
      currentBlock.upKicked=true
      return true
    end
  end
  currentBlock.rotation=oldRotation
  return false
end

function checkDASKick(blocked)
  if holdinp.game.left then
    return (pressinp.game.left or (lDAS==0 and priority=="LEFT")) or blocked.left
  end
  if holdinp.game.right then
    return (pressinp.game.right or (rDAS==0 and priority=="RIGHT")) or blocked.right
  end
  return false
end

function moveReset()
  while currentBlock.lockDelay<currentBlock.maxLockDelay and currentBlock.resetFrames>0 do
    currentBlock.lockDelay=currentBlock.lockDelay+1
    currentBlock.resetFrames=currentBlock.resetFrames-1
  end
end

function hold()
  if currentBlock.resetFrames>1000 then
    cardstandby.infinite=cardstandby.infinite+1
  end
  if currentBlock.maxLockDelay==0 then
    cardstandby.instant=cardstandby.instant+1
  end
  if holdblock then
    local temp={currentBlock.block, currentBlock.fakeblock}
    currentBlock={
      x=5,
      y=2,
      rotation=(holdinp.game.ccw and 3 or holdinp.game.cw and 1 or holdinp.game.dbl and 2 or 0),
      block=holdblock+(cheat.bigblock and 7 or 0),
      fakeblock=fakeholdblock+(cheat.bigblock and 7 or 0),
      gravity=0,
      resetFrames=getLockDelay()*15,
      lockDelay=getLockDelay(),
      maxLockDelay=getLockDelay(),
      activeFrames=0
    }
    holdblock=temp[1]-(cheat.bigblock and 7 or 0)
    fakeholdblock=temp[2]-(cheat.bigblock and 7 or 0)
  else
    holdblock=currentBlock.block-(cheat.bigblock and 7 or 0)
    fakeholdblock=currentBlock.fakeblock-(cheat.bigblock and 7 or 0)
    currentBlock={
      x=5,
      y=2,
      rotation=(holdinp.game.ccw and 3 or holdinp.game.cw and 1 or holdinp.game.dbl and 2 or 0),
      block=queue[1]+(cheat.bigblock and 7 or 0),
      fakeblock=fakequeue[1]+(cheat.bigblock and 7 or 0),
      gravity=0,
      resetFrames=getLockDelay()*15,
      lockDelay=getLockDelay(),
      maxLockDelay=getLockDelay(),
      activeFrames=0
    }
    bagDraw()
  end
  if mode==4 then
    if currentBlock.rotation==2 then currentBlock.rotation=0 end
    if cardstandby.infinite > 0 then
      cardstandby.infinite = cardstandby.infinite - 1
      currentBlock.resetFrames=math.huge
    end
    if cardstandby.instant > 0 then
      cardstandby.instant = cardstandby.instant - 1
      currentBlock.maxLockDelay = 0
      currentBlock.lockDelay = 0
    end
    if (holdblock-1)%14+1>7 then
      holdblock=holdblock-7
      currentBlock.block=currentBlock.block+7
    end
  end
  held=true
  if not checkPosition(0, 0) then
    currentBlock.rotation=0
    if not checkPosition(0, 0) then
      gameState="Curtain"
    end
  end
end

function checkPosition(dx, dy)
  for idx, block in pairs(blocks[currentBlock.block][currentBlock.rotation]) do
    local b={x=currentBlock.x+block[1]+dx,y=currentBlock.y+block[2]+dy}
    if not grid[b.x] or not grid[b.x][b.y] or grid[b.x][b.y]>0 then
      return false
    end
  end
  return true
end

function lock()
  gamesfx.lock:play()
  spin=nil
  if not checkPosition(0, -1) and not checkPosition(-1, 0) and not checkPosition(1, 0) then
    spin=(currentBlock.block-1)%7+1
  end
  if currentBlock.maxLockDelay>0 and currentBlock.resetFrames<1000 then
    rfxCount=rfxCount+math.ceil(currentBlock.resetFrames/currentBlock.maxLockDelay)
  end
  for idx, block in pairs(blocks[currentBlock.block][currentBlock.rotation]) do
    local b={x=currentBlock.x+block[1],y=currentBlock.y+block[2]}
    grid[b.x][b.y]=blockindex[currentBlock.block]
  end
  currentBlock=nil
  local oldLevel=math.floor(level/100+1)*100-1
  checkLines()
  if spin then
    semiJaftaw=semiJaftaw+#clearedLines+(spin==5 and 1 or 0)
    spnCount=spnCount+#clearedLines+(spin==5 and 2 or 1)
    lineData={}
    lineData[1]="INERT\n"..(({"J","I","Z","L","O","T","S"})[spin].."-SPIN\n")
    lineData[2]=120
  end
  if #clearedLines>0 then
    local ld=cheat.bigblock and 2 or 1 
    gamesfx.lines[math.min(math.ceil(#clearedLines/ld),4)]:stop()
    gamesfx.lines[math.min(math.ceil(#clearedLines/ld),4)]:play()
    if gameState=="Roll" then
      rollLines=rollLines+({1, 2, 3, 5})[math.min(math.ceil(#clearedLines/ld), 4)]
    end
    if math.ceil(#clearedLines/ld)<4 and not spin then
      chain=0
    end
    lineData={}
    lineData[1]=(chain>0 and (chain.."-CHAIN\n") or "")..(spin and (({"J","I","Z","L","O","T","S"})[spin].."-SPIN\n") or "")..({"SINGLE","DOUBLE","TRIPLE","JAFDAW","DIJAW","SARSAW","SAFXAW","XAMANAW"})[math.ceil(#clearedLines/ld)]..(combo>0 and ("+"..combo) or "")
    lineData[2]=120

    if level<1000 then
      internalscore=internalscore+math.floor(valuesInternalPoints[math.min(math.ceil(#clearedLines/ld), 4)][math.min(11,internalrank+1)]*18000*(1+0.05*math.sqrt(combo))*(chain>0 and 1.1 or 1)*(spin and 1.25 or 1)*(1+level/300))
      if internalscore>=1800000 then
        internalrank=math.min(30,internalrank+1)
        internalscore=0
        totalrank=internalrank+survivalrank+speedrank+skillrank
      end
    end

    local oldcombo=combo
    combo=combo+math.ceil(#clearedLines/ld)
    for x=1,6 do
      local req=3+2*x
      if combo>=req and oldcombo<req then
        cmbCount=cmbCount+({1,2,6,18,54,162})[x]
      end
    end
    if math.ceil(#clearedLines/ld)>3 or spin then
      chain=chain+1
      for x=1,6 do
        if chain==({3,4,5,6,7,8})[x] then
          chnCount=chnCount+({1,1,2,4,8,16})[x]
        end
      end
      if math.ceil(#clearedLines/ld)==4 and level<1000 then
        if level%100<90 then 
          if not cheat.bigblock then
            sectionJaftaw=sectionJaftaw+1
            if sectionJaftaw<4 then skillrank=skillrank+1 end
          else
            for x=1,3 do
              sectionJaftaw=sectionJaftaw+1
              if sectionJaftaw<4 then skillrank=skillrank+1 end
            end
          end
        end
        sklCount=sklCount+1
      end
      while (semiJaftaw>2 or (cheat.bigblock and semiJaftaw>0)) and level<1000 do
        if level%100<90 then
          sectionJaftaw=sectionJaftaw+1
          if sectionJaftaw<4 then skillrank=skillrank+1 end
        end
        semiJaftaw=semiJaftaw-(cheat.bigblock and 1 or 3)
      end
    end
    if mode~=4 then
      level=level+({1,2,4,7})[math.ceil(#clearedLines/ld)]
    else
      activationtimer=math.max(0, activationtimer-({60, 180, 360, 600, 1200, 1800, 2400, 3600})[#clearedLines])
    end
    LCF=getLCF()
  else
    combo=0
  end
  ARE=getARE(#clearedLines>0)
  checkSegmentRank()
  checkMedals()
  if mode<4 then
    if mode==1 then
      for x=0,4 do
        if checkSpeedLevel()>=({[0]=0, 600, 1200, 1800, 2400})[x] then
          stage=x+1
        end
      end
    elseif mode==2 then
      for x=0,3 do
        if level>=({[0]=0, 285, 485, 885})[x] then
          stage=x+4
        end
      end
    elseif mode==3 then
      for x=0,2 do
        if level>=({[0]=0, 285, 585})[x] then
          stage=x+5
        end
      end
    end
    if level>950 then stage=8 end
    if level%100>84 and stage>1 then
      for x=1, stage-1 do
        bgm[x]:stop()
      end
    end
  end
  if level>oldLevel then
    if mode~=4 and checkBGMPlaying(stage) then
      bgm[stage]:play()
    end
    levelstopped=false
    gamesfx.sectionadvance:play()
    semiJaftaw=0
    sectionJaftaw=0
    survivalrank=math.floor(level/100)+speedup
    totalrank=internalrank+survivalrank+speedrank+skillrank
    while speedup~=math.floor(math.min(totalrank,100)/({[0]=5,5,5,10,101})[cheat.difficulty]) do
      speedup=math.floor(math.min(totalrank,100)/({[0]=5,5,5,10,101})[cheat.difficulty])
      survivalrank=math.floor(level/100)+speedup
      totalrank=internalrank+survivalrank+speedrank+skillrank
    end
  elseif level%100==99 and not levelstopped then
    levelstopped=true
    gamesfx.levelstop:play()
  end
  if level>=1000 then
    level=1000
    if gameState~="Roll" then
      gameState="Roll"
      rollLines=0
      rolltimer=3000
    end
  end
  if mode==4 and #deck~=0 then
    cardtimer=cardtimer-1
    if cardtimer==0 then
      gamesfx.levelstop:play()
    end
  end
  updateGrid=true
end

function checkLines()
  for y=-2,20 do
    local count=0
    for x=1,10 do
      if grid[x][y]>0 then
        count=count+1
      end
    end
    if count==10 then
      clearedLines[#clearedLines+1]=y
    end
  end
end

function clearLines()
  for y=-2,20 do
    if clearedLines[1]==y then
      for y=y,-1,-1 do
        for x=1,10 do
          grid[x][y]=grid[x][y-1]
        end
      end
      for x=1,10 do
        grid[x][-2]=0
      end
      table.remove(clearedLines, 1)
      updateGrid=true
    end
  end
end

function checkBGMPlaying(stage)
  for x=0, stage do
    if bgm[x]:isPlaying() then
      return false
    end
  end
  return true
end

function checkMedals()
  while sklCount>=medalreqs[1] do
    medals[1]=medals[1]+1
    medalreqs[1]=valuesMedalReqs[1][medals[1]+1]
  end
  while spnCount>=medalreqs[2] do
    medals[2]=medals[2]+1
    medalreqs[2]=valuesMedalReqs[2][medals[2]+1]
  end
  while rfxCount>=medalreqs[3] do
    medals[3]=medals[3]+1
    medalreqs[3]=valuesMedalReqs[3][medals[3]+1]
  end
  while cmbCount>=medalreqs[4] do
    medals[4]=medals[4]+1
    medalreqs[4]=valuesMedalReqs[4][medals[4]+1]
  end
  while chnCount>=medalreqs[5] do
    medals[5]=medals[5]+1
    medalreqs[5]=valuesMedalReqs[5][medals[5]+1]
  end
end

function checkSpeedLevel()
  local baserank=speedrank+skillrank+internalrank
  local level=level+15
  local survivalrank=survivalrank
  survivalrank=math.floor(level/100)+speedup
  local rank=baserank+survivalrank
  while survivalrank~=math.floor(math.min(rank,100)/({[0]=5,5,5,10,101})[cheat.difficulty])+math.floor(level/100) do
    survivalrank=math.floor(math.min(rank,100)/({[0]=5,5,5,10,101})[cheat.difficulty])+math.floor(level/100)
    rank=baserank+survivalrank
  end
  return survivalrank*100
end

function checkSegmentRank()
  if level>=segmentThreshold then
    segmentThreshold=segmentThreshold+30
    if segmentThreshold%100==20 then
      segmentThreshold=segmentThreshold+10
    end
    local checkSection=math.floor((level-10)/100)
    if stime<=(1320-60*checkSection) then
      speedrank=speedrank+1
    end
    stime=0
  end
  totalrank=internalrank+survivalrank+speedrank+skillrank
end