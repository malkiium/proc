ArrayList<Balle> balles = new ArrayList();

void setup() {
  size(200, 200);
  frameRate(30);
  balles.add(new Balle(50, 0, 10));
}

void draw() {
  background(100);
  for (int i = 0; i < balles.size(); i++) {
    balles.get(i).bouger();
    balles.get(i).dessiner();
  }
}

void mousePressed() {
  balles.add(new Balle(mouseX, mouseY, 10));
  // Voici la fonction append() qui ajoute un élément (ici b) à la fin d'un tableau donné
  // (ici balles). Il faut faire très attention à remplacer l'ancien tableau (qui n'a pas
  // changé de taille) par le nouveau créé par append() et renvoyé en résultat, ce qui
  // explique le signe = utilisé. De plus si les éléments du tableau sont des objets,
  // il faut re-préciser le type du tableau avec une projection (plus souvent appelée "cast"),
  // en plaçant ce type entre parenthèses après le signe =.
}
