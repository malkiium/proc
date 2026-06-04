int cols = 31;
int rows = 31;
int cellSize = 18;

int gridX = 50;
int gridY = 105;

int refX = 650;
int refY = 105;

boolean[][] targetGrid;

String[] shapeNames = {
  "circle",
  "square",
  "triangle"
};

int detectedShape = -1;
float[] scores;

// How forgiving the detector is when comparing nearby pixels.
// Bigger = more tolerant of shaky hand drawing.
float matchTolerance = 1.35;

// Thickness of the generated outline in normalized shape-space.
// Bigger = thicker reference outlines.
float normalizedOutlineThickness = 0.16;

void setup() {
  size(1260, 720);
  textFont(createFont("Arial", 16));

  targetGrid = new boolean[cols][rows];
  scores = new float[shapeNames.length];

  resetGrid();
}

void draw() {
  background(245);

  detectShape();

  drawTargetGrid(gridX, gridY);
  drawBestReferenceGrid(refX, refY);
  drawInfo();
}

void mousePressed() {
  editGridWithMouse();
}

void mouseDragged() {
  editGridWithMouse();
}

void editGridWithMouse() {
  int gx = floor((mouseX - gridX) / float(cellSize));
  int gy = floor((mouseY - gridY) / float(cellSize));

  if (gx >= 0 && gx < cols && gy >= 0 && gy < rows) {
    if (mouseButton == LEFT) {
      targetGrid[gx][gy] = true;
    }

    if (mouseButton == RIGHT) {
      targetGrid[gx][gy] = false;
    }
  }
}

void resetGrid() {
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      targetGrid[x][y] = false;
    }
  }

  detectedShape = -1;
}

// Finds the top-left and bottom-right limits of your drawing.
int[] getDrawnBoundingBox() {
  int minX = cols;
  int minY = rows;
  int maxX = -1;
  int maxY = -1;

  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      if (targetGrid[x][y]) {
        minX = min(minX, x);
        minY = min(minY, y);
        maxX = max(maxX, x);
        maxY = max(maxY, y);
      }
    }
  }

  if (maxX == -1) {
    return null;
  }

  return new int[] { minX, minY, maxX, maxY };
}

void detectShape() {
  int[] box = getDrawnBoundingBox();

  if (box == null) {
    detectedShape = -1;

    for (int i = 0; i < scores.length; i++) {
      scores[i] = 0;
    }

    return;
  }

  float bestScore = Float.MAX_VALUE;
  int bestIndex = -1;

  for (int i = 0; i < shapeNames.length; i++) {
    boolean[][] reference = makeReferenceOutline(shapeNames[i], box);

    scores[i] = compareDrawingToReference(reference);

    if (scores[i] < bestScore) {
      bestScore = scores[i];
      bestIndex = i;
    }
  }

  detectedShape = bestIndex;
}

// Creates a fitted reference outline using the drawing's bounding box.
boolean[][] makeReferenceOutline(String shapeType, int[] box) {
  boolean[][] reference = new boolean[cols][rows];

  int minX = box[0];
  int minY = box[1];
  int maxX = box[2];
  int maxY = box[3];

  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      reference[x][y] = isOnNormalizedReferenceOutline(
        shapeType,
        x,
        y,
        minX,
        minY,
        maxX,
        maxY
      );
    }
  }

  return reference;
}

// This is the core idea:
//
// Your drawn bounding box becomes a mini coordinate space:
//
// top-left     = (-1, -1)
// center       = ( 0,  0)
// bottom-right = ( 1,  1)
//
// Then each shape is generated inside that normalized space.
boolean isOnNormalizedReferenceOutline(String shapeType, int x, int y, float minX, float minY, float maxX, float maxY) {
  float w = maxX - minX;
  float h = maxY - minY;

  if (w < 2 || h < 2) {
    return false;
  }

  float u = map(x, minX, maxX, -1, 1);
  float v = map(y, minY, maxY, -1, 1);

  float t = normalizedOutlineThickness;

  if (u < -1 - t || u > 1 + t || v < -1 - t || v > 1 + t) {
    return false;
  }

  if (shapeType.equals("square")) {
    float edgeDistance = abs(max(abs(u), abs(v)) - 1);
    return edgeDistance <= t;
  }

  if (shapeType.equals("circle")) {
    float distanceFromCenter = sqrt(u * u + v * v);
    return abs(distanceFromCenter - 1) <= t;
  }

  if (shapeType.equals("triangle")) {
    float d1 = distanceToSegment(u, v, 0, -1, -1, 1);
    float d2 = distanceToSegment(u, v, -1, 1, 1, 1);
    float d3 = distanceToSegment(u, v, 1, 1, 0, -1);

    return d1 <= t || d2 <= t || d3 <= t;
  }

  return false;
}

// Lower score = better match.
float compareDrawingToReference(boolean[][] reference) {
  int expectedCount = 0;
  int missingCount = 0;

  int drawnCount = 0;
  int extraCount = 0;

  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      boolean expected = reference[x][y];
      boolean drawn = targetGrid[x][y];

      if (expected) {
        expectedCount++;

        if (!hasNearbyBlack(targetGrid, x, y, matchTolerance)) {
          missingCount++;
        }
      }

      if (drawn) {
        drawnCount++;

        if (!hasNearbyBlack(reference, x, y, matchTolerance)) {
          extraCount++;
        }
      }
    }
  }

  if (expectedCount == 0 || drawnCount == 0) {
    return Float.MAX_VALUE;
  }

  float missingRatio = missingCount / float(expectedCount);
  float extraRatio = extraCount / float(drawnCount);

  // Missing reference outline matters more.
  // Extra pixels matter less, so messy/filled parts don't completely destroy detection.
  float missingPenalty = missingRatio * 100.0;
  float extraPenalty = extraRatio * 35.0;

  return missingPenalty + extraPenalty;
}

boolean hasNearbyBlack(boolean[][] grid, int cx, int cy, float radius) {
  if (grid == null) {
    return false;
  }

  int r = ceil(radius);

  for (int y = cy - r; y <= cy + r; y++) {
    for (int x = cx - r; x <= cx + r; x++) {
      if (x >= 0 && x < cols && y >= 0 && y < rows) {
        float dx = x - cx;
        float dy = y - cy;

        if (dx * dx + dy * dy <= radius * radius) {
          if (grid[x][y]) {
            return true;
          }
        }
      }
    }
  }

  return false;
}

float distanceToSegment(float px, float py, float x1, float y1, float x2, float y2) {
  float vx = x2 - x1;
  float vy = y2 - y1;

  float wx = px - x1;
  float wy = py - y1;

  float segmentLengthSquared = vx * vx + vy * vy;

  if (segmentLengthSquared == 0) {
    return dist(px, py, x1, y1);
  }

  float amount = (wx * vx + wy * vy) / segmentLengthSquared;
  amount = constrain(amount, 0, 1);

  float closestX = x1 + amount * vx;
  float closestY = y1 + amount * vy;

  return dist(px, py, closestX, closestY);
}

void drawTargetGrid(int startX, int startY) {
  fill(0);
  textSize(20);
  text("Draw outline here", startX, startY - 25);

  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      if (targetGrid[x][y]) {
        fill(20);
      } else {
        fill(255);
      }

      stroke(180);
      strokeWeight(1);
      rect(startX + x * cellSize, startY + y * cellSize, cellSize, cellSize);
    }
  }

  drawBoundingBox(startX, startY);
}

void drawBoundingBox(int startX, int startY) {
  int[] box = getDrawnBoundingBox();

  if (box == null) {
    return;
  }

  noFill();
  stroke(0, 120, 255);
  strokeWeight(3);

  rect(
    startX + box[0] * cellSize,
    startY + box[1] * cellSize,
    (box[2] - box[0] + 1) * cellSize,
    (box[3] - box[1] + 1) * cellSize
  );

  strokeWeight(1);
}

void drawBestReferenceGrid(int startX, int startY) {
  fill(0);
  textSize(20);
  text("Best fitted reference", startX, startY - 25);

  int[] box = getDrawnBoundingBox();

  boolean[][] reference = null;

  if (box != null && detectedShape != -1) {
    reference = makeReferenceOutline(shapeNames[detectedShape], box);
  }

  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      boolean drawn = targetGrid[x][y];
      boolean expected = false;

      if (reference != null) {
        expected = reference[x][y];
      }

      fill(255);

      if (expected) {
        fill(20);
      }

      // Red = reference expected black here, but your drawing missed it.
      if (expected && !hasNearbyBlack(targetGrid, x, y, matchTolerance)) {
        fill(255, 120, 120);
      }

      // Pink = you drew here, but the reference does not expect it.
      if (drawn && !hasNearbyBlack(reference, x, y, matchTolerance)) {
        fill(255, 180, 180);
      }

      // Black = your drawing matches the reference nearby.
      if (drawn && hasNearbyBlack(reference, x, y, matchTolerance)) {
        fill(20);
      }

      stroke(180);
      strokeWeight(1);
      rect(startX + x * cellSize, startY + y * cellSize, cellSize, cellSize);
    }
  }
}

void drawInfo() {
  fill(0);
  textSize(18);

  if (detectedShape == -1) {
    text("Detected outline: none", 50, 30);
  } else {
    text("Detected outline: " + shapeNames[detectedShape], 50, 30);
  }

  textSize(16);
  text("Left click / drag = draw black", 50, 55);
  text("Right click / drag = erase", 300, 55);
  text("R = reset grid", 520, 55);

  int y = 695;

  for (int i = 0; i < shapeNames.length; i++) {
    String scoreText;

    if (scores[i] == Float.MAX_VALUE) {
      scoreText = shapeNames[i] + " score = ---";
    } else {
      scoreText = shapeNames[i] + " score = " + nf(scores[i], 1, 2);
    }

    if (i == detectedShape) {
      fill(0, 120, 0);
    } else {
      fill(0);
    }

    text(scoreText, 50 + i * 210, y);
  }
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    resetGrid();
  }
}
