int rows = 2; // Number of rows
int cols = 2; // Number of columns
boolean sorting = false; // Flag to indicate if sorting is in progress
RadixSortState rState; // State of the radix sort
Visualizer visualizer; // Visualizer object to handle drawing
int topMargin = 20; // Margin at the top to prevent bars from going out of the screen

void setup() {
  size(1900, 400); // Set the size of the window
  visualizer = new Visualizer(); // Create a new Visualizer object
  visualizer.initializeArray(rows, cols); // Initialize with 2x2 elements
  surface.setResizable(true); // Allow the window to be resizable
  frameRate(60); // Set the frame rate to 60 frames per second
}

void draw() {
  background(255); // Clear the background with white color
  visualizer.barDraw(); // Draw the bars

  // Display the number of bars at the top left
  fill(0); // Set the fill color to black
  textSize(16); // Set the text size
  text("Code of Eliott HALL.", 10, 40); // Display the author's name
  text("Number of bars: " + (visualizer.bars.length * visualizer.bars[0].length), 10, 20); // Display the number of bars

  if (sorting) {
    visualizer.radixSortStep(); // Perform a step of the radix sort if sorting is true
  }
}

// Recursive function to calculate factorial
int factorial(int n) {
  if (n <= 1) {
    return 1;
  } else {
    return n * factorial(n - 1);
  }
}

// Class to represent a complex number
class Complex {
  float real;
  float imag;

  Complex(float real, float imag) {
    this.real = real;
    this.imag = imag;
  }

  // Calculate the magnitude of the complex number
  float magnitude() {
    return sqrt(real * real + imag * imag);
  }
}

// Class to represent a bar in the visualization
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

// Class to handle the visualization
class Visualizer {
  Bar[][] bars; // 2D array of bars
  float initialMaxMagnitude; // Initial maximum magnitude of the bars

  // Initialize the array of bars
  void initializeArray(int newRows, int newCols) {
    // Prevent excessive growth or invalid sizes
    if (newRows < 1) newRows = 1;
    if (newCols < 1) newCols = 1;

    bars = new Bar[newRows][]; // Initialize row array first
    for (int i = 0; i < newRows; i++) {
      bars[i] = new Bar[newCols]; // Initialize column array
      for (int j = 0; j < newCols; j++) {
        bars[i][j] = new Bar(new Complex(random(0, 101), random(0, 101)), color(0, 0, 255), i, j); // Create a new bar with random values
      }
    }

    // Calculate the initial maximum magnitude
    initialMaxMagnitude = 0;
    for (int i = 0; i < bars.length; i++) {
      for (int j = 0; j < bars[i].length; j++) {
        initialMaxMagnitude = max(initialMaxMagnitude, bars[i][j].value.magnitude());
      }
    }

    sorting = true; // Set sorting to true
    rState = null; // Reset the radix sort state
  }

  // Draw the bars
  void barDraw() {
    int minBarWidth = 1; // Minimum bar width (adjust as needed)
    int barWidth = max(minBarWidth, width / (bars.length * bars[0].length)); // Calculate the bar width

    for (int i = 0; i < bars.length; i++) {
      for (int j = 0; j < bars[i].length; j++) {
        Bar bar = bars[i][j];

        // Highlight the current bar being processed
        if (rState != null) {
          if ((rState.phase == 0 || rState.phase == 1 || rState.phase == 3) && i == rState.countIndex) {
            bar.col = color(255, 0, 0); // Red color for the current bar
          } else if (rState.phase == 2 && i == rState.placeIndex) {
            bar.col = color(255, 0, 0); // Red color for the bar being placed
          } else {
            bar.col = color(0, 0, 255); // Default color for bars
          }
        } else {
          bar.col = color(0, 0, 255); // Default color for bars
        }

        // Adjust bar height based on the initial maximum magnitude
        int barHeight = int(map(bar.value.magnitude(), 0, initialMaxMagnitude, 0, height - topMargin));
        barHeight = constrain(barHeight, 5, height - topMargin); // Ensure a minimum height and fit in screen

        fill(bar.col); // Set the fill color to the bar's color
        rect((i * bars[i].length + j) * barWidth, height - barHeight, barWidth - 2, barHeight); // Draw the bar
      }
    }
  }

  // Perform a step of the radix sort
  void radixSortStep() {
    if (rState == null) {
      rState = new RadixSortState(bars); // Initialize the radix sort state
    }

    rState.step(); // Perform a step of the radix sort

    if (rState.done) {
      bars = rState.bars; // Update the bars with the sorted bars
      sorting = false; // Set sorting to false
      delay(1000); // Delay for 1 second

      // Only increase one of the dimensions at a time
      if (bars.length < bars[0].length) {
        initializeArray(bars.length * 2, bars[0].length); // Grow rows first
      } else {
        initializeArray(bars.length, bars[0].length * 2); // Then grow columns
      }

      rState = null; // Reset the radix sort state
    }
  }
}

// Class to handle the state of the radix sort
class RadixSortState {
  Bar[][] bars; // 2D array of bars
  int exp; // Current exponent (1, 10, 100, ...)
  int phase; // 0: counting frequency, 1: cumulative count, 2: placing into output, 3: copying output back
  int countIndex; // Iterator for counting/copying phases
  int placeIndex; // Iterator for placing phase (processes values in reverse)
  int[] count; // Frequency count array for digits 0-9
  Bar[][] output; // Temporary array to hold sorted order for the current digit
  float maxVal; // Maximum value in the array (to determine when sorting is done)
  boolean done; // Flag indicating if sorting is complete

  RadixSortState(Bar[][] arr) {
    bars = arr;
    maxVal = 0;
    for (int i = 0; i < bars.length; i++) {
      for (int j = 0; j < bars[i].length; j++) {
        if (bars[i][j].value.magnitude() > maxVal) maxVal = bars[i][j].value.magnitude(); // Find the maximum value
      }
    }
    exp = 1; // Initialize exponent to 1
    phase = 0; // Start with the counting frequency phase
    countIndex = 0; // Initialize count index
    placeIndex = bars.length * bars[0].length - 1; // Initialize place index
    count = new int[10]; // Initialize count array
    int newRows = bars.length > 0 ? bars.length : 1;
    int newCols = bars.length > 0 && bars[0].length > 0 ? bars[0].length : 1;
    output = new Bar[newRows][newCols]; // Initialize output array
    done = false; // Set done to false
  }

  // Perform a step of the radix sort
  void step() {
    if (exp > maxVal) {
      done = true; // Set done to true if exponent is greater than the maximum value
      return;
    }

    if (phase == 0) {
      // Counting frequency of digits
      if (countIndex < bars.length * bars[0].length) {
        int i = countIndex / bars[0].length;
        int j = countIndex % bars[0].length;
        int digit = int((bars[i][j].value.magnitude() / exp) % 10);
        count[digit]++; // Increment the count for the digit
        countIndex++;
      } else {
        phase = 1; // Move to the cumulative count phase
        countIndex = 0;
      }
    } else if (phase == 1) {
      // Cumulative count
      if (countIndex < 9) {
        count[countIndex + 1] += count[countIndex]; // Update the cumulative count
        countIndex++;
      } else {
        phase = 2; // Move to the placing into output phase
        placeIndex = bars.length * bars[0].length - 1;
      }
    } else if (phase == 2) {
      // Placing into output array
      if (placeIndex >= 0) {
        int i = placeIndex / bars[0].length;
        int j = placeIndex % bars[0].length;
        int digit = int((bars[i][j].value.magnitude() / exp) % 10);
        int outputIndex = count[digit] - 1;
        int outputRow = outputIndex / bars[0].length;
        int outputCol = outputIndex % bars[0].length;
        output[outputRow][outputCol] = bars[i][j]; // Place the bar in the output array
        count[digit]--;
        placeIndex--;
      } else {
        phase = 3; // Move to the copying output back phase
        countIndex = 0;
      }
    } else if (phase == 3) {
      // Copying output back to bars array
      if (countIndex < bars.length * bars[0].length) {
        int i = countIndex / bars[0].length;
        int j = countIndex % bars[0].length;
        bars[i][j] = output[i][j]; // Copy the bar from the output array to the bars array
        countIndex++;
      } else {
        exp *= 10; // Move to the next digit
        phase = 0; // Reset to the counting frequency phase
        countIndex = 0;
        placeIndex = bars.length * bars[0].length - 1;
        count = new int[10]; // Reset the count array
        output = new Bar[bars.length][bars[0].length]; // Reset the output array
      }
    }
  }
}