ArrayCreator arraySystem;
Bars bars;
int lastUpdate = 0;
int x = 2;

void setup() {
    size(1900, 1000);
    arraySystem = new ArrayCreator(x);
    bars = new Bars(arraySystem);
}

void draw() {
    background(0);

  // update numbers every 200 ms
    if (millis() - lastUpdate > 1000) {
        arraySystem = new ArrayCreator(x);
        bars = new Bars(arraySystem);
        arraySystem.generate();
        lastUpdate = millis();
        x = x*2;
    }

    bars.display();
}
