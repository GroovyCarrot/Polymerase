//
// GCDependencyInjection
//
// Created by Jake Wise on 17/04/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//
// You are permitted to use, modify, and distribute this file in accordance with
// the terms of the license agreement accompanying it.
//

#import <Foundation/Foundation.h>

@interface GCDIExampleService : NSObject
@property (nonatomic, strong) NSNumber *a;
@property (nonatomic, strong) NSNumber *b;
@property (nonatomic, strong) NSNumber *c;
- (GCDIExampleService *)initService;
- (BOOL)exampleServiceInitialised;
- (void)setA:(NSNumber *)a andB:(NSNumber *)b;
- (void)setA:(NSNumber *)a andB:(NSNumber *)b andC:(NSNumber *)c;
@end
