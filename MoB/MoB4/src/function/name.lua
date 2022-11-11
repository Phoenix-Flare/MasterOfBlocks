function updateNameInput()
  nameIndex=nameIndex or {1, 1}
  nameEntryCompleted=false
  if pressinp.menuleft then
    menusfx[1]:stop()
    menusfx[1]:play()
    nameIndex[1]=(nameIndex[1]-2)%13+1
  end
  if pressinp.menuright then
    menusfx[1]:stop()
    menusfx[1]:play()
    nameIndex[1]=nameIndex[1]%13+1
  end
  if pressinp.menuup then
    menusfx[1]:stop()
    menusfx[1]:play()
    nameIndex[2]=(nameIndex[2]-2)%5+1
  end
  if pressinp.menudown then
    menusfx[1]:stop()
    menusfx[1]:play()
    nameIndex[2]=nameIndex[2]%5+1
  end
  if pressinp.accept then
    menusfx[2]:stop()
    menusfx[2]:play()
    if nameIndex[1]<11 or nameIndex[2]<5 then
      name=name..letters[nameIndex[2]][nameIndex[1]]
    else
      if nameIndex[1]==11 then
        name=name.." "
      end
      if nameIndex[1]==12 then
        name=string.sub(name, 0, -2)
      end
      if nameIndex[1]==13 then
        nameEntryCompleted=true
        nameIndex=nil
      end
    end
  end
  if pressinp.back then
    if name~="" then
      menusfx[3]:stop()
      menusfx[3]:play()
      name=string.sub(name, 0, -2)
    else
      nameEntryCompleted=true
      nameIndex=nil
    end
  end
end

function drawNameEntry()
  nameIndex=nameIndex or {1, 1}
  love.graphics.setColor(0.6, 0.6, 0.6, 1)
  love.graphics.rectangle("fill", 110, 305, 420, 150)
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.rectangle("fill", 115, 310, 410, 140)
  for y=1,5 do
    for x=1,13 do
      love.graphics.setColor(1, 1, 1, 1)
      if nameIndex[1]==x and nameIndex[2]==y then
        love.graphics.setColor(1, 1, 0.4, 1)
      end
      local align="center"
      if y==5 and x==13 then
        align="left"
      end
      love.graphics.printf(letters[y][x], font_medium, 95+30*x, 300+24*y, 30, "center")
    end
  end
end
