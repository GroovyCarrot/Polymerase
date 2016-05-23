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
    @"example.parameter": [GCDIReference referenceForServiceId:@"example.service"]
  }];

  _container = [[GCDIDefinitionContainer alloc] initWithParameterBag:parameterBag];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testExampleService {
  [_container setService:@"example.service" definition:^(GCDIDefinition *definition) {
    [definition setClass:[GCDIExampleService class]];
    [definition setInitializerSelector:@selector(initService)];
  }];

  GCDIExampleService *exampleService = _container[@"example.service"];
  XCTAssertTrue([exampleService exampleServiceInitialised]);
}

- (void)testDependentExampleService {
  [_container registerService:@"example.service"
                     forClass:[GCDIExampleService class]
                  andSelector:@selector(initService)];

  GCDIExampleService *exampleService = _container[@"example.service"];
  XCTAssertTrue([exampleService exampleServiceInitialised]);

  [_container setService:@"example.dependent_service" definition:^(GCDIDefinition *definition) {
    [definition setClass:[GCDIDependentExampleService class]];
    [definition setInitializerSelector:@selector(initWithDependentService:)];
    [definition setArguments:@[
      [GCDIReference referenceForServiceId:@"example.service"]
    ]];
  }];

  NSArray *expectedServices = @[@"example.service", @"service_container", @"example.dependent_service"];
  XCTAssertEqualObjects(expectedServices, [_container getServiceIds]);

  GCDIDependentExampleService *exampleDependentService = _container[@"example.dependent_service"];
  XCTAssertTrue([exampleDependentService isDependentServiceInitialised]);
}

- (void)testContainerParameters {
  [_container registerService:@"example.service"
                     forClass:[GCDIExampleService class]
                  andSelector:@selector(initService)];

  [_container setService:@"example.dependent_service" definition:^(GCDIDefinition *definition) {
    [definition setClass:[GCDIDependentExampleService class]];
    [definition setInitializerSelector:@selector(initWithDependentService:)];
    [definition setArguments:@[@"%example.parameter%"]];
  }];

  GCDIDependentExampleService *dependentExampleService = _container[@"example.dependent_service"];
  XCTAssertTrue([dependentExampleService isDependentServiceInitialised]);
}

- (void)testDefinitionMethodCalls {
  [_container registerService:@"example.service"
                     forClass:[GCDIExampleService class]
                  andSelector:@selector(initService)];

  [_container setService:@"example.injected_service" definition:^(GCDIDefinition *definition) {
    [definition setClass:[GCDIInjectedExampleService class]];
    [definition addMethodCall:
      [GCDIMethodCall methodCallForSelector:@selector(setInjectedService:)
                               andArguments:@[[GCDIReference referenceForServiceId:@"example.service"]]]];
  }];

  GCDIInjectedExampleService *service = _container[@"example.injected_service"];
  XCTAssertTrue([[service injectedService] exampleServiceInitialised]);
}

- (void)testDefinitionProperties {
  [_container registerService:@"example.service"
                     forClass:[GCDIExampleService class]
                  andSelector:@selector(initService)];

  [_container setService:@"example.injected_service" definition:^(GCDIDefinition *definition) {
    [definition setClass:[GCDIInjectedExampleService class]];
    [definition setSetters:@{
      @"setInjectedService:" : [GCDIReference referenceForServiceId:@"example.service"],
    }];
  }];

  GCDIInjectedExampleService *service = _container[@"example.injected_service"];
  XCTAssertTrue([[service injectedService] exampleServiceInitialised]);
}

@end
