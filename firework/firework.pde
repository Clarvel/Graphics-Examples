class Firework{
  float lifeA = 200;
  ParticleSystem tail, boom;
  float h = 0;

  Firework(){
    tail = new ParticleSystem(30);
    boom = new RadialEmitter(200);
  }

  void update() {

    lifeA -= 1;
    tail.update();

  }

  void setEmitter(PVector a) {
    if(lifeA >= 0){
        PVector b = a;
        b.y -= h;
        tail.setEmitter(b);
        h+=2;
    }else{
        booms.play();
        tail = boom;
        PVector b = a;
        b.y -= h;
        tail.setEmitter(b);
    }
      if(lifeA == 198){
        launchs.play();
      }
  }
  void display(){
      tail.display();
  }

}

