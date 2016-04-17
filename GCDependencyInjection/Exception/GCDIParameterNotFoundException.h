//
// Created by Jake Wise on 29/03/2016.
// Copyright (c) 2016 GroovyCarrot Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDIParameterNotFoundException : NSException
@property (nonatomic, strong, readonly) NSString *key;
@property (nonatomic, strong, readonly) NSString *sourceId;
@property (nonatomic, strong) NSString *sourceKey;
@property (nonatomic, strong, readonly) NSArray *alternatives;
+ (id)exceptionForParameterNamed:(NSString *)key;
+ (id)exceptionForParameterNamed:(NSString *)key andSourceId:(NSString *)sourceId withAlternativeSuggestions:(NSArray *)alternatives;
- (id)initForParameterNamed:(NSString *)key andSourceId:(NSString *)sourceId withAlternativeSuggestions:(NSArray *)alternatives;
@end
