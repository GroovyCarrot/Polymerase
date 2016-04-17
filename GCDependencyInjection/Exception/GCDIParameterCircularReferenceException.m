//
// Created by Jake Wise on 29/03/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//

#import "GCDIParameterCircularReferenceException.h"

@implementation GCDIParameterCircularReferenceException

+ (id)exceptionWithReferences:(NSDictionary *)userInfo {
  return [self exceptionWithName:@"Circular reference detected"
                          reason:@"Key has already been processed."
                        userInfo:userInfo];
}

@end
