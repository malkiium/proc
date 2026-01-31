class Tile {
  int x, y;
  int cost;

  boolean visited = false;
  boolean isStart = false;
  boolean isGoal = false;

  int bestCost = 999999; // Dijkstra result

  Tile(int x, int y, int cost) {
    this.x = x;
    this.y = y;
    this.cost = cost;
  }

  void display() {
    int px = x * tileSize;
    int py = y * tileSize;

    // color based on cost
    float c = map(cost, 1, 9, 50, 255);

    // normal alpha
    float alpha = 255;

    // fade if visited
    if (visited) alpha = 75;  // ~30%

    fill(c, 80, 255 - c, alpha);
    rect(px, py, tileSize, tileSize);


    fill(255);
    textAlign(CENTER, CENTER);
    text(cost, px + tileSize/2, py + tileSize/2);

    if (isStart) {
      fill(0,255,0);
      ellipse(px + 15, py + 15, 12, 12);
    }
    if (isGoal) {
      fill(255,0,0);
      ellipse(px + tileSize-15, py + tileSize-15, 12, 12);
    }
  }

  boolean isNeighbor(Tile other) {
    return abs(x - other.x) + abs(y - other.y) == 1;
  }
}
