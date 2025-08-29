int x = 0;
int y = 0;
int speedx = 10;
int speedy = 10;

void setup() {
    size(1800, 900);
}

void draw() {
    background(0);
    rect(x, y, 100, 100);
    x += speedx;
    y += speedy;
    if (x > width - 100 || x < 0) {
        speedx = -speedx;
    }
    if (y > height - 100 || y < 0) {
        speedy = -speedy;
    }
}