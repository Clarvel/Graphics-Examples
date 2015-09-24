class RadialEmitter extends ParticleSystem{
    RadialEmitter(int n){
        super(n);
        particles = new ArrayList<Particle>();
        particleShape = createShape(PShape.GROUP);
        color[] ca = {color(255, 255, 255), color(255, 255, 0), color(255, 178, 0), color(255, 0, 0)};
        for (int i = 0; i < n; i++) {
          RadialParticle p = new RadialParticle();
          p.colors(ca);
          float rand = random(1.5, 3);
          p.velocity = new PVector(rand*cos(TWO_PI*(i)/n), rand*sin(TWO_PI*(i)/n), 0);
          particles.add(p);
          particleShape.addChild(p.getShape());
        }        
    }
    
}

class RadialParticle extends ColGradParticle{
    boolean re = true;
    RadialParticle(){
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
        MAX_LIFE = 100;
        gravity = new PVector(0, -0.02, 0);
    
        //lifespan = int(random(MAX_LIFE));
        col = color(255);
    }
    void rebirth(PVector v) {
        if(re){
    lifespan = MAX_LIFE;   
    //part.resetMatrix();
    part.translate(v.x + width/2, v.y + height/2, v.z); 
    re = false;
        }
  }
}
