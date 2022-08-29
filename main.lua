require "librairies/tableUtils"

local Cell = require "cell"

function love.load()

  math.randomseed(os.time())

  CELL_SIZE = 10
  BOARD_WIDTH = 80 -- En nombre de cellules
  BOARD_HEIGHT = 80 -- En nombre de cellules
  BOARD_SIZE = BOARD_WIDTH * BOARD_HEIGHT

  board = {}

  for j=1, BOARD_HEIGHT do
    for i=1, BOARD_WIDTH do
      local _index = i + (j-1)*BOARD_HEIGHT
      local _cell = Cell:new(i, j, _index)
      table.insert(board, _cell)
    end
  end


  timer = 0.05

end

function love.update(dt)

  timer = timer - dt

  if timer <= 0 then

    for index, cell in ipairs(board) do
      cell:update(dt)
    end

    for index, cell in ipairs(board) do
      cell.isAlive = cell.isAliveForTheNextGeneration
    end

    timer = 0.05

  end

end





function love.draw()

  love.graphics.setBackgroundColor(0.3, 0.3, 0.3)

  love.graphics.push()

  love.graphics.translate(love.graphics.getWidth()/2 - (CELL_SIZE * BOARD_WIDTH /2), love.graphics.getHeight()/2 - (CELL_SIZE * BOARD_HEIGHT /2))

  for index, cell in ipairs(board) do
    cell:draw()
  end

  love.graphics.pop()

end
