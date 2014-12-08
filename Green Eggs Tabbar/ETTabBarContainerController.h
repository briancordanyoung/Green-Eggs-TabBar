//
//  ETTabBarContainerController.h
//  Egg Tracker
//
//  Created by Brian Young on 5/15/13.
//  Copyright (c) 2013 Brian Young. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETTabBarContainerController : UIViewController

@property (nonatomic, strong) UINavigationController *visibleViewController;

-(BOOL)dailyDataIsVisable;
-(BOOL)listsAreVisable;
-(BOOL)eventsAreVisable;
-(BOOL)expensesAreVisable;
-(BOOL)contributionsAreVisable;
-(BOOL)deliveriesAreVisable;

@end
