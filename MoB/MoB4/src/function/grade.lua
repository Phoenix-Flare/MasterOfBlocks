function drawGrade(x, y)
  if mode==1 then
    drawHGrade(capGrade(totalrank), x, y)
  elseif mode==2 then
    drawLGrade(math.floor(level/100), x, y)
  elseif mode==3 then
    drawPGrade(math.floor(level/100), x, y)
  end
end

function drawHGrade(grade, x, y)
  love.graphics.setColor(1,1,1,1)
  if not grade then grade=0 end
  grade=math.floor(grade)
  if grade<9 then
    local grades={"nine","eight","seven","six","five","four","three","two","one"}
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gradegfx[grades[grade+1]], x, y)
  elseif grade<99 then
    local letters={"F","D","C","B","A","S","X","V","omega","ankh"}
    local numbers={"one","two","three","four","five","six","seven","eight","nine"}
    local colors={{1,0.2,0.2},{1,0.5,0.2},{0.5,1,0.2},{0.2,1,0.2},{0.2,1,0.5},{0.2,0.5,1},{0.5,0.2,1},{1,0.2,0.5},{1,0.2,1},{1,1,1}}
    love.graphics.setColor(colors[math.floor(grade/9)][1], colors[math.floor(grade/9)][2], colors[math.floor(grade/9)][3], 1)
    love.graphics.draw(gradegfx[letters[math.floor(grade/9)]], x, y)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gradegfx["small"..numbers[grade%9+1]], x+40, y+40)
  elseif grade==99 then
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gradegfx["M"], x, y)
  elseif grade<110 then
    love.graphics.setColor(1, 1, 1, 1)
    if grade>104 then
      love.graphics.setColor(convertHSV({love.timer.getTime()*100,1,1}))
    end
    love.graphics.draw(gradegfx["G"], x, y)
    if grade>104 then
      love.graphics.setColor(convertHSV({love.timer.getTime()*100+180,1,1}))
    end
    love.graphics.draw(gradegfx["smallm"], x+40, y+40)
  elseif grade<120 then
    love.graphics.setColor(1, 1, 1, 1)
    if grade>114 then
      love.graphics.setColor(convertHSV({love.timer.getTime()*100,1,1}))
    end
    love.graphics.draw(gradegfx["omega"], x, y)
    if grade>114 then
      love.graphics.setColor(convertHSV({love.timer.getTime()*100+180,1,1}))
    end
    love.graphics.draw(gradegfx["smallm"], x+40, y+40)
  else
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gradegfx["ankh"], x, y)
    love.graphics.draw(gradegfx["smallm"], x+40, y+40)
  end
end

function drawLGrade(grade, x, y)
  if not grade then grade=0 end
  if grade==0 then
    return
  end
  if grade<10 then
    local numbers={"one","two","three","four","five","six","seven","eight","nine"}
    love.graphics.setColor(1, 1-grade*0.1, 1-grade*0.1, 1)
    love.graphics.draw(gradegfx["leviathan"], x, y)
    love.graphics.draw(gradegfx["small"..numbers[grade]], x+40, y+40)
  else
    love.graphics.setColor(0.8, 0, 0, 1)
    love.graphics.draw(gradegfx["leviathan"], x, y)
    love.graphics.draw(gradegfx["smallm"], x+40, y+40)
  end
end

function drawPGrade(grade, x, y)
  if not grade then grade=0 end
  if grade==0 then
    return
  end
  if grade<10 then
    local numbers={"one","two","three","four","five","six","seven","eight","nine"}
    love.graphics.setColor(1, 0, grade*0.1, 1)
    love.graphics.draw(gradegfx["leviathan"], x, y)
    love.graphics.draw(gradegfx["smallm"], x+8, y+40)
    love.graphics.draw(gradegfx["small"..numbers[grade]], x+40, y+40)
  else
    love.graphics.setColor(0.8, 0, 1, 1)
    love.graphics.draw(gradegfx["leviathan"], x, y)
    love.graphics.draw(gradegfx["smallm"], x+8, y+40)
    love.graphics.draw(gradegfx["smallm"], x+40, y+40)
  end
end

function drawActivationLevel(stage, x, y)
  if not stage then stage=0 end
  if stage==0 then return end
  local numbers={[0]="zero","one","two","three","four","five","six","seven","eight","nine"}
  love.graphics.setColor(0, 1, 0)
  love.graphics.draw(gradegfx["S"], x, y)
  if stage<10 then
    love.graphics.draw(gradegfx["small"..numbers[stage]], x+64, y+32)
  else
    love.graphics.draw(gradegfx["small"..numbers[math.floor(stage/10)]], x+64, y+32)
    love.graphics.draw(gradegfx["small"..numbers[stage%10]], x+96, y+32)
  end
end

function drawQualifyGrade(grade, x, y)
  if not grade then grade=0 end
  if grade<33 then
    local colors={{0.5,0.5,0.5},{1,0.2,0.2},{1,0.5,0.2},{0.5,1,0.2},{0.2,1,0.2},{0.2,1,0.5},{0.2,0.5,1},{0.5,0.2,1},{1,0.2,0.5},{1,0.2,1},{1,1,1}}
    local letters={"numbersign","F","D","C","B","A","S","X","V","omega","ankh"}
    local grade={math.floor(grade/3)+1, grade%3+1}
    love.graphics.setColor(colors[grade[1]][1], colors[grade[1]][2], colors[grade[1]][3], 1)
    love.graphics.draw(gradegfx[letters[grade[1]]], x, y)
    if grade[2]~=2 then
      love.graphics.draw(gradegfx[({"smallminus",nil,"smallplus"})[grade[2]]], x+40, y+40)
    end
  elseif grade==33 then
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gradegfx["M"], x, y)
  elseif grade<36 then
    love.graphics.setColor(1, 1, 1, 1)
    if grade==35 then
      love.graphics.setColor(convertHSV({love.timer.getTime()*100,1,1}))
    end
    love.graphics.draw(gradegfx["G"], x, y)
    if grade==35 then
      love.graphics.setColor(convertHSV({love.timer.getTime()*100+180,1,1}))
    end
    love.graphics.draw(gradegfx["smallm"], x+40, y+40)
  elseif grade<38 then
    love.graphics.setColor(1, 1, 1, 1)
    if grade==37 then
      love.graphics.setColor(convertHSV({love.timer.getTime()*100,1,1}))
    end
    love.graphics.draw(gradegfx["omega"], x, y)
    if grade==37 then
      love.graphics.setColor(convertHSV({love.timer.getTime()*100+180,1,1}))
    end
    love.graphics.draw(gradegfx["smallm"], x+40, y+40)
  else
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gradegfx["ankh"], x, y)
    love.graphics.draw(gradegfx["smallm"], x+40, y+40)
  end
end

function getClass(grade)
  if not grade then grade=0 end
  if grade<99 then
    return math.floor(grade/3)
  elseif grade==99 then
    return 33
  else
    return 34+math.floor((grade-100)/5)
  end
end

function getRankText(grade)
  if not grade then grade=0 end
  if grade<9 then
    return 9-grade
  elseif grade<99 then
    return ({"F","D","C","B","A","S","X","V","@","$"})[math.floor(grade/9)]..(grade%9+1)
  elseif grade==99 then
    return "M"
  elseif grade<105 then
    return "GM"
  elseif grade<110 then
    return "GM+"
  elseif grade<115 then
    return "@M"
  elseif grade<120 then
    return "@M+"
  else
    return "$M"
  end
end

function getClassText(grade)
  if not grade then grade=0 end
  if grade<33 then
    return ({"#","F","D","C","B","A","S","X","V","@","$"})[math.floor(grade/3)+1]..({"-","","+"})[grade%3+1]
  else
    return ({"M","GM","GM+","@M","@M+","$M"})[grade-32]
  end
end

function capGrade(g)
  for x=1,5 do
    if not savefile then
        return math.min(99, g)
    end
    if gameState==({"InGame", "Roll", "EndGame", "Curtain", "Paused"})[x] then
      if savefile then
        if save.players[savefile][cheatvalue][rotationrule].qualify>33 then
          if save.players[savefile][cheatvalue][rotationrule].qualify>35 then
            g=math.min(120, g)
          else
            g=math.min(115, g)
          end
        else
          g=math.min(105, g)
        end
      end
      if level>999 then
        if rolltimer>0 then
          g=math.min(119, g)
        end
        return math.min(100+rollLines, g)
      else
        return math.min(99, g)
      end
    end
  end
  return g
end