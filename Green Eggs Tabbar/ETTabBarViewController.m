//
//  ETTabBarViewController.m
//  ETTabBar
//
//  Created by Brian Young on 5/3/13.
//  Copyright (c) 2013 Brian Young. All rights reserved.
//

#import "ETTabBarContainerController.h"
#import "ETTabBarView.h"
#import "ETTabBarViewController.h"

typedef enum ETTabBarScrollPositionType {
    ETTabBarScrolledLeft,
    ETTabBarScrolledCenter,
    ETTabBarScrolledRight,
} ETTabBarScrollPosition ;

typedef void (^ETCompleteBlock)(BOOL finished);

const CGFloat minimumSecondsForTabUp = 0.25;
const CGFloat secondsToWaitForTabReset = .75;



@interface ETTabBarViewController ()
@property (nonatomic) BOOL aButtonIsActive;
@property (nonatomic) CGFloat maximumTabBarButtonHeight;
@property (nonatomic) CGFloat etTabBarViewAndContainerViewOverlap;
@property (nonatomic) ETTabBarScrollPosition lastPortraitPosition;

@property (nonatomic) dispatch_queue_t tabBarQueue;

@end

@implementation ETTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        

    }
    
    return self;
}

- (void)viewDidLoad
{
    

    [super viewDidLoad];

    _aButtonIsActive = NO;
    _tabBarQueue = dispatch_queue_create("com.BrianCordanYoung.eggtracker.tabbar", DISPATCH_QUEUE_CONCURRENT);
    
    // TODO: set these dates using NSUserDefaults

    [self createTabBar];
    
    // Set properties used in animating the tabbar off/on screen during rotations
    ETTabBarItem *centerTabBarButton = _appTabBar.items[4];
    _maximumTabBarButtonHeight = centerTabBarButton.height;
    _etTabBarViewAndContainerViewOverlap = self.contentBottomContraint.constant;
    
    // Set the visable child view controller 
    // frame to the right size
    ETTabBarContainerController *containerController = [self tabBarContainerController];
    containerController.visibleViewController.view.frame = containerController.view.frame;

    // Set the initial state of the tabbar.
    if (self.childViewControllers.count > 0)
    {
        ETTabBarContainerController *containerController = [self tabBarContainerController];
        if (containerController.childViewControllers.count > 0)
        {
            // Get the tabBarItem
            ETTabBarItem *startingTabBarItem =
                [self tabBarItemForStoryboardID: containerController.visibleViewController.title];
            
            // Select the tabBarItem
            [startingTabBarItem unselectedTabReleacedWithAnimation:NO completion:nil];
            
            // Set the tabBarItem property on the visable view controller
            containerController.visibleViewController.etTabBarItem = startingTabBarItem;
        }
    }

    
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [self.appTabBar scrollToCenter];
    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation) toInterfaceOrientation
        duration:(NSTimeInterval)duration
{
    
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        
    // Save the current scroll
    if ( UIInterfaceOrientationIsPortrait(interfaceOrientation) )
    {
        CGPoint centerPoint = _appTabBar.positionCenter.origin;
        CGPoint leftPoint   = _appTabBar.positionLeft.origin;
        CGPoint rightPoint  = _appTabBar.positionRight.origin;

        if (self.appTabBar.contentOffset.x == centerPoint.x)
        {
            //NSLog(@"Currently Centered");
           _lastPortraitPosition = ETTabBarScrolledCenter;
        }
        if (self.appTabBar.contentOffset.x == leftPoint.x)
        {
            //NSLog(@"Currently scrolled left");
            _lastPortraitPosition = ETTabBarScrolledLeft;
        }
        if (self.appTabBar.contentOffset.x == rightPoint.x)
        {
            //NSLog(@"Currently scrolled right");
            _lastPortraitPosition = ETTabBarScrolledRight;
        }

        
    } else {
        if (_lastPortraitPosition == ETTabBarScrolledCenter)
        {
            
        }
        if (_lastPortraitPosition == ETTabBarScrolledLeft)
        {
            //NSLog(@"Scrolling left.");
            [_appTabBar scrollToLeft];
        }
        if (_lastPortraitPosition == ETTabBarScrolledRight)
        {
            //NSLog(@"Scrolling right.");
            [_appTabBar scrollToRight];
        }
    }
    
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait ||
        toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        [_appTabBar waitThenScrollToSelected: YES];

        // show the tabbar when switching to portait
        self.appTabBarBottomContraint.constant = 0;
        self.contentBottomContraint.constant = _etTabBarViewAndContainerViewOverlap;
        self.appTabBarAddButtonViewBottomContraint.constant = (0 - _maximumTabBarButtonHeight);
        [UIView animateWithDuration: duration
                         animations:^{
                             [self.view layoutIfNeeded];
                         }];
        
    } else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight ||
               toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        
        [_appTabBar waitThenScrollToSelected: NO];

        // hide the tabbar when switching to landscape
        self.appTabBarBottomContraint.constant = (0 - _maximumTabBarButtonHeight);
        self.contentBottomContraint.constant = 0;
        self.appTabBarAddButtonViewBottomContraint.constant = 0;
        [UIView animateWithDuration: duration
                         animations:^{
                             [self.view layoutIfNeeded];
                         }];

    }
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    if (_lastPortraitPosition == ETTabBarScrolledCenter)
    {
        if (fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)
        {
            [self.appTabBar bounceToThe:ETTabBarBounceDirectionLeft];

        }
            if (fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
        {
            [self.appTabBar bounceToThe:ETTabBarBounceDirectionRight];

        }
    } else {
        if (fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
        {
            if (_lastPortraitPosition == ETTabBarScrolledLeft)
            {
                //NSLog(@"Scrolling left.");
                [_appTabBar scrollToLeft];
            }
            if (_lastPortraitPosition == ETTabBarScrolledRight)
            {
                //NSLog(@"Scrolling right.");
                [_appTabBar scrollToRight];
            }
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    
    
    [super didReceiveMemoryWarning];
        
    
}

#pragma mark - Creation Methods

-(void)createTabBar
{
    
        
    // Create Tab Bar Items
    ETTabBarItem *peopleItem   = [[ETTabBarItem alloc]
                                  initWithTitle:
                                  NSLocalizedString(@"People",@"People tab title")
                                AndStoryboardId: @"people"];
    ETTabBarItem *eggsItem     = [[ETTabBarItem alloc]
                                  initWithTitle:
                                  NSLocalizedString(@"Eggs",@"Eggs tab title")
                                AndStoryboardId: @"eggs"];
    ETTabBarItem *hensItem     = [[ETTabBarItem alloc]
                                  initWithTitle:
                                  NSLocalizedString(@"Hens",@"Hens tab title")
                                AndStoryboardId: @"hens"];
    ETTabBarItem *calendarItem = [[ETTabBarItem alloc]
                                  initWithTitle: 
                                  NSLocalizedString(@"Calendar",@"Calendar tab title")
                                AndStoryboardId: @"calendar"];
    calendarItem.shouldRotate = NO;
    
    ETTabBarItem *addItem      = [[ETTabBarItem alloc]
                                  initWithTitle: 
                                  NSLocalizedString(@"Add",@"Add tab title")
                                AndStoryboardId: @""];
    addItem.imageOnly = YES;
    
    ETTabBarItem *graphItem    = [[ETTabBarItem alloc]
                                  initWithTitle:
                                  NSLocalizedString(@"Graph",@"Graph tab title")
                                AndStoryboardId: @"graph"];
    ETTabBarItem *listItem     = [[ETTabBarItem alloc]
                                  initWithTitle:
                                  NSLocalizedString(@"List",@"List tab title")
                                AndStoryboardId: @"list"];
    ETTabBarItem *settingsItem = [[ETTabBarItem alloc]
                                  initWithTitle:
                                  NSLocalizedString(@"Settings",@"Settings tab title")
                                AndStoryboardId: @"settings"];
    ETTabBarItem *toolsItem    = [[ETTabBarItem alloc]
                                  initWithTitle:
                                  NSLocalizedString(@"Tools",@"Tools tab title")
                                AndStoryboardId: @"tools"];
        
    _appTabBarItems =  @[peopleItem,eggsItem,hensItem,calendarItem,
                              addItem,
                         graphItem,listItem,settingsItem,toolsItem];
    
    NSUInteger index=0;

    for ( ETTabBarItem *anItem in _appTabBarItems ) {
        UIImage *aTouchedImage = [UIImage imageNamed:
               [NSString stringWithFormat:@"tabbarItem%luTouched.png",  (index + 1)]];
        
        UIImage *aSelectedImage = [UIImage imageNamed:
               [NSString stringWithFormat:@"tabbarItem%luSelected.png",  (index + 1)]];
        
        UIImage *aNamePlateImage = [UIImage imageNamed:
                [NSString stringWithFormat:@"tabbarItem%luNameplate.png",  (index + 1)]];
        
        UIImage *anIcon = [UIImage imageNamed: [anItem.storyBoardId capitalizedString]];
        
        [anItem setImage: aTouchedImage forState:UIControlStateNormal];
        [anItem setImage: aSelectedImage forState:UIControlStateSelected];
        anItem.namePlateImage = aNamePlateImage;
        anItem.icon           = anIcon;
        
        index++;
    }
    
    // Setup tabbar
    _appTabBar.items = _appTabBarItems;
    _appTabBar.delegate = self;
    
    // Create and add the Center Add button
    [self createAddButton];

    
}

-(void)createAddButton
{
    

    // Create the Add Buttons for the Portrait Tab Bar
    // and the Landscape TabBarView
    UIImage *addButtonImage = [UIImage imageNamed: @"addButton.png"];
    UIImage *addButtonImageHighlighted = [UIImage imageNamed: @"addButtonHighlighted.png"];
    
    UIButton *portraitAddButton = [self createAddButtonWithImage:addButtonImage
                                               AndHighlightImage:addButtonImageHighlighted];
    CGRect centerButtonRect = _appTabBar.centerButtonRect;
    portraitAddButton.frame = centerButtonRect;
    [_appTabBar addSubview: portraitAddButton];
    
    
    UIButton *landscapeAddButton = [self createAddButtonWithImage:addButtonImage
                                                AndHighlightImage:addButtonImageHighlighted];
    landscapeAddButton.frame = CGRectMake(0, 0, centerButtonRect.size.width, centerButtonRect.size.height);
    
    [_appTabBarAddButtonView addSubview: landscapeAddButton];
    _appTabBarAddButtonView.alpha = 1;
    _appTabBarAddButtonView.backgroundColor = [UIColor clearColor];

}


- (UIButton *)createAddButtonWithImage:(UIImage *)image AndHighlightImage:(UIImage *) highlightImage
{
    
    
    UIButton *newAddButton = [UIButton buttonWithType: UIButtonTypeCustom];
    
    [newAddButton setImage: image
                  forState: UIControlStateNormal];
    
    [newAddButton setImage: highlightImage
                  forState: UIControlStateHighlighted];
    
    newAddButton.adjustsImageWhenHighlighted = NO;
    newAddButton.adjustsImageWhenDisabled    = NO;
    newAddButton.opaque                      = NO;
    
    
    return newAddButton;
}

#pragma mark - UIViewController Container Methods
- (BOOL)shouldAutomaticallyForwardRotationMethods
{
    
    return self.currentlySelectedTabBarItem.shouldRotate;
    
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    
    return YES;
    
}

- (BOOL)shouldAutorotate
{
    
    
    return self.currentlySelectedTabBarItem.shouldRotate;
}

- (NSUInteger)supportedInterfaceOrientations
{
    
    if (self.currentlySelectedTabBarItem.shouldRotate)
    {
        
        return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape);
    } else {
        
        return UIInterfaceOrientationMaskPortrait;
    }
}


#pragma mark - ETTabBarViewDelegate

-(void)     tabBar:(ETTabBarView *)tabBar
      didTouchItem:(ETTabBarItem *)tabBarItem
{
    
    
    // Ignore too many touches at once
    if (_aButtonIsActive)
    {
        //NSLog(@"Button Active... skipping.");

        
        return;
    }
    
    // Add Tab
    if ( ([tabBarItem.title isEqualToString:@"Add"])) {
        //NSLog(@"Add Tab Touched");
    } else if ([tabBarItem.storyBoardId isEqualToString:@""]) {
        // Empty Tab with no view controller
        //NSLog(@"Tab %@ provided no storyboard id",tabBarItem.title);
        [tabBarItem unselectedTabPressedWithAnimation:YES completion: nil ];
    } else {
        _aButtonIsActive = YES;
        
        // Current Tab
        if (tabBarItem == self.currentlySelectedTabBarItem )
        {
            //NSLog(@"Tab %@ is already visible.",tabBarItem.title);
            
            ETCompleteBlock popNavControllerAfterTabAnimatesUp = ^ (BOOL finished){
                // All Tabs are in Navigatin Controllers, pop to the next view up
                [self.currentTabViewController popViewControllerAnimated:YES];
                _aButtonIsActive = NO;
            };

            [tabBarItem selectedTabPressedWithAnimation:YES
                        completion: popNavControllerAfterTabAnimatesUp];

            
            return;
        }
        
        
        ETCompleteBlock presentViewComtrollerAfterTabAnimatesup = ^ (BOOL finished){
            [self.tabBarContainerController performSegueWithIdentifier:tabBarItem.storyBoardId sender: self];
            _aButtonIsActive = NO;
        };
        
        [tabBarItem unselectedTabPressedWithAnimation:YES
                    completion: presentViewComtrollerAfterTabAnimatesup];
    }
    
    

    
}

-(void)     tabBar:(ETTabBarView *)tabBar
    didReleaseItem:(ETTabBarItem *)tabBarItem
{
    
    
    // Do Nothing for Add tab
    if ([tabBarItem.title isEqualToString:@"Add"])
    {
        
        return;
    } 

    
    //_tabBarQueue
    dispatch_async(_tabBarQueue, ^{
        
        // Don't continue until it's been minimumSecondsForTabUp
        // since the tab button was first touched.
        NSDate *startTime;
        NSTimeInterval timeWaiting;
        BOOL waiting = YES;
        
        if (tabBarItem.timeLastedTouched){
            startTime = tabBarItem.timeLastedTouched;
        } else {
            startTime = [NSDate date];
        }
        
        waiting = YES;
        while (waiting) {
            timeWaiting = [[NSDate date] timeIntervalSinceDate: startTime];
            if (timeWaiting > (minimumSecondsForTabUp)) waiting = NO;
       }
        
        // Return the tab bar buttons to there final state.
        dispatch_sync(dispatch_get_main_queue(),  ^() {
            
            for (ETTabBarItem *eachTabBarItem in tabBar.items) {
                
                // Currently Touched Tab
                if (eachTabBarItem == tabBarItem )
                {
                    if (eachTabBarItem.normalImageViewState == ETTabBarItemSubviewStateUp ||
                        eachTabBarItem.selectedImageViewState == ETTabBarItemSubviewStateDown)
                    {
                        [eachTabBarItem unselectedTabReleacedWithAnimation:YES
                                                                completion:nil];
                    } else {
                        [eachTabBarItem selectedTabReleacedWithAnimation:YES
                                                              completion:nil];
                    }
                } else {
                    // Other Tabs
                    if (eachTabBarItem.selectedImageViewState != ETTabBarItemSubviewStateDown)
                    {
                        [eachTabBarItem unselectTabWithAnimation:YES
                                                      completion:nil];
                    }
                }
            }
            dispatch_async(_tabBarQueue, ^{
                NSDate *startTime = [NSDate date];
                NSTimeInterval timeWaiting;
                BOOL waiting = YES;
                while (waiting) {
                    timeWaiting = [[NSDate date] timeIntervalSinceDate: startTime];
                    if (timeWaiting > secondsToWaitForTabReset) waiting = NO;
                }

            // Return the tab bar buttons to there final state.                        
            dispatch_sync(dispatch_get_main_queue(),  ^() {
                    [self resetAllTabs];
                }); // Main Queue
            }); // Tab Bar Queue
          }); // Main Queue
    }); // Tab Bar Queue
    
    
}


#pragma mark - Custom

-(void) resetAllTabs
{
    
    
    NSTimeInterval timeWaiting;
    NSTimeInterval shortestTimeWaiting = 1000000;
    NSDate *currentTabBarButtonReset = [NSDate date];
    for (ETTabBarItem *eachTabBarItem in self.appTabBarItems)
    {

        timeWaiting = [currentTabBarButtonReset timeIntervalSinceDate: eachTabBarItem.timeLastedTouched];
        if (shortestTimeWaiting > timeWaiting)
        {
            shortestTimeWaiting = timeWaiting;
        }
    }
    if (shortestTimeWaiting < (minimumSecondsForTabUp + secondsToWaitForTabReset))
    {
        // NSLog(@"Not resetting tab bar button states since another button has been pressed since this one");
        return;
    }
    
    // NSLog(@"Resetting tab bar buttons (%f)", shortestTimeWaiting);
    for (ETTabBarItem *eachTabBarItem in self.appTabBarItems) {
        
        
        // Do Nothing for Add tab
        if ([eachTabBarItem.title isEqualToString:@"Add"])
        {
        } else {
            // Current Tab

            if (eachTabBarItem == self.currentlySelectedTabBarItem )
            {
                [eachTabBarItem selectedTabReleacedWithAnimation:YES
                                                      completion:nil];
            } else {
                [eachTabBarItem unselectTabWithAnimation:NO
                                              completion:nil];
            }
        }
    }
    
    [_appTabBar scrollToNearestPosition: NO];
    
}



#pragma mark Convenience methods to find ViewControllers and ETTabBarItems
-(ETTabBarItem *)tabBarItemForStoryboardID: (NSString *) storyboardID
{
    
    for (ETTabBarItem *aTabBarItem in _appTabBarItems)
    {
        if ([aTabBarItem.storyBoardId isEqualToString: storyboardID])
        {
            
            return aTabBarItem;
        }
    }
    
    return nil;
}

-(ETTabBarItem *)currentlySelectedTabBarItem
{
    
    ETTabBarContainerController *tabBarContainerController = [self tabBarContainerController];
    
    return tabBarContainerController.visibleViewController.etTabBarItem;
}

-(UINavigationController *)currentTabViewController
{
    
    ETTabBarContainerController *tabBarContainerController = [self tabBarContainerController];
    
    return tabBarContainerController.visibleViewController;
;
}

-(ETTabBarContainerController *)tabBarContainerController
{
    
    
    for (id viewController in self.childViewControllers)
    {
        if ([viewController isKindOfClass:[ETTabBarContainerController class]])
        {
            
            return (ETTabBarContainerController *) viewController;
        }
    }
    //NSLog(@"Tab Bar View Controller Not Found!");
    
    
    return nil;
}



#pragma mark - Scroll View Delegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Keep the ETTabBar UIScroll view from scrolling up
    if (scrollView.contentOffset.y > 0) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
    }

//    if (_appTabBar.decelerating ) //NSLog(@"Slowing rate: %f", _appTabBar.decelerationRate );
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    [_appTabBar scrollToNearestPosition ];
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
    [_appTabBar scrollToNearestPosition ];
    
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    
//    [_appTabBar scrollToNearestPosition: NO ];
//    
//}

#pragma mark - UIResponder

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [_appTabBar scrollToNearestPosition ];
    
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [_appTabBar scrollToNearestPosition ];
    
}


@end
