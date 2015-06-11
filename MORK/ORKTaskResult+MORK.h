//
//  ORKCollectionResult+MORK.h
//  MORK
//
//  Created by Nolan Carroll on 4/23/15.
//  Copyright (c) 2015 Medidata Solutions. All rights reserved.
//

#import "ORKResult.h"

@interface ORKTaskResult (MORK)
@property (readonly) NSArray *mork_fieldDataFromResults;
@end
