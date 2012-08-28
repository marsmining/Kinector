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

/**
 * Render the buffer owned by the Kinect object.
 */
- (void) render {
    
    // fps calculation
    
    NSLog(@"fps: %3.1f", timtick());
    
    // render
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    glBindTexture(GL_TEXTURE_2D, _tex);
    
    // glTexImage2D(GL_TEXTURE_2D, 0, 3, 640, 480, 0, GL_RGB, GL_UNSIGNED_BYTE, depth_mid);
    
    glBegin(GL_TRIANGLE_FAN);
    glColor4f(1.0f, 1.0f, 1.0f, 0.5f);
    glTexCoord2f(0, 0); glVertex3f(0,0,0);
    glTexCoord2f(1, 0); glVertex3f(640,0,0);
    glTexCoord2f(1, 1); glVertex3f(640,480,0);
    glTexCoord2f(0, 1); glVertex3f(0,480,0);
    glEnd();

}

- (id) init {
    
	if((self = [super init])) {
        
        timinit();
        
		NSLog(@"%s %s", glGetString(GL_RENDERER), glGetString(GL_VERSION));

		// Depth test will always be enabled
		glEnable(GL_DEPTH_TEST);
        
		// We will always cull back faces for better performance
		glEnable(GL_CULL_FACE);
        
        glClearColor(1.0f, 1.0f, 1.0f, 0.0f);
        glClearDepth(1.0);
        glDepthFunc(GL_LESS);
        glDepthMask(GL_FALSE);
        glDisable(GL_DEPTH_TEST);
        glDisable(GL_BLEND);
        glDisable(GL_ALPHA_TEST);
        glEnable(GL_TEXTURE_2D);
        glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        glShadeModel(GL_FLAT);
        
        glGenTextures(1, &_tex);
        glBindTexture(GL_TEXTURE_2D, _tex);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        
        // glViewport(0,0,Width,Height);
        glMatrixMode(GL_PROJECTION);
        glLoadIdentity();
        glOrtho(0, 640, 480, 0, -1.0f, 1.0f);
        glMatrixMode(GL_MODELVIEW);
        glLoadIdentity();

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

