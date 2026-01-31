void computeDijkstra() {
  ArrayList<Tile> open = new ArrayList<Tile>();
  startTile.bestCost = 0;
  open.add(startTile);

  while (open.size() > 0) {
    // find lowest cost node
    Tile current = open.get(0);
    for (Tile t : open) {
      if (t.bestCost < current.bestCost) current = t;
    }
    open.remove(current);

    for (Tile n : getNeighbors(current)) {
      int newCost = current.bestCost + n.cost;
      if (newCost < n.bestCost) {
        n.bestCost = newCost;
        open.add(n);
      }
    }
  }
}

ArrayList<Tile> getNeighbors(Tile t) {
  ArrayList<Tile> n = new ArrayList<Tile>();

  if (t.x > 0) n.add(grid[t.x-1][t.y]);
  if (t.x < cols-1) n.add(grid[t.x+1][t.y]);
  if (t.y > 0) n.add(grid[t.x][t.y-1]);
  if (t.y < rows-1) n.add(grid[t.x][t.y+1]);

  return n;
}
