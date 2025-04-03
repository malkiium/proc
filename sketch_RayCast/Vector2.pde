class Vector2 {
    float x,y;
    public Vector2(float elem1, float elem2) {
        this.x = elem1;
        this.y = elem2;
    }

    public float length() {
        return sqrt(sq(abs(x)) + sq(abs(y))) ;
    }

    public Vector2 normalized() {
        Vector2 vec = new Vector2(x,y);
        float magnitude = vec.length();
        vec.x = vec.x/magnitude;
        vec.y = vec.y/magnitude;
        return vec;
    }
    public void normalize() {
        float magnitude = this.length();
        this.x = this.x/magnitude;
        this.y = this.y/magnitude;
    }

    public boolean isEqual(Vector2 other) {
        if(other.x == this.x && other.y == this.y) 
            return true;
        return false;
    }

}