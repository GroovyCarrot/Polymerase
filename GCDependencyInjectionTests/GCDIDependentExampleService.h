//
// Created by Jake Wise on 17/04/2016.
// Copyright (c) 2016 Jake Wise. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCDIExampleService;

@interface GCDIDependentExampleService : NSObject
@property (nonatomic, weak) GCDIExampleService *dependency;
- (GCDIDependentExampleService *)initWithDependentService:(GCDIExampleService *)dependency;
- (BOOL)isDependentServiceInitialised;
@end
