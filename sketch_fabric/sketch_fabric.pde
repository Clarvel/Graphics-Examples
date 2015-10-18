/*
cloth simulation with user controlled ball
5 realtime render
5 video
5 3D render, user controlled camera
30 cloth simulation
(40 FEM-based cloth simulation)
10 interaction with spherical object
10 realtime user interaction with system
10 textured cloth
net = 75
*/
// +y is DOWN
// -z is FORWARD


PVector eye, rot;
float speed = 5.0;
float grav = 0.1;
PImage img;
ArrayList<Renderable> objects = new ArrayList<Renderable>(); // objects.add(new Renderable());
Sphere ball;

void setup(){
    size(1024, 768, P3D);
    //frameRate(10);
    eye = new PVector(-1000, -1000, -1500);
    rot = new PVector(PI/4, 0, 0);
    
    // Writing to the depth buffer is disabled to avoid rendering
    // artifacts due to the fact that the particles are semi-transparent
    // but not z-sorted.
    //hint(DISABLE_DEPTH_MASK);
    
    // setup scene here:
    img = loadImage("fabric.jpg");
    Fabric f = new Fabric(img, 20, 20);
    f.pin(0, 0);
    f.pin(20, 0);
    //w.start();
    objects.add(f);
    ball = new Sphere(1000, 1000, 400, 300, RED);
    objects.add(ball);
}

void draw(){
    lights();
    background(0);
    keyUpdate(); // update camera based on keyboard input

    beginCamera();
        camera();
        translate(width/2+eye.x, height/2+eye.y, eye.z); // move to 0x, 0y, 0z
        rotateY(rot.x);
        rotateZ(rot.y); 
    endCamera();
    
   
    //draw all objects here
    for(Renderable r : objects){
        r.update(frameRate);
        r.render();
    }

    // draw the 2D GUI here
    camera(); // reset the camera for 2D text
    fill(255);
    textSize(16);
    text("Frame rate: " + int(frameRate), 10, 20);
}

void keyUpdate(){    
    if(getKey("w")){
        eye.z += speed;
    }
    if(getKey("a")){
        eye.x += speed;
    }
    if(getKey("s")){
        eye.z -= speed;
    }
    if(getKey("d")){
        eye.x -= speed;
    }
}

void mouseDragged(){
    rot.x += (mouseX - pmouseX)/360.0;
    rot.y += (mouseY - pmouseY)/360.0;
}

void mouseMoved(){
    ball.pos.z += (mouseX - pmouseX);
}