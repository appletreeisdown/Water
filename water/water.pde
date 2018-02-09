
Mesh mesh;

void setup() {
  size(1200, 1200, P3D);
  mesh = new Mesh(new PVector(0, 0, 100), 400, 50);
  smooth(8);
  hint(DISABLE_DEPTH_TEST); // 'Fixes' Z-fighting
}

void draw() {
  translate(width/2, height/2);
  background(40);   

  text(round(frameRate), -width/2, -height/2+10);
  text(frameCount, -width/2, -height/2+20);

  mesh.update();
  mesh.show();
  //noLoop();
  System.gc();
}