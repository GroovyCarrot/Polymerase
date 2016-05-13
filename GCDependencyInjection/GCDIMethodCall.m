//
// GCDependencyInjection
//
// Created by Jake Wise on 13/05/2016.
// Copyright (c) 2016 Jake Wise. All rights reserved.
//
// You are permitted to use, modify, and distribute this file in accordance with
// the terms of the license agreement accompanying it.
//

#import "GCDIMethodCall.h"

@implementation GCDIMethodCall

+ (GCDIMethodCall *)methodCallForSelector:(SEL)pSelector andArguments:(NSArray *)arguments {
  return [[GCDIMethodCall alloc] initWithSelector:pSelector andArguments:arguments];
}

- (GCDIMethodCall *)initWithSelector:(SEL)pSelector andArguments:(NSArray *)arguments {
  self = [super init];
  if (!self) {
    return nil;
  }

  _pSelector = pSelector;
  _arguments = arguments.copy;

  return self;
}

- (BOOL)isEqualToMethodCall:(GCDIMethodCall *)methodCall {
  return (_pSelector == methodCall.pSelector) && [_arguments isEqualToArray:methodCall.arguments];
}

@end