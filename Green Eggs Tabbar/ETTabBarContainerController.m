//
//  ETTabBarContainerController.m
//  Egg Tracker
//
//  Created by Brian Young on 5/15/13.
//  Copyright (c) 2013 Brian Young. All rights reserved.
//

#import "ETTabBarViewController.h"
#import "ETTabBarContainerController.h"

@interface ETTabBarContainerController ()

@end

@implementation ETTabBarContainerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
   return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    if ( !self.childViewControllers || self.childViewControllers.count == 0)
    {
        //NSLog(@"No Tab Bar View controllers have been presented. Will now present for tab 'Hens'");
        [self performSegueWithIdentifier:@"hens" sender:nil];
    } 
    
    if ( self.childViewControllers && self.childViewControllers.count > 0)
    {
        _visibleViewController = self.childViewControllers[0];
    }
}

- (void)didReceiveMemoryWarning
{
    
    
    [super didReceiveMemoryWarning];
    
    [self logCachedViewControllers];

    // Remove all children from containerController,
    // except for the one that matches the currentViewController
    ETTabBarViewController *tabBarViewController = (ETTabBarViewController *) self.parentViewController;
    UIViewController *currentViewController = tabBarViewController.currentTabViewController;
    
    for (UIViewController *aViewController in self.childViewControllers)
    {
            if (aViewController == currentViewController)
            {
                //NSLog(@"Keeping Current View Controller: %@",aViewController.title);
            } else {
                //NSLog(@"Removing View Controller: %@",aViewController.title);
                [aViewController willMoveToParentViewController:nil];
                [aViewController removeFromParentViewController];
            }
    }
    
    [self logCachedViewControllers];
    
}

#pragma mark - UIViewController Container Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    // Look to see if the view controller for this segue currently exists in the cache
    UINavigationController *selectedTabViewController;
    
    UINavigationController *cachedController;
    for (UINavigationController *aViewController in self.childViewControllers)
    {
        if ([aViewController.title isEqualToString: segue.identifier])
        {
            cachedController = aViewController;
        }
    }
    
    if (cachedController)
    {
        // If there is a cached controller, use it
        //NSLog(@"Retrieving & Presenting View Controller from cache for tab: %@",segue.identifier);
        selectedTabViewController = cachedController;
        selectedTabViewController.view.frame = self.view.frame;
    } else {
        // If not, create a new view controller from the storyboard
        //NSLog(@"Creating View Controller for tab: %@",segue.identifier);
        selectedTabViewController = segue.destinationViewController;
        
        // Add the ETTabBarItem to the newly created viewController
        ETTabBarViewController *tabbarViewController =
            (ETTabBarViewController *) self.parentViewController;
        selectedTabViewController.etTabBarItem =
            [tabbarViewController tabBarItemForStoryboardID:segue.identifier];

    }
    

    
    // Present the View Controller
    [self addChildViewController: selectedTabViewController];
    [self.view addSubview: selectedTabViewController.view];
    [selectedTabViewController didMoveToParentViewController:self];
    [_visibleViewController.view removeFromSuperview];
    
    // Don't cache, but destroy the viewController
//    [_visibleViewController willMoveToParentViewController:nil];
//    [_visibleViewController removeFromParentViewController];
    
    _visibleViewController = selectedTabViewController;
    
    // If you need to animate between the view controllers replace the
    // above presentation code with this:
    //        __weak __block ETTabBarContainerController *weakSelf=self;
    //
    //        [self transitionFromViewController: self.currentViewController
    //                          toViewController: selectedTabViewController
    //                                  duration: 1
    //                                   options: UIViewAnimationOptionTransitionCrossDissolve
    //                                animations: nil
    //                                completion: ^(BOOL finished) {
    //                                    [selectedTabViewController didMoveToParentViewController:weakSelf];
    //                                    weakSelf.currentViewController = selectedTabViewController;
    //                                }];

    [self logCachedViewControllers];
    
    
}

- (BOOL)shouldAutomaticallyForwardRotationMethods
{
    
    return YES;
    
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    
    return YES;
    
}

#pragma mark - Visable Data Read only toggles

-(BOOL)dailyDataIsVisable
{
    
    
    if ([self listsAreVisable])
    {
        
        return YES;
    }
    
    
    if ([self eventsAreVisable])
    {
        
        return YES;
    }
    
    
    if ([self expensesAreVisable])
    {
        
        return YES;
    }
    
    
    if ([self contributionsAreVisable])
    {
        
        return YES;
    }
    
    if ([self deliveriesAreVisable])
    {
        
        return YES;
    }
    
    
    return NO;
}
-(BOOL)listsAreVisable
{
    
    // Edit this to enable this method for asking the TabBarVC if a listViewController is visible

    
//    UINavigationController *listNavVC;
//    
//    for (UINavigationController *aViewController in self.childViewControllers) {
//        if ([aViewController.title isEqualToString:@"list"])
//        {
//            listNavVC = aViewController;
//        }
//    }
//    
//    if (listNavVC)
//    {
//        id listVC = [listNavVC visibleViewController];
//        NSString *visableViewControllerClass = NSStringFromClass( [listVC class] );
//        // NSLog(@"%@",visableViewControllerClass);
//        
//        if([visableViewControllerClass isEqualToString:@"ETListViewController"])
//        {
//            ETListViewController *theListVC = (ETListViewController *) listVC;
//            if (theListVC.isViewLoaded && theListVC.view.window)
//            {
//                
//                return YES;
//            }
//        }
//    }
    
    return NO;
}

-(BOOL)eventsAreVisable
{
    
    
    return NO;
}

-(BOOL)expensesAreVisable
{
    
    
    return NO;
}

-(BOOL)contributionsAreVisable
{
    
    
    return NO;
}

-(BOOL)deliveriesAreVisable
{
    
    
    return NO;
}

#pragma mark - Custom

-(void)logCachedViewControllers
{
    NSMutableArray *aViewControllerNames = [NSMutableArray new];
    for (UINavigationController *aViewController in self.childViewControllers)
    {
        [aViewControllerNames addObject: aViewController.title];
    }
    
    NSArray *sortedList = [aViewControllerNames sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSLog(@"Current Tab ViewControllers (%d): %@", self.childViewControllers.count,
              [[sortedList valueForKey:@"description"] componentsJoinedByString:@", "]);
}




@end
