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
    NSString *resultString;
    
    if([self isKindOfClass:[ORKChoiceQuestionResult class]]) {
        ORKChoiceQuestionResult *cqResult = (ORKChoiceQuestionResult *) self;
        resultString = [NSString stringWithFormat:@"%@", cqResult.choiceAnswers.firstObject];
    }
    
    if([self isKindOfClass:[ORKDateQuestionResult class]]) {
        ORKDateQuestionResult *dResult = (ORKDateQuestionResult *) self;
        resultString = [[self mork_dateFormatter] stringFromDate:dResult.dateAnswer];
    }
    
    if([self isKindOfClass:[ORKScaleQuestionResult class]]) {
        ORKScaleQuestionResult *sqResult = (ORKScaleQuestionResult *) self;
        resultString = [NSString stringWithFormat:@"%@", [sqResult scaleAnswer]];
    }
    return resultString;
}

- (NSDateFormatter *) mork_dateFormatter {
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    });

    return dateFormatter;
}
@end
