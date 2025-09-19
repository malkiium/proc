class ArrayCreator {
    int[] values;
    int numBars;

    ArrayCreator(int numBars) {
        this.numBars = numBars;
        values = new int[numBars];
        generate();
    }

    void generate() {
        for (int i = 0; i < numBars; i++) {
        values[i] = int(random(0, 100));
        }
    }
}
