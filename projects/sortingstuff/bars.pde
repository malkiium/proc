int[] values;
int numBars = 20;

void setup() {
    size(1900, 1000);
    values = new int[numBars];

    for (int i = 0; i < numBars; i++) {
        values[i] = int(random(0, 100));
    }
}

void draw() {
    background(0);

    float barWidth = width / float(values.length);

    for (int j = 0; j < values.length; j++){
        float barHeight = map(values[j], 0, 100, 0, height-50);

        float x = j*barWidth;

        fill(100, 200, 250);
        rect(x, height - barHeight, barWidth, barHeight);
    }
}