//
//  ORKQuestionResult+MORK.m
//  MORK
//
//  Created by Nolan Carroll on 4/24/15.
//  Copyright (c) 2015 Medidata Solutions. All rights reserved.
//

#import "ORKQuestionResult+MORK.h"

@implementation ORKQuestionResult (MORK)
- (NSDictionary *)fieldDataDictionary {
    return @{
             @"data_value" : [self rawResult],
             @"item_oid" : self.identifier,
             @"date_time_entered" : [self.endDate description]
             };
}

- (NSString *)rawResult {
    NSString *resultString;
    
    if([self isKindOfClass:[ORKChoiceQuestionResult class]]) {
        ORKChoiceQuestionResult *cqResult = (ORKChoiceQuestionResult *) self;
        resultString = [NSString stringWithFormat:@"%@", cqResult.choiceAnswers.firstObject];
    }
    
    if([self isKindOfClass:[ORKDateQuestionResult class]]) {
        ORKDateQuestionResult *dResult = (ORKDateQuestionResult *) self;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
        resultString = [formatter stringFromDate:dResult.dateAnswer];
    }
    
    if([self isKindOfClass:[ORKScaleQuestionResult class]]) {
        ORKScaleQuestionResult *sqResult = (ORKScaleQuestionResult *) self;
        resultString = [NSString stringWithFormat:@"%@", [sqResult scaleAnswer]];
    }
    return resultString;
}
@end
