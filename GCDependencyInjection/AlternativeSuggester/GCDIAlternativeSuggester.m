//
// Created by Jake Wise on 29/03/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//

#import "GCDIAlternativeSuggester.h"

@implementation GCDIAlternativeSuggester

- (NSArray *)alternativesForItem:(NSString *)item inPossibleOptions:(NSArray *)options {
  NSMutableArray *alternatives = @[].mutableCopy;
  for (NSString *option in options) {
    NSInteger lev = [self compareWord:item
                             withWord:option
                                matchGain:1
                              missingCost:1];

    if (lev <= item.length / 3 || [item rangeOfString:option].location != NSNotFound) {
      alternatives[alternatives.count] = option;
    }
  }
  return alternatives.copy;
}

- (NSInteger)compareWord:(NSString *)stringA withWord:(NSString *)stringB matchGain:(NSInteger)gain missingCost:(NSInteger)cost {
  stringA = [[stringA stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
  stringB = [[stringB stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];

  // Step 1
  NSInteger k, i, j, change, *d, distance;

  NSUInteger n = [stringA length];
  NSUInteger m = [stringB length];

  if( n++ != 0 && m++ != 0 ) {
    d = malloc( sizeof(NSInteger) * m * n );

    // Step 2
    for( k = 0; k < n; k++)
      d[k] = k;

    for( k = 0; k < m; k++)
      d[ k * n ] = k;

    // Step 3 and 4
    for( i = 1; i < n; i++ ) {
      for( j = 1; j < m; j++ ) {

        // Step 5
        if([stringA characterAtIndex: i-1] == [stringB characterAtIndex: j-1]) {
          change = -gain;
        } else {
          change = cost;
        }

        // Step 6
        d[ j * n + i ] = MIN(d [ (j - 1) * n + i ] + 1, MIN(d[ j * n + i - 1 ] +  1, d[ (j - 1) * n + i -1 ] + change));
      }
    }

    distance = d[ n * m - 1 ];
    free( d );
    return distance;
  }

  return 0;
}

@end
