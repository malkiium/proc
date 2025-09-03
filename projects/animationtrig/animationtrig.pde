float startAngle = -HALF_PI; // start at the top
float sweep = 0;             
float duration = 0.5;        // circle duration in seconds
int totalFrames;

float lineDuration = 0.5;    // line duration in seconds
int lineFrames;              // frames needed to draw lines
int lineStartFrame;          // frame when lines start

// Labels for remarkable angles
// Remarkable angles in standard math convention (0 rad = right, CCW)
String[] labels = {
  "π/2", "π/3", "π/4", "π/6", "  0 or 2π",
  "11π/6", "7π/4", "5π/3", "3π/2",
  "4π/3", "5π/4", "7π/6", "π",
  "5π/6", "3π/4", "2π/3"
};

float[] angles = {
  0, PI/6, PI/4, PI/3, PI/2,
  2*PI/3, 3*PI/4, 5*PI/6, PI,
  7*PI/6, 5*PI/4, 4*PI/3, 3*PI/2,
  5*PI/3, 7*PI/4, 11*PI/6
};


void setup() {
  size(1000, 1000);
  frameRate(60);
  textAlign(CENTER, CENTER);
  textSize(20);
  totalFrames = int(duration * frameRate);
  lineFrames = int(lineDuration * frameRate);
  lineStartFrame = totalFrames; // start after circle is done
}

void draw() {
  background(0);
  noFill();
  stroke(255);
  strokeWeight(3);

  // --- Circle animation ---
  float progress = constrain(frameCount / float(totalFrames), 0, 1);
  sweep = progress * TWO_PI;
  arc(width/2, height/2, 500, 500, startAngle, startAngle + sweep);

  // --- Lines animation (after circle is complete) ---
  if (frameCount > lineStartFrame) {
    float lineProgress = constrain((frameCount - lineStartFrame) / float(lineFrames), 0, 1);
    float currentLength = 250 * lineProgress;

    drawDottedCross(width/2, height/2, currentLength); 
    drawRemarkableAngles(width/2, height/2, currentLength);
  }
}

// Function to draw dotted cross (with growing length)
void drawDottedCross(float cx, float cy, float length) {
  float step = 15; // gap between dots
  for (float i = 0; i <= length; i += step) {
    // vertical
    line(cx, cy - i, cx, cy - i + 5);
    line(cx, cy + i, cx, cy + i - 5);
    // horizontal
    line(cx - i, cy, cx - i + 5, cy);
    line(cx + i, cy, cx + i - 5, cy);
  }
}

// Function to draw dotted remarkable angles with labels
void drawRemarkableAngles(float cx, float cy, float length) {
  float step = 15; // dot spacing
  float dotSize = 5;

  for (int i = 0; i < angles.length; i++) {
    float angle = angles[i] - HALF_PI; // shift so 0 rad = top
    float dx = cos(angle);
    float dy = sin(angle);

    // alternate red/blue
    if (i % 2 == 0) stroke(255, 0, 0);
    else stroke(0, 128, 255);

    // Draw dotted line outward
    for (float d = 0; d <= length; d += step) {
      float x1 = cx + dx * d;
      float y1 = cy + dy * d;
      float x2 = cx + dx * (d + dotSize);
      float y2 = cy + dy * (d + dotSize);
      line(x1, y1, x2, y2);
    }

    // Draw label at the current line end
    float labelX = cx + dx * (length + 25);
    float labelY = cy + dy * (length + 25);
    if (i % 2 == 0) fill(255, 0, 0);
    else fill(0, 128, 255);
    noStroke();
    text(labels[i], labelX, labelY);
  }
}
