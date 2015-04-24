//
//  ORKQuestionResult+MORK.h
//  MORK
//
//  Created by Nolan Carroll on 4/24/15.
//  Copyright (c) 2015 Medidata Solutions. All rights reserved.
//

#import "ORKResult.h"

@interface ORKQuestionResult (MORK)
- (NSString *) rawResult;
- (NSDictionary *) fieldDataDictionary;
@end
