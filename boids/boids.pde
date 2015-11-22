
//http://www.red3d.com/cwr/boids/

PVector eye;
PVector rot;
float theta = 0;
float phi = 0;

float speed;
boolean DEBUG;
int mode;
float m = 100;

ArrayList<Renderable> render = new ArrayList<Renderable>();
ArrayList<Bird> birds = new ArrayList<Bird>();

void setup() {
	size(1024, 768, P3D);
	// Writing to the depth buffer is disabled to avoid rendering
	// artifacts due to the fact that the particles are semi-transparent
	// but not z-sorted.
	//hint(DISABLE_DEPTH_MASK);

	//frameRate(30);
	sphereDetail(7);
	eye = new PVector(0, 0, -500);
	rot = new PVector(0, 0, 0.01);
	DEBUG = true;
	mode = 0;
	speed = 5;

	for(int a = 0; a < 400; ++a) {
		PVector p = new PVector(random(-m, m),random(-m, m),random(-m, m));
		PVector d = new PVector(random(-1, 1),random(-1, 1),random(-1, 1));
		Bird b = new Bird(p, d, 5, 1);
		render.add(b);
		birds.add(b);
	}

} 

void draw () {
	lights();
	background(178);
	noStroke();

	// update camera based on keyboard input
	PVector update = new PVector();
	if(getKey("d")){
		update.x -= speed;
	}
	if(getKey("e")){
		update.y -= speed;
	}
	if(getKey("w")){
		update.z += speed;
	}
	if(getKey("a")){
		update.x += speed;
	}
	if(getKey("q")){
		update.y += speed;
	}
	if(getKey("s")){
		update.z -= speed;
	}
	// rotate our y axis with theta:
	eye.x += cos(theta)*update.x + sin(theta)*update.z;
	eye.y += update.y;
	eye.z += cos(theta)*update.z - sin(theta)*update.x;	

	camera(eye.x, eye.y, eye.z, eye.x+rot.x, eye.y+rot.y, eye.z+rot.z, 0, 1, 0);
	// draw scene here

	for(Bird b : birds) {
		// apply boid rules to all near birds
		PVector r1 = new PVector(0, 0, 0); // RULE 1: boids fly to perceived flock center
		PVector r2 = new PVector(0, 0, 0); // RULE 2: boids avoid other boids
		PVector r3 = new PVector(0, 0, 0); // RULE 3: boids match flock direction
		PVector r4 = new PVector(0, 0, 0); // RULE 4: boids want to travel to some point
		PVector r5 = new PVector(0, 0, 0); // RULE 5: object avoidance

		int nearcount = 0;
		for(Bird bb : birds){
			if(bb != b){ // TODO near is calculated 2x for each bird pair
				PVector d = PVector.sub(bb.pos, b.pos);
				float dm = d.mag();
				d.normalize();

				if(dm < 5*(b.radius + bb.radius)){
					r1.add(bb.pos); // sum all positions
					r3.add(bb.dir); // sum all directions
					nearcount = nearcount + 1;
				}

				float rr = 2*(b.radius + bb.radius); // 2x touch radius
				if(dm > rr){
					r2.add(d.mult(2*rr/(dm - rr))); // sum inverted distance to all near birds
				}else{
					r2.add(d.mult(1000));
				}
			}
		}

		r1.div(nearcount);

		if(nearcount > 0){
			r1.sub(b.pos).normalize();
			r3.normalize();
			r1.add(r3);
		}else{ // if no external forces, steer in self's direction
			r1 = PVector.mult(b.dir, 1); //PVector.add(b.dir, PVector.div(b.pos, -1000.0));
			r1.normalize();
		}
		r2.div(birds.size()-1);
		r2.mult(2);

		b.steer(PVector.sub(r1, r2));

		// then update
		b.update(0);
	}

	// draw objects
	for(Renderable r : render) {
		r.render();
	}


	// draw the 2D GUI here
	camera(); // reset the camera for 2D text
	fill(255);
	textSize(16);
	if(DEBUG){
		text("Frame rate: " + int(frameRate) + "\n", 10, 20);
	}
}


void mouseDragged(){
	theta += float(mouseX - pmouseX)/width;
	phi -= float(mouseY - pmouseY)/height;
	rot.x = sin(theta)*cos(phi);
	rot.y = sin(phi);
	rot.z = cos(theta)*cos(phi);
}




