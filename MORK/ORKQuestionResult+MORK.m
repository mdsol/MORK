//
//  ORKQuestionResult+MORK.m
//  MORK
//
//  Created by Nolan Carroll on 4/24/15.
//  Copyright (c) 2015 Medidata Solutions. All rights reserved.
//

#import "ORKQuestionResult+MORK.h"

@implementation ORKQuestionResult (MORK)
- (NSDictionary *)mork_fieldDataDictionary {
    return @{
             @"data_value" : [self mork_rawResult],
             @"item_oid" : self.identifier,
             @"date_time_entered" : [[self mork_dateFormatter] stringFromDate:self.endDate]
             };
}

- (NSString *)mork_rawResult {
    static NSDictionary *rawResultDictionary;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        rawResultDictionary = @{
                                @"ORKChoiceQuestionResult": ^NSString*(ORKChoiceQuestionResult *result) {
                                    return [NSString stringWithFormat:@"%@", result.choiceAnswers.firstObject];
                                },
                                @"ORKDateQuestionResult": ^NSString*(ORKDateQuestionResult *result) {
                                    return [[self mork_dateFormatter] stringFromDate:result.dateAnswer];
                                },
                                @"ORKScaleQuestionResult": ^NSString*(ORKScaleQuestionResult *result) {
                                  return [NSString stringWithFormat:@"%@", [result scaleAnswer]];
                                }
                                };
    });

    NSString * (^block)(ORKQuestionResult *) = [rawResultDictionary objectForKey:NSStringFromClass([self class])];
    return block(self);
}

- (NSDateFormatter *) mork_dateFormatter {
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy hh:mm:ss"];
    });

    return dateFormatter;
}
@end
