//
//  colors.h
//  
//
//  Created by Matthew Russell on 9/16/15.
//
// other colors can be assigned with:
//		GLfloat color[3] = {0.1, 0.1, 0.9};
//
//	glColor3fv(WHITE); // center


#ifndef _colors_h

const GLfloat BLACK[4] =	{0.0, 0.0, 0.0, 1.0};
const GLfloat WHITE[4] =	{1.0, 1.0, 1.0, 1.0};
const GLfloat GRAY[4] =		{0.5, 0.5, 0.5, 1.0};
#define GREY GRAY

const GLfloat RED[4] = 		{1.0, 0.0, 0.0, 1.0};
const GLfloat LIME[4] =		{0.0, 1.0, 0.0, 1.0};
const GLfloat BLUE[4] = 	{0.0, 0.0, 1.0, 1.0};

const GLfloat YELLOW[4] = 	{1.0, 1.0, 0.0, 1.0};
const GLfloat CYAN[4] = 	{0.0, 1.0, 1.0, 1.0};
const GLfloat MAGENTA[4] = 	{1.0, 0.0, 1.0, 1.0};

const GLfloat MAROON[4] = 	{0.5, 0.0, 0.0, 1.0};
const GLfloat GREEN[4] = 	{0.0, 0.5, 0.0, 1.0};
const GLfloat NAVY[4] = 	{0.0, 0.0, 0.5, 1.0};

const GLfloat OLIVE[4] = 	{0.5, 0.5, 0.0, 1.0};
const GLfloat TEAL[4] = 	{0.0, 0.5, 0.5, 1.0};
const GLfloat PURPLE[4] = 	{0.5, 0.0, 0.5, 1.0};

const GLfloat BROWN[4] = 	{0.65, 0.17, 0.17, 1.0};
const GLfloat ORANGE[4] = 	{1.0, 0.65, 0.0, 1.0};
const GLfloat VIOLET[4] = 	{0.93, 0.51, 0.93, 1.0};
const GLfloat PINK[4] = 	{1.0, 0.75, 0.8, 1.0};

const GLfloat GOLD[4] = 	{1.0, 0.84, 0.0, 1.0};
const GLfloat SILVER[4] = 	{0.75, 0.75, 0.75, 1.0};

#define OPAQUE	1.0
#define CLEAR	0.0

#define _colors_h


#endif
