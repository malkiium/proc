// A basic Complex class with real and imaginary parts, and a magnitude method.
class Complex {
  float re;
  float im;
  
  Complex(float re, float im) {
    this.re = re;
    this.im = im;
  }
  
  // Returns the magnitude (Euclidean norm) of the complex number.
  float magnitude() {
    return sqrt(re * re + im * im);
  }
}

int rows = 2;
int cols = 2;
boolean sorting = false;    // Flag indicating if sorting is in progress.
boolean finalPause = false; // Flag for the final pause when sorting completes.
long pauseStartTime = 0;    // Timestamp to track when the pause started.
RadixSortState rState;      // Object holding the radix sort state.
Visualizer visualizer; 
int topMargin = 20;         // Margin at the top for drawing bars.
int stepsPerFrame = 100;    // Sorting steps executed per frame.

void setup() {
  size(1900, 400);
  visualizer = new Visualizer();
  visualizer.initializeArray(rows, cols); // Initialize the grid with random bars.
  surface.setResizable(true);
  frameRate(60);
}

void draw() {
  background(255);
  visualizer.barDraw(); // Draw all bars.
  
  // Display header text.
  fill(0);
  textSize(16);
  text("Code of Eliott HALL.", 10, 40);
  int totalBars = visualizer.rows * visualizer.cols;
  text("Number of bars: " + totalBars, 10, 20);
  
  // Process multiple radix sort steps per frame.
  if (sorting) {
    for (int s = 0; s < stepsPerFrame && sorting; s++) {
      visualizer.radixSortStep();
    }
  }
  
  // After sorting, wait for 1 second before expanding the grid.
  if (finalPause && (millis() - pauseStartTime >= 1000)) {
    visualizer.expandGrid();
    finalPause = false;
  }
}

// Represents a visual bar with a Complex value.
class Bar {
  Complex value;
  color col;
  int row, colIndex;
  
  Bar(Complex value, color col, int row, int colIndex) {
    this.value = value;
    this.col = col;
    this.row = row;
    this.colIndex = colIndex;
  }
}

// Handles visualization of the array and sorting.
class Visualizer {
  Bar[][] bars;           // 2D array of bars.
  float initialMaxMagnitude;  // Used to scale bar heights.
  int rows, cols;         // Current grid dimensions.
  
  // Initializes a new array of bars.
  void initializeArray(int newRows, int newCols) {
    rows = max(newRows, 1);
    cols = max(newCols, 1);
    bars = new Bar[rows][cols];
    
    // Populate the grid with bars having random complex values.
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        bars[i][j] = new Bar(new Complex(random(0, 101), random(0, 101)), color(0, 0, 255), i, j);
      }
    }
    
    // Determine the maximum magnitude for scaling.
    initialMaxMagnitude = 0;
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        initialMaxMagnitude = max(initialMaxMagnitude, bars[i][j].value.magnitude());
      }
    }
    
    sorting = true;   // Begin sorting.
    rState = null;    // Reset sort state.
  }
  
  // Draws the bars on screen.
  void barDraw() {
    int totalBars = rows * cols;
    int barWidth = max(1, width / totalBars);
    
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        Bar bar = bars[i][j];
        int flatIndex = i * cols + j; // Flatten the 2D index.
        
        // Change color based on the sorting state.
        if (rState != null) {
          if ((rState.phase == 0 || rState.phase == 1 || rState.phase == 3) && flatIndex == rState.countIndex) {
            bar.col = color(255, 0, 0);  // Red for current counting phase.
          } else if (rState.phase == 2 && flatIndex == rState.placeIndex) {
            bar.col = color(255, 0, 0);  // Red when placing into output.
          } else {
            bar.col = color(0, 0, 255);  // Default blue.
          }
        } else {
          bar.col = color(0, 0, 255);
        }
        
        // Compute the bar's height and draw it.
        int barHeight = int(map(bar.value.magnitude(), 0, initialMaxMagnitude, 0, height - topMargin));
        barHeight = constrain(barHeight, 5, height - topMargin);
        rect(flatIndex * barWidth, height - barHeight, barWidth - 2, barHeight);
      }
    }
  }
  
  // Executes one step of the radix sort.
  void radixSortStep() {
    if (rState == null) {
      rState = new RadixSortState(bars, rows, cols);
    }
    rState.step();
    
    // When sorting is done, mark for a final pause.
    if (rState.done) {
      bars = rState.bars;
      sorting = false;
      finalPause = true;
      pauseStartTime = millis();
    }
  }
  
  // Doubles the grid dimensions after the pause.
  void expandGrid() {
    if (rows < cols) {
      initializeArray(rows * 2, cols);
    } else {
      initializeArray(rows, cols * 2);
    }
    rState = null;
  }
}

// Maintains state for a single pass of radix sort.
class RadixSortState {
  Bar[][] bars;
  int rows, cols;
  int exp;         // Exponent: 1, 10, 100, etc.
  int phase;       // 0: count, 1: cumulative, 2: place, 3: copy back.
  int countIndex;  // Index used in counting/copy phases.
  int placeIndex;  // Index used in placing phase.
  int[] count;     // Frequency array for digits 0-9.
  Bar[][] output;  // Temporary array for sorted order.
  float maxVal;    // Maximum value in the array.
  boolean done;    // Flag indicating completion of sort.
  
  RadixSortState(Bar[][] arr, int rows, int cols) {
    this.rows = rows;
    this.cols = cols;
    bars = arr;
    maxVal = 0;
    int total = rows * cols;
    // Find the maximum magnitude to decide when to stop.
    for (int i = 0; i < total; i++) {
      int r = i / cols;
      int c = i % cols;
      float mag = bars[r][c].value.magnitude();
      if (mag > maxVal) maxVal = mag;
    }
    exp = 1;
    phase = 0;
    countIndex = 0;
    placeIndex = total - 1;
    count = new int[10];
    output = new Bar[rows][cols];
    done = false;
  }
  
  // Process a single step of the radix sort algorithm.
  void step() {
    if (exp > maxVal) {
      done = true;
      return;
    }
    
    int total = rows * cols;
    if (phase == 0) { // Counting frequency of digits.
      if (countIndex < total) {
        int i = countIndex / cols;
        int j = countIndex % cols;
        int digit = int((bars[i][j].value.magnitude() / exp) % 10);
        count[digit]++;
        countIndex++;
      } else {
        phase = 1;
        countIndex = 0;
      }
    } else if (phase == 1) { // Convert counts to cumulative counts.
      if (countIndex < 9) {
        count[countIndex + 1] += count[countIndex];
        countIndex++;
      } else {
        phase = 2;
        placeIndex = total - 1;
      }
    } else if (phase == 2) { // Place elements into output array.
      if (placeIndex >= 0) {
        int i = placeIndex / cols;
        int j = placeIndex % cols;
        int digit = int((bars[i][j].value.magnitude() / exp) % 10);
        int outputIndex = count[digit] - 1;
        int outRow = outputIndex / cols;
        int outCol = outputIndex % cols;
        output[outRow][outCol] = bars[i][j];
        count[digit]--;
        placeIndex--;
      } else {
        phase = 3;
        countIndex = 0;
      }
    } else if (phase == 3) { // Copy sorted elements back.
      if (countIndex < total) {
        int i = countIndex / cols;
        int j = countIndex % cols;
        bars[i][j] = output[i][j];
        countIndex++;
      } else {
        exp *= 10; // Move to next digit.
        phase = 0;
        countIndex = 0;
        placeIndex = total - 1;
        count = new int[10];  // Reset count array.
        output = new Bar[rows][cols];  // Reset output array.
      }
    }
  }
}
