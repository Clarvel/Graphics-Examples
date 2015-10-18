class Fabric extends Renderable{
    float k, m, rlen; // spring constant, mass constant for each point, spring rest length
    PVector pts[][];
    PVector vels[][];
    PShape slist[][];
    ArrayList<int[]> pins = new ArrayList<int[]>();
    Fabric(PImage img, int x, int y){
        k = 1;
        m = 1;
        rlen = (img.width+img.height)/2; // spring rest length
        pts = new PVector[x+1][y+1];
        vels = new PVector[x+1][y+1];
        slist = new PShape[x][y];
        for(int a=0; a<=x; a++){
            for(int b=0; b<=y; b++){
                pts[a][b] = new PVector(a*img.width, b*img.height, 0);
                vels[a][b] = new PVector(0, 0, 0);
                if(a>0 && b>0){
                    PShape t = createShape();
                    t.beginShape(QUAD);
                        t.noStroke();
                        t.normal(0, 0, 1);
                        t.texture(img);
                        t.vertex(pts[a-1][b-1].x, pts[a-1][b-1].y, pts[a-1][b-1].z, 0, 0);
                        t.vertex(pts[a][b-1].x, pts[a][b-1].y, pts[a][b-1].z, img.width, 0);
                        t.vertex(pts[a][b].x, pts[a][b].y, pts[a][b].z, img.width, img.height);
                        t.vertex(pts[a-1][b].x, pts[a-1][b].y, pts[a-1][b].z, 0, img.height);
                    t.endShape();
                    slist[a-1][b-1] = t;
                }
            }
        }
    }
    void pin(int x, int y){
        int[] t = {x, y};
        pins.add(t);
    }
    boolean pinned(int a, int b){
       for(int c=0; c<pins.size(); c++){
            if(a == pins.get(c)[0] && b == pins.get(c)[1]){
                return true;
            }
        }
        return false;
    }
    
    PVector checkCollision(Sphere s, PVector pt){
        float diff = s.radius+0.01 - PVector.sub(pt, s.pos).mag();
        if(diff > 0){
            return PVector.add(pt, PVector.sub(pt, s.pos).normalize().mult(diff));
        }
        return pt;
    }
    
    void update(float dt){
        PVector pts2[][] = new PVector[pts.length][pts[0].length];
        PVector vels2[][] = new PVector[pts.length][pts[0].length];
        for(int a=0; a<pts.length; a++){
            for(int b=0; b<pts[a].length; b++){
                // don't update pinned points
                pts2[a][b] = pts[a][b];
                vels2[a][b] = vels[a][b];

                if(pinned(a, b)){ // ignore pinned points, they dont get updated
                    continue;
                }
                PVector tmp;
                PVector f = new PVector(0, grav, 0);
                /*
                spring force f:
                    direction = (p2-p1).normalize();
                    magnitude = (rest_length - (p2-p1).magnitude) * k;
                sum spring forces, use euler's equations:
                    m = mass
                    a=f/m;
                    x1=x0+v0*t+.5*a*t*t
                    v1=v0+a*t
                */
                if(a > 0){
                    tmp = PVector.sub(pts[a-1][b], pts[a][b]);
                    float mag = tmp.mag();
                    //println(mag);
                    tmp.normalize();
                    f.add(PVector.mult(tmp, -k*(rlen - mag)));
                }
                if(b > 0){
                    tmp = PVector.sub(pts[a][b-1], pts[a][b]);
                    float mag = tmp.mag();
                    tmp.normalize();
                    f.add(PVector.mult(tmp, -k*(rlen - mag)));
                }
                if(a < pts.length-1){
                    tmp = PVector.sub(pts[a+1][b], pts[a][b]);
                    float mag = tmp.mag();
                    tmp.normalize();
                    f.add(PVector.mult(tmp, -k*(rlen - mag)));
                }
                if(b < pts[a].length-1){
                    tmp = PVector.sub(pts[a][b+1], pts[a][b]);
                    float mag = tmp.mag();
                    tmp.normalize();
                    f.add(PVector.mult(tmp, -k*(rlen - mag)));
                }
                pts2[a][b].add(PVector.mult(vels[a][b], 1/dt));
                pts2[a][b].add(PVector.mult(f, 1/(2*m*dt*dt)));
                vels2[a][b].add(PVector.mult(f, 1/(m*2*dt)));
                pts2[a][b] = checkCollision(ball, pts2[a][b]);
            }
        }
        pts = pts2;
        vels = vels2;
    }
    
    void render(){
        for(int a = 0; a < slist.length; a++){
            for(int b = 0; b < slist[a].length; b++){
                PShape s = slist[a][b];
                s.setVertex(0, pts[a][b]);
                s.setVertex(1, pts[a+1][b]);
                s.setVertex(2, pts[a+1][b+1]);
                s.setVertex(3, pts[a][b+1]);
                shape(s);
            }
        }
    }
}