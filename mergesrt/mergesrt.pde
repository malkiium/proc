int barsCount = 2; // Start with 2 bars
boolean sorting = true;
Visualizer visualizer;
int topMargin = 20;
boolean sorted = false;
int lastSortTime = 0;
int delayTime = 500;

void setup() {
  size(1900, 400);
  visualizer = new Visualizer();
  visualizer.initializeArray(barsCount);
  surface.setResizable(true);
  frameRate(2);
}

void draw() {
  background(255);
  visualizer.barDraw();

  fill(0);
  textSize(16);
  text("Merge Sort Visualization", 10, 20);
  text("Number of bars: " + barsCount, 10, 40);

  if (sorting) {
    if (!visualizer.mergeSortStep()) {
      sorting = false;
      sorted = true;
      visualizer.markSorted(); // Ensure sorted bars are marked red
      lastSortTime = millis(); // Capture the time when sorting completes
    }
  } else if (sorted && millis() - lastSortTime >= delayTime) {
    // Wait 0.5 sec, then double bars and restart sorting
    barsCount *= 2;
    visualizer.initializeArray(barsCount);
    sorting = true;
    sorted = false;
  }
}

class Bar {
  float value;
  color col;

  Bar(float value, color col) {
    this.value = value;
    this.col = col;
  }
}

class Visualizer {
  Bar[] bars;
  int mergeStep;
  boolean sorting;

  void initializeArray(int count) {
    bars = new Bar[count];
    for (int i = 0; i < count; i++) {
      bars[i] = new Bar(random(height - topMargin), color(0, 0, 255));
    }
    sorting = true;
    mergeStep = 1;
  }

  // Modified barDraw() method
  void barDraw() {
    int barWidth = max(2, width / bars.length); // Ensures bars never disappear
    for (int i = 0; i < bars.length; i++) {
      fill(bars[i].col);
      rect(i * barWidth, height - bars[i].value, barWidth - 1, bars[i].value);
    }
  }

  boolean mergeSortStep() {
    if (mergeStep > bars.length) {
      return false;
    }
    
    for (int i = 0; i < bars.length; i += 2 * mergeStep) {
      merge(i, min(i + mergeStep, bars.length), min(i + 2 * mergeStep, bars.length));
    }
    
    mergeStep *= 2;
    if (mergeStep > bars.length) {
      markSorted();
      return false;
    }
    return true;
  }

  void merge(int left, int mid, int right) {
    int n1 = mid - left;
    int n2 = right - mid;
    Bar[] leftArray = new Bar[n1];
    Bar[] rightArray = new Bar[n2];

    for (int i = 0; i < n1; i++) leftArray[i] = bars[left + i];
    for (int j = 0; j < n2; j++) rightArray[j] = bars[mid + j];

    int i = 0, j = 0, k = left;
    while (i < n1 && j < n2) {
      if (leftArray[i].value <= rightArray[j].value) {
        bars[k++] = leftArray[i++];
      } else {
        bars[k++] = rightArray[j++];
      }
    }

    while (i < n1) bars[k++] = leftArray[i++];
    while (j < n2) bars[k++] = rightArray[j++];
  }

  void markSorted() {
    for (int i = 0; i < bars.length; i++) {
      bars[i].col = color(255, 0, 0); // Mark bars as sorted (red)
    }
  }
}
