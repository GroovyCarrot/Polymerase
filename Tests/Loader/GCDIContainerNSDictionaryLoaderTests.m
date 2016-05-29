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
#import <GCDependencyInjection/GCDependencyInjection.h>
#import "GCDIExampleService.h"
#import "GCDIDependentExampleService.h"
#import "GCDIInjectedExampleService.h"

@interface GCDIContainerNSDictionaryLoaderTests : XCTestCase
@property (nonatomic, strong) GCDIDefinitionContainer *container;
@property (nonatomic, strong) GCDIContainerNSDictionaryLoader *loader;
@end

@implementation GCDIContainerNSDictionaryLoaderTests

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

  GCDIDependentExampleService *service = _container[@"example.dependent_service"];
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

  GCDIInjectedExampleService *service = _container[@"example.injected_service"];
  XCTAssertTrue([service.injectedService exampleServiceInitialised]);
}

- (void)testTagging {
  [_loader setDictionary:@{
    @"Services": @{
      @"example.service": @{
        @"Class": @"GCDIExampleService",
        @"Selector": @"initService",
        @"Tags": @{
          @"type": @"controller",
        },
      },
    },
  }];

  [_loader loadIntoContainer:_container];

  NSDictionary *services = [_container findServiceIdsForTag:@"type"];
  XCTAssertTrue([services[@"example.service"] isEqualToString:@"controller"]);
}

@end
