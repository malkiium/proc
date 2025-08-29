int hell[];
boolean sorting = false;
int currentIndex = 0; // Tracks sorting progress
int passesPerFrame = 5; // Increase this to speed up sorting

void setup() {
  size(1900, 400);
  initializeArray(2); // Start with 2 elements
}

void draw() {
  background(255);
  barDraw();

  if (sorting) {
    for (int k = 0; k < passesPerFrame; k++) { // Perform multiple passes per frame
      barsort();
    }
  }
}

void barDraw() {
  int barWidth = max(1, width / hell.length); // Ensure barWidth never becomes 0

  for (int i = 0; i < hell.length; i++) {
    int barHeight = int(map(hell[i], 0, 100, 0, height)); // Scale value to fit screen height
    fill(0, 0, 255);
    rect(i * barWidth, height - barHeight, barWidth - 2, barHeight);
  }
}

// Optimized Bubble Sort with early exit
void barsort() {
  boolean swapped = false;
  
  if (currentIndex < hell.length - 1) {
    for (int j = 0; j < hell.length - 1 - currentIndex; j++) {
      if (hell[j] > hell[j + 1]) {
        swap(j, j + 1);
        swapped = true;
      }
    }
    currentIndex++;

    if (!swapped) { // Stop early if no swaps were made
      sorting = false;
      resetArray();
    }
  } else {
    sorting = false;
    resetArray();
  }
}

// Swap function
void swap(int i, int j) {
  int temp = hell[i];
  hell[i] = hell[j];
  hell[j] = temp;
}

// Reset and double array size
void resetArray() {
  initializeArray(hell.length * 2); // Double array size
  println("New size: " + hell.length);
}

// Function to reset array with random values
void initializeArray(int newSize) {
  hell = new int[newSize];
  for (int i = 0; i < hell.length; i++) {
    hell[i] = int(random(0, 100));
  }
  currentIndex = 0;
  sorting = true;
}
