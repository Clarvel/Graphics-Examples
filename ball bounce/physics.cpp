//
//  physics.cpp
//  5611 assignment 1
//
//  Created by Matthew Russell on 9/15/15.
//  Copyright (c) 2015 Matthew Russell. All rights reserved.
//

#include "physics.h"


class Vec3{
    private:
        int x, y, z;
    public:
        Vec3(int a, int b, int c){
            x=a;
            y=b;
            z=c;
        }
};

class Point{
    private:
        int x, y, z;
    public:
        Point(int a, int b, int c){
            x=a;
            y=b;
            z=c;
        }
};

class Color{
    private:
        int r, g, b, a;
    public:
        Color(int b, int c, int d, int e){
            r=b;
            g=c;
            b=d;
            a=e;
        }
};
