Amulet={}

function Amulet.update()
  amuletframes=amuletframes+1
  if amuletframes==30 then
    clearedLines={17, 18, 19, 20}
    clearLines()
    currentBlock=nil
    ARE=27
    gameState="Activate"
  end
end

function Amulet.drawBGA(offset, cmoffset, bxa, bxb, bya, byb)
  InGame.drawBGA(offset, cmoffset, bxa, bxb, bya, byb)
end

function Amulet.draw()
  InGame.draw()
  love.graphics.setColor(0, amuletframes/20, 1, amuletframes/20)
  love.graphics.rectangle("fill", 240, 356, 160, 64)
end

return Amulet