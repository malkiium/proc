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
        m.trainer();
        m.afficher();
        m.changeColor();
        m.pulsate();
    }
}
