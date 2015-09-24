  
  class ColGradParticle extends Particle{
      color[] cols;
      
      ColGradParticle(){
          super();
      }
      
      void colors(color[] colors){
          cols = colors;
      }
      public void update() {
        lifespan = lifespan - 1;
        velocity.add(gravity);
        color tmp = cols[int(cols.length-1-cols.length*lifespan/MAX_LIFE)];
        tmp = color(red(tmp), green(tmp), blue(tmp), lifespan*255/MAX_LIFE/2);
        part.setTint(tmp);
        if(velocity.x < 0){
            part.translate(velocity.x-velocity.y/3, velocity.y, velocity.z);
        }else{
            part.translate(velocity.x + velocity.y/3, velocity.y, velocity.z);
        }
      }
  }
