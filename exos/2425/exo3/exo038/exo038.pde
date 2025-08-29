void setup() {
    size(800, 800); //must be a square.
    background(255);
}

void draw() {
    float stepX = width / 255.0;
    float stepY = height / 255.0;

    float r = mouseX / stepX;
    float g = mouseY / stepY;

    // Calculate distance to center
    float distCenter = dist(mouseX, mouseY, width/2, height/2);

    // Map distance (0 to max) to 0-255 for blue
    float maxDist = dist(0, 0, width/2, height/2);
    float b = map(distCenter, 0, maxDist, 0, 255);

    background(r, g, b);
}
