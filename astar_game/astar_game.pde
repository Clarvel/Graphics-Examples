// +y is DOWN
// -z is FORWARD

PVector eye, rot;
float speed = 1.0;
System object;
int mode = 0;

void setup() {
	size(1024, 768, P3D);
	//frameRate(30);
	
	eye = new PVector(-70, -60, -220);
	rot = new PVector(-0.1172, 0.5615, 0);

	// Writing to the depth buffer is disabled to avoid rendering
	// artifacts due to the fact that the particles are semi-transparent
	// but not z-sorted.
	//hint(DISABLE_DEPTH_MASK);
	/* END DEFAULT */

	sphereDetail(7);
	PVector dim = new PVector(100, 100, 100);
	int numObstacles = 10;
	object = new System(dim, numObstacles);

} 

void draw () {
	lights();
	background(178);
	keyUpdate(); // update camera based on keyboard input
	beginCamera();
		camera(0, 0, 0, 0, 0, -1, 0, 1, 0);
		translate(eye.x, eye.y, eye.z); // move to 0x, 0y, 0z
		rotateX(rot.x);
		rotateY(rot.y);
		rotateZ(rot.z);
	endCamera();

	//draw all objects here
	object.update(frameRate);
	object.render();
	/*
	for(Renderable r : objects){
		r.update(frameRate);
		r.render();
	}*/

	// draw the 2D GUI here
	camera(); // reset the camera for 2D text
	fill(255);
	textSize(16);
	text("Frame rate: " + int(frameRate) + "\npress spacebar to start", 10, 20);
}

void keyUpdate(){
	PVector update = new PVector();
	if(getKey("d")){
		update.x += speed;
	}
	if(getKey("e")){
		update.y += speed;
	}
	if(getKey("w")){
		update.z += speed;
	}
	if(getKey("a")){
		update.x -= speed;
	}
	if(getKey("q")){
		update.y -= speed;
	}
	if(getKey("s")){
		update.z -= speed;
	}

	if(getKey(" ")){
		object.begin();
	}
	eye.add(update);
}

void mouseDragged(){
	rot.y += float(mouseX - pmouseX)/width;
	rot.x -= float(mouseY - pmouseY)/height;
}
