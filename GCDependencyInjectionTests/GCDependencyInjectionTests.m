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

@interface GCDependencyInjectionTests : XCTestCase
@property (nonatomic, strong) GCDIDefinitionContainer *container;
@end

@implementation GCDependencyInjectionTests

@synthesize container = _container;

- (void)setUp {
  [super setUp];

  GCDIParameterBag *parameterBag = [[GCDIParameterBag alloc] initWithParameters:@{
    @"example.parameter": [GCDIReference referenceForServiceNamed:@"example.service"]
  }];

  _container = [[GCDIDefinitionContainer alloc] initWithParameterBag:parameterBag];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testExampleService {
  GCDIDefinition *definition = [GCDIDefinition definitionForClass:[GCDIExampleService class]
                                                     withSelector:@selector(initService)];

  [_container setDefinition:definition forService:@"example.service"];

  GCDIExampleService *exampleService = [_container getService:@"example.service"];
  XCTAssertTrue([exampleService exampleServiceInitialised]);
}

- (void)testDependentExampleService {
  GCDIDefinition *definition;

  [_container registerService:@"example.service"
                     forClass:[GCDIExampleService class]
                  andSelector:@selector(initService)];

  GCDIExampleService *exampleService = [_container getService:@"example.service"];
  XCTAssertTrue([exampleService exampleServiceInitialised]);

  definition = [GCDIDefinition definitionForClass:[GCDIDependentExampleService class]
                                     withSelector:@selector(initWithDependentService:)
                                     andArguments:@[
                                       [GCDIReference referenceForServiceNamed:@"example.service"]
                                     ]];
  [_container setDefinition:definition forService:@"example.dependent_service"];

  NSArray *expectedServices = @[@"example.service", @"service_container", @"example.dependent_service"];
  XCTAssertEqualObjects(expectedServices, [_container getServiceIds]);

  GCDIDependentExampleService *exampleDependentService = [_container getService:@"example.dependent_service"];
  XCTAssertTrue([exampleDependentService isDependentServiceInitialised]);
}

- (void)testContainerParameters {
  GCDIDefinition *definition;

  [_container registerService:@"example.service"
                     forClass:[GCDIExampleService class]
                  andSelector:@selector(initService)];

  definition = [GCDIDefinition definitionForClass:[GCDIDependentExampleService class]
                                     withSelector:@selector(initWithDependentService:)
                                     andArguments:@[@"%example.parameter%"]];
  [_container setDefinition:definition forService:@"example.dependent_service"];

  GCDIDependentExampleService *dependentExampleService = [_container getService:@"example.dependent_service"];
  XCTAssertTrue([dependentExampleService isDependentServiceInitialised]);
}

- (void)testDefinitionMethodCalls {
  GCDIDefinition *definition;

  [_container registerService:@"example.service"
                     forClass:[GCDIExampleService class]
                  andSelector:@selector(initService)];

  definition = [GCDIDefinition definitionForClass:[GCDIInjectedExampleService class]];

  GCDIMethodCall *injector = [GCDIMethodCall methodCallForSelector:@selector(setInjectedService:)
                                                      andArguments:@[
                                                        [GCDIReference referenceForServiceNamed:@"example.service"]
                                                      ]];
  [definition addMethodCall:injector];

  [_container setDefinition:definition forService:@"example.injected_service"];

  GCDIInjectedExampleService *service = [_container getService:@"example.injected_service"];
  XCTAssertTrue([[service injectedService] exampleServiceInitialised]);
}

- (void)testDefinitionProperties {
  GCDIDefinition *definition;

  [_container registerService:@"example.service"
                     forClass:[GCDIExampleService class]
                  andSelector:@selector(initService)];

  definition = [GCDIDefinition definitionForClass:[GCDIInjectedExampleService class]];
  [definition setProperties:@{
    @"setInjectedService:": [GCDIReference referenceForServiceNamed:@"example.service"],
  }];
  [_container setDefinition:definition forService:@"example.injected_service"];

  GCDIInjectedExampleService *service = [_container getService:@"example.injected_service"];
  XCTAssertTrue([[service injectedService] exampleServiceInitialised]);
}

@end
