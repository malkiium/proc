// Bars.pde — separate file containing only the Bars class for Processing visualizations

class Bars {
  int[] a;
  float w;
  
  Bars(int[] arr) {
    a = arr;
    w = (float)width / a.length;
  }

  void update(int[] arr) {
    a = arr;
    w = (float)width / a.length;
  }

  void display() {
    int len = a.length;
    // find max within a to scale bar heights dynamically
    int localMax = 1;
    for (int v : a) if (v > localMax) localMax = v;

    noStroke();
    for (int i = 0; i < len; i++) {
      float h = map(a[i], 0, localMax, 0, - (height - 80)); // negative so bars go up
      float x = i * w;
      // color based on value (simple gradient)
      float hue = map(a[i], 0, localMax, 0, 255);
      fill(180 - hue * 0.5, 200, 220, 200);
      rect(x, 0, w - 1, h);
    }
  }
}