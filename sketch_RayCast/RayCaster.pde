class RayCaster {
    ArrayList<Ray> rays = new ArrayList<Ray>();
    float x,y;
    RayCaster(float xPos, float yPos) {
        this.x = xPos;
        this.y = yPos;

        for (float i = 0; i<360;i+=.01) {
            rays.add(new Ray(x,y,radians(i)));
        }
    }

    public void updateRays() {
        for (Ray ray : rays) {
            ray.x1 = this.x;
            ray.y1 = this.y;
        }
    }

    public void look(Line l) {
        for (Ray ray : rays) {
            final Vector2 pt = ray.cast(l);
            ray.updateLongeur(pt);
            if (pt != null) {
                ray.show();
            }
        } 
    }

    public void look(Line l, float longeur) {
        for (Ray ray : rays) {
            final Vector2 pt = ray.cast(l,longeur);
            ray.updateLongeur(pt,longeur);
            if (pt != null) {
                ray.show();
            }
        } 
    }

    public void look(ArrayList<Line> lines) {
        for (Ray ray : rays) {
            float record = pow(3,30);
            Vector2 closest = null;
            for (Line l : lines) {
                final Vector2 pt = ray.cast(l);
                if (pt != null) {
                    float distance = dist(this.x,this.y, pt.x, pt.y);
                    if (distance < record) {
                        record = distance;
                        closest = pt;
                    }
                }

            }
            ray.updateLongeur(closest);
            ray.show();

        } 
    }

    public void look(ArrayList<Line> lines, float longeur) {
        for (Ray ray : rays) {
            float record = pow(3,35);
            Vector2 closest = null;
            for (Line l : lines) {
                final Vector2 pt = ray.cast(l,longeur);
                if (pt != null) {
                    float distance = dist(this.x,this.y, pt.x, pt.y);
                    if (distance < record) {
                        record = distance;
                        closest = pt;
                    }
                }

            }
            ray.updateLongeur(closest, longeur);
            ray.show();

        } 
    }


    public void show() {
        circle(this.x, this.y, 30);
    }

    public void showRays() {
        for (Ray ray : rays) {
            ray.show();
        }
    }
}
