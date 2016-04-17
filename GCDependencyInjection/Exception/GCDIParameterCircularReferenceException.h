//
// Created by Jake Wise on 29/03/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDIParameterCircularReferenceException : NSException
+ (id)exceptionWithReferences:(NSDictionary *)userInfo;
@end
