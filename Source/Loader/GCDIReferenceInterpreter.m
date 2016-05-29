//
// GCDependencyInjection
//
// Created by Jake Wise on 19/05/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//
// You are permitted to use, modify, and distribute this file in accordance with
// the terms of the license agreement accompanying it.
//

#import "GCDIReferenceInterpreter.h"
#import "GCDIInterpreter.h"
#import "GCDIReference.h"
#import "GCDIDefinitionContainer.h"

@implementation GCDIReferenceInterpreter

+ (void)load {
  [GCDIInterpreter registerResolver:[[self alloc] init] forClass:[GCDIReference class]];
}

- (id)interpretStringRepresentation:(NSString *)service {
  if ([service rangeOfString:@"@"].location == 0) {
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
      return [GCDIReference referenceForServiceId:service
                             invalidBehaviourType:invalidBehaviourType];
    }

    return service;
  }

  return service;
}

- (id)resolveValue:(GCDIReference *)reference forContainer:(GCDIDefinitionContainer *)container {
  return [container getServiceNamed:reference.serviceId
               withInvalidBehaviour:reference.invalidBehaviourType];
}

@end