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

@protocol GCDIInterpreterPluginProtocol;
@class GCDIDefinitionContainer;

@interface GCDIInterpreter : NSObject
+ (void)registerInterpreter:(id<GCDIInterpreterPluginProtocol>)resolver forClass:(Class)klass;
- (id)interpretValue:(id)value;
- (id)resolveValue:(id)_value forContainer:(GCDIDefinitionContainer *)container;
- (BOOL)hasResolverForClass:(Class)klass;
@end