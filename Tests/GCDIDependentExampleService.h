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

@class GCDIExampleService;

@interface GCDIDependentExampleService : NSObject
@property (nonatomic, weak) GCDIExampleService *dependency;
- (GCDIDependentExampleService *)initWithDependentService:(GCDIExampleService *)dependency;
- (BOOL)isDependentServiceInitialised;
@end
