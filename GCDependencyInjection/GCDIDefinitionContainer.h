//
// Created by Jake Wise on 17/04/2016.
// Copyright (c) 2016 Jake Wise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDIContainer.h"
#import "GCDIDefinitionContainerProtocol.h"

@interface GCDIDefinitionContainer : GCDIContainer <GCDIDefinitionContainerProtocol> {
 @protected
  NSMutableDictionary *_definitions;
}

- (void)registerService:(NSString *)serviceId forClass:(Class)klass andSelector:(SEL)pSelector;
@end
