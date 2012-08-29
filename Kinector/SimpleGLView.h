//
//  SimpleGLView.h
//  Kinector
//
//  Created by foo on 8/26/12.
//  Copyright (c) 2012 Ockham Solutions GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/CVDisplayLink.h>
#import "KinectorProtocols.h"

@interface SimpleGLView : NSOpenGLView {

    CVDisplayLinkRef displayLink;
}

@property (nonatomic, strong) id <RenderDelegate> renderer;

- (void) start;

- (void) stop;

- (BOOL) isRunning;

@end
