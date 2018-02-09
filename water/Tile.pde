
class Tile {

  PShape triangles[];
  int rootIndex;

  Tile (PShape t0, PShape t1, int i) {
    triangles = new PShape[] {t0, t1};
    rootIndex = i; 
  }

  int getRootIndex() {
    return rootIndex;
  }

  PShape[] getTile() {
    return triangles;
  }
}