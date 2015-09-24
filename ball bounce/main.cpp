//SDL
//  main.cpp
//  5611 assignment 1
//
//  Created by Matthew Russell on 9/13/15.
//  Copyright (c) 2015 Matthew Russell. All rights reserved.
//

#include <GLUT/glut.h>
#include <stdlib.h>
#include <iostream>
#include <ctime>
#include <unistd.h>
#include <cmath>
#include "colors.h"

#define FPS 16.666 // 60 fps

clock_t displayTimer;
float renderTime;

float angle = 0.001;
float rot[3] = {0.0, 0.0, 0.0};
GLfloat pos[3] = {0.0, 0.0, 0.0};
GLfloat vel[3] = {4.0, 2.0, 7.0};
GLfloat acc[3] = {0.0, -0.98, 0.0};
float radius = 1.5;
float floor_ = -15;
float ceil_ = 15;

GLfloat v[] = {
	0.0, 50.0, 50.0,
	0.0, 50.0, 0.0,
	0.0, 0.0, 0.0,
	0.0, 0.0, 50.0
};
//GLuint vbo;

//glGenBuffers(1, &vbo);
//glBindBuffer(GL_ARRAY_BUFFER, vbo);
//glBufferData(GL_ARRAY_BUFFER, sizeof(v), v, GL_STATIC_DRAW);

void output(int x, int y, std::string c){
	const char* p;
	glPushMatrix();
	glRasterPos2i(x, y);
	for (p=c.c_str(); *p; p++){
		glutBitmapCharacter(GLUT_BITMAP_TIMES_ROMAN_24, *p);
	}
	glPopMatrix();
}

void display(void){
	displayTimer = clock(); // for fps measurements

	/* disply function for window */
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT); // Clear color and depth buffers
 

	glDisable(GL_DEPTH_TEST); // background
	glShadeModel(GL_SMOOTH);
	glBegin(GL_POLYGON);
		glColor3fv(BLACK);
		glVertex3f(-30, 30, -50);
		glVertex3f(30, 30, -50);
		glColor3fv(BLUE);
		glVertex3f(30, -30, -50);
		glVertex3f(-30, -30, -50);
	glEnd();
	
	//glMatrixMode(GL_MODELVIEW);     // floor
									//glPointSize(2.0);
	glBegin(GL_POLYGON);
		glColor3fv(BROWN);
		glVertex3f(-2, -2, 0);
		glVertex3f(2, -2, 0);
		glColor3fv(BLACK);
		glVertex3f(2, -2, -8);
		glVertex3f(-2, -2, -8);
	glEnd();
	
	glPushMatrix();
		glTranslatef(pos[0]-radius, pos[1], pos[2]-50);
		glRotatef(angle, rot[0], rot[1], rot[2]); // make the sphere rotate
		glColor3fv(RED);
		glutWireSphere(radius, 12, 12); //Draw a sphere
	glPopMatrix();
	
	glPushAttrib(GL_ENABLE_BIT);
		glMatrixMode(GL_PROJECTION);
		glPushMatrix();
			glLoadIdentity();
			gluOrtho2D(0, 1500, 0, 1500);
			glMatrixMode(GL_MODELVIEW);
			glPushMatrix();
				glLoadIdentity();
				glColor3fv(WHITE);
				renderTime = clock() - displayTimer;
				output(5, 5, ("ticks: " + std::to_string(renderTime)).c_str());
			glPopMatrix();
			glMatrixMode(GL_PROJECTION);
		glPopMatrix();
	glPopAttrib();
	glMatrixMode(GL_MODELVIEW);
	
	glutSwapBuffers();  // Swap the front and back frame buffers (double buffering)

	//std::cout << "RenderTime: " << renderTime << "ms";
}

void reshape(GLsizei width, GLsizei height){
	/* Handler for window re-size event. Called back when the window first appears and
	 whenever the window is re-sized with its new width and height 
	 from https://www3.ntu.edu.sg/home/ehchua/programming/opengl/CG_Examples.html
	 */
	if (height == 0) height = 1; // To prevent divide by 0
	GLfloat aspect = (GLfloat)width / (GLfloat)height;
 
	// Set the viewport to cover the new window
	glViewport(0, 0, width, height);
 
	// Set the aspect ratio of the clipping volume to match the viewport
	glMatrixMode(GL_PROJECTION);  // To operate on the Projection matrix
	glLoadIdentity();             // Reset
								  // Enable perspective projection with fovy, aspect, zNear and zFar
	gluPerspective(45.0f, aspect, 0.1f, 100.0f);
}

void keypress(unsigned char key, int x, int y){
	/*called when a key is pressed
	 x, y are relative mouse coords on keypress
	 During a keyboard callback, glutGetModifiers may be called to determine the state of modifier keys when the keystroke generating the callback occurred.
	 */
}
void mousepress(int button, int state, int x, int y){
	/* called when mouse button is pressed
	 When a user presses and releases mouse buttons in the window, each press and each release generates a mouse callback. The button parameter is one of GLUT_LEFT_BUTTON, GLUT_MIDDLE_BUTTON, or GLUT_RIGHT_BUTTON. For systems with only two mouse buttons, it may not be possible to generate GLUT_MIDDLE_BUTTON callback. For systems with a single mouse button, it may be possible to generate only a GLUT_LEFT_BUTTON callback. The state parameter is either GLUT_UP or GLUT_DOWN indicating whether the callback was due to a release or press respectively.
	 During a mouse callback, glutGetModifiers may be called to determine the state of modifier keys when the mouse event generating the callback occurred.
	 

	 */
}
void mousemove(int x, int y){
	/*called when mouse is moved, x and y indicate mouse pos in relativewindow coords*/
}
void quitfunc(){
	/*called on quit*/
	std::cout << "Quitting!\n";
	exit(0);
}

void update(int) {
	float t = renderTime/1000; // timestep
	std::cout << renderTime << '\n';
	bool collision[3] = {false, false, false};
	
	for(int a = 0; a < 3; a++){
		GLfloat po = pos[a];
		
		pos[a] += vel[a]*t + 0.5*acc[a]*t*t;
		vel[a] += acc[a]*t;
		
		// collision correction here
		if(pos[a] < floor_){
			vel[a] = 0.7*(po - pos[a] - 0.5*acc[a]*t*t)/t;
			pos[a] = floor_;
			collision[a] = true;
		}
		if(pos[a] > ceil_){
			pos[a] = ceil_;
			vel[a] = 0.7*(po - pos[a] - 0.5*acc[a]*t*t)/t;
			collision[a] = true;
		}
	}
	if(collision[0]){
		rot[1] = -radius*vel[1];
		rot[2] = -radius*vel[2];
	}
	if(collision[1]){
		rot[0] = -radius*vel[0];
		rot[2] = -radius*vel[2];
	}
	if(collision[2]){
		rot[1] = -radius*vel[1];
		rot[0] = -radius*vel[0];
	}
	angle += sqrt(vel[0]*vel[0]+vel[1]*vel[1]+vel[2]*vel[2])*radius;
	if(angle > 360){
		angle -= 360;
	}
	
	glutPostRedisplay();
	glutTimerFunc(FPS, update, 0);
}

int main(int argc, char **argv){
	std::cout << "a\n";
	glutInit(&argc, argv);
	
	glutInitWindowSize(800, 800);
	//glutInitWindowPosition(720-400, 450-400);
	glutInitDisplayMode(GLUT_DOUBLE | GLUT_DEPTH);
	
	glutCreateWindow("5611 assignment 1");
	
	// setup callbacks
	glutDisplayFunc(display);
	glutReshapeFunc(reshape);
	glutKeyboardFunc(keypress);
	glutMouseFunc(mousepress);
	glutMotionFunc(mousemove);
	glutPassiveMotionFunc(mousemove);
	glutWMCloseFunc(quitfunc);
	glutTimerFunc(FPS, update, 0);
	//glutVisibilityFunc(visible);
	
	/* Initialize OpenGL Graphics */
	glClearColor(0.0f, 0.0f, 0.0f, 1.0f); // Set background color to black and opaque
	glClearDepth(1.0f);                   // Set background depth to farthest
	glEnable(GL_DEPTH_TEST);   // Enable depth testing for z-culling
	glDepthFunc(GL_LEQUAL);    // Set the type of depth-test
	glShadeModel(GL_SMOOTH);   // Enable smooth shading
	glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);  // Nice perspective corrections
	std::cout << "b\n";

	
	glutMainLoop();
	
	return 0; /* ANSI C requires main to return int. */
}