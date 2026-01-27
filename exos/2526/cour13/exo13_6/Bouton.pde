class Bouton{

    int x;
    int y;
    int t;
    color couleur;
    char symb;

    Bouton(int x, int y, int t, color couleur, char symb) {
        this.x = x;
        this.y = y;
        this.t = t;
        this.couleur = couleur;
        this.symb = symb;
    }

    void dessiner() {
        textAlign(CENTER, CENTER);
        rectMode(CENTER);
        fill(couleur);
        rect(x, y, t, t);
        fill(0);
        text(symb, x, y);
    }

    boolean sourisDedans() {
        return (mouseX > x-t/2 && mouseX < x+t/2 &&
        mouseY > y-t/2 && mouseY < y+t/2);
    }
}