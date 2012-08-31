//
//  SimpleGLView.m
//  Kinector
//
//  Created by foo on 8/26/12.
//  Copyright (c) 2012 Ockham Solutions GmbH. All rights reserved.
//

#import "SimpleGLView.h"

@interface SimpleGLView ()

- (void) drawView;

@end

@implementation SimpleGLView

@synthesize renderer = _renderer;

/**
 * Just delegate to 'drawView'.
 */
- (CVReturn) getFrameForTime:(const CVTimeStamp*)outputTime {
	[self drawView];
	return kCVReturnSuccess;
}

/**
 * Display link callback function
 */
static CVReturn dlc(CVDisplayLinkRef displayLink,
                    const CVTimeStamp* now,
                    const CVTimeStamp* outputTime,
                    CVOptionFlags flagsIn,
                    CVOptionFlags* flagsOut,
                    void* displayLinkContext)
{
    NSLog(@"SimpleGLView - dlc");
    
    // use the context passed in to call obj-c instance method
    CVReturn result = [(__bridge SimpleGLView*) displayLinkContext getFrameForTime:outputTime];
    return result;
}

/**
 * Start display link thread loop.
 */
- (void) start
{
    NSLog(@"SimpleGLView - start");
    
    // start the link
	CVDisplayLinkStart(displayLink);
}

/**
 * Stop the loop.
 */
- (void) stop
{
    NSLog(@"SimpleGLView - stop");
    
    // stop the link
    CVDisplayLinkStop(displayLink);
}

/**
 * Public status method.
 */
- (BOOL) isRunning {
    return CVDisplayLinkIsRunning(displayLink);
}

/**
 * Initial setup.
 */
- (void) awakeFromNib {
    NSLog(@"SimpleGLView - awakeFromNib");
    
    NSOpenGLPixelFormatAttribute attrs[] = {
        // setup attrs here, none for now
	};
	
	NSOpenGLPixelFormat *pf = [[NSOpenGLPixelFormat alloc] initWithAttributes:attrs];
	
	if (!pf) NSLog(@"No OpenGL pixel format");
    
    NSOpenGLContext* ctx = [[NSOpenGLContext alloc] initWithFormat:pf shareContext:nil];
    
    [self setPixelFormat:pf];
    [self setOpenGLContext:ctx];
}

- (void) prepareOpenGL {
    NSLog(@"SimpleGLView - prepareOpenGL");

    GLint swapInt = 1;

	[super prepareOpenGL];
    
	[[self openGLContext] makeCurrentContext];
	[[self openGLContext] setValues:&swapInt forParameter:NSOpenGLCPSwapInterval];
    
	CVDisplayLinkCreateWithActiveCGDisplays(&displayLink);	
	CVDisplayLinkSetOutputCallback(displayLink, &dlc, (__bridge void *)(self));
    CGLContextObj cglContext = [[self openGLContext] CGLContextObj];
	CGLPixelFormatObj cglPixelFormat = [[self pixelFormat] CGLPixelFormatObj];
	CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext(displayLink, cglContext, cglPixelFormat);
}

- (void) reshape {
    
	[super reshape];

	CGLLockContext([[self openGLContext] CGLContextObj]);
	
	NSRect rect = [self bounds];
	
	[self.renderer resizeWithWidth:rect.size.width AndHeight:rect.size.height];
	
	CGLUnlockContext([[self openGLContext] CGLContextObj]);
}

- (void) drawView
{
	[[self openGLContext] makeCurrentContext];
    
	// We draw on a secondary thread through the display link
	// When resizing the view, -reshape is called automatically on the main thread
	// Add a mutex around to avoid the threads accessing the context simultaneously	when resizing
	CGLLockContext([[self openGLContext] CGLContextObj]);

	[self.renderer render];
    	
	CGLFlushDrawable([[self openGLContext] CGLContextObj]);
	CGLUnlockContext([[self openGLContext] CGLContextObj]);
}

- (void) dealloc
{
	// Stop the display link BEFORE releasing anything in the view
    // otherwise the display link thread may call into the view and crash
    // when it encounters something that has been release
	CVDisplayLinkStop(displayLink);
    
	CVDisplayLinkRelease(displayLink);
}

@end
