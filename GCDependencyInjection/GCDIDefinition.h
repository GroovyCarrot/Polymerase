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

@interface GCDIDefinition : NSObject

@property (nonatomic, copy) NSString *klass;
@property (nonatomic, strong) id factory;
@property (nonatomic, getter=getSelector, setter=setSelector:) SEL pSelector;
@property (nonatomic, copy) NSString *pathToLibrary;

@property (nonatomic, copy) NSMutableArray *arguments;
@property (nonatomic, copy) NSMutableDictionary *properties;
@property (nonatomic, copy) NSMutableArray *methodInvocations;
@property (nonatomic, copy) NSMutableDictionary *tags;

@property (nonatomic, strong) id configurator;
@property (nonatomic) SEL configuratorSelector;

@property (nonatomic, getter=isShared) BOOL shared;
@property (nonatomic, getter=isPublic) BOOL public;
@property (nonatomic, getter=isLazy) BOOL lazy;
@property (nonatomic, getter=isSynthetic) BOOL synthetic;

@property (nonatomic, readonly, getter=isDepreciated) BOOL depreciated;
@property (nonatomic, copy, readonly, getter=getDepreciationMessage) NSString *depreciationMessage;

+ (GCDIDefinition *)definitionForClass:(Class)klass withSelector:(SEL)pSelector;
+ (GCDIDefinition *)definitionForClass:(Class)klass withSelector:(SEL)pSelector andArguments:(NSArray *)arguments;
+ (GCDIDefinition *)definitionForClassNamed:(NSString *)klass withSelector:(SEL)pSelector;
+ (GCDIDefinition *)definitionForClassNamed:(NSString *)klass withSelector:(SEL)pSelector andArguments:(NSArray *)arguments;

- (GCDIDefinition *)initForClassNamed:(NSString *)klass withSelector:(SEL)pSelector andArguments:(NSArray *)arguments;

- (void)setArguments:(NSArray *)arguments;
- (void)setProperties:(NSDictionary *)properties;
- (void)setMethodInvocations:(NSArray *)methodInvocations;
- (void)setTags:(NSDictionary *)tags;

- (void)addArgument:(id)argument;
- (void)replaceArgument:(id)argument atIndex:(NSUInteger)index;

- (void)addMethodInvocation:(NSInvocation *)methodInvocation;
- (void)addMethodCall:(SEL)pSelector withArguments:(NSArray *)arguments;
- (void)removeMethodCall:(SEL)pSelector;
- (BOOL)hasMethodCall:(SEL)pSelector;

- (NSString *)getTag:(NSString *)tag;
- (void)clearTag:(NSString *)tag;
- (void)clearTags;

- (void)setDepreciated:(BOOL)status forReason:(NSString *)reason;

// @todo autowiring?

@end
