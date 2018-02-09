
class Mesh {

  PVector pos;
  int size;
  int resolution;
  int rowSize;
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  ArrayList<Tile> tiles = new ArrayList<Tile>();
  PShape bottom;
  float bottomHeight;
  float offset = 0;
  PVector up = new PVector(0, 1, 0);

  Mesh(PVector p, int s, int res) {
    pos = p;
    size = s;
    resolution = res;
    rowSize = size / resolution * 2;

    float min = -20;
    float max = 50;
    print("Creating grid: ");
    for (int y = 0; y < size*2; y+=resolution) {
      for (int x = 0; x < size*2; x+=resolution) {
        Vertex v = new Vertex(rotateVectorX(new PVector(x-size, y-size, 0), -QUARTER_PI), min, max, abs(x * y * 0.005), 0.25);
        vertices.add(v);
        //vertices.add(new PVector(x, y, pos.z));
      }
    }
    println("done");

    up = rotateVectorX(up, -QUARTER_PI);
    println("World up: " + up);    

    // Create tiles, skipping right and bottom vertex edges
    int rows = 0;
    for (int i = 0; i < vertices.size()-rowSize; i++) {
      if (i != rowSize - 1 + (rowSize * rows)) {
        PShape triangle0 = createShape();
        triangle0.beginShape();
        triangle0.noStroke();
        triangle0.fill(0);
        triangle0.vertex(0, 0, 0);
        triangle0.vertex(1, 0, 0);
        triangle0.vertex(0, 1, 0);
        triangle0.endShape(CLOSE);    

        PShape triangle1 = createShape();
        triangle1.beginShape();
        triangle1.noStroke();
        triangle1.fill(0);
        triangle1.vertex(1, 0, 0);
        triangle1.vertex(1, 1, 0);
        triangle1.vertex(0, 1, 0);
        triangle1.endShape(CLOSE); 

        // Add Tile with PShape and index of first vertex in shape
        tiles.add(new Tile(triangle0, triangle1, i));
      } else {
        rows++;
      }
    }

    // Create mesh bottom
    //bottomHeight = max+1;

    //PVector p0 = vertices.get(0).getPos();
    //PVector p1 = vertices.get(rowSize-1).getPos();
    //PVector p2 = vertices.get(vertices.size()-1).getPos();
    //PVector p3 = vertices.get(vertices.size()-rowSize).getPos();

    //bottom = createShape();
    //bottom.beginShape();
    ////bottom.noStroke();
    //bottom.vertex(p0.x, p0.y, p0.z);
    //bottom.vertex(p1.x, p1.y, p1.z);
    //bottom.vertex(p1.x, p1.y+bottomHeight, p1.z);
    //bottom.vertex(p0.x, p0.y, p0.z);
    //bottom.vertex(p0.x, p0.y+bottomHeight, p0.z);
    //bottom.vertex(p1.x, p1.y+bottomHeight, p1.z);
    //bottom.fill(255);
    //bottom.endShape();


    println("Row size: " + rowSize); 
    println("Num total vertices: " + vertices.size());
    println("Num total tiles: " + tiles.size());
  }

  void show() {
    stroke(200);
    strokeWeight(1.5);
    textSize(10);
    float a = 0.01;
    offset = 0;

    //PVector b0 = vertices.get(0).getPos();
    //PVector b1 = vertices.get(rowSize-1).getPos();
    //PVector b2 = vertices.get(vertices.size()-1).getPos();
    //PVector b3 = vertices.get(vertices.size()-rowSize).getPos();
    
    //bottom.setVertex(0, b0.x, b0.y, b0.z);
    //bottom.setVertex(1, b1.x, b1.y, b1.z);
    //bottom.setVertex(2, b1.x, b1.y+bottomHeight, b1.z);
    //bottom.setVertex(3, b0.x, b0.y, b0.z);
    //bottom.setVertex(4, b0.x, b0.y+bottomHeight, b0.z);
    //bottom.setVertex(5, b1.x, b1.y+bottomHeight, b1.z);

    //text("p0", b0.x, b0.y, b0.z);
    //text("p1", b1.x, b1.y, b1.z);
    //text("p2", b2.x, b2.y, b2.z);
    //text("p3", b3.x, b3.y, b3.z);
    //text("p0+", b0.x, b0.y+bottomHeight, b0.z);
    //text("p1+", b1.x, b1.y+bottomHeight, b1.z);
    //text("p2+", b2.x, b2.y+bottomHeight, b2.z);
    //text("p3+", b3.x, b3.y+bottomHeight, b3.z);
    
    //shape(bottom);

    // Drawing tiles and tile annotations
    for (int i = 0; i < tiles.size(); i++) {
      Tile tile = tiles.get(i);

      Vertex v0 = vertices.get(tile.getRootIndex());
      Vertex v1 = vertices.get(tile.getRootIndex()+1);
      Vertex v2 = vertices.get(tile.getRootIndex()+1+rowSize);
      Vertex v3 = vertices.get(tile.getRootIndex()+rowSize);

      PVector p0 = v0.getPos();
      PVector p1 = v1.getPos();
      PVector p2 = v2.getPos();
      PVector p3 = v3.getPos();

      float h0 = v0.getHeight();
      float h1 = v1.getHeight();
      float h2 = v2.getHeight();
      float h3 = v3.getHeight();

      float avg0 = (h0 + h1 + h3) / 3;
      float avg1 = (h1 + h2 + h3) / 3;

      offset += a;
      PShape triangles[] = tile.getTile();    

      float rg0 = map(noise(offset)*avg0, -20, 20, 120, 40);
      float blue0 = map(noise(offset)*avg0, -20, 20, 255, 110);

      PShape t0 = triangles[0];
      t0.setFill(color(rg0, rg0, blue0));
      //t0.setStroke(color(90, 90, blue, 200));
      t0.setVertex(0, p0);
      t0.setVertex(1, p1);
      t0.setVertex(2, p3);
      shape(t0);

      float rg1 = map(noise(offset)*avg1, -20, 20, 120, 40);
      float blue1 = map(noise(offset)*avg1, -20, 20, 255, 110);

      PShape t1 = triangles[1];
      t1.setFill(color(rg1, rg1, blue1));
      //t1.setStroke(color(92, 92, blue, 200));
      t1.setVertex(0, p1);
      t1.setVertex(1, p2);
      t1.setVertex(2, p3);
      shape(t1);

      //text(tile.getRootIndex(), p0.x, p0.y, p0.z);
    }

    //Drawing grid points and vertex annotations
    //for (int i = 0; i < vertices.size(); i++) {
    //  PVector v = vertices.get(i).getPos();
    //  point(v.x, v.y, v.z);
    //  text(i, v.x, v.y, v.z);
    //}
  }

  void update() {
    for (Vertex v : vertices) {
      v.addMultiplier(up); 
      //text(v.getHeight(), v.getPos().x, v.getPos().y, v.getPos().z);
    }
  }

  PVector rotateVectorX(PVector v, float angle) {  
    PVector result = new PVector();
    PVector vCopy = v.copy();
    result.x = vCopy.x;
    result.y = vCopy.y * cos(angle) - vCopy.z * sin(angle);
    result.z = -vCopy.y * sin(angle) + vCopy.z * cos(angle);    

    return result;
  }
}