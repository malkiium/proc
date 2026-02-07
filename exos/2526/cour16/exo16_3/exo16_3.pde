Snake leader;
Snake[] followers = new Snake[10];

void setup() {
  size(800, 800);
  leader = new Snake(50, color(255, 0, 0), 0, 0, 0);
  for (int i = 0; i < followers.length; i++) {
    followers[i] = new Snake(int(random(20, 80)),
      color(random(255), random(255), random(255)), random(2, 10),
      random(width), random(height));
  }
}

void draw() {
  background(0);
  leader.deplacer(mouseX, mouseY);
  leader.dessiner();
  followers[0].avancerVers(leader.getXQueue(), leader.getYQueue());
  followers[0].dessiner();
  
  int i = 1;
   while ( i < followers.length) {
    followers[i].avancerVers(followers[i-1].getXQueue(), followers[i-1].getYQueue());
    followers[i].dessiner();
    i++;
  }
}
