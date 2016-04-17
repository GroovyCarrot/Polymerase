//
// Created by Jake Wise on 29/03/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//

#import "GCDIServiceCircularReferenceException.h"

@implementation GCDIServiceCircularReferenceException

@synthesize serviceId = _serviceId;
@synthesize previousServiceIds = _previousServiceIds;

+ (id)exceptionForServiceNamed:(NSString *)serviceId
                      previous:(NSArray *)previousServiceIds {
  GCDIServiceCircularReferenceException *exception = [self init];

  [exception setServiceId:serviceId];
  [exception setPreviousServiceIds:previousServiceIds];

  return exception;
}

- (NSString *)description {
  return [NSString stringWithFormat:
    @"Circular reference detected for service \"%@\", path: %@.",
    _serviceId, _previousServiceIds];
}

@end
