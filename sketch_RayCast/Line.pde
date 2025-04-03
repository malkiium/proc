class Line {
    float x1,y1,x2,y2,l;
    Vector2 dir;
    public Line(float xStart,float yStart, float xDir, float yDir, float longeur) {
        this.x1 = xStart;
        this.y1 = yStart;
        this.dir = new Vector2(xDir,yDir); 
        this.l = longeur;
        this.dir.normalize();
        calculEndPoint();
    }
    public void calculEndPoint() {
        this.x2 = dir.x*l+x1;
        this.y2 = dir.y*l+y1;
    }
    public void afficher() {
        calculEndPoint();
        line(this.x1, this.y1, this.x2, this.y2);
    }
}