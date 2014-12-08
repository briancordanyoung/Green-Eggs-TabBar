//
//  ETTabBarItem.h
//  ETTabBar
//
//  Created by Brian Young on 5/3/13.
//  Copyright (c) 2013 Brian Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum ETTabBarItemSubviewStateType {
    ETTabBarItemSubviewStateNormal,
    ETTabBarItemSubviewStateUp,
    ETTabBarItemSubviewStateDown
} ETTabBarItemSubviewState ;

typedef void (^ETAnimationBlock)(void);



// TODO: Add fixed image icons and scalable backgrounds
// - Add a tabBar image (60x60 pixels) that will be
//   composited on to the tab bar backgrounds
//   (normalImage, disabledImageView, selectedImageView, movingImageView)
// - Create 4 more private image properties that hold the original above
// - Change these tabBar image getter methods to check self.width,
//   scale the original version of the image, and composite
//   tabBar image on.
// - Add setters that actually set the original images


@interface ETTabBarItem : NSObject 


@property (nonatomic, strong)   NSString *title;
@property (nonatomic, strong)   NSString *storyBoardId;
@property (nonatomic, strong)   NSDate   *timeLastedTouched;
@property (nonatomic)   BOOL             shouldRotate;

// If an image is not set it will default to the image
// of another state.  'normalImage' is the default and
// if that does not exist, a red colored image will be
// generated.
@property (nonatomic, strong)   UIImage *normalImage;
@property (nonatomic, strong)   UIImage *disabledImage;
@property (nonatomic, strong)   UIImage *selectedImage;
@property (nonatomic, strong)   UIImage *movingImage;
@property (nonatomic, strong)   UIImage *namePlateImage;
@property (nonatomic, strong)   UIImage *icon;

// Views are lazily created when called
@property (nonatomic, strong)   UIButton    *button;
@property (nonatomic, strong)   UILabel     *titleLabel;
@property (nonatomic, strong)   UIImageView *normalImageView;
@property (nonatomic, strong)   UIImageView *disabledImageView;
@property (nonatomic, strong)   UIImageView *selectedImageView;
@property (nonatomic, strong)   UIImageView *movingImageView;
@property (nonatomic, strong)   UIImageView *namePlateImageView;

// Setting these properties will also set the
// coresponding values of all views in this tabbar item
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
// TODO: create a new superView for each position,
// Layout all tabbar items in this view. It should clip
// subviews and extend of the top of the superScrollView
// The Name plate will need to be slid up.
@property (nonatomic) CGFloat position;
@property (nonatomic) CGFloat labelHeight;
@property (nonatomic) CGFloat topOverhang;

// Is this is a imageOnly tab.
// Default is NO - The Center Tab should be YES;
@property (nonatomic)           BOOL imageOnly;
@property (nonatomic)           BOOL enabled;


-(id)initWithTitle: (NSString *) title
   AndStoryboardId: (NSString *) storyboardId;
-(void)setImage:(UIImage *)image
       forState:(UIControlState)state;
-(BOOL)imagesAreScaled;
-(ETTabBarItemSubviewState)normalImageViewState;
-(ETTabBarItemSubviewState)selectedImageViewState;


-(void)unselectedTabPressedWithAnimation: (BOOL) animation
                              completion: (void (^)(BOOL finished))completion;
-(void)selectedTabPressedWithAnimation: (BOOL) animation
                              completion: (void (^)(BOOL finished))completion;

-(void)unselectedTabReleacedWithAnimation: (BOOL) animation
                               completion: (void (^)(BOOL finished))completion;
-(void)selectedTabReleacedWithAnimation: (BOOL) animation
                             completion: (void (^)(BOOL finished))completion;
-(void)unselectTabWithAnimation: (BOOL) animation
                     completion: (void (^)(BOOL finished))completion;

@end
