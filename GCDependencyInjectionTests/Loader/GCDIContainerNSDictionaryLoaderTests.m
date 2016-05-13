//
// GCDependencyInjection
//
// Created by Jake Wise on 31/03/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//
// You are permitted to use, modify, and distribute this file in accordance with
// the terms of the license agreement accompanying it.
//

#import <XCTest/XCTest.h>
#import "GCDIDefinitionContainer.h"
#import "GCDIContainerNSDictionaryLoader.h"
#import "GCDIDependentExampleService.h"
#import "GCDIInjectedExampleService.h"
#import "GCDIExampleService.h"

@interface GCDIContainerNSDictionaryLoaderTests : XCTestCase
@property (nonatomic, strong) GCDIDefinitionContainer *container;
@property (nonatomic, strong) GCDIContainerNSDictionaryLoader *loader;
@end

@implementation GCDIContainerNSDictionaryLoaderTests

@synthesize container = _container,
            loader = _loader;

- (void)setUp {
  [super setUp];

  _loader = [[GCDIContainerNSDictionaryLoader alloc] init];
  _container = [[GCDIDefinitionContainer alloc] init];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testContainerNSDictionaryLoader {
  [_loader setDictionary:@{
    @"Parameters": @{
      @"example.parameter": @"@example.service",
    },
    @"Services": @{
      @"example.service": @{
        @"Class": @"GCDIExampleService",
        @"Selector": @"initService",
      },

      @"example.dependent_service": @{
        @"Class": @"GCDIDependentExampleService",
        @"Selector": @"initWithDependentService:",
        @"Arguments": @[
          @"%example.parameter%",
        ],
      }
    },
  }];

  [_loader loadIntoContainer:_container];

  GCDIDependentExampleService *service = [_container getService:@"example.dependent_service"];
  XCTAssertTrue([service isDependentServiceInitialised]);
}

- (void)testServiceProvisioning {
  [_loader setDictionary:@{
    @"Parameters": @{
      @"example.parameter": @"@example.service",
    },
    @"Services": @{
      @"example.service": @{
        @"Class": @"GCDIExampleService",
        @"Selector": @"initService",
      },

      @"example.injected_service": @{
        @"Class": @"GCDIInjectedExampleService",
        @"Selector": @"init",
        @"MethodCalls": @[
          @{
            @"Selector": @"setInjectedService:",
            @"Arguments": @[@"@example.service"],
          }
        ],
      }
    },
  }];

  [_loader loadIntoContainer:_container];

  GCDIInjectedExampleService *service = [_container getService:@"example.injected_service"];
  XCTAssertTrue([service.injectedService exampleServiceInitialised]);
}

@end
