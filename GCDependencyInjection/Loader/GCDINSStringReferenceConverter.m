//
// GCDependencyInjection
//
// Created by Jake Wise on 19/05/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//
// You are permitted to use, modify, and distribute this file in accordance with
// the terms of the license agreement accompanying it.
//

#import "GCDINSStringReferenceConverter.h"
#import "GCDIReference.h"

@implementation GCDINSStringReferenceConverter

- (id)resolveReferencesToServices:(id)_services {
  if ([_services isKindOfClass:[NSArray class]]) {
    NSArray *services = _services;

    NSMutableArray *resolvedServices = @[].mutableCopy;
    for (id service in services) {
      resolvedServices[resolvedServices.count] = [self resolveReferencesToServices:service];
    }
    return resolvedServices.copy;
  }
  if ([_services isKindOfClass:[NSDictionary class]]) {
    NSDictionary *services = _services;

    NSMutableDictionary *resolvedServices = @{}.mutableCopy;
    for (NSString *key in services.allKeys) {
      resolvedServices[key] = [self resolveReferencesToServices:services[key]];
    }
    return resolvedServices.copy;
  }
  else if ([_services isKindOfClass:[NSString class]] && [_services rangeOfString:@"@"].location == 0) {
    NSString *service = _services;
    GCDIInvalidBehaviourType invalidBehaviourType = NULL;

    if ([service rangeOfString:@"@@"].location == 0) {
      service = [service substringFromIndex:1];
    }
    else if ([service rangeOfString:@"@?"].location == 0) {
      service = [service substringFromIndex:2];
      invalidBehaviourType = kNilOnInvalidReference;
    }
    else {
      service = [service substringFromIndex:1];
      invalidBehaviourType = kExceptionOnInvalidReference;
    }

    if (invalidBehaviourType != NULL) {
      return [GCDIReference referenceForServiceNamed:service
                                invalidBehaviourType:invalidBehaviourType];
    }

    return service;
  }

  return _services;
}

@end