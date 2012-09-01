//
//  KinectorProtocols.h
//  Kinector
//
//  Created by foo on 8/29/12.
//  Copyright (c) 2012 Ockham Solutions GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RenderDelegate <NSObject>

- (void) prepare;

- (void) render;

- (void) resizeWithWidth:(GLuint)width AndHeight:(GLuint)height;

@end

@protocol KinectBufferDelegate <NSObject>

- (uint8_t *) getDepthBuffer;

@end