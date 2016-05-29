//
// GCDependencyInjection
//
// Created by Jake Wise on 13/05/2016.
// Copyright (c) 2016 GroovyCarrot. All rights reserved.
//
// You are permitted to use, modify, and distribute this file in accordance with
// the terms of the license agreement accompanying it.
//

#import "GCDIMethodCall.h"

@implementation GCDIMethodCall

+ (GCDIMethodCall *)methodCallForSelectorNamed:(NSString*)pSelector andArguments:(NSArray *)arguments {
  return [[self alloc] initWithSelector:pSelector andArguments:arguments];
}

+ (GCDIMethodCall *)methodCallForSelector:(SEL)pSelector andArguments:(NSArray *)arguments {
  return [[self alloc] initWithSelector:NSStringFromSelector(pSelector) andArguments:arguments];
}

- (GCDIMethodCall *)initWithSelector:(NSString *)pSelector andArguments:(NSArray *)arguments {
  self = [super init];
  if (!self) {
    return nil;
  }

  _pSelector = pSelector.copy;
  _arguments = arguments.copy;

  return self;
}

- (BOOL)isEqualToMethodCall:(GCDIMethodCall *)methodCall {
  return (_pSelector == methodCall.pSelector) && [_arguments isEqualToArray:methodCall.arguments];
}

@end