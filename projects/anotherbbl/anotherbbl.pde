ArrayList<Integer> unsorted = new ArrayList<Integer>();
int unordered = 1;
int amount = 2; // number of bars
int maxValue = 100;

void setup() {
  size(1600, 400);
  fillListWithRandomNumbers(amount);
  frameRate(60); // fast sorting
}

void draw() {
  background(125);
  drawBars();

  if (unordered > 0) {
    unordered = 0;

    // one pass of bubble sort
    for (int i = 1; i < unsorted.size(); i++) {
      int current = unsorted.get(i);
      int prev = unsorted.get(i - 1);

      if (current < prev) {
        // swap
        unsorted.set(i, prev);
        unsorted.set(i - 1, current);
        unordered++;
      }
    }
  } else {

    // Increase amount and restart
    amount *= 2;

    fillListWithRandomNumbers(amount);
    unordered = 1;
  }
}

void fillListWithRandomNumbers(int count) {
  unsorted.clear();
  for (int i = 0; i < count; i++) {
    unsorted.add(int(random(10, maxValue)));
  }
}

void drawBars() {
  int barWidth = max(1, width / unsorted.size());

  for (int i = 0; i < unsorted.size(); i++) {
    int val = unsorted.get(i);
    int barHeight = int(map(val, 0, 100, 0, height));
    fill(0, 0, 255);
    rect(i * barWidth, height - barHeight, barWidth - 1, barHeight);
  }
}
