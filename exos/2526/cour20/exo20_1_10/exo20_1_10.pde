void setup() {
  Complexe z1 = new Complexe(3, 2);
  Complexe z2 = new Complexe(1, -1);
  Complexe z3 = new Complexe(4);
  Complexe z4 = new Complexe();
  Complexe z5 = new Complexe(z1);

  println("=== Constructeurs ===");
  println("z1 =", z1);          // 3.0+2.0i
  println("z2 =", z2);          // 3.0-2.0i (signe -)
  println("z3 =", z3);          // 4.0 (imaginaire nulle)
  println("z4 =", z4);          // 0.0 (défaut)
  println("z5 =", z5);          // 3.0+2.0i (copie de z1)

  println("\n=== Accesseurs ===");
  println("re(z1) =", z1.re()); // 3.0
  println("im(z1) =", z1.im()); // 2.0

  println("\n=== toString (cas particuliers) ===");
  println(new Complexe(0, 0));   // 0.0
  println(new Complexe(0, 1));   // i
  println(new Complexe(0, -1));  // -i
  println(new Complexe(0, 3));   // 3.0i
  println(new Complexe(2, 0));   // 2.0
  println(new Complexe(1, 1));   // 1.0+i
  println(new Complexe(1, -1));  // 1.0-i

  println("\n=== egal(Complexe) ===");
  println("z1.egal(z1) =", z1.egal(z1));          // true
  println("z1.egal(z5) =", z1.egal(z5));          // true  (copie)
  println("z1.egal(z2) =", z1.egal(z2));          // false

  println("\n=== egal(float) ===");
  println("z3.egal(4) =", z3.egal(4));            // true
  println("z1.egal(3) =", z1.egal(3));            // false (imaginaire != 0)

  println("\n=== plus ===");
  println("z1+z2 =", z1.plus(z2));                // 4.0+i
  println("z1+10 =", z1.plus(10));                // 13.0+2.0i

  println("\n=== moins ===");
  println("z1-z2 =", z1.moins(z2));               // 2.0+3.0i
  println("z1-1  =", z1.moins(1));                // 2.0+2.0i

  println("\n=== mult ===");
  println("z1*z2 =", z1.mult(z2));                // (3+2i)(1-i) = 5-i
  println("z1*3  =", z1.mult(3));                 // 9.0+6.0i

  println("\n=== div ===");
  println("z1/z2 =", z1.div(z2));                 // (3+2i)/(1-i) = 0.5+2.5i
  println("z1/2  =", z1.div(2));                  // 1.5+i

  println("\n=== mod ===");
  println("mod(z1) =", z1.mod());                 // sqrt(13) ≈ 3.6056

  println("\n=== conj ===");
  println("conj(z1) =", z1.conj());               // 3.0-2.0i
  println("conj(conj(z1)).egal(z1) =", z1.conj().conj().egal(z1)); // true

  println("\n=== z*conj(z) == mod^2 ===");
  println(z1.mult(z1.conj()).egal(z1.mod() * z1.mod())); // true

  println("\n=== arg ===");
  println("arg(1+i) =", new Complexe(1, 1).arg()); // π/4 ≈ 0.7854

  println("\n=== puissance ===");
  println("(1+i)^5 =", new Complexe(1, 1).puissance(5)); // -4.0-4.0i
  println("(1+i)^0 =", new Complexe(1, 1).puissance(0)); // 1.0
  println("(1+i)^1 =", new Complexe(1, 1).puissance(1)); // 1.0+i

  println("\n=== enchaînement ===");
  // (5*z1*z2 - 4) * (z1² + 2*z2)
  println(z1.mult(z2).mult(5).moins(4).mult(z1.mult(z1).plus(z2.mult(2))));
}

void draw() {}
