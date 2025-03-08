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
  frameRate(6);
}

void draw() {
  background(255);
  visualizer.barDraw();

  fill(0);
  textSize(16);
  text("Quicksort Visualization", 10, 20);
  text("Number of bars: " + barsCount, 10, 40);

  if (sorting) {
    if (!visualizer.quickSortStep()) {
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
  boolean sorting;
  boolean partitioningInProgress = false;  // To check if partitioning is in progress

  void initializeArray(int count) {
    bars = new Bar[count];
    for (int i = 0; i < count; i++) {
      bars[i] = new Bar(random(height - topMargin), color(0, 0, 255));
    }
    sorting = true;
  }

  // Modified barDraw() method
  void barDraw() {
    int barWidth = max(2, width / bars.length); // Ensures bars never disappear
    for (int i = 0; i < bars.length; i++) {
      fill(bars[i].col);
      rect(i * barWidth, height - bars[i].value, barWidth - 1, bars[i].value);
    }
  }

  boolean quickSortStep() {
    if (sorting) {
      // Start quicksort by calling the partition method
      quickSort(0, bars.length - 1);
      sorting = false; // Only perform sorting once, after partitioning
      return false;
    }
    return true;
  }

  // Step-by-step quicksort
  void quickSort(int low, int high) {
    if (low < high) {
      int pi = partition(low, high);
      // Swap pivot and recursively sort the subarrays one step at a time
      partitioningInProgress = true; // Mark partitioning as in progress
    }
  }

  // Partitioning step: returns the index of pivot after it is placed correctly
  int partition(int low, int high) {
    // Choose the pivot element (for simplicity, we'll pick the last element as pivot)
    Bar pivot = bars[high];
    int i = low - 1; // index of smaller element

    // Reorder the array so that elements smaller than pivot are to the left
    // and larger elements are to the right of the pivot
    for (int j = low; j < high; j++) {
      if (bars[j].value <= pivot.value) {
        i++;
        swap(i, j);
      }
    }
    // Swap the pivot element with the element at i+1, so the pivot is in its correct position
    swap(i + 1, high);
    return i + 1;
  }

  void swap(int i, int j) {
    Bar temp = bars[i];
    bars[i] = bars[j];
    bars[j] = temp;
  }

  void markSorted() {
    for (int i = 0; i < bars.length; i++) {
      bars[i].col = color(255, 0, 0); // Mark bars as sorted (red)
    }
  }
}
