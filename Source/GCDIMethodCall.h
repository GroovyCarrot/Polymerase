//
// GCDependencyInjection
//
// Created by Jake Wise on 13/05/2016.
// Copyright (c) 2016 GroovyCarrot. All rights reserved.
//
// You are permitted to use, modify, and distribute this file in accordance with
// the terms of the license agreement accompanying it.
//

#import <Foundation/Foundation.h>

@interface GCDIMethodCall : NSObject
@property (nonatomic, copy, getter=getSelector, setter=setSelector:) NSString *pSelector;
@property (nonatomic, copy) NSArray *arguments;
+ (GCDIMethodCall *)methodCallForSelector:(SEL)pSelector andArguments:(NSArray *)arguments;
- (GCDIMethodCall *)initWithSelector:(NSString *)pSelector andArguments:(NSArray *)arguments;
- (BOOL)isEqualToMethodCall:(GCDIMethodCall *)methodCall;
@end
