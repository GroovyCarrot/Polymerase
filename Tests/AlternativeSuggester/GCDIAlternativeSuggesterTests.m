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

@interface GCDIAlternativeSuggesterTests : XCTestCase
@property (nonatomic, strong) GCDIAlternativeSuggester *suggester;
@end

@implementation GCDIAlternativeSuggesterTests

@synthesize suggester = _suggester;

- (void)setUp {
  [super setUp];

  _suggester = [[GCDIAlternativeSuggester alloc] init];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testAlternativeSuggestions {
  NSArray *alternatives, *expected;

  alternatives = [_suggester alternativesForItem:@"foo"
                               inPossibleOptions:@[
                                 @"bar",
                                 @"baz",
                                 @"foobar",
                                 @"barfoo",
                               ]];

  expected = @[
    @"foobar",
    @"barfoo",
  ];

  XCTAssertEqualObjects(alternatives, expected);

  alternatives = [_suggester alternativesForItem:@"bar"
                               inPossibleOptions:@[
                                 @"foo",
                                 @"baz",
                                 @"foobar",
                                 @"barfoo",
                               ]];

  expected = @[
    @"foobar",
    @"barfoo",
  ];

  XCTAssertEqualObjects(alternatives, expected);

  alternatives = [_suggester alternativesForItem:@"example"
                               inPossibleOptions:@[
                                 @"example.service",
                                 @"another_example",
                                 @"some_service",
                                 @"some.other_service",
                               ]];

  expected = @[
    @"example.service",
    @"another_example",
  ];

  XCTAssertEqualObjects(alternatives, expected);
}

@end
