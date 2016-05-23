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
#import "GCDIContainerProtocol.h"

@interface GCDIReference : NSObject
@property (nonatomic, readonly, copy) NSString *serviceId;
@property (nonatomic, readonly) GCDIInvalidBehaviourType invalidBehaviourType;
+ (GCDIReference *)referenceForServiceId:(NSString *)serviceId;
+ (GCDIReference *)referenceForServiceId:(NSString *)serviceId invalidBehaviourType:(GCDIInvalidBehaviourType)invalidBehaviourType;
- (GCDIReference *)initForServiceId:(NSString *)serviceId invalidBehaviourType:(GCDIInvalidBehaviourType)invalidBehaviourType;
@end
