void setup() {
  size(200, 200);
  frameRate(30);
  ellipse(width/2, height/2, width/3, height/3);
  line(0, 0, width, height);
  line(width, 0, 0, height);
  rect(width/10, height/2-height/15, width/9, height/10);
  rect(width/1.3, height/2-height/15, width/9, height/10);
}

void keyPressed() {
  // on affiche la dernière touche
  println(key);
}