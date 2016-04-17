//
// Created by Jake Wise on 30/03/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDIAlias : NSObject
@property (nonatomic, copy, readonly) NSString *aliasId;
@property (nonatomic) BOOL public;
+ (id)aliasForId:(NSString *)aliasId;
@end
