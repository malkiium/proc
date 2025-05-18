class Molecule {
    float x, y;
    float vx, vy;
    float r;
    color col;
    float pulseSpeed = 0.05;  // vitesse de pulsation
    float time = 0;  // variable de temps

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
        // change la couleur quand MA mol touche un bord
        if (this.x > width - r || this.x < r) {
        this.col = color(random(255), random(255), random(255));
        }
        if (this.y > height - r || this.y < r) {
        this.col = color(random(255), random(255), random(255));
        }
    }

    void pulsate() {
        // pulsation
        if (this.x < (this.r+5) || this.x > width - (this.r+5) || this.y < (this.r+5) || this.y > height - (this.r+5)) {
            return; // on sort sans changer le rayon
        } else if (this.time > 300) {
            this.pulseSpeed *= -1;
            this.time = 0;
        } else {
            this.r += this.pulseSpeed;
            this.time += 1;
        }
    }
}

Molecule[] molecules = new Molecule[10];

void setup() {
    surface.setResizable(true);
    frameRate(60);
    size(400, 400);
    background(255);
    for (int i = 0; i < molecules.length; i++) {
        molecules[i] = new Molecule(random(31, width-31), random(31, height-31), random(10, 30)); //limites 31 pour pas que les molécules sortent de l'écran
    }
}

void draw() {
    background(255);
    for (Molecule m : molecules) {
        m.deplacer();
        m.afficher();
        m.changeColor();
        m.pulsate();
    }
}
