//
// Created by Jake Wise on 28/03/2016.
//

#import "GCDIContainerProtocol.h"
#import "GCDIAliasableContainerProtocol.h"
#import "GCDIResettableContainerProtocol.h"

@protocol GCDIParameterBagProtocol,
          GCDIAlternativeSuggesterProtocol;

@interface GCDIContainer : NSObject <GCDIContainerProtocol, GCDIAliasableContainerProtocol, GCDIResettableContainerProtocol> {
 @protected
  NSMutableDictionary *_services;
  NSMutableDictionary *_loading;
  NSMutableDictionary *_aliases;
  NSMutableDictionary *_methodMap;

  id <GCDIParameterBagProtocol> _parameterBag;
  id <GCDIAlternativeSuggesterProtocol> _alternativeSuggester;
}

@property(nonatomic, strong, readonly) id <GCDIParameterBagProtocol> parameterBag;
@property(nonatomic, strong) id <GCDIAlternativeSuggesterProtocol> alternativeSuggester;

- (id)init;
- (id)initWithParameterBag:(id <GCDIParameterBagProtocol>)parameterBag;
- (NSArray *)getServiceIds;
@end
