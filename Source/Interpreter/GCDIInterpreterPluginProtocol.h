//
// GCDependencyInjection
//
// Created by Jake Wise on 29/05/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//
// You are permitted to use, modify, and distribute this file in accordance with
// the terms of the license agreement accompanying it.
//

#import <Foundation/Foundation.h>

@class GCDIReference, GCDIDefinitionContainer;
@protocol GCDIDefinitionContainerProtocol;

@protocol GCDIInterpreterPluginProtocol<NSObject>
- (id)resolveValue:(id)reference forContainer:(id<GCDIDefinitionContainerProtocol>)container;
- (id)interpretStringValue:(NSString *)value;
@end
