float scaler = 1;
long points = 0;
int ptsPC = 1;
boolean mouseHeld = false;

//clic upgrade variables
int clcUpNmb = 0;
int clcUpgLvl = 0;
int cstClcUpg = 100;
//buy max stuff
int maxClcUpgrd;

//eyes
float mvmntscl = 0.5;
float mvmnt = 0;

void setup() {
  size(1000, 800);
  surface.setResizable(true);
}

void slime() {
  noStroke();
  rectMode(CORNER);
  //outer layer
  fill(0, 255, 0, 50);
  rect((width/10)-(scaler/2), (height/4)-(scaler/2), (width/3)+scaler, (height/3)+scaler);
  //inner layer
  fill(0, 255, 0);
  rect((width/8)-(scaler/2), (height/3.6)-(scaler/2), (width/3.6)+scaler, (height/3.6)+scaler);
  rectMode(CORNERS);
  //eyes
  fill(0);
  rect((width/6.5)+mvmnt, height/3, (width/5.75)+mvmnt, height/2.5);
  rect(((width/6.5)+mvmnt)+100, height/3, ((width/5.75)+mvmnt)+100, height/2.5);
  //eye movement
  mvmnt += mvmntscl;
  if (mvmnt > 50 || mvmnt < -10) {
    mvmntscl *= -1;
  }
}

void slimeClick() {
  if (mouseX > (width/10)-scaler && mouseX < (width/10+width/3)+scaler && mouseY > (height/4)-scaler && mouseY < (height/4+height/3)+scaler) {
    if (mousePressed && !mouseHeld) {
      scaler = 30;
      points += ptsPC;
      mouseHeld = true;
    } else {
      scaler = 1;
    }
  }
}

void upgrdBar() {
  fill(50);
  rectMode(CORNERS);
  rect(width/1.7, 0, width, height);
}

void clickUpgrd() {
  fill(150);
  rect(width/1.6, height/10, width/1.05, height/6);
  fill(255);
  textSize(20);
  String clcUpgrd = "+1 per click. cost : " + cstClcUpg + "pts. level : " + clcUpgLvl;
  text(clcUpgrd, width/1.55, height/7);
  if (mouseX > width/1.6 && mouseX < width/1.05 && mouseY > height/10 && mouseY < height/6) {
    if (mousePressed && points >= cstClcUpg && !mouseHeld) {
      mouseHeld = true;
      points -= cstClcUpg;
      ptsPC +=1;
      clcUpgLvl++;
    }
  }
}

void clickMaxUpgrd() {
  maxClcUpgrd = (int)points/cstClcUpg;
  fill(100);
  rect(width/1.6, height/6, width/1.05, height/4.5);
  fill(255);
  textSize(20);
  String clcMxUpgrd = "buy max : " + maxClcUpgrd;
  text(clcMxUpgrd, width/1.55, height/5);
  if (mouseX > width/1.6 && mouseX < width/1.05 && mouseY > height/6 && mouseY < height/4.5) {
    if (mousePressed && maxClcUpgrd >= 1 && !mouseHeld) {
      mouseHeld = true;
      points -= cstClcUpg*maxClcUpgrd;
      ptsPC += 1*maxClcUpgrd;
      clcUpgLvl += 1*maxClcUpgrd;
    }
  }
}

void score() {
  fill(255);
  textSize(32);
  String scur = "Points : " + points;
  text(scur, width/12, height/15);
}

void mouseReleased() {
  mouseHeld = !mouseHeld;
}

void draw() {
  background(0);
  slime();
  slimeClick();
  upgrdBar();
  score();
  clickUpgrd();
  clickMaxUpgrd();
}
