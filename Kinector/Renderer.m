//
//  Renderer.m
//  Kinector
//
//  Created by foo on 8/26/12.
//  Copyright (c) 2012 Ockham Solutions GmbH. All rights reserved.
//

#import "Renderer.h"

@interface Renderer() {
    @private
    
    Timer *timer;
    GLuint _width;
    GLuint _height;
    GLuint _tex;
}
@end

@implementation Renderer

@synthesize delegate = _delegate;

/**
 * Render the buffer owned by the Kinect object.
 */
- (void) render {
    
    // fps calculation
    
    NSLog(@"Renderer - render - fps: %3.1f", [timer timtick]);
    
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
    
    glFlush();

}

- (id) initWithDelegate:(id)adel {
    
	if((self = [super init])) {
        
        self.delegate = adel;

        timer = [[Timer alloc] init];
        
		NSLog(@"Renderer - initWithDelegate - %s %s",
              glGetString(GL_RENDERER), glGetString(GL_VERSION));

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

