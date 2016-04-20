//
//  GCDIAlternativeSuggesterTests.m
//  GCDIAlternativeSuggesterTests
//
//  Created by Jake Wise on 20/04/2016.
//  Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GCDIAlternativeSuggester.h"

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
