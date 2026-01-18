ArrayList<Bulle> bulles;
int lastTime = 0;

void setup() {
  size(800, 600);
  smooth();

  bulles = new ArrayList<Bulle>();
  bulles.add(new Bulle(width/2, height/2));
  bulles.add(new Bulle(width/2 + 25, height/2));
}

void draw() {
  background(20);

  for (Bulle b : bulles) {
    b.update(bulles);
    b.display();
  }

  fill(255);
  text("Bulles : " + bulles.size(), 10, 20);

  // toutes les 1 seconde : n = n + n/2
  if (millis() - lastTime >= 1000) {
    lastTime = millis();

    int paires = bulles.size() / 2;

    for (int i = 0; i < paires; i++) {
      Bulle parent = bulles.get(i);
      bulles.add(spawnSafe(parent));
    }
  }
}

// =================================
// SPAWN SANS CHEVAUCHEMENT
// =================================
Bulle spawnSafe(Bulle parent) {
  float minDist = parent.r * 2.2;
  int tries = 0;

  while (tries < 60) {
    PVector dir = PVector.random2D();
    float d = random(minDist, minDist * 3);
    PVector pos = PVector.add(parent.pos, dir.mult(d));

    boolean ok = true;
    for (Bulle b : bulles) {
      if (PVector.dist(pos, b.pos) < b.r * 2) {
        ok = false;
        break;
      }
    }

    if (ok) {
      Bulle enfant = new Bulle(pos.x, pos.y);

      // impulsion vers l'extérieur
      enfant.vel = PVector.sub(enfant.pos, parent.pos);
      enfant.vel.normalize();
      enfant.vel.mult(1.2);

      // courte immunité aux forces
      enfant.freeze = 6;

      return enfant;
    }
    tries++;
  }

  // fallback ultra rare
  return new Bulle(
    parent.pos.x + random(-50, 50),
    parent.pos.y + random(-50, 50)
  );
}

// =================================
// CLASSE BULLE
// =================================
class Bulle {
  PVector pos;
  PVector vel;
  float r = 10;
  int freeze = 0;

  Bulle(float x, float y) {
    pos = new PVector(x, y);
    vel = PVector.random2D().mult(0.3);
  }

  void update(ArrayList<Bulle> autres) {
    if (freeze > 0) {
      pos.add(vel);
      freeze--;
      return;
    }

    PVector force = new PVector();

    for (Bulle b : autres) {
      if (b == this) continue;

      float d = PVector.dist(pos, b.pos);
      if (d == 0) continue;

      // répulsion (hitbox)
      if (d < r * 2) {
        PVector rep = PVector.sub(pos, b.pos);
        rep.normalize();
        rep.mult(0.8);
        force.add(rep);
      }

      // attraction douce (cohésion)
      if (d > r * 3 && d < 140) {
        PVector att = PVector.sub(b.pos, pos);
        att.normalize();
        att.mult(0.02);
        force.add(att);
      }
    }

    vel.add(force);
    vel.limit(2);
    pos.add(vel);

    // limites écran
    pos.x = constrain(pos.x, r, width - r);
    pos.y = constrain(pos.y, r, height - r);
  }

  void display() {
    noStroke();
    fill(120, 180, 255);
    ellipse(pos.x, pos.y, r * 2, r * 2);
  }
}
