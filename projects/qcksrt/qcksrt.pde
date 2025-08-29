import java.util.Stack;

int barsCount = 2; // Start with 2 bars
boolean sorting = true;
Visualizer visualizer;
int topMargin = 20;
boolean sorted = false;
int lastSortTime = 0;
int delayTime = 500; // Reduced delay time for faster transitions

void setup() {
  size(1900, 400);
  visualizer = new Visualizer();
  visualizer.initializeArray(barsCount);
  surface.setResizable(true);
  frameRate(60); // Increased frame rate for smoother and faster sorting
}

void draw() {
  background(255);
  visualizer.barDraw();

  fill(0);
  textSize(16);
  text("Quicksort Visualization", 10, 20);
  text("Number of bars: " + barsCount, 10, 40);

  if (sorting) {
    for (int i = 0; i < 10; i++) { // Perform multiple sorting steps per frame
      if (!visualizer.quickSortStep()) {
        sorting = false;
        sorted = true;
        visualizer.markSorted(); // Ensure sorted bars are marked red
        lastSortTime = millis(); // Capture the time when sorting completes
        break;
      }
    }
  } else if (sorted && millis() - lastSortTime >= 500) {
    // Wait briefly, then double bars and restart sorting
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
  Stack<int[]> stack = new Stack<int[]>(); // Stack for iterative quicksort
  boolean sorting = true;

  void initializeArray(int count) {
    bars = new Bar[count];
    for (int i = 0; i < count; i++) {
      bars[i] = new Bar(random(height - topMargin), color(0, 0, 255));
    }
    sorting = true;
    stack.clear();
    stack.push(new int[]{0, bars.length - 1}); // Push initial range
  }

  void barDraw() {
    int barWidth = max(2, width / bars.length); // Ensures bars never disappear
    for (int i = 0; i < bars.length; i++) {
      fill(bars[i].col);
      rect(i * barWidth, height - bars[i].value, barWidth - 1, bars[i].value);
    }
  }

  boolean quickSortStep() {
    if (!stack.isEmpty()) {
      int[] range = stack.pop();
      int low = range[0], high = range[1];

      if (low < high) {
        int pi = partition(low, high);

        // Push subarrays onto stack to process them in future frames
        stack.push(new int[]{low, pi - 1});
        stack.push(new int[]{pi + 1, high});
      }
      return true; // Sorting still in progress
    }
    return false; // Sorting done
  }

  int partition(int low, int high) {
    Bar pivot = bars[high];
    int i = low - 1;
    
    for (int j = low; j < high; j++) {
      if (bars[j].value <= pivot.value) {
        i++;
        swap(i, j);
      }
    }
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
