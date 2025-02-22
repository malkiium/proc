int[] values;
boolean sorting = false;
RadixSortState rState;

void setup() {
  size(1900, 400);
  initializeArray(150); // Start with 150 elements
}

void draw() {
  background(255);
  barDraw();
  
  if (sorting) {
    radixSortStep();
  }
}

// Draws the bars; the active element in the current phase is shown in red.
void barDraw() {
  int barWidth = max(1, width / values.length);
  for (int i = 0; i < values.length; i++) {
    // Highlight the element currently being processed in red.
    if (rState != null) {
      // For phases 0, 1, and 3, highlight the bar at countIndex.
      // For phase 2, highlight the bar at placeIndex.
      if ((rState.phase == 0 || rState.phase == 1 || rState.phase == 3) && i == rState.countIndex) {
        fill(255, 0, 0);
      } else if (rState.phase == 2 && i == rState.placeIndex) {
        fill(255, 0, 0);
      } else {
        fill(0, 0, 255);
      }
    } else {
      fill(0, 0, 255);
    }
    
    int barHeight = int(map(values[i], 0, 100, 0, height));
    rect(i * barWidth, height - barHeight, barWidth - 2, barHeight);
  }
}

// Executes one step of the Radix Sort per frame.
void radixSortStep() {
  if (rState == null) {
    rState = new RadixSortState(values);
  }
  
  rState.step();
  
  // When the radix sort is finished, update the values and restart after a pause.
  if (rState.done) {
    values = rState.values;
    sorting = false;
    delay(1000);
    initializeArray(values.length * 2); // Example: double array size for next run
    rState = null;
  }
}

// Initializes the array with random values between 0 and 100.
void initializeArray(int newSize) {
  values = new int[newSize];
  for (int i = 0; i < values.length; i++) {
    values[i] = int(random(0, 101));
  }
  sorting = true;
  rState = null;
}

// RadixSortState class encapsulates the state and phases of a single digit pass.
class RadixSortState {
  int[] values;
  int exp;         // Current exponent (1, 10, 100, ...)
  int phase;       // 0: counting frequency, 1: cumulative count, 2: placing into output, 3: copying output back
  int countIndex;  // Iterator for counting/copying phases
  int placeIndex;  // Iterator for placing phase (processes values in reverse)
  int[] count;     // Frequency count array for digits 0-9
  int[] output;    // Temporary array to hold sorted order for the current digit
  int maxVal;      // Maximum value in the array (to determine when sorting is done)
  boolean done;    // Flag indicating if sorting is complete
  
  // Constructor: initializes state for the first digit pass.
  RadixSortState(int[] arr) {
    values = arr;
    maxVal = 0;
    for (int i = 0; i < values.length; i++) {
      if (values[i] > maxVal) maxVal = values[i];
    }
    exp = 1;
    phase = 0;
    countIndex = 0;
    placeIndex = values.length - 1;
    count = new int[10];
    output = new int[values.length];
    done = false;
  }
  
  // Processes one small step of the current phase per frame.
  void step() {
    // If all digits have been processed, mark as done.
    if (exp > maxVal) {
      done = true;
      return;
    }
    
    if (phase == 0) {
      // Phase 0: Count the frequency of each digit for the current exponent.
      if (countIndex < values.length) {
        int digit = (values[countIndex] / exp) % 10;
        count[digit]++;
        countIndex++;
      } else {
        phase = 1;
        countIndex = 0;
      }
    } else if (phase == 1) {
      // Phase 1: Transform the count array to cumulative counts.
      if (countIndex < 9) {
        count[countIndex + 1] += count[countIndex];
        countIndex++;
      } else {
        phase = 2;
        placeIndex = values.length - 1;
      }
    } else if (phase == 2) {
      // Phase 2: Build the output array by placing each element in its correct position.
      if (placeIndex >= 0) {
        int digit = (values[placeIndex] / exp) % 10;
        output[count[digit] - 1] = values[placeIndex];
        count[digit]--;
        placeIndex--;
      } else {
        phase = 3;
        countIndex = 0;
      }
    } else if (phase == 3) {
      // Phase 3: Copy the sorted output array back into the values array.
      if (countIndex < values.length) {
        values[countIndex] = output[countIndex];
        countIndex++;
      } else {
        // Completed processing one digit; prepare for the next pass.
        exp *= 10;
        phase = 0;
        countIndex = 0;
        placeIndex = values.length - 1;
        count = new int[10];
        output = new int[values.length];
      }
    }
  }
}
