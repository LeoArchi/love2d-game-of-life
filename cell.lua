local function getIndex(i, j)

  if i<1 then
    i = BOARD_WIDTH
  elseif i > BOARD_WIDTH then
    i = 1
  end

  if j<1 then
    j = BOARD_HEIGHT
  elseif j > BOARD_HEIGHT then
    j=1
  end

  return i + (j-1)*BOARD_HEIGHT

end

local Cell = {

  i,
  j,
  x,
  y,
  index,
  isAlive,
  isAliveForTheNextGeneration,
  lifetime,


  new = function(self, i, j, index)
    local _cell = {}

    setmetatable(_cell, self)
    self.__index = self

    _cell.i = i
    _cell.j = j
    _cell.x = (i -1) * CELL_SIZE
    _cell.y = (j -1) * CELL_SIZE
    _cell.index = index
    _cell.lifetime = 0

    if math.random() < 0.2 then
      _cell.isAlive = true
    else
      _cell.isAlive = false
    end

    return _cell
  end,

  update = function(self, dt)

    local nbOfAliveNeighboors = self:getNbOfAliveNeighboors()

    if self.isAlive and (nbOfAliveNeighboors == 2 or nbOfAliveNeighboors == 3) then
      self.isAliveForTheNextGeneration = true
    elseif not self.isAlive and nbOfAliveNeighboors == 3 then
      self.isAliveForTheNextGeneration = true
    else
      self.isAliveForTheNextGeneration = false
    end

    if self.isAliveForTheNextGeneration then
      self.lifetime = self.lifetime + dt
    else
      self.lifetime = 0
    end

  end,

  draw = function(self)
    love.graphics.push()

    if self.isAlive then
      love.graphics.setColor(1, 1, 1)
      love.graphics.circle('fill', self.x + CELL_SIZE/2, self.y + CELL_SIZE/2, CELL_SIZE/2, 16)
    end

    love.graphics.pop()
  end,

  getNbOfAliveNeighboors = function(self)

    local nbOfAliveNeighboors = 0
    local totalNbOfNeighboor = 0

    for i=self.i-1, self.i+1 do
      for j=self.j-1, self.j+1 do
        if not (i == self.i and j == self.j) then
          totalNbOfNeighboor = totalNbOfNeighboor +1
          local neighboor = board[getIndex(i, j)]
          if neighboor.isAlive then nbOfAliveNeighboors = nbOfAliveNeighboors+1 end
        end
      end
    end

    return nbOfAliveNeighboors

  end

}

return Cell
