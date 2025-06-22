void setup() {
    size(800, 800);
    background(255);
}

void draw() {
    background(255);
    circle(width/2, height/2, dist(mouseX, mouseY, width/2, height/2)*2);
}