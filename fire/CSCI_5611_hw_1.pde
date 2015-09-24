// +y is DOWN
// -z is FORWARD


ParticleSystem ps;
PImage sprite;
PVector eye, center, up;
float speed = 5.0;


void setup() {
  size(1024, 768, P3D);
  
  sprite = loadImage("sprite.png");
  ps = new ParticleSystem(1000);
  
  eye = new PVector(width/2, height/2, (height/2) / tan(PI/6));
  center = new PVector(width/2, height/2, 0);
  up = new PVector(0, 1, 0);

  // Writing to the depth buffer is disabled to avoid rendering
  // artifacts due to the fact that the particles are semi-transparent
  // but not z-sorted.
  hint(DISABLE_DEPTH_MASK);
} 

void update(){
    ps.update();
    
    if(getKey("w")){
        eye.z -= speed;
    }
    if(getKey("a")){
        eye.x -= speed;
        center.x -= speed;
    }
    if(getKey("s")){
        eye.z += speed;
    }
    if(getKey("d")){
        eye.x += speed;
        center.x += speed;
    }
    //center.x += (width/2-mouseX);
    //center.y -= (height/2-mouseY);
}

void mouseDragged(){
    center.x += mouseX - pmouseX;
    center.y += mouseY - pmouseY;
}

void draw () {
  background(178);
  update();
  ps.display();
  
  camera(eye.x, eye.y, eye.z, center.x, center.y, center.z, up.x, up.y, up.z);

  ps.setEmitter(new PVector(0, 0, -20));
  
  fill(255);
  textSize(16);
  text("Frame rate: " + int(frameRate), 10, 20);
  
}


