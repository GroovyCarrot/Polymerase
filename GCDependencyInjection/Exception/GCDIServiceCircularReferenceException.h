//
// Created by Jake Wise on 29/03/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDIServiceCircularReferenceException : NSException
@property (nonatomic, strong) NSString *serviceId;
@property (nonatomic, strong) NSArray *previousServiceIds;
+ (id)exceptionForServiceNamed:(NSString *)serviceId previous:(NSArray *)previousServiceIds;
@end