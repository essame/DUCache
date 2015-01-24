//
//  DUCacheOperation.m
//  Pods
//
//  Created by Essam on 1/24/15.
//
//

#import <malloc/malloc.h>

#import "DUCacheOperation.h"
#import "DUCache.h"
#import "DUDataConverter.h"

@implementation DUCacheOperation

- (void)main
{
    // check if operation was cancelled by client
    if (self.isCancelled) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.operationBlock(DUOperationResultCancelled, nil);
        });
    }
    
    // download the data from url
    NSData *downloadedData = [[NSData alloc] initWithContentsOfURL:self.url];
    
    // client might have canclled the operation, check again
    if (self.isCancelled) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.operationBlock(DUOperationResultCancelled, nil);
        });
    }

    // convert downloaded data into a meaningful object
    id downloadedObject = [[DUDataConverter defaultConverter] convert:downloadedData ofType:self.url.path.pathExtension];
    
    // save object in cache and pass it to client
    dispatch_sync(dispatch_get_main_queue(), ^{
        if (downloadedObject != nil) {
            [[DUCache defaultCache] setObject:downloadedObject forUrl:self.url];
            self.operationBlock(DUOperationResultFinished, downloadedObject);
        }
        else {
            self.operationBlock(DUOperationResultFailed, downloadedObject);
        }
    });
}

@end
