ArrayCreator arraySystem;
Bars bars;
Sorthing sorter;
int x = 2;
boolean sorted = false;
int lastUpdate = 0;

void setup() {
  size(1900, 1000);
  arraySystem = new ArrayCreator(x);
  bars = new Bars(arraySystem);
  sorter = new Sorthing(arraySystem);
}

void draw() {
  background(0);

  // only run sorting step
  if (!sorter.sorted) {
    sorter.sortStep();
  } else if (millis() - lastUpdate > 1000) {
    // regenerate array once
    x = x*2; // optional
    arraySystem = new ArrayCreator(x);
    bars = new Bars(arraySystem);
    sorter = new Sorthing(arraySystem);
    lastUpdate = millis();
  }

  bars.display();
}
