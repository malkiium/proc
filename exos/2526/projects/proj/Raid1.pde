class Raid1 {
  ArrayList<ArrayList<Integer>> disk;
  ArrayList<ArrayList<Integer>> copy;

  Raid1(ArrayList<ArrayList<Integer>> d) {
    disk = d;
    copy = new ArrayList<ArrayList<Integer>>();
    for (int i = 0; i < d.size(); i++) {
      copy.add(new ArrayList<Integer>(d.get(i)));
    }
  }

  void show() {
    println("\n--- RAID 1 ---");
    for (int i = 0; i < copy.size(); i++) {
      println(copy.get(i));
    }
  }
}
