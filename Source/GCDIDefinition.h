//
// GCDependencyInjection
//
// Created by Jake Wise on 30/03/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//
// You are permitted to use, modify, and distribute this file in accordance with
// the terms of the license agreement accompanying it.
//

#import <Foundation/Foundation.h>

@class GCDIMethodCall;

@interface GCDIDefinition : NSObject

@property (nonatomic, copy, setter=setClassName:) NSString *klass;
@property (nonatomic, strong) id factory;
@property (nonatomic, copy, getter=getInitializer, setter=setInitializer:) NSString *initializer;
@property (nonatomic, copy) NSString *pathToLibrary;

@property (nonatomic, copy) NSArray *arguments;
@property (nonatomic, copy) NSDictionary *setters;
@property (nonatomic, copy) NSArray *methodCalls;
@property (nonatomic, copy) NSDictionary *tags;

@property (nonatomic, strong) id configurator;
@property (nonatomic, copy) NSString *configuratorSelector;

@property (nonatomic, getter=isShared) BOOL shared;
@property (nonatomic, getter=isPublic) BOOL isPublic;
@property (nonatomic, getter=isLazy) BOOL lazy;
@property (nonatomic, getter=isSynthetic) BOOL synthetic;

@property (nonatomic, readonly, getter=isDepreciated) BOOL depreciated;
@property (nonatomic, copy, readonly, getter=getDepreciationMessage) NSString *depreciationMessage;

- (GCDIDefinition *)initForClassNamed:(NSString *)klass withSelector:(NSString *)pSelector andArguments:(NSArray *)arguments;

- (void)setClass:(Class)klass;
- (void)setInitializerSelector:(SEL)pSelector;
- (void)setArguments:(NSArray *)arguments;
- (void)setSetters:(NSDictionary *)setters;
- (void)setMethodCalls:(NSArray *)methodCalls;
- (void)setTags:(NSDictionary *)tags;

- (void)addArgument:(id)argument;
- (void)replaceArgument:(id)argument atIndex:(NSUInteger)index;

- (void)addMethodCall:(GCDIMethodCall *)methodCall;
- (void)removeMethodCall:(GCDIMethodCall *)methodCall;
- (BOOL)hasMethodCall:(GCDIMethodCall *)methodCall;

- (NSString *)getTag:(NSString *)tag;
- (void)clearTag:(NSString *)tag;
- (void)clearTags;

- (void)setDepreciated:(BOOL)status forReason:(NSString *)reason;

// @todo autowiring?

@end

typedef void (^GCDIDefinitionBlock)(GCDIDefinition *);
