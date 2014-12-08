//
//  UIViewController+ETTabBarItem.m
//  Egg Tracker
//
//  Created by Brian Young on 5/6/13.
//  Copyright (c) 2013 Brian Young. All rights reserved.
//

#import "UIViewController+ETTabBarItem.h"
#import <objc/runtime.h>



static char const * const kETTabBarItem = "kETTabBarItem";



@implementation UIViewController (ETTabBarItem)
@dynamic etTabBarItem;

-(ETTabBarItem*) etTabBarItem
{
    ETTabBarItem *anEtTabBarItem = objc_getAssociatedObject(self, kETTabBarItem);
    
    if (anEtTabBarItem)
    {
        return anEtTabBarItem;
    } else {
        NSString *viewcontrollerTitle = self.title;
        NSString *tabTitle = [viewcontrollerTitle capitalizedStringWithLocale:[NSLocale currentLocale]];
        NSString *storyboardID = [viewcontrollerTitle lowercaseStringWithLocale:[NSLocale currentLocale]];
        anEtTabBarItem = [[ETTabBarItem alloc] initWithTitle: tabTitle
                                             AndStoryboardId: storyboardID];
        return anEtTabBarItem;
    }
}

-(void)setEtTabBarItem: (ETTabBarItem *) tabBarItem
{
	objc_setAssociatedObject(self, kETTabBarItem, tabBarItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
