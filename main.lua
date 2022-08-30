require "librairies/tableUtils"

local Cell = require "cell"

function love.load()

  math.randomseed(os.time())

  CELL_SIZE = 5
  BOARD_WIDTH = 160 -- En nombre de cellules
  BOARD_HEIGHT = 160 -- En nombre de cellules
  BOARD_SIZE = BOARD_WIDTH * BOARD_HEIGHT

  board = {}

  for j=1, BOARD_HEIGHT do
    for i=1, BOARD_WIDTH do
      local _index = i + (j-1)*BOARD_HEIGHT
      local _cell = Cell:new(i, j, _index)
      table.insert(board, _cell)
    end
  end

  timer_delay = 0.05
  timer = timer_delay

  averageCellLifeTime = 0
  nbOfGeneration = 1

end

function love.update(dt)

  timer = timer - dt

  if timer <= 0 then

    local _sumOfCellsLifetime = 0

    for index, cell in ipairs(board) do
      cell:update(dt)
      _sumOfCellsLifetime = _sumOfCellsLifetime + cell.lifetime
    end

    averageCellLifeTime = _sumOfCellsLifetime / table.length(board)
    averageCellLifeTime = math.floor(averageCellLifeTime * 1000) / 1000 -- Cet opération permet d'arrondir à quatre chiffres après la virgule

    for index, cell in ipairs(board) do
      cell.isAlive = cell.isAliveForTheNextGeneration
    end

    timer = timer_delay
    nbOfGeneration = nbOfGeneration+1

  end

end





function love.draw()

  love.graphics.setBackgroundColor(0.15, 0.15, 0.15)

  love.graphics.push()

  love.graphics.translate(love.graphics.getWidth()/2 - (CELL_SIZE * BOARD_WIDTH /2), love.graphics.getHeight()/2 - (CELL_SIZE * BOARD_HEIGHT /2))

  for index, cell in ipairs(board) do
    cell:draw()
  end

  love.graphics.pop()

  love.graphics.setColor(0.3, 0.3, 0.4, 1)
  love.graphics.rectangle('fill', 20, 20, 200, 40)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print("Durée de vie moyenne : " .. averageCellLifeTime .. "s", 25, 25)
  love.graphics.print("Génération n° : " .. nbOfGeneration, 25, 40)

end
