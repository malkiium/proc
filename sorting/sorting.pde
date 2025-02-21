int hell[]; 
boolean sorting = false;
int currentIndex = 0; // Tracks sorting progress

void setup() {
  size(1900, 400);
  initializeArray(2); // Start with 2 elements
}

void draw() {
  background(255);
  barDraw();

  if (sorting) {
    barsort();
  }
}

void barDraw() {
  // Calculate the bar width based on the screen size and the length of hell[]
  int barWidth = max(1, width / hell.length);  // Ensure barWidth never becomes 0

  for (int i = 0; i < hell.length; i++) {
    int barHeight = int(map(hell[i], 0, 100, 0, height)); // Scale value to fit screen height

    fill(0, 0, 255); // Blue color for bars
    rect(i * barWidth, height - barHeight, barWidth - 2, barHeight); // Draw each bar
  }
}

// Bubble Sort with visualization
void barsort() {
  if (currentIndex < hell.length - 1) {
    for (int j = 0; j < hell.length - 1 - currentIndex; j++) {
      if (hell[j] > hell[j + 1]) {
        // Swap
        int temp = hell[j];
        hell[j] = hell[j + 1];
        hell[j + 1] = temp;
      }
    }
    currentIndex++;
  } else {
    sorting = false; // Sorting finished
    delay(1000); // Pause before resetting
    initializeArray(hell.length * 2); // Double the array size
    println(hell.length); // Print the new array size
  }
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
