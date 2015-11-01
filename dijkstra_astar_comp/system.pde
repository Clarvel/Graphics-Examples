
class Object extends Renderable{
    color c;
    PVector pos;
    float radius;
    
    Object(PVector p, float r){
        pos = p;
        radius = r;
        c = color(0);
        
    }
    void render(){
        noStroke();
        pushMatrix();
        translate(pos.x, pos.y, pos.z);
        fill(c);
        sphere(radius);
        popMatrix();
    }
}


class Movable extends Object{
    float speed;
    ArrayList<PVector> path;

    Movable(PVector p, float r){
        super(p, r);
        c = color(255);
        speed = 1;
    }

    void update(float fr){
        if(path != null && path.size() > 0){
            PVector travel = PVector.sub(path.get(0), pos);
            float movespeed = travel.mag();
            if(movespeed <= speed){ // if I am reaching or passing the point, remove point from path
                path.remove(0);
            }else{
                movespeed = speed;
            }

            pos.add(travel.normalize().mult(movespeed));
        }
    }


    void render(){
        noStroke();
        pushMatrix();
        translate(pos.x, pos.y, pos.z);
        fill(c);
        sphere(radius);
        popMatrix();
        if(path != null && path.size() > 0){
            PVector a = pos;
            PVector b;
            stroke(color(255, 0, 0));
            for(int c = 0; c < path.size(); c++){
                b = a;
                a = path.get(c);
                line(a.x, a.y, a.z, b.x, b.y, b.z);
            }
        }
    }

    void move(PVector p){
        pos.add(p);
    }
}


class System extends Renderable{
    PVector dimensions;
    ArrayList<Object> objects;
    Movable playerPiece;
    Movable aiPiece;

    Rpm map;
    
    float defaultRadius = 5;
    boolean begun = false;
    
    System(PVector d, int obstacleCount){
        this.begun = false;
        dimensions = d;
        objects = new ArrayList<Object>();
        aiPiece = new Movable(new PVector(dimensions.x-defaultRadius, dimensions.y-defaultRadius, dimensions.z-defaultRadius), defaultRadius);
        aiPiece.c = color(255, 0, 0);
        playerPiece = new Movable(new PVector(0, 0, 0), defaultRadius);
        playerPiece.c = color(0, 255, 0);
        
        int a = obstacleCount;
        int generationlimit = 100; // cap on number of addition failures, so we never get stuck on this while loop
        while(a > 0 && generationlimit > 0){
            Object o = new Object(new PVector(defaultRadius+random(dimensions.x-2*defaultRadius), defaultRadius+random(dimensions.y-2*defaultRadius), defaultRadius+random(dimensions.z-2*defaultRadius)), defaultRadius);
            boolean collided = false;
            for(Object ob : objects){
                if(collide(ob, o)){
                    collided = true;
                    break;
                }
            }
            if(collide(o, aiPiece) || collide(o, playerPiece)){
                collided = true;
            }
            if(!collided){
                objects.add(o);
                a--;   
            }else{
                generationlimit--;
            }
        }
        map = new Rpm(objects, dimensions); // TODO change based on type of search
        objects.add(aiPiece);
        objects.add(playerPiece);
    }

    void update(float dt){
        aiPiece.update(dt);
        playerPiece.update(dt);
    }

    void render(){
        for(Object o : objects){
            o.render();
        }
        map.render();
    }

    void begin(boolean useA){
        if(this.begun == false){
            this.begun = true;
            println("beginnging");
            aiPiece.path = map.solve(aiPiece.pos, playerPiece.pos, useA);
        }
    }
    void placeStart(PVector pos){
        aiPiece.pos.add(pos);
        this.begun = false;
    }
    void placeEnd(PVector pos){
        playerPiece.pos.add(pos);
        this.begun = false;
    }
    boolean collide(Object a, Object b){
        if(PVector.sub(a.pos, b.pos).mag() < (a.radius + b.radius)){
            return true;
        }
        return false;
    }
}