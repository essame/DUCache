//
//  DUCache.m
//  Pods
//
//  Created by Essam on 1/24/15.
//
//

#define DEFAULT_MEMORY_CAPACITY 50*1024*1024

#import "DUCache.h"

@interface DUCache()

@property (nonatomic)  NSOperationQueue *queue;
@property (nonatomic)  NSMutableDictionary *cache;
@property (nonatomic) NSUInteger memoryUsed;

@end

@implementation DUCache

#pragma mark - Properties

- (void)setMemoryCapacity:(NSUInteger)memoryCapacity
{
    if (_memoryCapacity != memoryCapacity) {
        _memoryCapacity = memoryCapacity;
        if (self.memoryUsed > _memoryCapacity) {
            [self evictOldEntries];
        }
    }
}

- (NSOperationQueue *)queue
{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

- (NSMutableDictionary *)cache
{
    if (!_cache) {
        _cache = [[NSMutableDictionary alloc] init];
    }
    return _cache;
}

#pragma mark - Public

+ (instancetype)defaultCache
{
    static dispatch_once_t once;
    static DUCache *defaultCache;
    dispatch_once(&once, ^{
        defaultCache = [[self alloc] init];
        defaultCache.memoryCapacity = DEFAULT_MEMORY_CAPACITY;
    });
    return defaultCache;
}

- (DUCacheOperation *)objectForUrl:(NSURL *)url completionHandler:(DUOperationBlock)handler
{
    // try to get object from cache
    id object = self.cache[url.description];
    if (object != nil) {
        handler(DUOperationResultFinished, object);
        return [[DUCacheOperation alloc] init];
    }
    
    // not found, queue a new operation to get it from url
    DUCacheOperation *operation = [[DUCacheOperation alloc] init];
    operation.url = url;
    operation.operationBlock = handler;
    [self.queue addOperation:operation];
    
    // return operation to allow clients to cancel it
    return operation;
}

- (void)setObject:(id)object forUrl:(NSURL *)url
{
    self.cache[url.description] = object;
    
    // memory usage will be based on images only (not very accurate)
    if ([object isKindOfClass:[UIImage class]]) {
        NSData *imageData = UIImageJPEGRepresentation(object, 1);
        self.memoryUsed += imageData.length;
        if (self.memoryUsed > self.memoryCapacity) {
            [self.queue addOperationWithBlock:^{
                [self evictOldEntries];
            }];
        }
    }
}

#pragma mark - Private

// I wrote this last, not looking good...
- (void)evictOldEntries
{
    NSLog(@"evictOldEntries Started, items count %lu", (unsigned long)self.cache.allKeys.count);
    
    NSArray *urls = self.cache.allKeys;

    // TODO: make sure this is thread safe
    for (NSString *url in urls) {
        id object = self.cache[url];
        // remember memory usage is based only on images
        if ([object isKindOfClass:[UIImage class]]) {
            // TODO: save this in cache dictionary so we don't have to calculate it again
            NSData *imageData = UIImageJPEGRepresentation(object, 1);
            self.memoryUsed -= imageData.length;
            [self.cache removeObjectForKey:url];
            if (self.memoryUsed <= self.memoryCapacity) {
                break;
            }
        }
    }
    
    NSLog(@"evictOldEntries Finsied, items count %lu", (unsigned long)self.cache.allKeys.count);
}

@end
