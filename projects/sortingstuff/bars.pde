class Bars {
    ArrayCreator data;

    Bars(ArrayCreator data) {
        this.data = data;
    }

    void display() {
        float barWidth = width / float(data.values.length);

        for (int j = 0; j < data.values.length; j++) {
            float barHeight = map(data.values[j], 0, 100, 0, height - 50);
            float x = j * barWidth;

            fill(100, 200, 250);
            rect(x, height - barHeight, barWidth, barHeight);
        }
    }
}
