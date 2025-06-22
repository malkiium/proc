void setup() {
  size(800, 600);
  background(255);
}

void draw() {
    background(255);

    float cx = width / 2;
    float cy = height / 2;
    float w = abs(mouseX - cx);
    float h = abs(mouseY - cy);
    
    fill(0, 0, 255);
    rect(cx, cy, w, h);

    fill(255, 0, 0);
    rect(cx, cy, mouseX-cx, mouseY-cy);
}