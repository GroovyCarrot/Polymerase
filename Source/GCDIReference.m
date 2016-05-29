//
// GCDependencyInjection
//
// Created by Jake Wise on 17/04/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//
// You are permitted to use, modify, and distribute this file in accordance with
// the terms of the license agreement accompanying it.
//

#import "GCDIReference.h"

@implementation GCDIReference

@synthesize serviceId = _serviceId,
            invalidBehaviourType = _invalidBehaviourType;

+ (GCDIReference *)referenceForServiceId:(NSString *)serviceId {
  return [[self alloc] initForServiceId:serviceId
                   invalidBehaviourType:kExceptionOnInvalidReference];
}

+ (GCDIReference *)referenceForServiceId:(NSString *)serviceId
                    invalidBehaviourType:(GCDIInvalidBehaviourType)invalidBehaviourType {
  return [[self alloc] initForServiceId:serviceId
                            invalidBehaviourType:invalidBehaviourType];
}

- (GCDIReference *)initForServiceId:(NSString *)serviceId
               invalidBehaviourType:(GCDIInvalidBehaviourType)invalidBehaviourType {
  self = [super init];
  if (!self) {
    return nil;
  }

  _serviceId = serviceId.copy;
  _invalidBehaviourType = invalidBehaviourType;

  return self;
}

@end