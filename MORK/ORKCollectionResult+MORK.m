//
//  ORKCollectionResult+MORK.m
//  MORK
//
//  Created by Nolan Carroll on 4/23/15.
//  Copyright (c) 2015 Medidata Solutions. All rights reserved.
//

#import "ORKCollectionResult+MORK.h"
#import "ORKQuestionResult+MORK.h"

@implementation ORKCollectionResult (MORK)
+(void) doSomethingElse {
    NSLog(@"doing something else");
}

-(void) doSomething {
    NSLog(@"log something");
}

-(NSArray *) fieldDataFromResults {
    NSMutableArray *data = [NSMutableArray arrayWithArray: @[]];
    [self.results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if([obj isKindOfClass:[ORKQuestionResult class]]) {
            ORKQuestionResult *result = (ORKQuestionResult *) obj;
            [data addObject:[result fieldDataDictionary]];
        }
    }];
    return [data copy];
}

@end
