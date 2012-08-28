//
//  NSGLView.m
//  Kinector
//
//  Created by foo on 8/26/12.
//  Copyright (c) 2012 Ockham Solutions GmbH. All rights reserved.
//

#import "NSGLView.h"

@interface NSGLView (PrivateMethods)

- (void) initGL;
- (void) drawView;

@end

@implementation NSGLView

@synthesize renderer = _renderer;

- (CVReturn) getFrameForTime:(const CVTimeStamp*)outputTime {
	[self drawView];
	return kCVReturnSuccess;
}

// renderer output callback function
static CVReturn dlc(CVDisplayLinkRef displayLink, const CVTimeStamp* now,
                    const CVTimeStamp* outputTime, CVOptionFlags flagsIn,
                    CVOptionFlags* flagsOut, void* displayLinkContext) {
    NSLog(@"callback invoked..");
    
    CVReturn result = [(__bridge NSGLView*) displayLinkContext getFrameForTime:outputTime];
    return result;
}

- (void) awakeFromNib {
    NSOpenGLPixelFormatAttribute attrs[] = {
		NSOpenGLPFADoubleBuffer,
		NSOpenGLPFADepthSize, 24,
		NSOpenGLPFAOpenGLProfile,
		NSOpenGLProfileVersion3_2Core,
		0
	};
	
	NSOpenGLPixelFormat *pf = [[NSOpenGLPixelFormat alloc] initWithAttributes:attrs];
	
	if (!pf) NSLog(@"No OpenGL pixel format");
    
    NSOpenGLContext* ctx = [[NSOpenGLContext alloc] initWithFormat:pf shareContext:nil];
    
    [self setPixelFormat:pf];
    [self setOpenGLContext:ctx];
}

- (void) prepareOpenGL {
	[super prepareOpenGL];
	
	// Make all the OpenGL calls to setup rendering
	//  and build the necessary rendering objects
	[self initGL];
	
	// Create a display link capable of being used with all active displays
	CVDisplayLinkCreateWithActiveCGDisplays(&displayLink);
	
	// Set the renderer output callback function
	CVDisplayLinkSetOutputCallback(displayLink, &dlc, (__bridge void *)(self));
	
	// Set the display link for the current renderer
	CGLContextObj cglContext = [[self openGLContext] CGLContextObj];
	CGLPixelFormatObj cglPixelFormat = [[self pixelFormat] CGLPixelFormatObj];
	CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext(displayLink, cglContext, cglPixelFormat);
	
	// Activate the display link
	CVDisplayLinkStart(displayLink);
}

- (void) initGL
{
	// Make this openGL context current to the thread
	// (i.e. all openGL on this thread calls will go to this context)
	[[self openGLContext] makeCurrentContext];
	
	// Synchronize buffer swaps with vertical refresh rate
	GLint swapInt = 1;
	[[self openGLContext] setValues:&swapInt forParameter:NSOpenGLCPSwapInterval];
	
	// Init our renderer.
	self.renderer = [[Renderer alloc] init];
}

- (void) reshape
{
	[super reshape];
	
	// We draw on a secondary thread through the display link
	// When resizing the view, -reshape is called automatically on the main thread
	// Add a mutex around to avoid the threads accessing the context simultaneously when resizing
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
