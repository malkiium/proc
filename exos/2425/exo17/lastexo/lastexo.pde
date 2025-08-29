int[] cells;    // Current generation
int[] nextGen;  // Next generation
int cols = 201; // Must be an odd number for symmetry
int rule = 86;  // Rule number (0-255)
int cellSize = 4; // Size of each cell (adjust for resolution)
int generations;

void setup() {
  size(800, 800);
  generations = height / cellSize;
  
  cells = new int[cols];
  nextGen = new int[cols];

  // **Ensure the first cell is exactly centered**
  cells[cols / 2] = 1;
  
  noLoop(); // Run once
}

void draw() {
  background(255);
  
  for (int y = 0; y < generations; y++) {
    display(y);
    generateNext();
  }
}

// **Improved Display Function**
void display(int y) {
  for (int x = 0; x < cols; x++) {
    if (cells[x] == 1) {
      fill(0);
      rect(x * cellSize, y * cellSize, cellSize, cellSize);
    }
  }
}

// **Generate the next row correctly**
void generateNext() {
  for (int i = 0; i < cols; i++) {
    int left = cells[(i - 1 + cols) % cols]; // Left neighbor
    int self = cells[i];                     // Current cell
    int right = cells[(i + 1) % cols];        // Right neighbor
    
    // Compute rule index
    int index = (left << 2) | (self << 1) | right;
    
    // Apply rule
    nextGen[i] = (rule >> index) & 1;
  }
  
  // Swap arrays
  int[] temp = cells;
  cells = nextGen;
  nextGen = temp;
}
