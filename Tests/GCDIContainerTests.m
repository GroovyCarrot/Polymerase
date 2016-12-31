//
// GCDependencyInjection
//
// Created by Jake Wise on 20/04/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//
// You are permitted to use, modify, and distribute this file in accordance with
// the terms of the license agreement accompanying it.
//

#import <XCTest/XCTest.h>
#import "Polymerase.h"
#import "GCDIExampleService.h"

@interface GCDIContainer (Tests)
- (SEL)getInitializerSelectorForService:(NSString *)serviceId;
@end


@interface GCDIContainerTests : XCTestCase
@property (nonatomic, strong) GCDIContainer *container;
@end

@implementation GCDIContainerTests

@synthesize container = _container;

- (void)setUp {
  [super setUp];

  _container = [[GCDIContainer alloc] init];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testGetSetService {
  GCDIExampleService *exampleService = [[GCDIExampleService alloc] initService];

  // Test setting example service set, and is converted to lowercase.
  // Use shorthand setter.
  _container[@"Example"] = exampleService;
  XCTAssertEqual(_container[@"example"], exampleService);
  XCTAssertEqual(_container[@"Example"], exampleService);
  XCTAssertEqual(_container[@"EXAMPLE"], exampleService);
  XCTAssertTrue([_container isServiceInitialised:@"example"]);

  @try {
    [_container setService:@"service_container" instance:exampleService];
    XCTFail(@"Failed to throw NSInvalidArgumentException for \"service_container\" service key.");
  }
  @catch (NSException *e) {
    XCTAssert([e.name isEqualToString:NSInvalidArgumentException]);
  }
}

- (void)testGetSelectorForService {
  NSString *testSelector;

  testSelector = NSStringFromSelector([_container getInitializerSelectorForService:@"example"]);
  XCTAssert([testSelector isEqualToString:@"getExampleService"]);

  testSelector = NSStringFromSelector([_container getInitializerSelectorForService:@"another_example"]);
  XCTAssert([testSelector isEqualToString:@"getAnotherExampleService"]);

  testSelector = NSStringFromSelector([_container getInitializerSelectorForService:@"yet.another_example"]);
  XCTAssert([testSelector isEqualToString:@"getYet_AnotherExampleService"]);
}

# pragma mark - Alias tests

- (void)testGetSetHasAliasedServices {
  GCDIExampleService *exampleService = [[GCDIExampleService alloc] initService];
  _container[@"example"] = exampleService;

  XCTAssertFalse([_container hasAlias:@"example"]);
  XCTAssertFalse([_container hasAlias:@"example.object"]);
  XCTAssertFalse([_container hasAlias:@"example.string"]);

  // Test setting
  [_container setAlias:@"example_alias.object" to:[GCDIAlias aliasForId:@"example"]];
  XCTAssert([_container hasAlias:@"example_alias.object"]);
  XCTAssertEqual(_container[@"example_alias.object"], exampleService);

  // Test setting an alias via a string.
  [_container setAlias:@"example_alias.string" to:@"example"];
  XCTAssert([_container hasAlias:@"example_alias.string"]);
  XCTAssertEqual(_container[@"example_alias.string"], exampleService);
}

@end
