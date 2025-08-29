void setup(){
    size(400, 400);
    background(255);
    msg(); // affiche le message une seule fois
}

void draw() {
    background(255);
    noStroke();

    corps();
    leds();
    roues();
    tete();
    antenne();
    camer();
}


void corps() {
    // le corps
    fill(191);
    rect(165, 200, 70, 70);
}

void leds() {
    // les trois LEDs
    fill(255, 0, 0);
    rect(175, 220, 10, 10);
    fill(0, 255, 0);
    rect(195, 220, 10, 10);
    fill(0, 0, 255);
    rect(215, 220, 10, 10);
}
void roues() {
    // les roues
    fill(0);
    ellipse(180, 270, 20, 20);
    ellipse(220, 270, 20, 20);
}

void tete() {
    // la tête
    fill(191);
    arc(200, 195, 70, 70, -PI, 0, CHORD);
}

void camer() {
    // la caméra
    fill(63, 0, 0);
    ellipse(200, 180, 20, 20);
}

void antenne() {
    // l'antenne
    strokeWeight(3);
    line(200, 160, 200, 120);
}

void msg() {
    // le message
    println("Processing ... please wait");
}