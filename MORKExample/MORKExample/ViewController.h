//
//  ViewController.h
//  MORKExample
//
//  Created by Nolan Carroll on 4/23/15.
//  Copyright (c) 2015 Medidata Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ResearchKit/ResearchKit.h>

@interface ViewController : UIViewController <ORKTaskViewControllerDelegate>
@property (strong, nonatomic) ORKTaskViewController *taskViewController;
@end

