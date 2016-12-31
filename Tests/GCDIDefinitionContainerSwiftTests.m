//
// GCDependencyInjection
//
// Created by Jake Wise on 25/05/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//
// You are permitted to use, modify, and distribute this file in accordance with
// the terms of the license agreement accompanying it.
//

#import <XCTest/XCTest.h>
#import <Polymerase/Polymerase.h>
#import <Polymerase/GCDIDefinitionContainer+Swift.h>

@interface GCDependencyInjectionContainerSwiftTests : XCTestCase
@property (nonatomic, strong) GCDIDefinitionContainer *container;
@end

@interface GCDIDefinitionContainer (SwiftPrivate)
+ (NSString *)getSwiftClass:(NSString *)className forBundle:(NSString *)application;
@end

@implementation GCDependencyInjectionContainerSwiftTests

@synthesize container = _container;

- (void)setUp {
  [super setUp];

  _container = [[GCDIDefinitionContainer alloc] init];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testSwiftClassFromString {
  NSString *className;

  className = [GCDIDefinitionContainer getSwiftClass:@"GCDIExampleService" forBundle:@"MyApplication"];
  XCTAssertEqualObjects(@"_TtC13MyApplication18GCDIExampleService", className);

  className = [GCDIDefinitionContainer getSwiftClass:@"GCDIDependentExampleService" forBundle:@"MyApplication"];
  XCTAssertEqualObjects(@"_TtC13MyApplication27GCDIDependentExampleService", className);

  className = [GCDIDefinitionContainer getSwiftClass:@"GCDIInjectedExampleService" forBundle:@"ExampleApplication"];
  XCTAssertEqualObjects(@"_TtC18ExampleApplication26GCDIInjectedExampleService", className);
}

- (void)testSwiftSelectorFromString {
  SEL sel;
  sel = [_container swiftSelectorFromString:@"init(dependency:)"];
  XCTAssertEqualObjects(@"initWithDependency:", NSStringFromSelector(sel));

  sel = [_container swiftSelectorFromString:@"doThis(_:withThis:)"];
  XCTAssertEqualObjects(@"doThis:withThis:", NSStringFromSelector(sel));

  sel = [_container swiftSelectorFromString:@"doSomething()"];
  XCTAssertEqualObjects(@"doSomething", NSStringFromSelector(sel));
}

@end
