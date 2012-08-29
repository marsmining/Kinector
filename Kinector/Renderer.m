//
//  Renderer.m
//  Kinector
//
//  Created by foo on 8/26/12.
//  Copyright (c) 2012 Ockham Solutions GmbH. All rights reserved.
//

#import "Renderer.h"
#import "timing.h"

@implementation Renderer

GLuint _width = 0;
GLuint _height = 0;
GLuint _tex;

static GLint vertices[] = {
    25, 25,
    100, 325,
    175, 25,
    175, 325,
    250, 25,
    325, 325};

static GLfloat colors[] = {
    1.0, 0.2, 0.2,
    0.2, 0.2, 1.0,
    0.8, 1.0, 0.2,
    0.75, 0.75, 0.75,
    0.35, 0.35, 0.35,
    0.5, 0.5, 0.5};

@synthesize delegate = _delegate;

/**
 * Render the buffer owned by the Kinect object.
 */
- (void) render {
    
    // fps calculation
    
    NSLog(@"Renderer - render - fps: %3.1f", timtick());
    
    // render
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    glBindTexture(GL_TEXTURE_2D, _tex);
    
    if (self.delegate) {
        glTexImage2D(GL_TEXTURE_2D, 0, 3, 640, 480, 0, GL_RGB, GL_UNSIGNED_BYTE, [self.delegate getDepthBuffer]);
        
        glBegin(GL_TRIANGLE_FAN);
        glColor4f(1.0f, 0.7f, 1.0f, 0.0f);
        glTexCoord2f(0, 0); glVertex3f(0,0,0);
        glTexCoord2f(1, 0); glVertex3f(640,0,0);
        glTexCoord2f(1, 1); glVertex3f(640,480,0);
        glTexCoord2f(0, 1); glVertex3f(0,480,0);
        glEnd();
    }
    
    glColor3f(1.0f, 0.0f, 0.0f);
    
    glBegin(GL_LINE_LOOP);
    glVertex3f( 500.0, 20.0, 0.0);
    glVertex3f( 600.0, 20.0, 0.0);
    glVertex3f( 550.0, 120.0, 0.0);
    glEnd();
    
    // point stuff
    glEnable(GL_POINT_SMOOTH);
    glPointSize(10.0f);
    
    // line stuff
    glLineWidth(3.0f);
    
    glEnableClientState(GL_COLOR_ARRAY);
    glColorPointer(3, GL_FLOAT, 0, colors);
    
    glEnableClientState(GL_VERTEX_ARRAY);
    glVertexPointer(2, GL_INT, 0, vertices);
    
    size_t size = sizeof(vertices) / sizeof(GLint);
    glDrawArrays(GL_POINTS, 0, size / 2);
    
    glFlush();

}

- (id) initWithDelegate:(id)adel {
    
	if((self = [super init])) {
        
        self.delegate = adel;
        
        timinit();
        
		NSLog(@"%s %s", glGetString(GL_RENDERER), glGetString(GL_VERSION));

		// Depth test will always be enabled
		// glEnable(GL_DEPTH_TEST);
        
		// We will always cull back faces for better performance
		// glEnable(GL_CULL_FACE);
        
        glClearColor(1.0f, 1.0f, 1.0f, 0.0f);
        glClearDepth(1.0);
        glDepthFunc(GL_LESS);
        glDepthMask(GL_FALSE);
        glDisable(GL_DEPTH_TEST);
        glDisable(GL_BLEND);
        glDisable(GL_ALPHA_TEST);
        glEnable(GL_TEXTURE_2D);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        glShadeModel(GL_FLAT);
        
        glGenTextures(1, &_tex);
        glBindTexture(GL_TEXTURE_2D, _tex);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        
        // glViewport(0,0,640,480);
        glMatrixMode(GL_PROJECTION);
        glLoadIdentity();
        glOrtho(0, 640, 480, 0, -1.0f, 1.0f);
        glMatrixMode(GL_MODELVIEW);
        glLoadIdentity();

//        depth_mid = (uint8_t*)malloc(640*480*3);
//        
//        for (int i=0; i<640*480; i++) {
//            depth_mid[3*i+0] = 153;
//            depth_mid[3*i+1] = 204;
//            depth_mid[3*i+2] = 255;
//        }
	}
	
	return self;
}

- (void) resizeWithWidth:(GLuint)width AndHeight:(GLuint)height
{
	glViewport(0, 0, width, height);
	
	_width = width;
	_height = height;
}

@end

