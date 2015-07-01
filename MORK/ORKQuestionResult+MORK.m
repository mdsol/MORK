//
//  ORKQuestionResult+MORK.m
//  MORK
//
//  Created by Nolan Carroll on 4/24/15.
//  Copyright (c) 2015 Medidata Solutions. All rights reserved.
//

#import "ORKQuestionResult+MORK.h"

@implementation ORKQuestionResult (MORK)

#pragma mark - Public Methods
- (NSDictionary *)mork_getFieldDataDictionary {
    return @{@"data_value"          : [self mork_rawResult],
             @"item_oid"            : self.identifier,
             @"date_time_entered"   : [[self mork_dateFormatter] stringFromDate:self.endDate]};
}

#pragma mark - Private Methods
- (NSString *)mork_rawResult {
    static NSDictionary *rawResultDictionary;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        rawResultDictionary = @{@"ORKChoiceQuestionResult": ^NSString*(ORKChoiceQuestionResult *result) {
                                    return [NSString stringWithFormat:@"%@", result.choiceAnswers.firstObject];
                                },
                                @"ORKDateQuestionResult": ^NSString*(ORKDateQuestionResult *result) {
                                    return [[self mork_dateFormatter] stringFromDate:result.dateAnswer];
                                },
                                @"ORKScaleQuestionResult": ^NSString*(ORKScaleQuestionResult *result) {
                                  return [NSString stringWithFormat:@"%@", result.scaleAnswer];
                                }};
    });

    NSString *class = NSStringFromClass([self class]);
    NSString *(^block)(ORKQuestionResult *) = rawResultDictionary[class];

    NSAssert(block != nil, @"The %@ class is not currently supported.", class);

    return block(self);
}

- (NSDateFormatter *)mork_dateFormatter {
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"dd-MM-yyyy hh:mm:ss";
    });

    return dateFormatter;
}

@end
