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
#import "Polymerase.h"
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
    [definition useClass:[GCDIExampleService class]];
    [definition useInitializer:@selector(initService)];
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
    [definition useClass:[GCDIDependentExampleService class]];
    [definition useInitializer:@selector(initWithDependentService:)];
    [definition injectArguments:@[
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
    [definition useClass:[GCDIDependentExampleService class]];
    [definition useInitializer:@selector(initWithDependentService:)];
    [definition injectArguments:@[@"%example.parameter%"]];
  }];

  GCDIDependentExampleService *dependentExampleService = _container[@"example.dependent_service"];
  XCTAssertTrue([dependentExampleService isDependentServiceInitialised]);
}

- (void)testDefinitionMethodCalls {
  [_container registerService:@"example.service"
                     forClass:[GCDIExampleService class]
                  andSelector:@selector(initService)];

  [_container setService:@"example.injected_service" definition:^(GCDIDefinition *definition) {
    [definition useClass:[GCDIInjectedExampleService class]];
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
    [definition useClass:[GCDIInjectedExampleService class]];
    [definition setSetters:@{
      @"setInjectedService:" : [GCDIReference referenceForServiceId:@"example.service"],
    }];
  }];

  GCDIInjectedExampleService *service = _container[@"example.injected_service"];
  XCTAssertTrue([[service injectedService] exampleServiceInitialised]);
}

- (void)testMethodCallMultipleArguments {
  [_container setService:@"example_service.a_and_b" definition:^(GCDIDefinition *definition) {
    [definition useClass:[GCDIExampleService class]];
    [definition setMethodCalls:@[
      [GCDIMethodCall methodCallForSelector:@selector(setA:andB:)
                               andArguments:@[@100, @200]],
    ]];
  }];

  GCDIExampleService *service = [_container getService:@"example_service.a_and_b"];
  XCTAssertNotNil(service);
  XCTAssertEqualObjects(service.a, @100);
  XCTAssertEqualObjects(service.b, @200);

  [_container setService:@"example_service.a_and_b_and_c" definition:^(GCDIDefinition *definition) {
    [definition useClass:[GCDIExampleService class]];
    [definition setMethodCalls:@[
      [GCDIMethodCall methodCallForSelector:@selector(setA:andB:andC:)
                               andArguments:@[@300, @400, @500]],
    ]];
  }];

  service = [_container getService:@"example_service.a_and_b_and_c"];
  XCTAssertNotNil(service);
  XCTAssertEqualObjects(service.a, @300);
  XCTAssertEqualObjects(service.b, @400);
  XCTAssertEqualObjects(service.c, @500);
}

@end
