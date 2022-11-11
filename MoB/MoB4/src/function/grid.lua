function checkUpdateGrid()
  if not gridCanvas then
    gridCanvas=
    {
      love.graphics.newCanvas(),
      love.graphics.newCanvas(),
      love.graphics.newCanvas(),
    }
    for x=1,3 do
      gridCanvas[x]:setFilter("nearest", "nearest")
    end
  end
  if not updateGrid then return end
  updateGrid=nil
  if scale>=1 then
    love.graphics.reset()
  end
  for lyr=1,3 do
    gridCanvas[lyr]:renderTo(function()
        love.graphics.clear(0,0,0,0)
        for x=1,10 do
          for y=1,20 do
            if grid[x][y]~=0 then
              if lyr==1 then
                love.graphics.setColor(0.4, 0.4, 0.4, 1)
                love.graphics.rectangle("fill", 222+16*x, 82+16*y, 20, 20)
              elseif lyr==2 then
                love.graphics.setColor(0, 0, 0, 1)
                love.graphics.rectangle("fill", 224+16*x, 84+16*y, 16, 16)
              elseif lyr==3 then
                local c=blockcolors[grid[x][y]];
                love.graphics.setColor(c[1]*0.75, c[2]*0.75, c[3]*0.75, 1)
                love.graphics.draw(blockgfx, 224+16*x, 84+16*y)
              end
            end
          end
        end
      end)
  end
  love.graphics.setCanvas()
  if scale>=1 then
    love.graphics.translate((wdth-scale*640)/2,(hght-scale*480)/2)
    love.graphics.scale(scale)
  end
end

function drawGrid()
  for lyr=1,3 do
    if scale<1 then
      love.graphics.reset()
    end
    love.graphics.setColor(1, 1, 1, 1)
    if lyr~=3 or (gameState~="Paused" and (mode~=2 or level<500 or cheat.difficulty>2)) and cheat.difficulty~=1 then
      love.graphics.draw(gridCanvas[lyr])
    end
    if scale<1 then
      love.graphics.translate((wdth-scale*640)/2,(hght-scale*480)/2)
      love.graphics.scale(scale)
    end
    if currentBlock then
      if lyr~=3 or (gameState~="Paused" and (mode~=2 or level<500 or cheat.difficulty>2)) and cheat.difficulty~=1 then
        drawBlock(224+16*currentBlock.x, 84+16*currentBlock.y, currentBlock.block, currentBlock.rotation, lyr, true, currentBlock.fakeblock, mode==3 and level>=900 or cheat.difficulty==0)
      end
    end
  end
  if currentBlock and gameState~="Paused" and (level<100 or cheat.difficulty>2) and mode<2 and cheat.difficulty>1 then
    local ghostYOffset=0
    while checkPosition(0, ghostYOffset+1) do
      ghostYOffset=ghostYOffset+1
    end
    drawBlock(224+16*currentBlock.x, 84+16*(currentBlock.y+ghostYOffset), currentBlock.block, currentBlock.rotation, 0, true)
  end
  --line clear animation
  if LCF%2==0 then
    love.graphics.setColor(0.75, 0.75, 0.75, 1)
    for idx, y in pairs(clearedLines) do
      love.graphics.rectangle("fill", 240, 84+16*y, 160, 16)
    end
  end
end

function drawBlock(x, y, block, rotation, layer, isCurrentBlock, fakeBlock, isFakeBlock)
  if isFakeBlock and cheat.difficulty<3 then return drawFalseBlock(x, y, block, rotation, layer, isCurrentBlock, fakeBlock) end
  for lyr=1,3 do
    if layer then lyr=layer end
    for idx, b in pairs(blocks[block][rotation]) do
      if lyr==0 then
        --ghost piece
        local blockColor={}
        for c=1,3 do
          blockColor[c]=blockcolors[blockindex[block]][c]
        end
        blockColor[4]=0.5
        love.graphics.setColor(blockColor)
        love.graphics.draw(blockgfx, x+b[1]*16, y+b[2]*16)
      elseif lyr==1 then
        love.graphics.setColor(0.4, 0.4, 0.4, 1)
        if isCurrentBlock then
          local red=1-0.04*(currentBlock.resetFrames/currentBlock.maxLockDelay)
          local nonred=0.4*(currentBlock.resetFrames/currentBlock.maxLockDelay)/15
          love.graphics.setColor(red, nonred, nonred, 1)
          if currentBlock.maxLockDelay==0 then
            love.graphics.setColor(1, 0, 0, 1)
          end
        end
        love.graphics.rectangle("fill", x+b[1]*16-2, y+b[2]*16-2, 20, 20)
      elseif lyr==2 then
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle("fill", x+b[1]*16, y+b[2]*16, 16, 16)
      elseif lyr==3 and (mode~=2 or level<500 or cheat.difficulty>2) and cheat.difficulty~=1 then
        --block sprite draw code
        local blockColor={}
        for c=1,3 do
          blockColor[c]=blockcolors[blockindex[block]][c]
        end
        if isCurrentBlock then
          for c=1,3 do
            blockColor[c]=blockColor[c]*(0.2+0.8*(currentBlock.lockDelay/currentBlock.maxLockDelay))
          end
          if currentBlock.maxLockDelay==0 then
            blockColor=blockcolors[blockindex[block]]
          end
        end
        love.graphics.setColor(blockColor)
        love.graphics.draw(blockgfx, x+b[1]*16, y+b[2]*16)
      end
    end
    if layer then break end
  end
end

function drawFalseBlock(x, y, block, rotation, layer, isCurrentBlock, fakeblock)
  for lyr=1,3 do
    if layer then lyr=layer end
    for idx, b in pairs(blocks[fakeblock][rotation]) do
      if lyr==1 then
        love.graphics.setColor(0.4, 0.4, 0.4, 1)
        if isCurrentBlock then
          local red=1-0.04*(currentBlock.resetFrames/currentBlock.maxLockDelay)
          local nonred=0.4*(currentBlock.resetFrames/currentBlock.maxLockDelay)/15
          love.graphics.setColor(red, nonred, nonred, 1)
        end
        love.graphics.rectangle("fill", x+b[1]*16-2, y+b[2]*16-2, 20, 20)
      elseif lyr==2 then
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle("fill", x+b[1]*16, y+b[2]*16, 16, 16)
      elseif lyr==3 and (mode~=2 or level<500 or cheat.difficulty>2) and cheat.difficulty~=1 then
        --block sprite draw code
        local blockColor={}
        for c=1,3 do
          blockColor[c]=blockcolors[blockindex[block]][c]
        end
        if isCurrentBlock then
          for c=1,3 do
            blockColor[c]=blockColor[c]*(0.2+0.8*(currentBlock.lockDelay/currentBlock.maxLockDelay))
          end
        end
        love.graphics.setColor(blockColor)
        love.graphics.draw(blockgfx, x+b[1]*16, y+b[2]*16)
      end
    end
    if layer then break end
  end
end

function drawNextQueue()
  for x=1,3 do
    drawBlock(224+80*x, 56, queue[x], 0, nil, false, fakequeue[x], (mode==3 and level>=(800-100*x)) or cheat.difficulty==0)
  end
  if holdblock then
    drawBlock(208, 56, holdblock, 0, nil, false, fakeholdblock, (mode==3 and level>=800) or cheat.difficulty==0)
  end
end