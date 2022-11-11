function getGravity()
  local g=2
  if mode==4 then
    for x=1,#valuesGravity[mode] do
      if math.floor(activationtimer/36)>=valuesGravity[mode][x][1] then
        g=valuesGravity[mode][x][2]
      else
        break
      end
    end
    return g
  end
  if cheat.maxspeed then return 2560 end
  local speedup=mode==1 and speedup or 0
  for x=1,#valuesGravity[mode] do
    if level+100*speedup>=valuesGravity[mode][x][1] then
      g=valuesGravity[mode][x][2]
    else
      break
    end
  end
  return g
end

function getLockDelay()
  local ld=30
  if cheat.maxspeed and mode==1 then local level=math.max(level, 500) end
  if mode>1 and cheat.difficulty>3 then local level=math.min(level, 500) end
  local speedup=mode==1 and speedup or 0
  for x=1,#valuesLockDelay[mode] do
    if level+100*speedup>=valuesLockDelay[mode][x][1] then
      ld=valuesLockDelay[mode][x][2]
    else
      break
    end
  end
  return ld
end

function getARE(line)
  local are={27, 67}
  if cheat.maxspeed and mode==1 then local level=math.max(level, 500) end
  if mode>1 and cheat.difficulty>3 then local level=math.min(level, 500) end
  local speedup=mode==1 and speedup or 0
  for x=1,#valuesARE[mode] do
    if level+100*speedup>=valuesARE[mode][x][1] then
      are=valuesARE[mode][x][2]
    else
      break
    end
  end
  return are[line and 2 or 1]
end

function getLCF()
  local lcf=40
  if cheat.maxspeed and mode==1 then local level=math.max(level, 500) end
  if mode>1 and cheat.difficulty>3 then local level=math.min(level, 500) end
  local speedup=mode==1 and speedup or 0
  for x=1,#valuesLCF[mode] do
    if level+100*speedup>=valuesLCF[mode][x][1] then
      lcf=valuesLCF[mode][x][2]
    else
      break
    end
  end
  return lcf
end

function getDAS()
  local das=14
  if cheat.maxspeed and mode==1 then local level=math.max(level, 500) end
  if mode>1 and cheat.difficulty>3 then local level=math.min(level, 500) end
  local speedup=mode==1 and speedup or 0
  for x=1,#valuesDAS[mode] do
    if level+100*speedup>=valuesDAS[mode][x][1] then
      das=valuesDAS[mode][x][2]
    else
      break
    end
  end
  return das
end

function getDecayRate()
  return valuesDecayRate[internalrank+1]
end