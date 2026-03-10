ArrayList<RectA> rects = new ArrayList();
int NbRects = 3;
ArrayList<Balle> balles = new ArrayList();
int NbBalles = 10;

void setup() {
  size(400, 400);
  for (int nmb=0; nmb < NbRects; nmb++) {
    rects.add(new RectA(random(30, 100)));
  }
  for (int nmb=0; nmb < NbBalles; nmb++) {
    balles.add(new Balle(random(30)));
  }
}

void draw() {
  background(0);
  for (int i = 0; i<rects.size(); i++) {
    rects.get(i).bouger();
    rects.get(i).dessiner();
    for (int j = 0; j<rects.size(); j++) {
      if (i != j && rects.get(i).intersecte(rects.get(j))) {
        rects.get(i).changerColor();
        rects.get(j).changerColor();
      }
    }
  }
  for (int i = 0; i<balles.size(); i++) {
    balles.get(i).bouger();
    balles.get(i).dessiner();
    for (int j = 0; j<balles.size(); j++) {
      if (i != j && balles.get(i).intersecte(balles.get(j))) {
        balles.get(i).changerColor();
        balles.get(j).changerColor();
      }
    }
  }
}
