//
//  DUDataConverter.h
//  Pods
//
//  Created by Essam on 1/24/15.
//
//

#import <Foundation/Foundation.h>

typedef id (^ConverterBlock)(NSData *);

@interface DUDataConverter : NSObject

+ (instancetype)defaultConverter;

- (id)convert:(NSData *)data ofType:(NSString *)type;

- (void)registerConverterForTypes:(NSArray *)types block:(ConverterBlock)block;

@end
