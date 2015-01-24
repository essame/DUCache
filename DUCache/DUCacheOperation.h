//
//  DUCacheOperation.h
//  Pods
//
//  Created by Essam on 1/24/15.
//
//

#import <Foundation/Foundation.h>

#import "DUOperationResult.h"

typedef void (^DUOperationBlock)(DUOperationResult, id);

@interface DUCacheOperation : NSOperation

@property (nonatomic) NSURL *url;
@property (nonatomic, strong) DUOperationBlock operationBlock;

@end
