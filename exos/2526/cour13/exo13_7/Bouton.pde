class Bouton{

    int x;
    int y;
    int wid;
    int hei;
    color couleur;

    Bouton(int x, int y, int w, int h, color couleur) {
        this.x = x;
        this.y = y;
        this.hei = h;
        this.wid = w;
        this.couleur = couleur;
    }

    void dessiner() {
        rectMode(CENTER);
        fill(couleur);
        rect(x, y, wid, hei);
    }

    boolean sourisDedans() {
        return (mouseX > x-wid/2 && mouseX < x+wid/2 &&
        mouseY > y-hei/2 && mouseY < y+hei/2);
    }
}