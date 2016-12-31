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

@property (nonatomic, copy, setter=useClassNamed:) NSString *klass;
@property (nonatomic, strong) id factory;
@property (nonatomic, copy, getter=getInitializer, setter=useInitializerNamed:) NSString *initializer;
@property (nonatomic, copy) NSString *pathToLibrary;

@property (nonatomic, copy, setter=injectArguments:) NSArray<id> *arguments;
@property (nonatomic, copy) NSDictionary<NSString *, id> *setters;
@property (nonatomic, copy) NSArray<GCDIMethodCall *> *methodCalls;
@property (nonatomic, copy) NSDictionary<NSString *, NSString *> *tags;

@property (nonatomic, strong) id configurator;
@property (nonatomic, copy) NSString *configuratorSelector;

@property (nonatomic, getter=isShared) BOOL shared;
@property (nonatomic, getter=isPublic) BOOL isPublic;
@property (nonatomic, getter=isLazy) BOOL lazy;
@property (nonatomic, getter=isSynthetic) BOOL synthetic;

@property (nonatomic, readonly, getter=isDepreciated) BOOL depreciated;
@property (nonatomic, copy, readonly, getter=getDepreciationMessage) NSString *depreciationMessage;

- (GCDIDefinition *)initForClassNamed:(NSString *)klass withSelector:(NSString *)pSelector andArguments:(NSArray *)arguments;

- (void)useClass:(Class)klass;
- (void)useInitializer:(SEL)initializer;

- (void)addArgument:(id)argument;

- (void)replaceArgumentAtIndex:(NSUInteger)index with:(id)argument;

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
