int cols = 8;
int rows = 8;
int tileSize = 70;

Tile[][] grid;

Tile startTile;
Tile goalTile;
Tile playerTile;

boolean finished = false;
int playerCost = 0;
ArrayList<Tile> playerPath = new ArrayList<Tile>();

public void settings() {
  size(cols * tileSize, rows * tileSize + 80);
}

void setup() {
  generateGrid();
  computeDijkstra();
}

void draw() {
  background(30);

  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      grid[x][y].display();
    }
  }

  drawUI();
}

void mousePressed() {
  if (finished) return;

  int gx = mouseX / tileSize;
  int gy = mouseY / tileSize;

  if (gx < 0 || gx >= cols || gy < 0 || gy >= rows) return;

  Tile clicked = grid[gx][gy];

    if (playerTile.isNeighbor(clicked) && !clicked.visited) {
        playerTile = clicked;
        clicked.visited = true;  // mark as stepped on
        playerPath.add(clicked);
        playerCost += clicked.cost;

        if (clicked == goalTile) {
            finished = true;
        }
    }
}

void drawUI() {
  fill(255);
  textSize(18);
  textAlign(LEFT);

  text("Your cost: " + playerCost, 10, height - 50);

  if (finished) {
    int optimal = goalTile.bestCost;
    float efficiency = 100.0 * optimal / playerCost;

    text("Optimal cost: " + optimal, 10, height - 30);
    text("Efficiency: " + nf(efficiency, 0, 1) + "%", 200, height - 30);
  }
}

void generateGrid() {
  grid = new Tile[cols][rows];

  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      int cost = int(random(1, 10)); // tile movement cost
      grid[x][y] = new Tile(x, y, cost);
    }
  }

  startTile = grid[0][0];
  goalTile = grid[cols-1][rows-1];
  playerTile = startTile;
  playerPath.add(startTile);

  startTile.isStart = true;
  goalTile.isGoal = true;
}
