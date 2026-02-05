String[] sNotes;
int[] notes;
float sommeNotes = 0;
float moyenne = 0;
int[] distrib;

void setup() {
  size(800, 400);
  frameRate(10000000);

  sNotes = loadStrings("notes.txt");
  notes = int(sNotes);
  distrib = int[20];

    for (int i = 0; i<sNotes.length; i++) {
        sommeNotes += notes[i];
    }
    moyenne = sommeNotes/sNotes.length;
    println(moyenne);
}

void draw() {
}