//
//  ETTabView.m
//  ETTabBar
//
//  Created by Brian Young on 4/26/13.
//  Copyright (c) 2013 Brian Young. All rights reserved.
//

#import "ETTabBarViewController.h"
#import "ETTabBarView.h"



const NSTimeInterval scrollToSelectedTabDelay = 5.0;
const CGFloat gapBetweenTabsForTestingLayout = 0;
const NSUInteger userScrolledSlowSpeed = 900;

#pragma mark - ETTabView internal properties

@interface ETTabBarView()

@property (nonatomic) NSUInteger tabBarItemCount;

@property (nonatomic, readonly) CGFloat tabBarItemWidth;
@property (nonatomic, readonly) CGFloat widthOfAllTabBarItemsCombined;
@property (nonatomic, readonly) NSUInteger tabBarVisableItemCount;
@property (nonatomic, readonly) NSUInteger tabBarOffScreenItemCount;
@property (nonatomic, readonly) CGFloat tabBarContentHeight;
@property (nonatomic, readonly) CGFloat tabBarContentWidth;
@property (nonatomic, readonly) CGSize tabBarContentSize;
@property (nonatomic, readonly) CGRect positionCenter;
@property (nonatomic, readonly) CGRect positionLeft;
@property (nonatomic, readonly) CGRect positionRight;
@property (nonatomic)           CGFloat decelerationRateModifier;

@end


#pragma mark - ETTabView

@implementation ETTabBarView


- (id)initWithFrame: (CGRect) frame
{
    

    self = [super initWithFrame:frame];
    if (self)
    {
    }

    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    
    
    self = [super initWithCoder: aDecoder];
    if (self)
    {
    }
    
    return self;
}


- (void)loadView
{

}

-(void)setItems:(NSArray *)items
{
    _items = items;
    [self setupTabBarView];
}


-(void)setupTabBarView
{
    
    
    // Delete everything that is in the scroll view
    for (UIView *aView in self.subviews)
    {
        [aView removeFromSuperview];
    }

    
    self.tabBarItemCount = self.items.count;
    
    // Setup the scroll view
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.bounces = NO;
    self.hidden = NO;
    self.opaque = NO;
    self.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.000];
    self.multipleTouchEnabled = NO;
    //self.decelerationRateModifier = 0.99;

    // Add The Buttons and IamgeViews that represent the buttons
    NSUInteger index = 0;
    for (ETTabBarItem *anItem in self.items)
    {
        // Add Unselected Tab Image
        [self addSubview: anItem.normalImageView];
        
        if (! anItem.imageOnly)
        {
            // Add Selected Tab Image
            [self addSubview: anItem.selectedImageView];
            
            // Add button
            [self addSubview: anItem.button];
            
            // Keep track of what the coresponding button is
            anItem.button.tag = index;
            
            // What happens when the button is pressed
            [self addButtonActions: anItem.button];
        }
        
        // Add Image and Label at the base of the tabs
        [self addSubview: anItem.namePlateImageView];
        UILabel *label = anItem.titleLabel;
        [self addSubview: label];
        index++;
    }

    // Apply the default Appearence
    [self setDefaultApearenceProperties];
    
    // Set the size of the full scroll view content
    self.contentSize = self.tabBarContentSize ;
    
    // Now that the views are added, set the position
    // and layout the tab bar items along the scroll view
    [self positionEachTabBarItem];
    
    
}

-(void)positionEachTabBarItem
{
    
    
    NSUInteger index = 0;
    for (ETTabBarItem *anItem in self.items)
    {
        anItem.topOverhang = self.heightOfHighestItem - self.contentSize.height;
        anItem.position = [self combinedWidthOfPreviousTabBarItems:index];
        index++;
    }

    
}

-(void)setDecelerationRateModifier:(CGFloat)decelerationRateModifier
{
    
    
    // Set the decelaration rate to faster than UIScrollViewDecelerationRateFast
    // http://stackoverflow.com/questions/513396/can-uiscrollviews-deceleration-rate-be-modified
    @try
    {
        CGFloat decelerationRate = UIScrollViewDecelerationRateFast * decelerationRateModifier ;
        [self setValue:[NSValue valueWithCGSize:CGSizeMake(decelerationRate,decelerationRate)] forKey:@"_decelerationFactor"];
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"Custom decelaration rate for the main tab bar no longer works. API may have changed.");
    }

    
}

-(void)addButtonActions:(UIButton *)aButton
{
    // To make sure that the TabBar is returned to one of 3 positions
    // All buttons tell the tabBar to 'scrollToNearestPosition'
    [aButton addTarget:self
                      action:@selector(scrollToNearestPosition)
            forControlEvents: (UIControlEventTouchDragInside |
                               UIControlEventTouchDragOutside |
                               UIControlEventTouchDragEnter |
                               UIControlEventTouchDragExit |
                               UIControlEventTouchUpInside |
                               UIControlEventTouchUpOutside |
                               UIControlEventTouchCancel )
     ];
    
    // Touching the tab bar button
    [aButton addTarget:self
                      action:@selector(tabBarButtonPressed:)
            forControlEvents: (UIControlEventTouchDown) ];
    
    // Releasing the tab bar button
    [aButton addTarget:self
                      action:@selector(tabBarButtonReleaced:)
            forControlEvents: (UIControlEventTouchDragEnter |
                               UIControlEventTouchDragExit |
                               UIControlEventTouchUpInside |
                               UIControlEventTouchUpOutside |
                               UIControlEventTouchCancel) ];

}


#pragma mark - Custom

-(void)scrollToNearestPosition
{
    

    [self scrollToNearestPosition: YES];
    
    
}


-(void)scrollToNearestPosition: (BOOL) whenUserIsDraggingSlow
{
    
    [self scrollToNearestPosition: whenUserIsDraggingSlow
       AfterDelayScrollToSelected: YES];
    
}

-(void)scrollToNearestPosition: (BOOL) whenUserIsDraggingSlow
    AfterDelayScrollToSelected: (BOOL) scrollToSelected
{
    
    
    // whenUserIsDraggingSlowOrFast is the opposite of whenUserIsDraggingSlow
    BOOL whenUserIsNotDraggingSlow = whenUserIsDraggingSlow ? NO : YES;
    
    if (self.userScrolledSlow || whenUserIsNotDraggingSlow)
    {        
        [self scrollToNearestPositionNow];
    } else {
        // TODO: This doesn't workout well.  Maybe it can be removed now?
//        [self scrollToEnd];
    }

    
    if (scrollToSelected)
    {
        // Wait for 'theDelay' and tell the tab bar to scroll to where the
        // currently selected tab is vissible.
        
        [self waitThenScrollToSelected: NO];
        [self waitThenScrollToSelected: YES];
    }
    
    
}

-(void)waitThenScrollToSelected:(BOOL)doit
{
    SEL scrollToBarItem = @selector(scrollToSelectedETTabBarItem);
    
    if (doit)
    {
        [self performSelector: scrollToBarItem
                   withObject: nil
                   afterDelay: scrollToSelectedTabDelay];
    } else {

    [NSObject cancelPreviousPerformRequestsWithTarget: self
                                             selector: scrollToBarItem
                                               object: nil];
    }

}


-(void)scrollToNearestPositionNow
{
    // Change this to make the distance from the sides the tab bar must move
    // before snapping to either side.
    // 0   = all the way to the edges or the tab bar will snap to the center
    // 0.5 = anywhere past the center line and the tab bar will snap to the an edge.
    CGFloat boundryFactor = 0.25;

    
    CGFloat currentLeftSideOfVisableRect = self.contentOffset.x;
    CGFloat leftSideBoundry = (self.contentSize.width - (self.frame.size.width * (1 + boundryFactor) ));
    CGFloat rightSideBoundry = (self.frame.size.width * boundryFactor );
        
    if ( currentLeftSideOfVisableRect > leftSideBoundry )
    {
        [self scrollRectToVisible: self.positionLeft animated:YES];
    } else if ( currentLeftSideOfVisableRect < rightSideBoundry  ) {
        [self scrollRectToVisible: self.positionRight animated:YES];
    } else {
        [self scrollRectToVisible: self.positionCenter animated:YES];
    }
}

-(void)scrollToEnd
{
    CGPoint velocity = [[self panGestureRecognizer] velocityInView:self];
    BOOL scrollingToTheRight = (velocity.x > 0) ? NO : YES;

    // If were not moving, don't do anything.
    if ( abs(velocity.x) == 0) return;

    CGFloat distanceToEnd;

    
    ETAnimationBlock animationBlock;
    if (scrollingToTheRight)
    {
        distanceToEnd = self.positionLeft.origin.x - self.contentOffset.x;
        animationBlock = ^{
            [self setContentOffset: self.positionLeft.origin animated: NO];
        };

     } else {
         distanceToEnd = self.contentOffset.x - self.positionRight.origin.x ;
         animationBlock = ^{
        [self setContentOffset: self.positionRight.origin animated:NO];
         };
    }

    
    if (distanceToEnd > 0)
    {
        CGFloat duration = [self durationFromVelocity: velocity];
        CGFloat distanceToEndFactor = distanceToEnd / self.frame.size.width;
        duration = (duration * distanceToEndFactor);
        //NSLog(@"Velocity: %f  Duration: %f  Distance: %f  Distance Factor: %f", velocity.x, duration, distanceToEnd , distanceToEndFactor );

        [UIView
             animateWithDuration: duration
             delay: 0
             options: ( UIViewAnimationOptionBeginFromCurrentState |  UIViewAnimationCurveEaseOut)
             animations: animationBlock
             completion: nil
         ];
    }
}

-(CGFloat)durationFromVelocity:(CGPoint)velocity
{
    

    // Velocity
    CGFloat currentAdjustedVelocity = abs(velocity.x);
    CGFloat highVelocity = 2000.0;
    
    // Duration
    CGFloat slow = .8;
    CGFloat fast = .3;
    
    CGFloat velocityRange = (highVelocity - 0);
    CGFloat durationRange = ( fast - slow);
    CGFloat result = (((currentAdjustedVelocity - 0) * durationRange) / velocityRange) + slow;
    
    
    return result;
}



-(void)scrollToSelectedETTabBarItem
{
    
    
    TAB_BAR_VC
    ETTabBarItem *selectedTabBarItem = [tabBarVC currentlySelectedTabBarItem];
    
    // The center  of the tabBarItem
    CGFloat itemCenter = (selectedTabBarItem.position + (selectedTabBarItem.width / 2));
    
    NSRange visibleRange = NSMakeRange(self.contentOffset.x, /* left side */
                                       self.frame.size.width /* length */);
    
    if ( NSLocationInRange(itemCenter, visibleRange) )
    {
        //NSLog(@"Selected Tab Bar Item is visible, will scroll To Nearest Position.");
        [self scrollToNearestPositionNow];
    } else {
        /// NSLog(@"Tab Bar Item Center %f is NOT between %d & %d",
        //             itemCenter,visibleRange.location,visibleRange.length);
        
        NSRange centerRange = NSMakeRange(self.positionCenter.origin.x,self.positionCenter.size.width);
        NSRange leftRange   = NSMakeRange(0, (self.positionCenter.size.width - 1));
        NSRange rightRange  = NSMakeRange((self.positionCenter.size.width + 1), self.positionLeft.size.width);
        
        
        if (NSLocationInRange(itemCenter, centerRange))
        {
            //NSLog(@"Selected Tab Bar Item is not visible, scrolling to the center.");
            [self scrollRectToVisible: self.positionCenter animated:YES];
            
            return;
        }
        
        if (NSLocationInRange(itemCenter, leftRange))
        {
            //NSLog(@"Selected Tab Bar Item is not visible, scrolling to the left.");
            [self scrollRectToVisible: self.positionRight animated:YES];
            
            return;
        }

        if (NSLocationInRange(itemCenter, rightRange))
        {
            //NSLog(@"Selected Tab Bar Item is not visible, scrolling to the right.");
            [self scrollRectToVisible: self.positionLeft animated:YES];
            
            return;
        }

        //NSLog(@"Selected Tab Bar Item is in some unknown impossible position!!! ( %f )",itemCenter);
    }

    
    
}

-(void)scrollToCenter
{
    
    
    CGRect rect = self.positionCenter;
    
    [self scrollRectToVisible: rect animated:NO];
    
}

-(void)scrollToLeft
{
    
    
    CGRect rect = self.positionLeft;
    
    [self scrollRectToVisible: rect animated:NO];
    
}

-(void)scrollToRight
{
    
    
    CGRect rect = self.positionRight;
    
    [self scrollRectToVisible: rect animated:NO];
    
}

-(void)scrollToRect:(CGRect) aRect
{
    
    [self scrollRectToVisible: aRect animated:NO];
    

}

-(void)bounceToThe:(ETTabBarBounceDirection) direction
{
    CGPoint endOffset = self.positionCenter.origin;
    CGFloat duration0, distance0;
    CGFloat duration1, distance1;
    CGFloat duration2;
    ETAnimationBlock animationBlock0, animationBlock1, animationBlock2;

    duration0 = 0.0;
    duration1 = 0.0;
    duration2 = 0.0;
    
    
    if (direction == ETTabBarBounceDirectionLeft)
    {
        // Old values, use when the ScrollView is 
        // being scaled wider during rotation
        duration0 = 0.15;
        distance0 = 6.8;
        duration1 = 0.17;
        distance1 = 25.4;
        duration2 = 0.155;
        
        // New values, use when the ScrollView ramains
        // a fixed width during rotation
        duration0 = 0;
        distance0 = 0;
        duration1 = 0.09;
        distance1 = 15;
        duration2 = 0.1875;

        
        CGPoint offset1 = CGPointMake( endOffset.x + distance0 ,
                                      endOffset.y);
        CGPoint offset2 = CGPointMake(endOffset.x + distance1,
                                      endOffset.y);
        
        animationBlock0 = ^{
            [self setContentOffset: offset1 animated: NO];
        };
        animationBlock1 = ^{
            [self setContentOffset: offset2 animated: NO];
        };
        animationBlock2 = ^{
            [self setContentOffset:endOffset animated: NO];
        };
    }
    
    if (direction == ETTabBarBounceDirectionRight)
    {
        duration0 = 0;
        distance0 = 0;
        duration1 = 0.062;
        distance1 = 15;
        duration2 = 0.1875;

        CGFloat currentOffset = self.contentOffset.x;
        
        CGPoint offset1 = CGPointMake( currentOffset - distance0,
                                      endOffset.y);
        CGPoint offset2 = CGPointMake(currentOffset - distance1,
                                      endOffset.y);
        
        animationBlock0 = ^{
            [self setContentOffset: offset1 animated: NO];
        };
        animationBlock1 = ^{
            [self setContentOffset: offset2 animated: NO];
        };
        animationBlock2 = ^{
            [self setContentOffset:endOffset animated: NO];
        };
    }
    
    [UIView
     animateWithDuration: duration0
     delay: 0
     options: UIViewAnimationOptionCurveLinear
     animations: animationBlock0
     completion: ^(BOOL finished){
         [UIView
          animateWithDuration: duration1
          delay: 0
          options: (UIViewAnimationOptionOverrideInheritedCurve |
                    UIViewAnimationOptionCurveEaseOut)
          animations: animationBlock1
          completion: ^(BOOL finished){
              
              [UIView
               animateWithDuration: duration2
               delay: 0
               options: UIViewAnimationOptionCurveEaseIn
               animations: animationBlock2
               completion: nil];
              
          }];
     }];
}

-(BOOL)isCentered
{
    
    BOOL result;
    if (self.positionCenter.origin.x == self.contentOffset.x)
    {
        result = YES;
    } else {
        result = NO;
    }
    
    
    return result;
}

-(BOOL)isCloseToCentered
{
    
    
    CGFloat fudgeDistance   = (self.frame.size.width / 4);
    CGFloat centerPosition  = (self.positionCenter.origin.x + (self.positionCenter.size.width / 2));
    CGFloat currentPosition = (self.contentOffset.x + (self.frame.size.width / 2));
    
    BOOL result;
    if ((currentPosition < (centerPosition + fudgeDistance)) &&
        (currentPosition > (centerPosition - fudgeDistance))  )
    {
        result = YES;
        // NSLog(@"%f is between %f and %f",currentPosition,(centerPosition - fudgeDistance), (centerPosition + fudgeDistance) );
    } else {
        result = NO;
        // NSLog(@"%f is NOT between %f and %f",currentPosition,(centerPosition - fudgeDistance), (centerPosition + fudgeDistance) );
    }
    
    
    return result;
}


#pragma mark - Call the ETTabBarDelegate
- (void)tabBarButtonPressed:(id) sender
{
    
    UIButton *tabBarButton = (UIButton *) sender;
    NSUInteger tabBarButtonIndex = tabBarButton.tag;
    ETTabBarItem *tabBarItem = self.items[tabBarButtonIndex];
 
    [self.delegate performSelector:@selector(tabBar:didTouchItem:) withObject:self withObject:tabBarItem];
    
}

- (void)tabBarButtonReleaced:(id) sender
{
    
    UIButton *tabBarButton = (UIButton *) sender;
    NSUInteger tabBarButtonIndex = tabBarButton.tag;
    ETTabBarItem *tabBarItem = self.items[tabBarButtonIndex];
    
    [self.delegate performSelector:@selector(tabBar:didReleaseItem:) withObject:self withObject:tabBarItem];

    
}


- (BOOL)userScrolledSlow
{
    
    BOOL result = YES;
    
    // Check the scrolling speed
    CGPoint scrollVelocity =
    [[self panGestureRecognizer] velocityInView:self];
    
    NSUInteger lastUserScrollSpeed = abs(scrollVelocity.x);
    
    if (lastUserScrollSpeed != 0)
    {
        if (lastUserScrollSpeed > userScrolledSlowSpeed)
        {
            result = NO;
            //NSLog(@"Scroll Speed Fast - %d ",lastUserScrollSpeed);
            
        } else {
            result = YES;
            //NSLog(@"Scroll Speed Slow - %d ",lastUserScrollSpeed);
        }
    }
    
        
    return result;
}

#pragma mark - Size and position properties
-(CGRect)centerButtonRect
{
    
    NSUInteger centerButtonIndex = (self.items.count / 2) ;
    ETTabBarItem *centerItem = self.items[centerButtonIndex];
    CGFloat height   = centerItem.height;
    CGFloat width    = centerItem.width;
    CGFloat overhang = centerItem.topOverhang;
    CGFloat position = centerItem.position;
    
    CGRect centerButtonRect = CGRectMake(position, (0 - overhang), width, height);
    
    
    return centerButtonRect;

}

-(CGFloat)tabBarItemAverageWidth
{
    
    
    CGFloat contentWidth = 0.0;
    for (ETTabBarItem *anItem in self.items)
    {
        contentWidth = contentWidth + anItem.width;
    }

    CGFloat tabBarItemWidth = (contentWidth / self.items.count);
    
    
    return tabBarItemWidth;
}

-(CGRect)positionCenter
{
    
    CGRect centerRect =
            CGRectMake((self.contentSize.width / 2) - (self.frame.size.width / 2) ,
                        0,
                       (self.frame.size.width),
                        self.tabBarContentHeight);
    
    
    return centerRect;
}

// Area of the scroll view when slid all the way to the left
-(CGRect)positionLeft
{
    
    CGRect leftRect =
    CGRectMake((self.contentSize.width - self.frame.size.width),
               0,
               (self.frame.size.width),
               self.tabBarContentHeight);


    
    return leftRect;
}

// Area of the scroll view when slid all the way to the right
-(CGRect)positionRight
{
    
    CGRect rightRect =
            CGRectMake(  0,
                         0,
                        (self.frame.size.width),
                         self.tabBarContentHeight);

    
    return rightRect;
}

-(CGFloat)combinedWidthOfPreviousTabBarItems:(NSUInteger)currentItemIndex
{
    
    
    CGFloat combinedWidth = 0;
    ETTabBarItem *anItem;
    for (NSUInteger index = 0; currentItemIndex > index ; index++)
    {
        anItem = self.items[index];
        combinedWidth = combinedWidth + anItem.width + gapBetweenTabsForTestingLayout;
    }
    
    
    return combinedWidth;
}

-(CGFloat)widthOfAllTabBarItemsCombined
{
    return [self combinedWidthOfPreviousTabBarItems: self.items.count  ];
}

// TODO: Change method to work with actualy tab bar item widths,
//       not assuming uniform widths and using the average.
-(NSUInteger)tabBarVisableItemCount
{
    return (self.frame.size.width / self.tabBarItemWidth);
}

// TODO: Change method to work with actualy tab bar item widths,
//       not assuming uniform widths and using the average.
-(NSUInteger)tabBarOffScreenItemCount
{
    return (_tabBarItemCount - self.tabBarVisableItemCount);
}

-(CGFloat)tabBarContentHeight
{
    
    CGFloat contentHeight = self.frame.size.height;
    if (contentHeight == 0)
    {
        for (NSLayoutConstraint *aContraint in self.constraints) {
            if (aContraint.firstItem == self)
            {
                if (aContraint.firstAttribute == NSLayoutAttributeHeight)
                {
                    contentHeight = aContraint.constant;
                    //NSLog(@"Setting the scroll view content height to %f from contraint with attribute NSLayoutAttributeHeight",contentHeight);
                    
                }
            }
        }
    }
    
    
    return contentHeight;
}

-(CGFloat)tabBarContentWidth
{
    return self.widthOfAllTabBarItemsCombined;
}

-(CGSize)tabBarContentSize
{
    return CGSizeMake( self.tabBarContentWidth , self.tabBarContentHeight );
}

-(CGRect)contentRect
{
    CGRect aRect = CGRectMake(self.contentOffset.x, 0, self.frame.size.width, self.frame.size.height);
    
    return aRect;
}

-(CGFloat)heightOfHighestItem
{
    
    CGFloat highestTabBarButton = 0;
    for (ETTabBarItem *anItem in self.items)
    {
        if (anItem.height > highestTabBarButton)
        {
            highestTabBarButton =  anItem.height;
        }
    }
    
    
    return highestTabBarButton;
}

#pragma mark - Appearence Setters
-(void)setDefaultApearenceProperties
{
    _labelFont = [UIFont boldSystemFontOfSize: 10];
    _labelTextAlignment = NSTextAlignmentCenter;
    _labelBackgroundColor = [UIColor clearColor];
    _labelTextColor = [UIColor whiteColor];
    
    for (ETTabBarItem *anItem in self.items)
    {
        anItem.titleLabel.font = self.labelFont;
        anItem.titleLabel.textAlignment = self.labelTextAlignment;
        anItem.titleLabel.backgroundColor = self.labelBackgroundColor;
        anItem.titleLabel.textColor = self.labelTextColor;
    }
}

-(void)setLabelTextColor:(UIColor *)color
{
    _labelTextColor = color;
    for (ETTabBarItem *item in self.items) {
        item.titleLabel.textColor = color;
    }
}

-(void)setLabelBackgroundColor:(UIColor *)color
{
    _labelBackgroundColor = color;
    for (ETTabBarItem *item in self.items) {
        item.titleLabel.backgroundColor = color;
    }
}

-(void)setLabelFont:(UIFont *)labelFont
{
    _labelFont = labelFont;
    for (ETTabBarItem *item in self.items) {
        item.titleLabel.font = labelFont;
    }
}

-(void)setLabelTextAlignment:(NSTextAlignment)labelTextAlignment
{
    _labelTextAlignment = labelTextAlignment;
    for (ETTabBarItem *item in self.items) {
        item.titleLabel.textAlignment = labelTextAlignment;
    }
}


@end
