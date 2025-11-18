float x = 1920/2;
float y = 1080/2;
float spdx = 0;
float spdy = 0;
float lzrWd = 50;
float spdmodX = 0;
float spdmodY = 0;


void setup() {
    size(1920, 1080);
    frameRate(170);
}

void draw() {
    background(0);

    circle(x, y, lzrWd);
    
    spdmodX = spdmodX + random(-1, 1);
    x += (spdx + spdmodX);
    
    spdmodY = spdmodY + random(-1, 1);
    y += (spdy + spdmodY);
    
    if (x <= 0 || x >= width) {
        x = width - x;
    }
    if (y <= 0 || y >= height) {
        y = height - y;
    }
}