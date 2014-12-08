//
//  ETTabView.h
//  ETTabBar
//
//  Created by Brian Young on 4/26/13.
//  Copyright (c) 2013 Brian Young. All rights reserved.
//

#import "ETTabBarItem.h"
#import "ETTabBarView.h"
#import <UIKit/UIKit.h>

typedef enum ETTabBarBounceDirectionType {
    ETTabBarBounceDirectionLeft,
    ETTabBarBounceDirectionRight
} ETTabBarBounceDirection ;

@class ETTabBarView;

@protocol ETTabBarDelegate <UIScrollViewDelegate>
- (void)tabBar:(ETTabBarView *)tabBar didTouchItem:(ETTabBarItem *)item;
- (void)tabBar:(ETTabBarView *)tabBar didReleaseItem:(ETTabBarItem *)item;
@end


@interface ETTabBarView : UIScrollView  <UIAppearanceContainer>
{
    id <ETTabBarDelegate> delegate;
}

@property (nonatomic, weak) id<ETTabBarDelegate> delegate;
@property (nonatomic, strong) NSArray   *items;
@property (nonatomic, readonly) CGRect contentRect;

// Appearence 
@property (nonatomic) UIFont         *labelFont UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor        *labelTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) NSTextAlignment labelTextAlignment UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor         *labelBackgroundColor UI_APPEARANCE_SELECTOR;

- (void)tabBarButtonPressed:(id) sender;
- (void)tabBarButtonReleaced:(id) sender;
- (void)scrollToNearestPosition;
- (void)scrollToNearestPosition: (BOOL) whenUserIsDraggingFastOrSlow;
- (void)scrollToNearestPosition: (BOOL) whenUserIsDraggingFastOrSlow
     AfterDelayScrollToSelected: (BOOL) scrollToSelected;
- (void)scrollToSelectedETTabBarItem;
- (void)scrollToCenter;
- (void)scrollToRight;
- (void)scrollToLeft;
- (BOOL)isCloseToCentered;
- (BOOL)isCentered;
- (CGRect)positionCenter;
- (CGRect)positionRight;
- (CGRect)positionLeft;

-(CGRect)centerButtonRect;
-(void)waitThenScrollToSelected:(BOOL)doit;



-(void)scrollToRect:(CGRect) aRect;
-(void)bounceToThe:(ETTabBarBounceDirection) direction;

@end
