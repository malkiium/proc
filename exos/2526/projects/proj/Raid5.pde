class Raid5 {
  ArrayList<ArrayList<Integer>> diskA, diskB, diskC;

  Raid5(ArrayList<ArrayList<Integer>> a, ArrayList<ArrayList<Integer>> b, ArrayList<ArrayList<Integer>> c) {
    diskA = new ArrayList<ArrayList<Integer>>();
    diskB = new ArrayList<ArrayList<Integer>>();
    diskC = new ArrayList<ArrayList<Integer>>();

    for (int i = 0; i < a.size(); i++) {
      diskA.add(new ArrayList<Integer>(a.get(i)));
      diskB.add(new ArrayList<Integer>(b.get(i)));
      diskC.add(new ArrayList<Integer>(c.get(i)));
    }

    computeRotatingParity();
  }

  void computeRotatingParity() {
    for (int i = 0; i < diskA.size(); i++) {
      int parityPos = i % 3;
      if (parityPos == 0) {
        for (int j = 0; j < diskA.get(i).size(); j++) {
          diskC.get(i).set(j, diskA.get(i).get(j) ^ diskB.get(i).get(j));
        }
      } else if (parityPos == 1) {
        for (int j = 0; j < diskA.get(i).size(); j++) {
          diskB.get(i).set(j, diskA.get(i).get(j) ^ diskC.get(i).get(j));
        }
      } else {
        for (int j = 0; j < diskA.get(i).size(); j++) {
          diskA.get(i).set(j, diskB.get(i).get(j) ^ diskC.get(i).get(j));
        }
      }
    }
  }

  void show() {
    println("\n--- RAID 5 ---");
    for (int i = 0; i < diskA.size(); i++) {
      println(diskA.get(i) + " | " + diskB.get(i) + " | " + diskC.get(i));
    }
  }
}
