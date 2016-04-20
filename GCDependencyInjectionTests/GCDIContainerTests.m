//
//  GCDIContainerTests.m
//  GCDIContainerTests
//
//  Created by Jake Wise on 20/04/2016.
//  Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GCDIContainer.h"
#import "GCDIExampleService.h"
#import "GCDIAlias.h"

@interface GCDIContainer (Tests)
- (SEL)getSelectorForServiceNamed:(NSString *)serviceId;
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
  [_container setService:@"Example" instance:exampleService];
  XCTAssertEqual([_container getService:@"example"], exampleService);
  XCTAssertEqual([_container getService:@"Example"], exampleService);
  XCTAssertEqual([_container getService:@"EXAMPLE"], exampleService);
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

  testSelector = NSStringFromSelector([_container getSelectorForServiceNamed:@"example"]);
  XCTAssert([testSelector isEqualToString:@"getExampleService"]);

  testSelector = NSStringFromSelector([_container getSelectorForServiceNamed:@"another_example"]);
  XCTAssert([testSelector isEqualToString:@"getAnotherExampleService"]);

  testSelector = NSStringFromSelector([_container getSelectorForServiceNamed:@"yet.another_example"]);
  XCTAssert([testSelector isEqualToString:@"getYet_AnotherExampleService"]);
}

# pragma mark - Alias tests

- (void)testGetSetAliasedServices {
  GCDIExampleService *exampleService = [[GCDIExampleService alloc] initService];
  [_container setService:@"example" instance:exampleService];

  // Test setting
  [_container setAlias:@"example_alias.object" to:[GCDIAlias aliasForId:@"example"]];
  XCTAssertEqual([_container getService:@"example_alias.object"], exampleService);

  // Test setting an alias via a string.
  [_container setAlias:@"example_alias.string" to:@"example"];
  XCTAssertEqual([_container getService:@"example_alias.string"], exampleService);
}

@end
