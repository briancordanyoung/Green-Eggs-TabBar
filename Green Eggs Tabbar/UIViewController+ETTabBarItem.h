//
//  UIViewController+ETTabBarItem.h
//  Egg Tracker
//
//  Created by Brian Young on 5/6/13.
//  Copyright (c) 2013 Brian Young. All rights reserved.
//

#import "ETTabBarItem.h"
#import <UIKit/UIKit.h>

@interface UIViewController (ETTabBarItem)

@property (nonatomic, strong) ETTabBarItem *etTabBarItem;

-(void)setEtTabBarItem: (ETTabBarItem *) tabBarItem;
-(ETTabBarItem*) etTabBarItem;

@end
