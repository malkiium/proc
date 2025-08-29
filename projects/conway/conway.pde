// Global variables
Grid grid;
boolean simulationStarted = false;

void setup() {
  size(800, 800);
  // Set frame rate to slow down the simulation for visibility.
  frameRate(5);
  grid = new Grid(50, 50, 800/50);
}

void draw() {
  background(255);
  grid.display();
  
  if (simulationStarted) {
    grid.update();
  }
}

void mousePressed() {
  // Allow toggling cells only before simulation starts.
  if (!simulationStarted) {
    grid.toggleCell(mouseX, mouseY);
  }
}

void keyPressed() {
  // Start simulation when space bar is pressed.
  if (key == ' ') {
    simulationStarted = true;
  }
}

// ----- Cell Class -----
class Cell {
  int row, col;
  int state;      // 0 for dead, 1 for alive
  int nextState;  // used during update
  int cellSize;
  
  Cell(int row, int col, int cellSize) {
    this.row = row;
    this.col = col;
    this.cellSize = cellSize;
    this.state = 0;
    this.nextState = 0;
  }
  
  // Draw the cell as a rectangle filled with black (alive) or white (dead)
  void display() {
    if (state == 1) {
      fill(0);
    } else {
      fill(255);
    }
    stroke(200);
    rect(col * cellSize, row * cellSize, cellSize, cellSize);
  }
  
  // Toggle the cell state
  void toggle() {
    state = (state == 1) ? 0 : 1;
  }
}

// ----- Grid Class -----
class Grid {
  int rows, cols, cellSize;
  Cell[][] cells;
  
  Grid(int rows, int cols, int cellSize) {
    this.rows = rows;
    this.cols = cols;
    this.cellSize = cellSize;
    cells = new Cell[rows][cols];
    
    // Initialize each cell in the grid.
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        cells[i][j] = new Cell(i, j, cellSize);
      }
    }
  }
  
  // Display all cells in the grid.
  void display() {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        cells[i][j].display();
      }
    }
  }
  
  // Toggle a cell based on mouse click position.
  void toggleCell(int mouseX, int mouseY) {
    int col = mouseX / cellSize;
    int row = mouseY / cellSize;
    if (row >= 0 && row < rows && col >= 0 && col < cols) {
      cells[row][col].toggle();
    }
  }
  
  // Update the grid using Conway's Game of Life rules.
  void update() {
    // First, compute the next state for each cell.
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        int aliveNeighbors = countAliveNeighbors(i, j);
        
        if (cells[i][j].state == 1) {
          if (aliveNeighbors < 2 || aliveNeighbors > 3) {
            cells[i][j].nextState = 0;
          } else {
            cells[i][j].nextState = 1;
          }
        } else {
          if (aliveNeighbors == 3) {
            cells[i][j].nextState = 1;
          } else {
            cells[i][j].nextState = 0;
          }
        }
      }
    }
    // Then, update all cells to their new state.
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        cells[i][j].state = cells[i][j].nextState;
      }
    }
  }
  
  // Count the number of alive neighbors around the cell at (row, col)
  int countAliveNeighbors(int row, int col) {
    int count = 0;
    for (int dr = -1; dr <= 1; dr++) {
      for (int dc = -1; dc <= 1; dc++) {
        if (dr == 0 && dc == 0) continue;
        int newRow = row + dr;
        int newCol = col + dc;
        if (newRow >= 0 && newRow < rows && newCol >= 0 && newCol < cols) {
          count += cells[newRow][newCol].state;
        }
      }
    }
    return count;
  }
}
