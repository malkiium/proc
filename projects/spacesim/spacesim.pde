ArrayList<Body> bodies = new ArrayList<Body>();
float G = 1000;
float dt = 0.1;

void setup() {
  size(1900, 1400);
  textAlign(CENTER, CENTER);
  textSize(12);
  smooth(18);
  frameRate(12);

  // Sun
  Body sun = new Body(width/2, height/2, 125); // 125px radius
  sun.massEarths = 333000;
  sun.radius = 125;
  sun.isSun = true;
  sun.name = "Sun";
  sun.col = color(255, 200, 0);
  bodies.add(sun);

  // Planets (mass, distance from Sun, radius, name, color)
  addPlanet(0.055, 150, 2, "Mercury", color(150));           // Mercury gray
  addPlanet(0.815, 200, 4.5, "Venus", color(255, 165, 0));   // Venus orange
  addPlanet(1, 250, 5, "Earth", color(0, 102, 255));         // Earth blue
  addPlanet(0.107, 300, 2.5, "Mars", color(255, 0, 0));      // Mars red
  addPlanet(318, 375, 55, "Jupiter", color(255, 165, 0));    // Jupiter orange
  addPlanet(95, 450, 45, "Saturn", color(255, 255, 0));      // Saturn yellow
  addPlanet(14, 525, 17.5, "Uranus", color(173, 216, 230));  // Uranus lightBlue
  addPlanet(17, 600, 18.5, "Neptune", color(0, 0, 255));     // Neptune darkBlue
}

void draw() {
  background(0);

  applyGravity();
  handleCollisions();
  updateBodies();

  for (Body b : bodies) {
    fill(b.col);
    noStroke();
    ellipse(b.pos.x, b.pos.y, b.radius*2, b.radius*2);

    fill(255);
    text(b.name, b.pos.x, b.pos.y - b.radius - 10);
  }
}

// ==========================
// Add planet with circular orbit
// ==========================
void addPlanet(float mass, float dist, float radius, String name, int c) {
  Body sun = bodies.get(0);
  float angle = random(TWO_PI);
  PVector pos = new PVector(
    sun.pos.x + dist * cos(angle),
    sun.pos.y + dist * sin(angle)
  );

  Body planet = new Body(pos.x, pos.y, radius);
  planet.massEarths = mass;
  planet.name = name;
  planet.col = c;

  // Circular orbit speed: v = sqrt(G*M/r)
  float speed = sqrt(G * sun.massEarths / dist);
  PVector dir = PVector.sub(pos, sun.pos).normalize();
  PVector vel = new PVector(-dir.y, dir.x).mult(speed);
  planet.vel = vel;

  bodies.add(planet);
}

// ==========================
// Physics
// ==========================
void applyGravity() {
  for (int i = 0; i < bodies.size(); i++) {
    Body a = bodies.get(i);
    for (int j = i+1; j < bodies.size(); j++) {
      Body b = bodies.get(j);
      PVector dir = PVector.sub(b.pos, a.pos);
      float distSq = constrain(dir.magSq(), 25, 1e9);
      float force = (G * a.massEarths * b.massEarths) / distSq;
      dir.normalize();
      PVector f = dir.copy().mult(force);
      a.applyForce(f);
      b.applyForce(f.mult(-1));
    }
  }
}

void handleCollisions() {
  for (int i = bodies.size()-1; i >= 0; i--) {
    Body a = bodies.get(i);
    for (int j = i-1; j >= 0; j--) {
      Body b = bodies.get(j);
      if (PVector.dist(a.pos, b.pos) < a.radius + b.radius) {
        Body merged = mergeBodies(a, b);
        bodies.remove(i);
        bodies.remove(j);
        bodies.add(merged);
        break;
      }
    }
  }
}

Body mergeBodies(Body a, Body b) {
  float totalMass = a.massEarths + b.massEarths;
  PVector newVel = PVector.add(
    PVector.mult(a.vel, a.massEarths),
    PVector.mult(b.vel, b.massEarths)
  ).div(totalMass);

  PVector newPos = PVector.add(
    PVector.mult(a.pos, a.massEarths),
    PVector.mult(b.pos, b.massEarths)
  ).div(totalMass);

  Body merged = new Body(newPos.x, newPos.y, 10);
  merged.massEarths = totalMass;
  merged.vel = newVel.copy();

  if (a.isSun || b.isSun || totalMass > 100000) {
    merged.isSun = true;
    merged.radius = 125;
    merged.col = color(255, 200, 0);
    merged.name = "Sun";
  } else {
    merged.updateRadius();
    merged.col = (a.massEarths > b.massEarths) ? a.col : b.col;
    merged.name = (a.massEarths > b.massEarths) ? a.name : b.name;
  }

  return merged;
}

void updateBodies() {
  for (Body b : bodies) {
    b.update(dt);
  }
}

// ==========================
// Body class
// ==========================
class Body {
  PVector pos, vel, acc;
  float radius;
  float massEarths;
  boolean isSun = false;
  String name = "";
  int col;

  Body(float x, float y, float r) {
    pos = new PVector(x, y);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    radius = r;
  }

  void updateRadius() {
    radius = radius;
  }

  void applyForce(PVector f) {
    acc.add(PVector.div(f, massEarths));
  }

  void update(float dt) {
    vel.add(PVector.mult(acc, dt));
    pos.add(PVector.mult(vel, dt));
    acc.mult(0);
  }
}
