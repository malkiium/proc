int h = 1000;
int w = 1600;

ArrayList<Enemy> enemies = new ArrayList<Enemy>();
ArrayList<DmgZone> dmgZones = new ArrayList<DmgZone>();

void settings() {
    size(w, h);
}

void setup() {
    // Spawn some enemies
    for (int i = 0; i < 5; i++) {
        enemies.add(new Enemy(random(50, w-50), random(50, h-50)));
    }
}

void draw() {
    background(255);
    
    // Draw and update dmg zones
    for (int i = dmgZones.size()-1; i >= 0; i--) {
        DmgZone dz = dmgZones.get(i);
        dz.display();
        dz.update();
        if (dz.isExpired()) {
            dmgZones.remove(i);
        }
    }
    
    // Draw and update enemies
    for (int i = enemies.size()-1; i >= 0; i--) {
        Enemy e = enemies.get(i);
        e.display();
        // Apply damage from all dmg zones
        for (DmgZone dz : dmgZones) {
            if (dz.contains(e.x, e.y)) {
                e.applyDamage(dz.dps * (1.0/frameRate));
            }
        }
        if (e.isDead()) {
            // Spawn dmg zone at enemy death location
            dmgZones.add(new DmgZone(e.x, e.y));
            
            // Spawn 2 new enemies
            enemies.add(new Enemy(random(50, w-50), random(50, h-50)));
            enemies.add(new Enemy(random(50, w-50), random(50, h-50)));
            
            enemies.remove(i);
        }
    }
}

// Spawn dmg zone on left mouse click
void mousePressed() {
    if (mouseButton == LEFT) {
        dmgZones.add(new DmgZone(mouseX, mouseY));
    }
}

class Enemy {
    float x, y;
    float health = 100;
    Enemy(float x, float y) {
        this.x = x;
        this.y = y;
    }
    void display() {
        fill(255, 0, 0);
        ellipse(x, y, 50, 50);
        fill(0);
        textAlign(CENTER, CENTER);
        text(int(health), x, y);
    }
    void applyDamage(float dmg) {
        health -= dmg;
    }
    boolean isDead() {
        return health <= 0;
    }
}

class DmgZone {
    float x, y;
    float radius = 200; // 100px diameter
    float dps = 10;
    int duration = 300; // frames (1 second)
    int age = 0;
    DmgZone(float x, float y) {
        this.x = x;
        this.y = y;
    }
    void display() {
        noStroke();
        fill(0, 255, 0, 64); // 25% opacity
        ellipse(x, y, radius*2, radius*2);
    }
    void update() {
        age++;
    }
    boolean isExpired() {
        return age > duration;
    }
    boolean contains(float px, float py) {
        return dist(x, y, px, py) < radius;
    }
}