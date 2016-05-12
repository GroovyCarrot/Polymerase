//
// GCDependencyInjection
//
// Created by Jake Wise on 17/04/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//
// You are permitted to use, modify, and distribute this file in accordance with
// the terms of the license agreement accompanying it.
//

#import "GCDIExampleService.h"

@implementation GCDIExampleService {
 @private
  BOOL _initialised;
}

- (GCDIExampleService *)initService {
  self = [super init];
  if (!self) {
    return nil;
  }

  _initialised = TRUE;

  return self;
}

- (BOOL)exampleServiceInitialised {
  return _initialised;
}

@end