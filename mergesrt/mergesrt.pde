int barsCount; // Nombre de barres défini par l'utilisateur
boolean sorting = true;
Visualizer visualizer;
int topMargin = 20;
boolean sorted = false;
int lastSortTime = 0;
int delayTime = 500;

void setup() {
  size(1900, 400);
  
  barsCount = int(random(10, 50)); // Exemple : entre 10 et 50 barres
  println("Nombre initial de barres : " + barsCount);
  
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
  text("Merge Sort Visualization", 10, 20);
  text("Number of bars: " + barsCount, 10, 40);

  if (sorting) {
    if (!visualizer.mergeSortStep()) {
      sorting = false;
      sorted = true;
      visualizer.markSorted(); // Marque les barres triées en rouge
      lastSortTime = millis(); // Enregistre le temps de fin du tri
    }
  } else if (sorted && millis() - lastSortTime >= delayTime) {
    // Attente de 0.5 sec, puis doublement des barres et redémarrage du tri
    barsCount *= 2;
    visualizer.initializeArray(barsCount);
    sorting = true;
    sorted = false;
  }
}

class Bar {
  float value;
  color col;

  // Constructeur par défaut
  Bar() {
    this.value = 0;
    this.col = color(0, 0, 255);
  }

  // Constructeur avec paramètres
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

  void barDraw() {
    int barWidth = max(2, width / bars.length); // Empêche les barres de disparaître
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
      bars[i].col = color(255, 0, 0); // Marque les barres triées en rouge
    }
  }
}
