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
#import "GCDIYamlExampleContainer.h"

@interface GCDIYamlCompilerTests : XCTestCase
@property (nonatomic, strong) GCDIYamlExampleContainer *container;
@end

@implementation GCDIYamlCompilerTests

- (void)setUp {
  [super setUp];

  _container = [[GCDIYamlExampleContainer alloc] init];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testYamlContainer {
  GCDIDependentExampleService *dependentExampleService = [_container getService:@"example.dependent_service"];
  XCTAssertTrue([dependentExampleService isDependentServiceInitialised]);

  GCDIInjectedExampleService *injectedExampleService = [_container getService:@"example.injected_service"];
  XCTAssertTrue([injectedExampleService.injectedService exampleServiceInitialised]);

  NSDictionary *services = [_container findServiceIdsForTag:@"type"];
  XCTAssertTrue([services[@"example.service"] isEqualToString:@"controller"]);
}

@end
