//
// GCDependencyInjection
//
// Created by Jake Wise on 12/05/2016.
// Copyright (c) 2016 GroovyCarrot. All rights reserved.
//
// You are permitted to use, modify, and distribute this file in accordance with
// the terms of the license agreement accompanying it.
//

#import <Foundation/Foundation.h>

@class GCDIExampleService;

@interface GCDIInjectedExampleService : NSObject
@property (nonatomic, strong, setter=setInjectedService:) GCDIExampleService *injectedService;
@end