float note = random(0, 20);

if (note > 16) {
  println("Assigner la note A.");
} else if (note > 12) {
  println("B");
} else if (note > 8) {
  println("C");
} else if (note > 4) {
  println("D");
} else {
  println("F");
}
println("Note obtenue: " + note);