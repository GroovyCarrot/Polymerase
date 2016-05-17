//
// GCDependencyInjection
//
// Created by Jake Wise on 17/05/2016.
// Copyright (c) 2016 Jake Wise. All rights reserved.
//
// You are permitted to use, modify, and distribute this file in accordance with
// the terms of the license agreement accompanying it.
//

#import "GCDIExampleFactoryService.h"
#import "GCDIExampleService.h"

@implementation GCDIExampleFactoryService

- (GCDIExampleService *)newExampleService {
  return [[GCDIExampleService alloc] initService];
}

@end
