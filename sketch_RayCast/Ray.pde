class Ray {
  float x1, y1, x2, y2;
  Vector2 dir;
  public Ray(float xPos, float yPos, float rad) {
    this.x1 = xPos;
    this.y1 = yPos;
    this.dir = new Vector2(cos(rad), sin(rad));
    this.dir.normalize();
    this.x2 = dir.x*max(width*2, height*2)+x1;
    this.y2 = dir.y*max(width*2, height*2)+y1;
  }

  public void lookAt(float x, float y) {
    this.dir.x = x - this.x1;
    this.dir.y = y - this.y1;
    this.dir.normalize();
  }

  public void updateLongeur(Vector2 pt) {
    if (pt != null) {
      this.x2 = pt.x;
      this.y2 = pt.y;
    } else {
      this.x2 = dir.x*max(width*2, height*2)+x1;
      this.y2 = dir.y*max(width*2, height*2)+y1;
    }
  }

  public void updateLongeur(Vector2 pt, float longeur) {
    if (pt != null) {
      this.x2 = pt.x;
      this.y2 = pt.y;
    } else {
      this.x2 = dir.x*longeur+x1;
      this.y2 = dir.y*longeur+y1;
    }
  }
  public void show() {
    if (!Float.isNaN(this.x2) && !Float.isNaN(this.y2)) {
      line(this.x1, this.y1, this.x2, this.y2);
    } else {
      println("Error: x2 or y2 is NaN!");
    }
  }

  public Vector2 cast(Line line) {

    final float x1 = line.x1;
    final float y1 = line.y1;
    final float x2 = line.x2;
    final float y2 = line.y2;

    final float x3 = this.x1;
    final float y3 = this.y1;
    final float x4 = this.x1 + this.dir.x;
    final float y4 = this.y1 + this.dir.y;

    final float den = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
    if (den == 0) {
      return null;
    }

    final float t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4))/den;
    final float u = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3))/den;

    if (t > 0 && t < 1 && u >0 ) {
      Vector2 pt = new Vector2(0, 0);
      pt.x = x1 + t * (x2-x1);
      pt.y = y1 + t * (y2-y1);
      return pt;
    }
    return null;
  }


  public Vector2 cast(Line line, float longeur) {

    final float x1 = line.x1;
    final float y1 = line.y1;
    final float x2 = line.x2;
    final float y2 = line.y2;

    final float x3 = this.x1;
    final float y3 = this.y1;
    final float x4 = this.x1 + this.dir.x*longeur;
    final float y4 = this.y1 + this.dir.y*longeur;

    final float den = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
    if (den == 0) {
      return null;
    }

    final float t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4))/den;
    final float u = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3))/den;

    if (t > 0 && t < 1 && u > 0 && u < 1) {
      Vector2 pt = new Vector2(0, 0);
      pt.x = x1 + t * (x2-x1);
      pt.y = y1 + t * (y2-y1);
      return pt;
    }
    return null;
  }
}
