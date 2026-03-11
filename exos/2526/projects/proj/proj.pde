ArrayList<ArrayList<Integer>> disk1 = new ArrayList<ArrayList<Integer>>();
ArrayList<ArrayList<Integer>> disk2 = new ArrayList<ArrayList<Integer>>();
ArrayList<ArrayList<Integer>> disk3 = new ArrayList<ArrayList<Integer>>();

void setup() {
  size(800, 600);
  background(255);

  // Initialize disks
  disk1.add(new ArrayList<Integer>(List.of(0,0,0,1)));
  disk1.add(new ArrayList<Integer>(List.of(0,0,1,0)));
  disk1.add(new ArrayList<Integer>(List.of(0,1,0,0)));
  disk1.add(new ArrayList<Integer>(List.of(1,0,0,0)));

  disk2.add(new ArrayList<Integer>(List.of(0,1,0,1)));
  disk2.add(new ArrayList<Integer>(List.of(0,1,1,0)));
  disk2.add(new ArrayList<Integer>(List.of(1,1,0,0)));
  disk2.add(new ArrayList<Integer>(List.of(1,0,1,0)));

  disk3.add(new ArrayList<Integer>(List.of(0,1,1,1)));
  disk3.add(new ArrayList<Integer>(List.of(0,1,1,0)));
  disk3.add(new ArrayList<Integer>(List.of(1,1,0,1)));
  disk3.add(new ArrayList<Integer>(List.of(1,0,1,1)));

  // RAIDs
  new Raid0(disk1, disk2).show();
  new Raid1(disk1).show();
  new Raid4(disk1, disk2, disk3).show();
  new Raid5(disk1, disk2, disk3).show();
}
