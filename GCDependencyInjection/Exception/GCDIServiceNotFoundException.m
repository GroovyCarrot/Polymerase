//
// Created by Jake Wise on 29/03/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//

#import "GCDIServiceNotFoundException.h"

@implementation GCDIServiceNotFoundException

@synthesize serviceId = _serviceId,
            reason = _reason,
            alternatives = _alternatives;

+ (GCDIServiceNotFoundException *)exceptionForServiceNamed:(NSString *)serviceId {
  return [[GCDIServiceNotFoundException alloc] initForServiceNamed:serviceId];
}

+ (GCDIServiceNotFoundException *)exceptionForServiceNamed:(NSString *)serviceId withAlternatives:(NSArray *)alternatives {
  return [[GCDIServiceNotFoundException alloc] initForServiceNamed:serviceId
                                                  withAlternatives:alternatives];
}

- (GCDIServiceNotFoundException *)init {
  self = [super init];
  if (self == nil) {
    return nil;
  }

  _reason = @"Service not found";

  return self;
}

- (GCDIServiceNotFoundException *)initForServiceNamed:(NSString *)serviceId {
  self = [self init];
  if (self == nil) {
    return nil;
  }

  _serviceId = serviceId;

  return self;
}

- (GCDIServiceNotFoundException *)initForServiceNamed:(NSString *)serviceId withAlternatives:(NSArray *)alternatives {
  self = [self initForServiceNamed:serviceId];
  if (self == nil) {
    return nil;
  }

  _alternatives = alternatives.copy;

  return self;
}

- (NSString *)description {
  if (!_alternatives) {
    return [NSString stringWithFormat:
      @"You have requested a non-existent service \"%@\".",
      _serviceId];
  }

  return [NSString stringWithFormat:
    @"You have requested a non-existent service \"%@\", did you mean one of: %@",
    _serviceId, _alternatives];
}

@end
