//
// Created by Jake Wise on 30/03/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//

#import "GCDIAlias.h"

@implementation GCDIAlias

@synthesize aliasId = _aliasId,
            public = _public;

+ (id)aliasForId:(NSString *)aliasId {
  return [[GCDIAlias alloc] initForAliasId:aliasId];
}

- (id)initForAliasId:(NSString *)aliasId {
  self = [super init];
  if (self == nil) {
    return nil;
  }

  _aliasId = aliasId.copy;
  _public = TRUE;

  return self;
}

@end