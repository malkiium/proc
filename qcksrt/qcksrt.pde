int[] values;
boolean sorting = false;
ArrayList<Task> tasks = new ArrayList<Task>();
PartitionState pState = null;

void setup() {
  size(1900, 400);
  initializeArray(150); // Adjust the array size as desired
}

void draw() {
  background(255);
  barDraw();
  
  if (sorting) {
    quickSortStep();
  }
}

// Draws the bars; if a bar is in the current partition, it is red.
void barDraw() {
  int barWidth = max(1, width / values.length);
  for (int i = 0; i < values.length; i++) {
    // Highlight bars in the active partition in red.
    if (pState != null && i >= pState.low && i <= pState.high) {
      fill(255, 0, 0); // Red
    } else {
      fill(0, 0, 255); // Blue
    }
    
    int barHeight = int(map(values[i], 0, 100, 0, height));
    rect(i * barWidth, height - barHeight, barWidth - 2, barHeight);
  }
}

// Performs one step of QuickSort per frame.
void quickSortStep() {
  if (pState != null) {
    // Process one step of partitioning per frame.
    if (pState.j < pState.high) {
      if (values[pState.j] < pState.pivot) {
        pState.i++;
        swap(values, pState.i, pState.j);
      }
      pState.j++;  // Move to the next element.
    } else {
      // Partition is complete; place the pivot in the correct position.
      swap(values, pState.i + 1, pState.high);
      int partitionIndex = pState.i + 1;
      
      // Add the left subarray task if it exists.
      if (pState.low < partitionIndex - 1) {
        tasks.add(new Task(pState.low, partitionIndex - 1));
      }
      // Add the right subarray task if it exists.
      if (partitionIndex + 1 < pState.high) {
        tasks.add(new Task(partitionIndex + 1, pState.high));
      }
      pState = null;  // Reset the current partition state.
    }
  } else {
    // If not partitioning, fetch the next task from the stack.
    if (tasks.size() > 0) {
      Task t = tasks.remove(tasks.size() - 1);
      if (t.low < t.high) {
        pState = new PartitionState(t.low, t.high);
      }
    } else {
      // Sorting is complete. Pause then reinitialize if desired.
      sorting = false;
      delay(1000);
      initializeArray(values.length * 2); // Example: double the array size.
    }
  }
}

// Helper function to swap two elements in the array.
void swap(int[] arr, int a, int b) {
  int temp = arr[a];
  arr[a] = arr[b];
  arr[b] = temp;
}

// Initializes the array with random values and resets sorting state.
void initializeArray(int newSize) {
  values = new int[newSize];
  for (int i = 0; i < values.length; i++) {
    values[i] = int(random(0, 101)); // Values range from 0 to 100.
  }
  tasks.clear();
  tasks.add(new Task(0, values.length - 1));
  sorting = true;
  pState = null;
}

// Represents a subarray to be sorted.
class Task {
  int low, high;
  Task(int low, int high) {
    this.low = low;
    this.high = high;
  }
}

// Holds the state of the current partition operation.
class PartitionState {
  int low, high, pivot, i, j;
  
  PartitionState(int low, int high) {
    this.low = low;
    this.high = high;
    pivot = values[high]; // Use the last element as pivot.
    i = low - 1;
    j = low;
  }
}
