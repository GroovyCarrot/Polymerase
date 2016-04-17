//
//  GCDependencyInjectionTests.m
//  GCDependencyInjectionTests
//
//  Created by Jake Wise on 31/03/2016.
//  Copyright © 2016 Jake Wise. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GCDIDefinitionContainer.h"
#import "GCDIDefinition.h"
#import "GCDIExampleService.h"
#import "GCDIDependentExampleService.h"
#import "GCDIReference.h"
#import "GCDIParameterBag.h"

@interface GCDependencyInjectionTests : XCTestCase
@property (nonatomic, strong) GCDIDefinitionContainer *container;
@end

@implementation GCDependencyInjectionTests

@synthesize container = _container;

- (void)setUp {
  [super setUp];

  GCDIParameterBag *parameterBag = [[GCDIParameterBag alloc] initWithParameters:@{
    @"example.parameter": [GCDIReference referenceForServiceNamed:@"example.service"
                                             invalidBehaviourType:kExceptionOnInvalidReference]
  }];

  _container = [[GCDIDefinitionContainer alloc] initWithParameterBag:parameterBag];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testExampleService {
  GCDIDefinition *definition = [[GCDIDefinition alloc] initForClass:@"GCDIExampleService"
                                                       withSelector:@selector(initService)];

  [_container setDefinition:definition forServiceNamed:@"example.service"];

  GCDIExampleService *exampleService = [_container getServiceNamed:@"example.service"];
  XCTAssertTrue([exampleService exampleServiceInitialised]);
}

- (void)testDependentExampleService {
  GCDIDefinition *definition = [[GCDIDefinition alloc] initForClass:@"GCDIExampleService"
                                                       withSelector:@selector(initService)];
  [_container setDefinition:definition
            forServiceNamed:@"example.service"];

  GCDIExampleService *exampleService = [_container getServiceNamed:@"example.service"];
  XCTAssertTrue([exampleService exampleServiceInitialised]);

  definition = [[GCDIDefinition alloc] initForClass:@"GCDIDependentExampleService"
                                       withSelector:@selector(initWithDependentService:)
                                       andArguments:@[
                                         [GCDIReference referenceForServiceNamed:@"example.service"
                                                            invalidBehaviourType:kExceptionOnInvalidReference]
                                       ]];

  [_container setDefinition:definition
            forServiceNamed:@"example.dependent_service"];

  GCDIDependentExampleService *exampleDependentService = [_container getServiceNamed:@"example.dependent_service"];
  XCTAssertTrue([exampleDependentService isDependentServiceInitialised]);
}

- (void)testContainerParameters {
  GCDIDefinition *definition = [[GCDIDefinition alloc] initForClass:@"GCDIExampleService"
                                                       withSelector:@selector(initService)];

  [_container setDefinition:definition forServiceNamed:@"example.service"];

  definition = [[GCDIDefinition alloc] initForClass:@"GCDIDependentExampleService"
                                       withSelector:@selector(initWithDependentService:)
                                       andArguments:@[@"%example.parameter%"]];

  GCDIExampleService *exampleService = [_container getServiceNamed:@"example.service"];
  XCTAssertTrue([exampleService exampleServiceInitialised]);
}

@end
