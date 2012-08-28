//
//  Renderer.h
//  Kinector
//
//  Created by foo on 8/26/12.
//  Copyright (c) 2012 Ockham Solutions GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGL/OpenGL.h>

@interface Renderer : NSObject

- (void) render;

- (void) resizeWithWidth:(GLuint)width AndHeight:(GLuint)height;

@end
