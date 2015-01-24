//
//  DUDataConverter.m
//  Pods
//
//  Created by Essam on 1/24/15.
//
//

#import "DUDataConverter.h"

typedef id (^ConverterBlock)(NSData *);

@interface DUDataConverter()

@property (nonatomic) NSMutableDictionary *supportedTypesInfo;

@end

@implementation DUDataConverter

#pragma mark - Public

+ (instancetype)defaultConverter
{
    static dispatch_once_t once;
    static DUDataConverter *defaultConverter;
    dispatch_once(&once, ^{
        // init default converter
        defaultConverter = [[self alloc] init];
        defaultConverter.supportedTypesInfo = [[NSMutableDictionary alloc] init];
        
        // add some default supported types
        [defaultConverter registerConverterForTypes:@[@"png", @"jpg"] block:^id(NSData *data) {
            return [[UIImage alloc] initWithData:data];
        }];
        [defaultConverter registerConverterForTypes:@[@"json", @""] block:^id(NSData *data) {
            return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        }];
    });
    return defaultConverter;
}

- (id)convert:(NSData *)data ofType:(NSString *)type
{
    ConverterBlock converterBlock = self.supportedTypesInfo[type];
    if (converterBlock) {
        return converterBlock(data);
    }
    else {
        return nil;
    }
}

- (void)registerConverterForTypes:(NSArray *)types block:(ConverterBlock)block;
{
    for (NSString *type in types) {
        self.supportedTypesInfo[type] = block;
    }
}

@end
