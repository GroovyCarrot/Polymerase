//
// Created by Jake Wise on 17/04/2016.
// Copyright (c) 2016 Jake Wise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDIContainerProtocol.h"

@interface GCDIReference : NSObject
@property (nonatomic, readonly, copy) NSString *serviceId;
@property (nonatomic, readonly) GCDIInvalidBehaviourType invalidBehaviourType;
+ (GCDIReference *)referenceForServiceNamed:(NSString *)serviceId invalidBehaviourType:(GCDIInvalidBehaviourType)invalidBehaviourType;
- (GCDIReference *)initForServiceNamed:(NSString *)serviceId invalidBehaviourType:(GCDIInvalidBehaviourType)invalidBehaviourType;
@end
