
class Mesh {

  PVector pos;
  int size;
  int resolution;
  int rowSize;
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  ArrayList<Tile> tiles = new ArrayList<Tile>();
  PShape[] wallSegments;
  float bottomHeight;
  float offset = 0;
  PVector up = new PVector(0, 1, 0);

  float min = -10;
  float max = 40;

  Mesh(PVector p, int s, int res) {
    pos = p;
    size = s;
    resolution = res;
    rowSize = size / resolution * 2;

    print("Creating grid: ");
    for (int y = 0; y < size*2; y+=resolution) {
      for (int x = 0; x < size*2; x+=resolution) {
        Vertex v = new Vertex(rotateVectorX(new PVector(x-size, y-size, 0), -QUARTER_PI), min, max, abs(x * y * 0.005), 0.20);
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

    // Create walls
    wallSegments = new PShape[4];
    bottomHeight = max*1.5;

    PVector p0 = vertices.get(0).getPos();
    PVector p1 = vertices.get(rowSize-1).getPos();
    PVector p2 = vertices.get(vertices.size()-1).getPos();
    PVector p3 = vertices.get(vertices.size()-rowSize).getPos();

    color wallColour = color(60, 60, 160);

    PShape backWall = createShape();
    backWall.beginShape();
    backWall.noStroke();
    backWall.fill(wallColour);

    // Back
    backWall.vertex(p0.x, p0.y, p0.z);
    backWall.vertex(p1.x, p1.y, p1.z);
    backWall.vertex(p1.x, p1.y+bottomHeight, p1.z);
    backWall.vertex(p0.x, p0.y+bottomHeight, p0.z);
    backWall.endShape(CLOSE);
    wallSegments[0] = backWall;

    PShape bottomWall = createShape();
    bottomWall.beginShape();
    bottomWall.noStroke();
    bottomWall.fill(wallColour);

    // Bottom 
    bottomWall.vertex(p0.x, p0.y+bottomHeight, p0.z);
    bottomWall.vertex(p1.x, p1.y+bottomHeight, p1.z);
    bottomWall.vertex(p2.x, p2.y+bottomHeight, p2.z);
    bottomWall.vertex(p3.x, p3.y+bottomHeight, p3.z);   
    bottomWall.endShape(CLOSE);
    wallSegments[1] = bottomWall;

    PShape leftWall = createShape();
    leftWall.beginShape();
    leftWall.noStroke();
    leftWall.fill(wallColour);

    // Left
    leftWall.vertex(p3.x, p3.y+bottomHeight, p3.z);
    leftWall.vertex(p3.x, p3.y, p3.z);
    leftWall.vertex(p0.x, p0.y, p0.z);
    leftWall.vertex(p0.x, p0.y+bottomHeight, p0.z);    
    leftWall.endShape(CLOSE);
    wallSegments[2] = leftWall;

    PShape rightWall = createShape();
    rightWall.beginShape();
    rightWall.noStroke();
    rightWall.fill(wallColour);

    // Right
    rightWall.vertex(p1.x, p1.y+bottomHeight, p1.z);
    rightWall.vertex(p1.x, p1.y, p1.z);
    rightWall.vertex(p2.x, p2.y, p2.z);
    rightWall.vertex(p2.x, p2.y+bottomHeight, p2.z);    
    rightWall.endShape(CLOSE);
    wallSegments[3] = rightWall;


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

    // Updating and displaying wall segments
    PVector w0 = vertices.get(0).getPos();
    PVector w1 = vertices.get(rowSize-1).getPos();
    PVector w2 = vertices.get(vertices.size()-1).getPos();
    PVector w3 = vertices.get(vertices.size()-rowSize).getPos();

    // Back Wall
    wallSegments[0].setVertex(0, w0.x, w0.y, w0.z);
    wallSegments[0].setVertex(1, w1.x, w1.y, w1.z);
    shape(wallSegments[0]);

    // Bottom wall
    shape(wallSegments[1]);

    // Left Wall
    wallSegments[2].setVertex(1, w3.x, w3.y, w3.z);
    wallSegments[2].setVertex(2, w0.x, w0.y, w0.z);
    shape(wallSegments[2]);

    // Right Wall
    wallSegments[3].setVertex(1, w1.x, w1.y, w1.z);
    wallSegments[3].setVertex(2, w2.x, w2.y, w2.z);
    shape(wallSegments[3]);


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

      float rg0 = map(noise(offset)*avg0, min/2, max/2, 80, 20);      
      float blue0 = map(noise(offset)*avg0, min/2, max/2, 200, 95);

      PShape t0 = triangles[0];
      t0.setFill(color(rg0, rg0, blue0));
      //t0.setStroke(color(90, 90, blue, 200));
      t0.setVertex(0, p0);
      t0.setVertex(1, p1);
      t0.setVertex(2, p3);
      shape(t0);

      float rg1 = map(noise(offset)*avg1, min/2, max/2, 80, 20);
      float blue1 = map(noise(offset)*avg1, min/2, max/2, 200, 95);

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