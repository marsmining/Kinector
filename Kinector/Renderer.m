//
//  Renderer.m
//  Kinector
//
//  Created by foo on 8/26/12.
//  Copyright (c) 2012 Ockham Solutions GmbH. All rights reserved.
//

#import "Renderer.h"

// An array of 3 vectors which represents 3 vertices
static const GLfloat g_vertex_buffer_data[] = {
    -1.0f, -1.0f, 0.0f,
     1.0f, -1.0f, 0.0f,
     0.0f,  1.0f, 0.0f,
};

@interface Renderer() {
    @private
    
    Timer *timer;
    GLuint width;
    GLuint height;
}
@end

@implementation Renderer

@synthesize delegate = _delegate;

// This will identify our vertex buffer
GLuint vertexbuffer;

/**
 * Render the buffer owned by the Kinect object.
 */
- (void) render {

    NSLog(@"Renderer - render - fps: %3.1f", [timer timtick]);

    glClear(GL_COLOR_BUFFER_BIT);
    
    if ([self.delegate getDepthBuffer] != 0) {
        glRasterPos2i(0, 0);
        glDrawPixels(640, 480, GL_RGB, GL_UNSIGNED_BYTE, [self.delegate getDepthBuffer]);
    }
    
    // point stuff
    glColor3f(1.0f, 0.0f, 0.0f);
    glPointSize(10.0f);
    glBegin(GL_POINTS);
    glVertex2i(20, 20);
    glEnd();
    
    glFlush();
}

- (void) prepare {
    NSLog(@"Renderer - prepare");
    
    glShadeModel(GL_FLAT);
    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    glPixelZoom(1.0, -1.0);

    glViewport(0, 0, (GLsizei) width, (GLsizei) height);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(0, width, height, 0, -1.0, 1.0);
    glMatrixMode(GL_MODELVIEW);
    
    glClearColor(1.0f, 1.0f, 1.0f, 0.0f);
}

- (id) initWithDelegate:(id)adel {
    
    NSLog(@"Renderer - initWithDelegate - %s %s",
          glGetString(GL_RENDERER), glGetString(GL_VERSION));
    
	if((self = [super init])) {
        
        self.delegate = adel;

        timer = [[Timer alloc] init];
        
        width = INITIAL_WIDTH;
        height = INITIAL_HEIGHT;
        
        [self prepare];
	}
	
	return self;
}

- (void) resizeWithWidth:(GLuint)pwidth AndHeight:(GLuint)pheight {
	
	width = pwidth;
	height = pheight;
    
    [self prepare];
}

@end

