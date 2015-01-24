//
//  DUCache.h
//  Pods
//
//  Created by Essam on 1/24/15.
//
//

#import <Foundation/Foundation.h>

#import "DUCacheOperation.h"
#import "DUOperationResult.h"

@interface DUCache : NSObject

@property (nonatomic) NSUInteger memoryCapacity;

+ (instancetype)defaultCache;

- (DUCacheOperation *)objectForUrl:(NSURL *)url completionHandler:(DUOperationBlock)handler;

- (void)setObject:(id)object forUrl:(NSURL *)url;

@end
