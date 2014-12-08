//
//  ETTabBarViewController.h
//  ETTabBar
//
//  Created by Brian Young on 5/3/13.
//  Copyright (c) 2013 Brian Young. All rights reserved.
//

#import "ETTabBarContainerController.h"
#import "UIViewController+ETTabBarItem.h"
#import "ETTabBarItem.h"
#import "ETTabBarView.h"
#import <UIKit/UIKit.h>

@interface ETTabBarViewController : UIViewController   <ETTabBarDelegate>
@property (nonatomic, strong) IBOutlet UIView *mainView;
@property (nonatomic, strong) IBOutlet UIView *contentView;
@property (nonatomic, strong) IBOutlet ETTabBarView *appTabBar;
@property (nonatomic, strong) IBOutlet UIView *appTabBarAddButtonView;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *appTabBarBottomContraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *contentBottomContraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *appTabBarAddButtonViewBottomContraint;

@property (nonatomic, strong) NSArray *appTabBarItems;
@property (nonatomic, strong) NSDate *lastSelectedDate;
@property (nonatomic, strong) NSDate *lastViewedStartDate;
@property (nonatomic, strong) NSDate *lastViewedEndDate;

-(void)resetAllTabs;

-(ETTabBarItem *)currentlySelectedTabBarItem;
-(UINavigationController *)currentTabViewController;
-(ETTabBarContainerController *)tabBarContainerController;
-(ETTabBarItem *)tabBarItemForStoryboardID: (NSString *) storyboardID;



@end
