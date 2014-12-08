//
//  ETAppearance.m
//  Egg Tracker
//
//  Created by Brian Young on 6/9/13.
//  Copyright (c) 2013 Brian Young. All rights reserved.
//

#import "ETTabBarView.h"
#import "ETAppearance.h"

@implementation ETAppearance

+(void)apply
{
    CGRect rect = CGRectMake(0, 0, 1, 30);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   [[UIColor colorWithRed:0.301 green:0.467 blue:0.755 alpha:1.000] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *greenEggsBlue = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(rect.size);
    context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   [[UIColor colorWithRed:0.261 green:0.335 blue:0.494 alpha:1.000] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *greenEggsBlueDark = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(rect.size);
    context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   [[UIColor colorWithRed:0.527 green:0.690 blue:0.934 alpha:1.000] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *greenEggsBlueHighlight = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    id navBars = [UINavigationBar appearance];
    //[navBars setTintColor: [UIColor colorWithRed:0.285 green:0.413 blue:0.695 alpha:1.000]];
    [navBars setBackgroundImage: greenEggsBlue forBarMetrics: UIBarMetricsDefault];
    [navBars setTintColor:[UIColor clearColor]];
    
    id navBarItems = [UIBarButtonItem appearance];
    [navBarItems setBackgroundImage: greenEggsBlueDark
                           forState: UIControlStateNormal
                         barMetrics:UIBarMetricsDefault];
    [navBarItems setBackgroundImage: greenEggsBlueHighlight
                           forState: UIControlStateHighlighted
                         barMetrics:UIBarMetricsDefault];
    [navBarItems setBackButtonBackgroundImage: greenEggsBlueDark
                                     forState: UIControlStateNormal
                                   barMetrics:UIBarMetricsDefault];
    [navBarItems setBackButtonBackgroundImage: greenEggsBlueHighlight
                                     forState: UIControlStateHighlighted
                                   barMetrics:UIBarMetricsDefault];
    
    
}

@end
