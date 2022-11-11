Activate={}

function Activate.update()
  processDAS()
  
  -- Block cards with card 7
  if cardstandby.block and (lastcard>20 or lastcard%2==0) then
    cardstandby.block=false
    gameState="InGame"
    if #cardqueue>0 then
      lastcard=table.remove(cardqueue, 1)
      cardframes=0
      gameState="DrawCard"
    end
    return
  end

  -- Certain cards destroy the block to prevent overlaps
  -- In card 12's case, it's just to make it less confusing visually
  for idx, card in pairs(({2, 5, 6, 9, 12, 15, 16, 20, 21, 22, 23})) do
    if lastcard==card then
      currentBlock=nil
      ARE=27
    end
  end

  -- Initialize blocks cleared by the card
  if not cardcleared then
    cardcleared={}
  end
  
  -- Initialize a ball for card 12
  if lastcard==12 and not ball then
    ball={x=love.math.random(10), y=1, dx=0, b=love.math.random(7)}
  end

  -- Certain cards have no animation to them beyond being drawn
  for idx, card in pairs(({1, 3, 7, 8, 13, 14, 17, 18, 24})) do
    if lastcard==card then
      print(idx)
      local effects={
        [1]=function() activationtimer=math.floor(activationtimer/2) end, --Gravity Down
        [3]=function() cardstandby.infinite=2 end, --Infinite Resets 2 Pieces
        [7]=function() cardstandby.block=true end, --Card Block
        [8]=function() activationtimer=math.min(activationtimer+3600, 21600) end, --Gravity Up
        [13]=function() cardstandby.thirteen=true end, --Card 13
        [14]=function() cardstandby.instant=2 end, --Instant Lock 2 Pieces
        [17]=function() cardstandby.amulet=true end, --Amulet
        [18]=function() cardstandby.big=true end, --Death Block
        [24]=function()
          cardqueue[1]=love.math.random(20)
          cardqueue[2]=love.math.random(10)*2-(cardqueue[1]%2+1)
        end, --Double Wild
      }
      effects[card]()
      gameState="InGame"
      if #cardqueue>0 then
        lastcard=table.remove(cardqueue, 1)
        cardframes=0
        gameState="DrawCard"
        updateGrid=true
      end
      return
    end
  end

  cardframes=cardframes+1
  
  if lastcard==2 and cardframes==135 then
    menusfx[1]:stop()
    menusfx[1]:play()
    for x=1,10 do
      for y=-2,19 do
        grid[x][y]=grid[x][y+1]
      end
    end
    updateGrid=true
  end
  if lastcard==4 and cardframes<=135 then
    queue[1]=(queue[1]+14*love.math.random(3)-1)%42+1
  end
  if lastcard==5 and cardframes==150 then
    clearedLines={19, 20}
    clearLines()
  end
  if lastcard==6 and cardframes%5==0 and cardframes<136 then
    menusfx[1]:stop()
    menusfx[1]:play()
    for x=1,10 do
      for y=-2,19 do
        grid[x][y]=grid[x][y+1]
      end
      grid[x][20]=0
    end
    local blocks = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
    for x=1,3 do
      if x<3 or love.math.random(2)==1 then
        table.remove(blocks, love.math.random(#blocks))
      end
    end
    for idx, block in pairs(blocks) do
      grid[block][20]=love.math.random(7)
    end
    updateGrid=true
  end
  if lastcard==9 then
    local dropped=false
    for x=1,10 do
      for y=20,-1,-1 do
        if grid[x][y]==0 and grid[x][y-1]~=0 then
          grid[x][y], grid[x][y-1] = grid[x][y-1], grid[x][y]
          dropped=true
          updateGrid=true
        end
      end
    end
    if not dropped then
      local count=0
      for x=1,10 do
        if grid[x][20]>0 then
          count=count+1
        end
      end
      if count==10 then
        clearedLines={20}
      end
      clearLines()
    end
  end
  if lastcard==10 then
    if cardframes==130 then
      for y=-2,20 do
        cardcleared[#cardcleared+1]={love.math.random(10), y}
      end
    end
    if cardframes==140 then
      menusfx[1]:stop()
      menusfx[1]:play()
      for idx, b in pairs(cardcleared) do
        grid[b[1]][b[2]]=0
      end
      updateGrid=true
    end
  end
  if lastcard==11 and cardframes%10==0 and cardframes<141 then
    menusfx[1]:stop()
    menusfx[1]:play()
    for x=1,10 do
      for y=-2,20 do
        if grid[x][y]>0 then
          grid[x][y]=0
          break
        end
      end
    end
    updateGrid=true
  end
  if lastcard==12 then
    if cardframes==135 then
      while true do
        local steps=20
        cardcleared[#cardcleared+1]={ball.x, ball.y}
        if ball.y==20 then
          break
        end
        if grid[ball.x][ball.y+1]~=ball.b then
          ball.dx=0
          ball.y=ball.y+1
          steps=20
        else
          if ball.x==1 or grid[ball.x-1][ball.y]==ball.b then
            ball.dx=1
		      end
          if ball.x==10 or grid[ball.x+1][ball.y]==ball.b then
            ball.dx=-1
          else
            if ball.dx==0 then
              --If this particular line of code looks stupid, that's because it kind of is.
              ball.dx=love.math.random(2)*2-3
            end
          end
          ball.x=ball.x+ball.dx
          steps=steps-1
          if steps<1 then
            break
          end
        end
      end
    end
    if cardframes==145 then
      menusfx[1]:stop()
      menusfx[1]:play()
      for idx, b in pairs(cardcleared) do
        grid[b[1]][b[2]]=0
      end
      updateGrid=true
    end
  end
  if lastcard==15 then
    if cardframes==121 then
      for y=-1, 19, 2 do
        local count=0
        for x=1,10 do
          if grid[x][y]>0 then
            count=count+1
          end
        end
        if count>0 then
          for x=1, 10 do
            cardcleared[#cardcleared+1]={x,y}
          end
        end
      end
    end
    if cardframes==150 then
      menusfx[1]:stop()
      menusfx[1]:play()
      for idx, b in pairs(cardcleared) do
        grid[b[1]][b[2]]=0
      end
      for x=-1, 19, 2 do
        clearedLines[#clearedLines+1]=x
        clearLines()
      end
    end
  end
  if lastcard==16 and cardframes%6==0 and cardframes~=150 then
    extrapos=extrapos and extrapos+1 or math.random(20)
    local p = extraPattern[extrapos]
    menusfx[1]:stop()
    menusfx[1]:play()
    for x=10,1,-1 do
      for y=-2,19 do
        grid[x][y]=grid[x][y+1]
      end
      if p%10==1 then
        grid[x][20]=math.random(7)
      else
        grid[x][20]=0
      end
      p=math.floor(p/10)
    end
    updateGrid=true
  end
  if lastcard==19 and cardframes==150 then
    gridInit()
    updateGrid=true
  end
  if lastcard==20 and cardframes<139 then
    local count=0
    for x=1,10 do
      if grid[x][cardframes-118]>0 then
        count=count+1
      end
    end
    if count>0 then
      for x=1,10 do
        if grid[x][cardframes-118]==0 then
          grid[x][cardframes-118]=math.random(7)
        end
      end
      if cardframes<130 then
        grid[cardframes-119][cardframes-118]=0
      else
        grid[139-cardframes][cardframes-118]=0
      end
      updateGrid=true
    end
  end
  if lastcard==21 then
    if cardframes==130 then
      local newgrid={}
      for x=1,10 do
        newgrid[x]={}
        for y=1,20 do
          newgrid[x][21-y]=grid[x][y]
        end
      end
      gridInit()
      for x=1,10 do
        for y=1,20 do
          grid[x][y]=newgrid[x][y]
        end
      end
    end
    if cardframes>130 then
      local count=0
      for x=1,10 do
        if grid[x][20]>0 then
          count=count+1
        end
      end
      if count==0 then
        for x=1, 10 do
          for y=20,-1,-1 do
            grid[x][y], grid[x][y-1] = grid[x][y-1], grid[x][y]
          end
        end
        updateGrid=true
      end
    end
  end
  if lastcard==22 and cardframes%3==0 and cardframes<136 then
    menusfx[1]:stop()
    menusfx[1]:play()
    for x=1,10 do
      for y=-2,19 do
        grid[x][y]=grid[x][y+1]
      end
      grid[x][20]=0
    end
    updateGrid=true
  end
  if lastcard==23 and cardframes<=143 then
    local count=0
    for x=1,10 do
      if grid[x][cardframes-123]>0 then
        count=count+1
      end
    end
    if count>0 then
      for x=1,10 do
        if grid[x][cardframes-123]==0 then
          grid[x][cardframes-123]=math.random(7)
        else
          grid[x][cardframes-123]=0
        end
      end
      updateGrid=true
    end
  end
  
  if cardframes==150 then
    extrapos=nil
    ball=nil
    cardcleared=nil
    if #cardqueue>0 then
      lastcard=table.remove(cardqueue, 1)
      cardframes=0
      gameState="DrawCard"
    else
      gameState="InGame"
    end
    return
  end
end

function Activate.drawBGA(offset, cmoffset, bxa, bxb, bya, byb)
  InGame.drawBGA(offset, cmoffset, bxa, bxb, bya, byb)
end

function Activate.draw()
  InGame.draw()
  if lastcard==5 then
    love.graphics.setColor(0, (cardframes-120)/20, 1, (cardframes-120)/20)
    love.graphics.rectangle("fill", 240, 388, 160, 32)
  end
  if lastcard==10 and cardframes<135 then
    love.graphics.setColor(1, 0, 0, 1)
    if cardcleared and cardframes%2==0 and cardframes<140 then
      for idx, b in pairs(cardcleared) do
        if b[2]>0 then
          love.graphics.rectangle("fill", 224+b[1]*16, 84+b[2]*16, 16, 16)
        end
      end
    end
  end
  if lastcard==12 then
    if ball then
      for y=1,20 do
        for x=1,10 do
          if grid[x][y]==ball.b then
            love.graphics.setColor(0.2, 0.2, 0.2, 1)
            love.graphics.rectangle("fill", 224+x*16, 84+y*16, 16, 16)
          end
        end
      end
    end
    if cardframes<145 and cardframes%2==0 and cardcleared then
      for idx, b in pairs(cardcleared) do
        love.graphics.setColor(1, 0, 0, (cardframes-135)/10)
        love.graphics.rectangle("fill", 224+b[1]*16, 84+b[2]*16, 16, 16)
      end
    end
  end
  if lastcard==15 then
    love.graphics.setColor(0, (cardframes-120)/20, 1, (cardframes-120)/20)
    if cardcleared then
      for idx, b in pairs(cardcleared) do
        if b[2]>0 then
          love.graphics.rectangle("fill", 224+b[1]*16, 84+b[2]*16, 16, 16)
        end
      end
    end
  end
  if lastcard==19 then
    love.graphics.setColor(0, (cardframes-120)/20, 1, (cardframes-120)/20)
    love.graphics.rectangle("fill", 240, 100, 160, 320)
  end
end

return Activate