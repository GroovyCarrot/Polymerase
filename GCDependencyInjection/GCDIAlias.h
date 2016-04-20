//
// GCDependencyInjection
//
// Created by Jake Wise on 30/03/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//
// You are permitted to use, modify, and distribute this file in accordance with
// the terms of the license agreement accompanying it.
//

#import <Foundation/Foundation.h>

@interface GCDIAlias : NSObject
@property (nonatomic, copy, readonly) NSString *aliasId;
@property (nonatomic) BOOL public;
+ (id)aliasForId:(NSString *)aliasId;
@end
