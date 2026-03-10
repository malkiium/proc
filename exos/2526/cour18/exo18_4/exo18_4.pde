ArrayList<RectA> rects = new ArrayList();
int NbRects = 3;


void setup() {
  size(400, 400);
  for (int nmb=0; nmb < NbRects; nmb++) {
    rects.add(new RectA(random(30, 100)));
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

}
