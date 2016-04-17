//
// Created by Jake Wise on 17/04/2016.
// Copyright (c) 2016 Jake Wise. All rights reserved.
//

#import "GCDIDependentExampleService.h"
#import "GCDIExampleService.h"

@implementation GCDIDependentExampleService

- (GCDIDependentExampleService *)initWithDependentService:(GCDIExampleService *)dependency {
  self = [super init];
  if (self == nil) {
    return nil;
  }

  self.dependency = dependency;

  return self;
}

- (BOOL)isDependentServiceInitialised {
  return [self.dependency exampleServiceInitialised];
}

@end