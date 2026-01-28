ArrayList<Bubble> boule = new ArrayList<Bubble>();

void setup() {
    size(800, 800);
    boule.add(new Bubble(width/1.5, height/1.5, 100));
    boule.add(new Bubble(width/3, height/3, 100));
}

void draw() {
    background(0);
    
    for(int curbl = 0; curbl < boule.size(); curbl++) {
        Bubble b = boule.get(curbl);
        b.move();
        b.dessiner();

        //other balls colision
        for(int othbl=0; othbl < boule.size(); othbl++) {
            if (curbl != othbl) {
                Bubble other = boule.get(othbl);

                if (dist(b.x, b.y, other.x, other.y) <= (b.r + other.r)/2) {
                    Bubble newB = b.bounceColide();
                    boule.add(newB);
                    other.bounceColide();
                }
            }
        }

        //call colision
        if (b.x - (b.r)/2 < 0 || b.x + (b.r)/2 > width) {
            b.sx *= -1;
        }
        if (b.y - (b.r)/2 < 0 || b.y + (b.r)/2 > height) {
            b.sy *= -1;
        }
    }
}