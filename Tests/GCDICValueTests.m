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

@interface GCDICValueTests : XCTestCase
@property (nonatomic, strong) GCDIDefinitionContainer *container;
@end

@implementation GCDICValueTests {
  NSValue *_value;
}

- (void)setUp {
  [super setUp];

  _container = [[GCDIDefinitionContainer alloc] init];

  [_container setService:@"example.test.NSInteger" definition:^(GCDIDefinition *definition) {
    [definition setClass:[GCDIExampleService class]];
    [definition addMethodCall:[GCDIMethodCall methodCallForSelector:@selector(setANSInteger:)
                                                       andArguments:@[[NSValue valueWithInteger:999]]]];
  }];

  [_container setService:@"example.test.float" definition:^(GCDIDefinition *definition) {
    [definition setClass:[GCDIExampleService class]];
    [definition addMethodCall:[GCDIMethodCall methodCallForSelector:@selector(setAFloat:)
                                                       andArguments:@[[NSValue valueWithFloat:99.999]]]];
  }];

  // Test using a raw float value, wrapped in NSValue.
  float aValue = 99.999;
  [_container setService:@"example.test.float.raw" definition:^(GCDIDefinition *definition) {
    [definition setClass:[GCDIExampleService class]];
    [definition addMethodCall:[GCDIMethodCall methodCallForSelector:@selector(setAFloat:)
                                                       andArguments:@[[NSValue valueWithBytes:&aValue
                                                                                     objCType:@encode(float)]]]];
  }];
}

- (void)testValueWithFloat {
  // float check.
  _value = [NSValue valueWithFloat:99.999];
  float test1CValue;
  [_value getValue:&test1CValue];
  XCTAssertEqual(test1CValue, (float) 99.999);
  XCTAssertNotEqual(test1CValue, (float) -99.999);

  // Negative float check.
  _value = [NSValue valueWithFloat:-99.999];
  float test2CValue;
  [_value getValue:&test2CValue];
  XCTAssertEqual(test2CValue, (float) -99.999);
  XCTAssertNotEqual(test2CValue, (float) 99.999);
}

- (void)testValueWithDouble {
  // double check.
  _value = [NSValue valueWithDouble:0.0001];
  double test1CValue;
  [_value getValue:&test1CValue];
  XCTAssertEqual(test1CValue, (double) 0.0001);
  XCTAssertNotEqual(test1CValue, (double) -0.0001);

  // double check.
  _value = [NSValue valueWithDouble:-0.0001];
  double test2CValue;
  [_value getValue:&test2CValue];
  XCTAssertEqual(test2CValue, (double) -0.0001);
  XCTAssertNotEqual(test2CValue, (double) 0.0001);
}

- (void)testValueWithInt {
  // int check.
  _value = [NSValue valueWithInt:99];
  int test1CValue;
  [_value getValue:&test1CValue];
  XCTAssertEqual(test1CValue, 99);
  XCTAssertNotEqual(test1CValue, -99);

  // Negative int check.
  _value = [NSValue valueWithInt:-99];
  int test2CValue;
  [_value getValue:&test2CValue];
  XCTAssertEqual(test2CValue, -99);
  XCTAssertNotEqual(test2CValue, 99);
}

- (void)testValueWithUnsignedInt {
  // unsigned int check.
  _value = [NSValue valueWithUnsignedInt:99];
  unsigned int test1CValue;
  [_value getValue:&test1CValue];
  XCTAssertEqual(test1CValue, (unsigned int) 99);
  XCTAssertNotEqual(test1CValue, (unsigned int) -99);

  // Negative unsigned int check.
  _value = [NSValue valueWithUnsignedInt:-99];
  unsigned int test2CValue;
  [_value getValue:&test2CValue];
  XCTAssertEqual(test2CValue, (unsigned int) -99);
  XCTAssertNotEqual(test2CValue, (unsigned int) 99);
  // Validate that -99 is actually converted to negative offset from maximum.
  XCTAssertEqual(test2CValue, UINT_MAX - 98);
}

- (void)testValueWithInteger {
  // NSInteger check.
  _value = [NSValue valueWithInteger:999];
  NSInteger test1CValue;
  [_value getValue:&test1CValue];
  XCTAssertEqual(test1CValue, 999);
  XCTAssertEqual(test1CValue, (long long) 999);
  XCTAssertNotEqual(test1CValue, -999);
  XCTAssertNotEqual(test1CValue, (long long) -999);

  // Negative NSInteger check.
  _value = [NSValue valueWithInteger:-999];
  XCTAssert([_value isKindOfClass:[NSValue class]]);
  NSInteger test2CValue;
  [_value getValue:&test2CValue];
  XCTAssertEqual(test2CValue, -999);
  XCTAssertEqual(test2CValue, (long long) -999);
  XCTAssertNotEqual(test2CValue, 999);
  XCTAssertNotEqual(test2CValue, (long long) 999);
}

- (void)testValueWithUnsignedInteger {
  // NSUInteger check.
  _value = [NSValue valueWithUnsignedInteger:999];
  XCTAssert([_value isKindOfClass:[NSValue class]]);
  NSUInteger test1CValue;
  [_value getValue:&test1CValue];
  XCTAssertEqual(test1CValue, (NSUInteger) 999);
  XCTAssertNotEqual(test1CValue, (NSUInteger) -999);

  // NSUInteger negative check.
  _value = [NSValue valueWithUnsignedInteger:(NSUInteger) -999];
  XCTAssert([_value isKindOfClass:[NSValue class]]);
  NSUInteger test5CValue;
  [_value getValue:&test5CValue];
  XCTAssertEqual(test5CValue, (NSUInteger) -999);
  XCTAssertNotEqual(test5CValue, (NSUInteger) 999);
  // Validate that -999 is actually converted to negative offset from maximum.
  NSUInteger cmp5CValue = NSUIntegerMax - 998;
  XCTAssertEqual(test5CValue, cmp5CValue);
}

- (void)testValueWithLong {
  // Long long check.
  _value = [NSValue valueWithLong:999];
  long test1CValue;
  [_value getValue:&test1CValue];
  XCTAssertEqual(test1CValue, 999);
  XCTAssertNotEqual(test1CValue, -999);

  // Long long check.
  _value = [NSValue valueWithLong:-999];
  long test2CValue;
  [_value getValue:&test2CValue];
  XCTAssertEqual(test2CValue, -999);
  XCTAssertNotEqual(test2CValue, 999);
}

- (void)testValueWithUnsignedLong {
  // unsigned long long negative check.
  _value = [NSValue valueWithUnsignedLong:(unsigned long) 999];
  unsigned long test1CValue;
  [_value getValue:&test1CValue];
  XCTAssertEqual(test1CValue, (unsigned long) 999);
  XCTAssertNotEqual(test1CValue, (unsigned long) -999);

  // unsigned long long negative check.
  _value = [NSValue valueWithUnsignedLong:(unsigned long) -999];
  unsigned long test2CValue;
  [_value getValue:&test2CValue];
  XCTAssertEqual(test2CValue, (unsigned long) -999);
  XCTAssertNotEqual(test2CValue, (unsigned long) 999);
  // Validate that -999 is actually converted to negative offset from maximum.
  unsigned long cmp2CValue = ULONG_MAX - 998;
  XCTAssertEqual(test2CValue, cmp2CValue);
}
- (void)testValueWithLongLong {
  // Long long check.
  _value = [NSValue valueWithLongLong:999];
  long long test1CValue;
  [_value getValue:&test1CValue];
  XCTAssertEqual(test1CValue, 999);
  XCTAssertNotEqual(test1CValue, -999);

  // Long long check.
  _value = [NSValue valueWithLongLong:-999];
  long long test2CValue;
  [_value getValue:&test2CValue];
  XCTAssertEqual(test2CValue, -999);
  XCTAssertNotEqual(test2CValue, 999);
}

- (void)testValueWithUnsignedLongLong {
  // unsigned long long negative check.
  _value = [NSValue valueWithUnsignedLongLong:(unsigned long long) 999];
  unsigned long long test1CValue;
  [_value getValue:&test1CValue];
  XCTAssertEqual(test1CValue, (unsigned long long) 999);
  XCTAssertNotEqual(test1CValue, (unsigned long long) -999);

  // unsigned long long negative check.
  _value = [NSValue valueWithUnsignedLongLong:(unsigned long long) -999];
  unsigned long long test2CValue;
  [_value getValue:&test2CValue];
  XCTAssertEqual(test2CValue, (unsigned long long) -999);
  XCTAssertNotEqual(test2CValue, (unsigned long long) 999);
  // Validate that -999 is actually converted to negative offset from maximum.
  unsigned long long cmp6CValue = ULLONG_MAX - 998;
  XCTAssertEqual(test2CValue, cmp6CValue);
}

- (void)testValueWithBOOL {
  // BOOL positive check.
  _value = [NSValue valueWithBOOL:YES];
  BOOL test1CValue;
  [_value getValue:&test1CValue];
  XCTAssertEqual(test1CValue, YES);
  XCTAssertNotEqual(test1CValue, NO);

  // BOOL negative check.
  _value = [NSValue valueWithBOOL:NO];
  BOOL test2CValue;
  [_value getValue:&test2CValue];
  XCTAssertEqual(test2CValue, NO);
  XCTAssertNotEqual(test2CValue, YES);
}

- (void)testValueWithBool {
  // bool/_Bool positive check.
  _value = [NSValue valueWithBool:TRUE];
  bool test1CValue;
  [_value getValue:&test1CValue];
  XCTAssertEqual(test1CValue, TRUE);
  XCTAssertNotEqual(test1CValue, FALSE);

  // bool/_Bool negative check.
  _value = [NSValue valueWithBool:FALSE];
  bool test2CValue;
  [_value getValue:&test2CValue];
  XCTAssertEqual(test2CValue, FALSE);
  XCTAssertNotEqual(test2CValue, TRUE);
}

- (void)testValueWithCString {
  _value = [NSValue valueWithCString:"test"];
  const char *test1CValue;
  [_value getValue:&test1CValue];
  XCTAssert((strcmp(test1CValue, "test") == 0));
}

- (void)testContainerCValueInterpreter {
  GCDIExampleService *exampleService = [_container getService:@"example.test.NSInteger"];
  XCTAssert([exampleService.a isEqualToNumber:@(999)]);

  exampleService = [_container getService:@"example.test.float"];
  XCTAssert([exampleService.a isEqualToNumber:[NSDecimalNumber numberWithFloat:99.999]]);

  exampleService = [_container getService:@"example.test.float.raw"];
  XCTAssert([exampleService.a isEqualToNumber:[NSDecimalNumber numberWithFloat:99.999]]);
}

@end
