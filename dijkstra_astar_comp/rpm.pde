

float getHcost(Point a, Point b){
	return PVector.sub(b.pos, a.pos).mag();
}

class Point{
	PVector pos;
	boolean visited = false;
	Point prev;
	float minDist = Float.MAX_VALUE;
	float est = Float.MAX_VALUE;
	ArrayList<Point> neighbors = new ArrayList<Point>();
	ArrayList<Float> distances = new ArrayList<Float>();

	Point(PVector p){
		pos = p;
	}
	Point(){}

	void clean(){
		visited = false;
		prev = null;
		minDist = Float.MAX_VALUE;
		est = Float.MAX_VALUE;
	}
}
class Rpm{
	/*
	make world:
	for some number, generate potential points in space
	remove points intersecting any sphere
	for each point, make list of vertexes to other points with weight = length
	if any vertex intersects sphere, remove it

	solve:
	add start and end points to list, and make their vertexes
	starting at start point, find shortest path to end point using naive search
	*/
	Point current;
	Point end;
	ArrayList<Point> unvisited;
	ArrayList<Object> ob;

    Rpm(ArrayList<Object> o, PVector size){
    	ob = o;
    	unvisited = new ArrayList<Point>();
		// generate points
		//unvisited.add(new Point(new PVector(size.x/2, size.y/2, size.z/2)));
		for(int a = 0; a < 1000; a++){
			Point p = new Point(new PVector(random(size.x), random(size.y), random(size.z)));
			boolean hit = false;
			for(Object ob : o){
				if(PVector.sub(p.pos, ob.pos).mag() < 2*ob.radius){
					hit = true;
					break;
				}
			}
			if(!hit){
				// pre generate vertexes
				for(Point p2 : unvisited){
					if(los(o, p.pos, PVector.sub(p2.pos, p.pos).normalize())){
						float dist = PVector.sub(p2.pos,p.pos).mag();
						p.neighbors.add(p2);
						p.distances.add(dist);
						p2.neighbors.add(p);
						p2.distances.add(dist);
					}
				}
				unvisited.add(p);
			}
		}
	}

	ArrayList<PVector> solve(PVector start, PVector end_, boolean useA){
		int m = millis();
		for(Point p : unvisited){
			p.clean();
		}
		// add start and end points
		Point e = new Point(end_);
		for(Point p : unvisited){
			if(los(ob, p.pos, PVector.sub(e.pos,p.pos).normalize())){
				float dist = PVector.sub(e.pos,p.pos).mag();
				p.neighbors.add(e);
				p.distances.add(dist);
				e.neighbors.add(p);
				e.distances.add(dist);
			}
		}
		unvisited.add(e);
		end = e;

		Point s = new Point(start);
		s.minDist = 0;
		s.est = getHcost(s, e);
		for(Point p : unvisited){
			if(los(ob, p.pos, PVector.sub(s.pos,p.pos).normalize())){
				float dist = PVector.sub(s.pos,p.pos).mag();
				p.neighbors.add(s);
				p.distances.add(dist);
				s.neighbors.add(p);
				s.distances.add(dist);
			}
		}
		unvisited.add(s);

		ArrayList<PVector> path = new ArrayList<PVector>();
		if(useA){
			path = astar();
		}else{
			path = dijkstra();
		}

		println(path);
		println("Found in " + str(millis()-m) + " milliseconds");
		unvisited.remove(e);
		unvisited.remove(s);
		return path;
	}

	ArrayList<PVector> dijkstra(){
		// start dijkstra's algorithm here
		int openset = unvisited.size();
		while(openset > 0){
			Point u = new Point();
			boolean flag = false;
			// set u to mindist point
			for(Point p : unvisited){
				if(!p.visited && p.minDist < u.minDist){
					u = p;
					flag = true;
				}
			}
			if(!flag){ // no viable paths
				println("dijkstra No viable paths");
				break;
			}
			u.visited = true;
			openset--;
			if(u == end){
				println("dijkstra found end");
				break;
			}

			for(int a = 0; a < u.neighbors.size(); a++){
				/*if(u.neighbors.get(a).visited){
					continue;
				}*/
				float alt = u.minDist + u.distances.get(a);
				if(alt < u.neighbors.get(a).minDist){
					u.neighbors.get(a).minDist = alt;
					u.neighbors.get(a).prev = u;
				}
			}
		}


		ArrayList<PVector> path = new ArrayList<PVector>();
		while(end.prev != null){
			path.add(0, end.pos);
			end = end.prev;
		}
		return path;
	}

	ArrayList<PVector> astar(){
		// start astar algorithm here
		int openset = unvisited.size();
		while(openset > 0){
			Point u = new Point();
			boolean flag = false;
			// set u to mindist point
			for(Point p : unvisited){
				if(!p.visited && p.est < u.est){
					u = p;
					flag = true;
				}
			}
			if(!flag){ // no viable paths
				println("Astar No viable paths");
				break;
			}
			u.visited = true;
			openset--;
			if(u == end){
				println("Astar found end");
				break;
			}

			for(int a = 0; a < u.neighbors.size(); a++){
				/*if(u.neighbors.get(a).visited){
					continue;
				}*/
				float alt = u.minDist + u.distances.get(a);
				if(alt < u.neighbors.get(a).minDist){
					u.neighbors.get(a).minDist = alt;
					u.neighbors.get(a).est = u.neighbors.get(a).minDist + getHcost(u.neighbors.get(a), end);
					u.neighbors.get(a).prev = u;
				}
			}
		}


		ArrayList<PVector> path = new ArrayList<PVector>();
		while(end.prev != null){
			path.add(0, end.pos);
			end = end.prev;
		}
		return path;		
	}




	void render(){
		stroke(color(0, 0, 255));
		fill(color(0, 0, 255));
		for(Point p : unvisited){
			pushMatrix();
	        translate(p.pos.x, p.pos.y, p.pos.z);
	        sphere(0.5);
	        popMatrix();
	        for(Point n : p.neighbors){
	        	//line(p.pos.x, p.pos.y, p.pos.z, n.pos.x, n.pos.y, n.pos.z);
	        }
		}
	}
}


boolean los(ArrayList<Object> o, PVector p, PVector d){
	/*
	for each object, return false if the ray hits something
	*/
	for(Object ob : o){
		PVector ip = PVector.sub(p, ob.pos);
		float b = 2 * PVector.dot(d, ip);
		float c = PVector.dot(ip, ip) - (2*ob.radius)*(2*ob.radius);
		float dis = b*b - 4*c;
		float t1 = -b;
		if(dis < 0){
			continue;
		}else if(dis > 0){
			float rt = sqrt(dis);
			t1 =  rt - b;
			float t2 = -rt - b;
			if(t1 > t2){
				t1 = t2;
			}
		}
		if(t1 < 0){
			continue;
		}
		return false;
	}
	return true;
}


