class WaterMap extends Renderable{
    float x, dx;
    Point[] pointList;
    PShape[] shapeList;
    float sim_dt = 1;

    WaterMap(PImage tex, int w){
        x = tex.width * w;
        dx = 20;
        pointList = new Point[w+1];
        shapeList = new PShape[w];
        for(int a = 0; a <= w; a++){
            pointList[a] = new Point(-a*a, 0);
            if(a > 0){
                PShape tmp = createShape();
                tmp.beginShape(QUAD);
                    tmp.noStroke();
                    tmp.normal(0, 1, 0);
                    tmp.texture(tex);
                    float y = pointList[a-1].h;
                    tmp.vertex((a-1)*tex.width, y, 0, 0, 0);
                    y = pointList[a].h;
                    tmp.vertex(a*tex.width, y, 0, tex.width, 0);
                    tmp.vertex(a*tex.width, y, tex.height, tex.width, tex.height);
                    y = pointList[a-1].h;
                    tmp.vertex((a-1)*tex.width, y, tex.height, 0, tex.height);
                tmp.endShape();
                shapeList[a-1] = tmp;
            }
        }
    }
    
    void waveEquation(float dt){ //update according to shallow wave equation
        float[] hm = new float[pointList.length];
        float[] uhm = new float[pointList.length];
        float damp = 0.1;
        float g = 1;
        //compute halfstep for midpoints
        for(int i=0; i < pointList.length-1; i++){
            float h = -pointList[i].h;
            float uh = -pointList[i].m;
            float h1 = -pointList[i+1].h;
            float uh1 = -pointList[i+1].m;
            hm[i] = (h + h1 - dt*(uh + uh1)/dx)/2;
            uhm[i] = abs((uh + uh1 - dt*(sqrt(uh1)/h1 - sqrt(uh)/h + g*(sqrt(h1) - sqrt(h))/2)/dx)/2);
            println(uhm[i]);
        }
        //then fullstep
        /*hm[0] = hm[1];
        uhm[0] = abs(uhm[1]);
        hm[pointList.length-1] = hm[pointList.length-2];
        uhm[pointList.length-1] = abs(uhm[pointList.length-2]);*/
        for(int i=0; i < pointList.length-2; i++){
            float test = dt*(uhm[i+1] - uhm[i])/dx;
            if(!Float.isNaN(test)){
                pointList[i+1].h += test;
            }else{
                println("NaN: h " + i);
            }
            test = dt*(damp*pointList[i+1].m + sqrt(uhm[i+1])/hm[i+1] - sqrt(uhm[i])/hm[i] + g*(sqrt(hm[i+1]) - sqrt(hm[i]))/2)/dx;
            if(!Float.isNaN(test)){
                pointList[i+1].m += test;
            }else{
                println("NaN: m " + 1);
            }
        }
    }
    
    void update(float dt){
        waveEquation(dt);
        /*for(int i=0; i < int(dt/sim_dt); i++){
            waveEquation(sim_dt);
        }*/

        // update shapes:
        for(int a = 0; a < shapeList.length; a++){
            PVector v = shapeList[a].getVertex(0);
            v.y = pointList[a].h;
            shapeList[a].setVertex(0, v);
            v = shapeList[a].getVertex(1);
            v.y = pointList[a+1].h;
            shapeList[a].setVertex(1, v);
            v = shapeList[a].getVertex(2);
            v.y = pointList[a+1].h;
            shapeList[a].setVertex(2, v);
            v = shapeList[a].getVertex(3);
            v.y = pointList[a].h;
            shapeList[a].setVertex(3, v);
            
        }
    }
    
    void render(){
        stroke(255);
        line(x, 0, 0, x, -500, 0);
        for(int a = 0; a < shapeList.length; a++){
            shape(shapeList[a]);
        }
        line(0, 0, 0, 0, -500, 0);

    }
}