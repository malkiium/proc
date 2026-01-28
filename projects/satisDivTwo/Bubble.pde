class Bubble {

    float x;
    float y;
    float r;
    float sx;
    float sy;

    Bubble(float posX, float posY, float radius) {
        this.x = posX;
        this.y = posY;
        this.r = radius;
        this.sx = random(-2, 2);
        this.sy = random(-2, 2);
    }

    void dessiner() {
        fill(255);
        circle(x, y, r);
    }

    void move() {
        x += sx;
        y += sy;
    }

    Bubble bounceColide() {
        r *= 0.9;
    
        float offset = r * 2;
        float angle = random(TWO_PI);
    
        float newX = x + cos(angle) * offset;
        float newY = y + sin(angle) * offset;
    
        Bubble newB = new Bubble(newX, newY, r);
    
        float speed = 2;
        newB.sx = cos(angle) * speed;
        newB.sy = sin(angle) * speed;
    
        sx *= -1;
        sy *= -1;
    
        return newB;
    }
}