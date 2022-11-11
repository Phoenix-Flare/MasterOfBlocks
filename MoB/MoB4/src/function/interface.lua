function drawGridOutline()
  love.graphics.setColor(0.7, 0.7, 0.7, 1)
  love.graphics.printf("HOLD", font_medium, 184, 10, 80, "center")
  love.graphics.printf("NEXT", font_medium, 280, 10, 80, "center")
  love.graphics.setColor(0.4, 0.4, 0.4, 1)
  love.graphics.rectangle("fill", 182, 30, 84, 52)
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.rectangle("fill", 186, 34, 76, 44)
  for x=1,3 do
    love.graphics.setColor(0.4, 0.4, 0.4, 1)
    love.graphics.rectangle("fill", 198+80*x, 30, 84, 52)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", 202+80*x, 34, 76, 44)
  end

  love.graphics.setColor(0.4, 0.4, 0.4, 1)
  love.graphics.rectangle("fill", 224, 84, 192, 352)
  if mode then
    love.graphics.setColor(({{0.2, 0.2, 0.8}, {0.6, 0.1, 0.1}, {0.7, 0.1, 0.7}, {0.2, 0.8, 0.2}})[mode])
  end
  love.graphics.rectangle("fill", 227, 87, 186, 346)
  love.graphics.setColor(0.4, 0.4, 0.4, 1)
  love.graphics.rectangle("fill", 237, 97, 166, 326)
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.rectangle("fill", 240, 100, 160, 320)
end

function drawMedals()
  local medalcolors={{1,0.25,0.25},{1,0.5,0.25},{1,1,0.25},{0.25,1,0.25},{0.25,0.25,1},{1,0.25,1}}
  for x=1,5 do
    if medals[x]~=0 then
      love.graphics.setColor(medalcolors[medals[x]][1], medalcolors[medals[x]][2], medalcolors[medals[x]][3], 1)
      love.graphics.draw(medalgfx[x], 180, 105+30*x, 0, 2, 2)
    end
  end
end

function drawPlayerStats()
  local name=players[savefile] or savefile
  local savefile=save.players[players[savefile]] or save.players[savefile]
  if not savefile then return end
  if not mode then mode=1 end
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print("Player:", font_medium, 20, 20)
  love.graphics.print(name, font_medium, 20, 40)
  for x=1,3 do
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(({"DRS","SRS-X","KRS"})[x], font_medium, 20, 20+100*x)
    if mode==1 then
      love.graphics.print("BEST: "..getRankText(savefile[cheatvalue][x].best), font_medium, 100, 50+100*x)
      love.graphics.print(5-#savefile[cheatvalue][x].lastfive.." LEFT", font_medium, 100, (savefile[cheatvalue][x].precedent and 90 or 70)+100*x)
      if savefile[cheatvalue][x].precedent then
        if savefile[cheatvalue][x].precedent>savefile[cheatvalue][x].qualify then
          love.graphics.print("TRY: "..getClassText(savefile[cheatvalue][x].precedent), font_medium, 100, 70+100*x)
        else
          love.graphics.setColor(1, 0, 0, 1)
          love.graphics.print("CAUTION!", font_medium, 100, 70+100*x)
        end
      end
      drawQualifyGrade(savefile[cheatvalue][x].qualify, 20, 40+100*x)
    elseif mode==2 then
      love.graphics.print("LVL "..(savefile[cheatvalue][x].hlevel<1000 and savefile[cheatvalue][x].hlevel or "@"), font_medium, 100, 50+100*x)
      drawLGrade(savefile[cheatvalue][x].hell, 20, 40+100*x)
    elseif mode==3 then
      love.graphics.print("LVL "..(savefile[cheatvalue][x].plevel<1000 and savefile[cheatvalue][x].plevel or "@"), font_medium, 100, 50+100*x)
      drawPGrade(savefile[cheatvalue][x].pandaemonium, 20, 40+100*x)
    elseif mode==4 then
      drawActivationLevel(savefile[cheatvalue][x].activation, 20, 40+100*x)
    end
  end
end

function drawCards()
  love.graphics.setColor(1, 1, 1)
  if cardtimer>0 then
    love.graphics.setColor(1, 1, 1, 0.4)
  end
  if lastcard then
    love.graphics.draw(cardgfx[lastcard], 432, 100)
  else
    love.graphics.draw(cardgfx[0], 432, 100)
  end
  if #deck>0 then
    love.graphics.print(#deck.."\nLEFT", font_large, 500, 110)
  end
  if #deck==30 and timer>=1800 and cardtimer<1 and activationstage==1 and gameState~="Paused" and gameState~="EndGame" then
    love.graphics.setColor(0.5, 1, 0.5, 0.5)
    love.graphics.printf("DRAW CARDS\nUSING THE\n180 BUTTON\nTO PASS THE\nSTAGE", font_large, 0, 150, 640, "center")
  end
end

function convertHSV(hsv)
  hsv[1]=hsv[1]%360
  
  local hue_sector = math.floor(hsv[1]/60)
  local hue_sector_offset = (hsv[1]/60)-hue_sector

  local p = hsv[3]*(1-hsv[2])
  local q = hsv[3]*(1-hsv[2]*hue_sector_offset )
  local t = hsv[3]*(1-hsv[2]*(1-hue_sector_offset))
  local v = hsv[3]

  return ({{v,t,p},{q,v,p},{p,v,t},{p,q,v},{t,p,v},{v,p,q}})[hue_sector+1]
end
