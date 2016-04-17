//
// Created by Jake Wise on 30/03/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GCDIDefinitionContainerProtocol;

@interface GCDIContainerNSDictionaryLoader : NSObject
@property (nonatomic, copy) NSDictionary *dictionary;
- (id)initWithDictionary:(NSDictionary *)dictionary;
- (void)loadIntoContainer:(id <GCDIDefinitionContainerProtocol>)container;
@end
