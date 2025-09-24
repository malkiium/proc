class Sorthing {
    ArrayCreator data;
    int i = 0;
    int j = 0;
    boolean sorted = false;

    Sorthing(ArrayCreator data) {
        this.data = data;
    }

  // bubble sort step
    void sortStep() {
        if (i < data.values.length) {
            if (j < data.values.length - i - 1) {
                if (data.values[j] > data.values[j+1]) {
                    int temp = data.values[j];
                    data.values[j] = data.values[j+1];
                data.values[j+1] = temp;
                }
                j++;
            } else {
                j = 0;
                i++;
            }
        } else {
            sorted = true; // done sorting
        }
    }
}
