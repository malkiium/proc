class Molecule {
    float x, y;
    float vx, vy;
    float r;
    color col;
    float pulseSpeed = 0.05;  // vitesse de pulsation
    float time = 0;  // variable de temps

    ArrayList<PVector> trailPositions = new ArrayList<PVector>();
    int maxTrailLength = 20;  // longueur max de la traînée

    Molecule(float x, float y, float r) {
    this.x = x;
    this.y = y;
    this.r = r;
    this.vx = random(-1, 1);
    this.vy = random(-1, 1);
    this.col = color(random(255), random(255), random(255));
    this.time = time;
    this.pulseSpeed = pulseSpeed;
    }

    void deplacer() {
    this.x += this.vx;
    this.y += this.vy;
    // rebot haut bas
    if (this.x > width - r || this.x < r) {
        this.vx *= -1;
    } //rebot gauche droite
    if (this.y > height - r || this.y < r) {
        this.vy *= -1;
    }
    }

    void afficher() {
        fill(col);
        noStroke();
        circle(x, y, 2*r);
    }

    void changeColor() {
        for (int i = 0; i < molecules.length; i++) {
            Molecule autre = molecules[i];
            if (autre != this) {
                float d = dist(this.x, this.y, autre.x, autre.y);
                if (d-5 <= this.r + autre.r) {
                    color c = color(random(255), random(255), random(255));
                    color c2 = color(random(255), random(255), random(255));
                    this.col = c;
                    autre.col = c2;
                    this.vx *= -1;
                    this.vy *= -1;
                }
            }
        }
    }



    void pulsate() {
        if (this.x < (this.r+5) || this.x > width - (this.r+5) || this.y < (this.r+5) || this.y > height - (this.r+5)) { //5 = padding
            return; // on sort sans changer le rayon
        } else if (this.time > 300) { // 300 a 60 fps = 5 sec
            this.pulseSpeed *= -1;
            this.time = 0;
        } else {
            this.r += this.pulseSpeed;
            this.time += 1;
        }
    }

    void trainer() {
        trailPositions.add(new PVector(this.x, this.y));
        if (trailPositions.size() > maxTrailLength) { // test si la trainer est trop longue
            trailPositions.remove(0); // sup plus vieux
        }

        noStroke();
        fill(col, 100);
        for (PVector pos : trailPositions) { //prend les pos du tableau
            circle(pos.x-(this.vx)*(r/4), pos.y-(this.vy)*(r/4), 1.5*this.r); // dessine la traînée avec un décalage
        }
    }

}