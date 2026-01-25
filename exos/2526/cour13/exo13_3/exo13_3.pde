Grenouille gamabunta;

void setup() {
  size(400, 400);

  // initialiser la voiture
  gamabunta = new Grenouille();
}

void draw() {
  background(0);
    gamabunta.sauter();
}