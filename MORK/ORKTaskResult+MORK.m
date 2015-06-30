//
//  ORKTaskResult+MORK.m
//  MORK
//
//  Created by Nolan Carroll on 4/23/15.
//  Copyright (c) 2015 Medidata Solutions. All rights reserved.
//

#import "ORKTaskResult+MORK.h"
#import "ORKQuestionResult+MORK.h"

/**
 *  While -mork_getFieldDataFromResults is exposed publicly for
 *  ORKTaskResult only, this helper function gives us the same
 *  benefits privately for ORKStepResult as well
 */
NSArray *getFieldDataFromResults (NSArray *results) {
    NSMutableArray *data = [NSMutableArray array];

    [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

        if ([obj isKindOfClass:[ORKQuestionResult class]]) {

            ORKQuestionResult *result = (ORKQuestionResult *)obj;
            [data addObject:[result mork_getFieldDataDictionary]];
        }
        else if ([obj isKindOfClass:[ORKStepResult class]]) {

            // Extract data from nested ORKCollectionResult
            ORKStepResult *stepResult = (ORKStepResult *)obj;
            [data addObjectsFromArray:getFieldDataFromResults(stepResult.results)];
        }
    }];

    return data;
}

@implementation ORKTaskResult (MORK)
- (NSArray *)mork_getFieldDataFromResults {
    return getFieldDataFromResults(self.results);
}
@end



