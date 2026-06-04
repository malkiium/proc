class Complexe {
  private float a;
  private float b;

  Complexe(float a, float b) {
    this.a = a;
    this.b = b;
  }

  Complexe(float a) {
    this.a = a;
    this.b = 0;
  }

  Complexe() {
    this.a = 0;
    this.b = 0;
  }

  Complexe(Complexe z) {
    this.a = z.a;
    this.b = z.b;
  }

  float re() {
    return a;
  }

  float im() {
    return b;
  }

  String toString() {
    if (b == 0) return str(a);
    String partieIm;
    if      (b ==  1) partieIm = "i";
    else if (b == -1) partieIm = "-i";
    else              partieIm = str(b) + "i";
    if (a == 0) return partieIm;
    if (b > 0) return str(a) + "+" + partieIm;
    else       return str(a) + partieIm;
  }

  boolean egal(Complexe z) {
    return a == z.a && b == z.b;
  }

  boolean egal(float c) {
    return a == c && b == 0;
  }

  Complexe plus(Complexe z) {
    return new Complexe(a + z.a, b + z.b);
  }

  Complexe plus(float c) {
    return new Complexe(a + c, b);
  }

  Complexe moins(Complexe z) {
    return new Complexe(a - z.a, b - z.b);
  }

  Complexe moins(float c) {
    return new Complexe(a - c, b);
  }

  Complexe mult(Complexe z) {
    return new Complexe(a*z.a - b*z.b, a*z.b + b*z.a);
  }

  Complexe mult(float c) {
    return new Complexe(a * c, b * c);
  }

  float mod() {
    return sqrt(a*a + b*b);
  }

  Complexe conj() {
    return new Complexe(a, -b);
  }

  Complexe div(Complexe z) {
    float diviseur = z.a*z.a + z.b*z.b;
    return new Complexe((a*z.a + b*z.b) / diviseur, (b*z.a - a*z.b) / diviseur);
  }

  Complexe div(float c) {
    return new Complexe(a / c, b / c);
  }

  float arg() {
    return atan2(b, a);
  }

  Complexe puissance(int n) {
    Complexe resultat = new Complexe(1);
    for (int i = 0; i < n; i++) {
      resultat = resultat.mult(this);
    }
    return resultat;
  }
}
