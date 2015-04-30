//
//  ORKCollectionResult+MORK.m
//  MORK
//
//  Created by Nolan Carroll on 4/23/15.
//  Copyright (c) 2015 Medidata Solutions. All rights reserved.
//

#import "ORKQuestionResult+MORK.h"

@implementation ORKCollectionResult (MORK)

-(NSArray *) mork_fieldDataFromResults {
    NSMutableArray *data = [NSMutableArray array];
    [self.results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if([obj isKindOfClass:[ORKQuestionResult class]]) {
            ORKQuestionResult *result = (ORKQuestionResult *) obj;
            [data addObject:[result mork_fieldDataDictionary]];
        } else if([obj isKindOfClass:[ORKStepResult class]]) {
            // Extract data from nested ORKCollectionResult
            ORKStepResult *stepResult = (ORKStepResult *) obj;
            [data addObjectsFromArray:[stepResult mork_fieldDataFromResults]];
        }
    }];
    return [data copy];
}

@end
