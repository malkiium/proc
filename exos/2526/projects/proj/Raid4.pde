class Raid4 {
  ArrayList<ArrayList<Integer>> diskA, diskB, diskC;
  ArrayList<ArrayList<Integer>> parity;

  Raid4(ArrayList<ArrayList<Integer>> a, ArrayList<ArrayList<Integer>> b, ArrayList<ArrayList<Integer>> c) {
    diskA = a;
    diskB = b;
    diskC = c;
    parity = new ArrayList<ArrayList<Integer>>();
    computeParity();
  }

  void computeParity() {
    for (int i = 0; i < diskA.size(); i++) {
      ArrayList<Integer> row = new ArrayList<Integer>();
      for (int j = 0; j < diskA.get(i).size(); j++) {
        int p = diskA.get(i).get(j) ^ diskB.get(i).get(j) ^ diskC.get(i).get(j);
        row.add(p);
      }
      parity.add(row);
    }
  }

  void show() {
    println("\n--- RAID 4 ---");
    for (int i = 0; i < diskA.size(); i++) {
      println(diskA.get(i) + " | " + diskB.get(i) + " | " + diskC.get(i) + " | parity: " + parity.get(i));
    }
  }
}
