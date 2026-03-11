class Raid0 {
  ArrayList<ArrayList<Integer>> diskA, diskB;
  ArrayList<ArrayList<Integer>> merged;

  Raid0(ArrayList<ArrayList<Integer>> a, ArrayList<ArrayList<Integer>> b) {
    diskA = a;
    diskB = b;
    merged = new ArrayList<ArrayList<Integer>>();
    mergeDisks();
  }

  void mergeDisks() {
    for (int i = 0; i < diskA.size(); i++) {
      merged.add(new ArrayList<Integer>(diskA.get(i)));
    }
    for (int i = 0; i < diskB.size(); i++) {
      merged.add(new ArrayList<Integer>(diskB.get(i)));
    }
  }

  void show() {
    println("\n--- RAID 0 ---");
    for (int i = 0; i < merged.size(); i++) {
      println(merged.get(i));
    }
  }
}
