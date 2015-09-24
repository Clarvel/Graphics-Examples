class ParticleSystem {
  ArrayList<Particle> particles;

  PShape particleShape;

  ParticleSystem(int n) {
    particles = new ArrayList<Particle>();
    particleShape = createShape(PShape.GROUP);
    color[] ca = {color(50, 50, 50)};
    for (int i = 0; i < n; i++) {
      ColGradParticle p = new ColGradParticle();
      p.colors(ca);
      particles.add(p);
      particleShape.addChild(p.getShape());
    }
  }

  void update() {
    for (Particle p : particles) {
      if(!p.isDead()){
      p.update();
      }
    }
  }

  void setEmitter(PVector a) {
    for (Particle p : particles) {
      if (p.isDead()) {
        p.rebirth(a);
      }
    }
  }

  void display() {
    shape(particleShape);
  }
}

