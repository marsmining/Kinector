//
//  NSGLView.h
//  Kinector
//
//  Created by foo on 8/26/12.
//  Copyright (c) 2012 Ockham Solutions GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/CVDisplayLink.h>
#import "Renderer.h"

@interface NSGLView : NSOpenGLView {

    CVDisplayLinkRef displayLink;

}

@property (nonatomic, strong) Renderer* renderer;

@end
