//
// Created by Jake Wise on 17/04/2016.
// Copyright (c) 2016 Jake Wise. All rights reserved.
//

#import "GCDIExampleService.h"

@implementation GCDIExampleService {
 @private
  BOOL _initialised;
}

- (GCDIExampleService *)initService {
  self = [super init];
  if (self == nil) {
    return nil;
  }

  _initialised = TRUE;

  return self;
}

- (BOOL)exampleServiceInitialised {
  return _initialised;
}

@end