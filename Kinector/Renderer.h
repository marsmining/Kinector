//
//  Renderer.h
//  Kinector
//
//  Created by foo on 8/26/12.
//  Copyright (c) 2012 Ockham Solutions GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGL/OpenGL.h>
#import "KinectorProtocols.h"
#import "Timer.h"

#define INITIAL_WIDTH 640
#define INITIAL_HEIGHT 480

@interface Renderer : NSObject <RenderDelegate>

- (id) initWithDelegate:(id)adel;

- (void) prepare;

- (void) render;

- (void) resizeWithWidth:(GLuint)width AndHeight:(GLuint)height;

@property (nonatomic, weak) id <KinectBufferDelegate> delegate;

@end
