//
//  GCDIParameterBagTests.m
//  GCDIParameterBagTests
//
//  Created by Jake Wise on 18/04/2016.
//  Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GCDIParameterBag.h"
#import "GCDIExceptions.h"

@interface GCDIParameterBagTests : XCTestCase
@property (nonatomic, strong) GCDIParameterBag *parameterBag;
@end

@implementation GCDIParameterBagTests

@synthesize parameterBag = _parameterBag;

- (void)setUp {
  [super setUp];

  _parameterBag = [[GCDIParameterBag alloc] initWithParameters:@{
    @"foo": @"bar",
    @"bar": @123,
  }];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testGetSetParameter {
  XCTAssert([[_parameterBag getParameter:@"foo"] isEqualToString:@"bar"]);

  [_parameterBag setParameter:@"green" value:@"red"];
  XCTAssert([[_parameterBag getParameter:@"green"] isEqualToString:@"red"]);

  [_parameterBag setParameter:@"green" value:@"blue"];
  XCTAssert([[_parameterBag getParameter:@"green"] isEqualToString:@"blue"]);

  // Test key converted to lowercase.
  XCTAssert([[_parameterBag getParameter:@"GREEN"] isEqualToString:@"blue"]);
}

- (void)testRemoveParameter {
  XCTAssertNotNil([_parameterBag allParameters][@"foo"]);
  [_parameterBag removeParameter:@"foo"];
  XCTAssertNil([_parameterBag allParameters][@"foo"]);

  XCTAssertNotNil([_parameterBag allParameters][@"bar"]);
  [_parameterBag removeParameter:@"bar"];
  XCTAssertNil([_parameterBag allParameters][@"bar"]);
}

- (void)testResolveParameterPlaceholders {
  // Test resolved parameters with no placeholders remain the same.
  XCTAssert([[_parameterBag resolveParameterPlaceholders:@"foo"] isEqualToString:@"foo"]);

  // Test string substitution occurs.
  XCTAssert([[_parameterBag resolveParameterPlaceholders:@"I'm a %foo%"] isEqualToString:@"I'm a bar"]);
  XCTAssert([[_parameterBag resolveParameterPlaceholders:@"I'm a %bar%"] isEqualToString:@"I'm a 123"]);

  // Test escaping is supported with %%.
  XCTAssert([[_parameterBag resolveParameterPlaceholders:@"I'm a %%foo%%"] isEqualToString:@"I'm a %%foo%%"]);

  // Test that spaces in parameters is ignored.
  XCTAssert([[_parameterBag resolveParameterPlaceholders:@"% foo %"] isEqualToString:@"% foo %"]);

  // Test that when the placeholder is the entire string, the object type is not
  // converted into a string.
  XCTAssert([[_parameterBag resolveParameterPlaceholders:@"%bar%"] isKindOfClass:[NSNumber class]]);

  @try {
    [_parameterBag resolveParameterPlaceholders:@"%baz%"];
    XCTFail(@"Failed to throw GCDIParameterNotFoundException exception for parameter \"baz\" that does not exist.");
  }
  @catch (NSException *e) {
    XCTAssert([[e name] isEqualToString:GCDIParameterNotFoundException]);
  }

  // Test that parameter values that reference each other are resolved.
  _parameterBag = [[GCDIParameterBag alloc] initWithParameters:@{
    @"foo": @"bar",
    @"bar": @"%foo%",
  }];
  [_parameterBag resolveParameterPlaceholders];
  XCTAssert([[_parameterBag allParameters][@"bar"] isEqualToString:@"bar"]);
}

- (void)testHasParameter {
  XCTAssert([_parameterBag hasParameter:@"foo"]);
  XCTAssert([_parameterBag hasParameter:@"Foo"]);
  XCTAssertFalse([_parameterBag hasParameter:@"foobar"]);
}

- (void)testEscapeParameterPlaceholders {
  _parameterBag = [[GCDIParameterBag alloc] initWithParameters:@{
    @"foo": @[@"%%bar%%"],
    @"bar": @"%%foo%%",
  }];

  [_parameterBag resolveParameterPlaceholders];

  XCTAssert([[_parameterBag getParameter:@"foo"][0] isEqualToString:@"%bar%"]);
  XCTAssert([[_parameterBag getParameter:@"bar"] isEqualToString:@"%foo%"]);
}

- (void)testResolveParametersCircularReference {
  _parameterBag = [[GCDIParameterBag alloc] initWithParameters:@{
    @"foo": @[@"%bar%"],
    @"bar": @"%foo%",
  }];

  @try {
    [_parameterBag resolveParameterPlaceholders];
    XCTFail(@"Failed to throw GCDICircularReferenceException exception for parameters that reference each other.");
  }
  @catch (NSException *e) {
    XCTAssert([[e name] isEqualToString:GCDICircularReferenceException]);
  }
}

- (void)testSpacesIgnoredInParameterNames {
  XCTAssert([[_parameterBag resolveParameterPlaceholders:@"%foo%"] isEqualToString:@"bar"]);
  XCTAssert([[_parameterBag resolveParameterPlaceholders:@"% foo %"] isEqualToString:@"% foo %"]);
  XCTAssert([[_parameterBag resolveParameterPlaceholders:@"5% to 15%"] isEqualToString:@"5% to 15%"]);
}

@end
