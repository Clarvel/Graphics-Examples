class Particle {

  PVector velocity = new PVector(0, 0, 0);
  int MAX_LIFE = 50;
  int lifespan;
  color col;
  
  PShape part;
  float partSize;
  
  PVector gravity = new PVector(0, -0.1, 0);


  Particle() {
    partSize = random(10,60);
    part = createShape();
    part.beginShape(QUAD);
    part.noStroke();
    part.texture(sprite);
    part.normal(0, 0, 1);
    part.vertex(-partSize/2, -partSize/2, 0, 0);
    part.vertex(+partSize/2, -partSize/2, sprite.width, 0);
    part.vertex(+partSize/2, +partSize/2, sprite.width, sprite.height);
    part.vertex(-partSize/2, +partSize/2, 0, sprite.height);
    part.endShape();

    lifespan = int(random(MAX_LIFE));
    col = color(255);
  }
  void colors(color c){
      col = c;
  }

  PShape getShape() {
    return part;
  }
  
  void rebirth(PVector v) {
    float a = random(TWO_PI);
    float speed = random(0.5,4);
    velocity = new PVector(cos(a)/3, 0, 2);
    velocity.mult(speed);
    lifespan = MAX_LIFE;   
    part.resetMatrix();
    part.translate(v.x + width/2, v.y + height/2, v.z); 
  }
  
  boolean isDead() {
    if (lifespan < 0) {
     return true;
    }
    return false;
  }
  

  public void update() {
    lifespan = lifespan - 1;
    velocity.add(gravity);
    
    part.setTint(col);
    part.translate(velocity.x, velocity.y, velocity.z);
  }
}
