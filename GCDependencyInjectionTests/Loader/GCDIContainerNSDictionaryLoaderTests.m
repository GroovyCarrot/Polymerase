//
//  GCDependencyInjectionTests.m
//  GCDependencyInjectionTests
//
//  Created by Jake Wise on 31/03/2016.
//  Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GCDIDefinitionContainer.h"
#import "GCDIContainerNSDictionaryLoader.h"
#import "GCDIDependentExampleService.h"

@interface GCDIContainerNSDictionaryLoaderTests : XCTestCase
@property (nonatomic, strong) GCDIDefinitionContainer *container;
@property (nonatomic, strong) GCDIContainerNSDictionaryLoader *loader;
@end

@implementation GCDIContainerNSDictionaryLoaderTests

@synthesize container = _container;

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

@end
