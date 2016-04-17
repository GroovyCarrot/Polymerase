//
// Created by Jake Wise on 29/03/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//

#import "GCDIParameterNotFoundException.h"

@implementation GCDIParameterNotFoundException

@synthesize key = _key,
            sourceKey = _sourceKey,
            sourceId = _sourceId,
            alternatives = _alternatives;

+ (id)exceptionForParameterNamed:(NSString *)key {
  return [GCDIParameterNotFoundException exceptionForParameterNamed:key
                                                        andSourceId:nil
                                         withAlternativeSuggestions:nil];
}

+ (id)exceptionForParameterNamed:(NSString *)key
                     andSourceId:(NSString *)sourceId
      withAlternativeSuggestions:(NSArray *)alternatives {
  return [[GCDIParameterNotFoundException alloc] initForParameterNamed:key
                                                           andSourceId:sourceId
                                            withAlternativeSuggestions:alternatives];
}

- (id)initForParameterNamed:(NSString *)key
                andSourceId:(NSString *)sourceId
 withAlternativeSuggestions:(NSArray *)alternatives {
  self = [super init];
  if (self == nil) {
    return nil;
  }

  _key = key;
  _sourceId = sourceId;
  _alternatives = alternatives;

  return self;
}

- (NSString *)description {
  NSString *message;

  if (_sourceId != nil) {
    message = [NSString stringWithFormat:
      @"The service \"%@\" has a dependency on a non-existent parameter \"%@\".",
      _sourceId, _key];
  }
  else if (_sourceKey != nil) {
    message = [NSString stringWithFormat:
      @"The parameter \"%@\" has a dependency on a non-existent parameter \"%@\".",
      _sourceKey, _key];
  }
  else {
    message = [NSString stringWithFormat:
      @"You have requested a non-existent parameter \"%@\".",
      _key];
  }

  if (_alternatives.count) {
    if (_alternatives.count == 1) {
      message = [message stringByAppendingString:@" Did you mean this: \""];
    }
    else {
      message = [message stringByAppendingString:@" Did you mean one of these: \""];
    }

    message = [message stringByAppendingFormat:
      @"%@\"?",
      [_alternatives componentsJoinedByString:@", "]];
  }

  return message;
}

@end