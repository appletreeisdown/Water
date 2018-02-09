
class Vertex {

  PVector pos;

  float h;
  float maxHeight;
  float minHeight;
  float hMultiplier;

  float offset;
  float frames;

  Vertex(PVector p, float min) {
    pos = p;

    minHeight = min;
    maxHeight = -min;
    h = 0;
    offset = 0;
    frames = 0;

    hMultiplier = random(-0.15, 0.15);
  }

  Vertex(PVector p, float min, float max, float o, float m) {
    pos = p;

    minHeight = min;
    maxHeight = max;
    h = 0;
    offset = o;
    frames = 0;

    hMultiplier = m;
  }

  void addMultiplier(PVector up) {
    if (frames >= offset) {
      PVector wUp = up.copy();
      pos.add(wUp.mult(hMultiplier));
      h += hMultiplier;

      if (h > maxHeight || h < minHeight) {
        hMultiplier *= -1;
      }
    } else {
       frames++; 
    }
  }

  void setPos(PVector p) {
    pos = p;
  }

  PVector getPos() {
    return pos;
  }

  float getHeight() {
    return h;
  }

  float getMultiplier() {
    return hMultiplier;
  }
}