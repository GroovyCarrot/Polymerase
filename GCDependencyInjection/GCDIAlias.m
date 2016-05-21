//
// GCDependencyInjection
//
// Created by Jake Wise on 30/03/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//
// You are permitted to use, modify, and distribute this file in accordance with
// the terms of the license agreement accompanying it.
//

#import "GCDIAlias.h"

@implementation GCDIAlias

+ (id)aliasForId:(NSString *)aliasId {
  return [[GCDIAlias alloc] initForAliasId:aliasId];
}

- (id)initForAliasId:(NSString *)aliasId {
  self = [super init];
  if (!self) {
    return nil;
  }

  _aliasId = aliasId.copy;
  _isPublic = TRUE;

  return self;
}

@end