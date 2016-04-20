//
// Created by Jake Wise on 17/04/2016.
// Copyright (c) 2016 Jake Wise. All rights reserved.
//

#import "GCDIReference.h"

@implementation GCDIReference

@synthesize serviceId = _serviceId,
            invalidBehaviourType = _invalidBehaviourType;

+ (GCDIReference *)referenceForServiceNamed:(NSString *)serviceId {
  return [[GCDIReference alloc] initForServiceNamed:serviceId
                               invalidBehaviourType:kExceptionOnInvalidReference];
}

+ (GCDIReference *)referenceForServiceNamed:(NSString *)serviceId
                       invalidBehaviourType:(GCDIInvalidBehaviourType)invalidBehaviourType {
  return [[GCDIReference alloc] initForServiceNamed:serviceId
                               invalidBehaviourType:invalidBehaviourType];
}

- (GCDIReference *)initForServiceNamed:(NSString *)serviceId
                       invalidBehaviourType:(GCDIInvalidBehaviourType)invalidBehaviourType {
  self = [super init];
  if (self == nil) {
    return nil;
  }

  _serviceId = serviceId.copy;
  _invalidBehaviourType = invalidBehaviourType;

  return self;
}

@end