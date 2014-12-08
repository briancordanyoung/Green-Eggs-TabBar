//
//  ETTabBarItem.m
//  ETTabBar
//
//  Created by Brian Young on 5/3/13.
//  Copyright (c) 2013 Brian Young. All rights reserved.
//

#import "ETTabBarItem.h"
#import <math.h>



const CGFloat defaultWidth       = 64;
const CGFloat defaultHeight      = 72;
const CGFloat defaultOverhang    = 17;
const CGFloat defaultLabelHeight = 11;

const CGFloat animationDuration = .25;

@interface ETTabBarItem ()

@property (nonatomic, strong, readonly)   UIImage *generatedStandInTabBarItemImage;

@property (nonatomic, readonly) CGFloat tabTopNormal;
@property (nonatomic, readonly) CGFloat tabTopDown;
@property (nonatomic, readonly) CGFloat tabTopUp;

@property (nonatomic, strong, readonly) NSArray *viewsForWidth;
@property (nonatomic, strong, readonly) NSArray *viewsForHeight;
@property (nonatomic, strong, readonly) NSArray *imageViews;

@end

#pragma mark - ETTabBarItem

@implementation ETTabBarItem

@synthesize namePlateImage = _namePlateImage;
@synthesize icon = _icon;
@synthesize generatedStandInTabBarItemImage = _generatedStandInTabBarItemImage;
@synthesize labelHeight = _labelHeight;
@synthesize topOverhang = _topOverhang;

- (id)initWithTitle: (NSString *) title AndStoryboardId: (NSString *) storyboardId
{
    
    self = [super init];
    if (self)
    {

        self.title        = title;
        self.storyBoardId = storyboardId;
        
        // Defaults:
        self.enabled      = YES;
        self.imageOnly    = NO;
        self.shouldRotate = YES;
                
    }
    return self;
    
}

- (void)setNamePlateImage:(UIImage *)namePlateImage
{
    
    _namePlateImage = namePlateImage;
    
}

- (void)setIcon:(UIImage *)icon
{
    
    _icon = icon;
    
}



- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    
    switch (state)
    {
        case UIControlStateNormal:
            _normalImage = image;
            break;

        case UIControlStateDisabled:
            _disabledImage = image;
            break;
        
        // Highlighted is same as
        // selected in this class
        case UIControlStateHighlighted:
            _selectedImage = image;
            break;
            
        case UIControlStateSelected:
            _selectedImage = image;
            break;
            
        case UIControlStateApplication:
            _movingImage = image;
            break;
            
        default:
            NSLog(@"Unknown UIControlState");
            break;
    }
    
}


#pragma mark - Return UIImages based on which images have been set

-(UIImage *)normalImage
{
    
    if (_normalImage)
    {
        
        return _normalImage;
    } else {
        _normalImage = self.generatedStandInTabBarItemImage;
        
        return _normalImage;
    }
}

-(UIImage *)disabledImage
{
    
    if (_disabledImage)
    {
        
        return _disabledImage;
    } else {
        
        return self.normalImage;
    }
}

-(UIImage *)selectedImage
{
    
    if (_selectedImage)
    {
        
        return _selectedImage;
    } else {
        
        return self.normalImage;
    }
}

-(UIImage *)movingImage
{
    
    if (_movingImage)
    {
        
        return _movingImage;
    } else {
        
        return self.normalImage;
    }
}

-(UIImage *)namePlateImage
{
    
    if (_namePlateImage)
    {
        
        return _namePlateImage;
    } else {
        
        // If no normal image has been set, be ready by creating a
        // default image with a color
        CGRect rect = CGRectMake(0, 0, 64, 11);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]) ;
        CGContextFillRect(context, rect);
        _namePlateImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        return _namePlateImage;
    }
}


#pragma mark - Standing Image


-(UIImage *)generatedStandInTabBarItemImage
{
    
    if (_generatedStandInTabBarItemImage)
    {
        
        return _generatedStandInTabBarItemImage;
    } else {
        // create a default image with a color
        CGRect rect = CGRectMake(0, 0, self.width, (self.height - self.topOverhang));
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context,
                                       [[UIColor colorWithRed:0.898 green:0.000 blue:0.074 alpha:0.770] CGColor]) ;
        CGContextFillRect(context, rect);
        _generatedStandInTabBarItemImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    
    return _generatedStandInTabBarItemImage;
}


#pragma mark - Customized Setters and Getters

-(BOOL)enabled
{
    
    if (self.button)
    {
        
        return self.button.enabled;
    } else {
        
        return NO;
    }
}

-(void)setEnabled:(BOOL)enabled
{
    
    
    if (!self.imageOnly)
    {
        self.button.enabled = enabled;
        
        if (_normalImageView && _disabledImageView)
        {
            if (enabled)
            {
                _normalImageView.hidden = NO;
                _disabledImageView.hidden = YES;
            } else {
                _normalImageView.hidden = YES;
                _disabledImageView.hidden = NO;
            }
        }
    }
    
}

-(CGFloat)labelHeight
{
    
    if (_labelHeight == 0)
    {
        _labelHeight = defaultLabelHeight;
    }
    
    
    return _labelHeight;
}

-(void)setLabelHeight:(CGFloat)labelHeight
{
    _labelHeight = labelHeight;
    [self reLayoutViews];
}

-(CGFloat)topOverhang
{
    
    if (_topOverhang == 0)
    {
        _topOverhang = defaultOverhang;
    }
    
    
    return _topOverhang;
}

-(void)setTopOverhang:(CGFloat)topOverhang
{
    _topOverhang = topOverhang;
    [self reLayoutViews];
}

-(CGFloat)tabTopUp
{
    return self.height;
}

-(CGFloat)tabTopDown
{
    return (self.height - self.labelHeight - self.topOverhang);
}

-(CGFloat)tabTopNormal
{
    
    CGFloat tabTopNormal = (self.height - (55 + self.topOverhang));
    
    if (self.imageOnly)
    {
        
        return (tabTopNormal - self.topOverhang);
    } else {
        
        return  tabTopNormal;
    }
}

#pragma mark - Lists of Views

// All views including the label
-(NSArray *)viewsForWidth
{
    
    
    NSMutableArray *theViews = [NSMutableArray arrayWithCapacity:7];
    if(_normalImageView)      [theViews addObject: _normalImageView];
    if(_disabledImageView)    [theViews addObject: _disabledImageView];
    if(_selectedImageView)    [theViews addObject: _selectedImageView];
    if(_movingImageView)      [theViews addObject: _movingImageView];
    if(_titleLabel)           [theViews addObject: _titleLabel];
    if(_namePlateImageView)   [theViews addObject: _namePlateImageView];
    if(_button)               [theViews addObject: _button];
    
    
    return [NSArray arrayWithArray: theViews];
}

// All views except the label and nameplate
-(NSArray *)viewsForHeight
{
    

    NSMutableArray *theViews = [NSMutableArray arrayWithCapacity:6];
    if(_normalImageView)      [theViews addObject: _normalImageView];
    if(_disabledImageView)    [theViews addObject: _disabledImageView];
    if(_selectedImageView)    [theViews addObject: _selectedImageView];
    if(_movingImageView)      [theViews addObject: _movingImageView];
    if(_button)               [theViews addObject: _button];

    
    return [NSArray arrayWithArray: theViews];
}

// Only the image views
-(NSArray *)imageViews
{
    
    
    NSMutableArray *theViews = [NSMutableArray arrayWithCapacity:6];
    if(_normalImageView)      [theViews addObject: _normalImageView];
    if(_disabledImageView)    [theViews addObject: _disabledImageView];
    if(_selectedImageView)    [theViews addObject: _selectedImageView];
    if(_movingImageView)      [theViews addObject: _movingImageView];
    
    
    return [NSArray arrayWithArray: theViews];
}


#pragma mark - Views

-(UILabel *)titleLabel
{
        
    if (_titleLabel)
    {
        
        return _titleLabel;
    }
    
    if (self.imageOnly)
    {
        
        return nil;
    } else {
        _titleLabel = [[UILabel alloc]initWithFrame: self.titleLabelRect];
        _titleLabel.text = _title;
        
        
        return _titleLabel;
    }
}

-(CGRect)titleLabelRect
{
    return CGRectMake(self.position,
                      (self.height - self.labelHeight - self.topOverhang),
                      self.width,
                      self.labelHeight);
}

-(UIButton *)button
{
    
    
    if (_button)
    {
        
        return _button;
    }
    
    _button = [UIButton buttonWithType: UIButtonTypeCustom];
    
    _button.adjustsImageWhenHighlighted = NO;
    _button.adjustsImageWhenDisabled = NO;
    
    _button.frame = self.buttonRect;
    _button.opaque = NO;
    
    
    return _button;
}

-(CGRect)buttonRect
{
    return  CGRectMake( self.position,
                        self.tabTopNormal,
                        self.width,
                        self.height);
}

-(UIImageView *)namePlateImageView
{
    
    
    if (_namePlateImageView)
    {
        
        return _namePlateImageView;
    } else {
        _namePlateImageView = [[UIImageView alloc ] initWithImage: self.namePlateImage] ;
        _namePlateImageView.frame = self.namePlateRect;
        _namePlateImageView.hidden = NO;
        
        
        return _namePlateImageView;
    }
}

-(CGRect)namePlateRect
{
    return CGRectMake(self.position,
                      (self.height - self.namePlateImageView.frame.size.height - self.topOverhang),
                      self.width,
                      self.namePlateImageView.frame.size.height);
}



#pragma mark - ImageViews

-(UIImageView *)normalImageView
{
    
 
    if (_normalImageView)
    {
        
        return _normalImageView;
    } else {
        _normalImageView = [[UIImageView alloc ] initWithImage: self.normalImage] ;
        _normalImageView.frame = self.normalRect;
        
        _normalImageView.hidden = NO;
        [self addIconImageView: _normalImageView];
        
        
        return _normalImageView;
    }
}

-(UIImageView *)disabledImageView
{
    
    
    if (_disabledImageView)
    {
        
        return _disabledImageView;
    } else {
        _disabledImageView = [[UIImageView alloc ] initWithImage: self.disabledImage] ;
        _disabledImageView.frame = self.normalRect;
        _disabledImageView.hidden = YES;
        [self addIconImageView: _disabledImageView];

        
        return _disabledImageView;
    }
}

-(UIImageView *)selectedImageView
{
    
    
    if (_selectedImageView)
    {
        
        return _selectedImageView;
    } else {
        _selectedImageView = [[UIImageView alloc ] initWithImage: self.selectedImage] ;
        _selectedImageView.frame = self.downRect;
        _selectedImageView.hidden = NO;
        [self addBlackIconImageView: _selectedImageView];

        
        return _selectedImageView;
    }
}

-(UIImageView *)movingImageView
{
    
    
    if (_movingImageView)
    {
        
        return _movingImageView;
    } else {
        _movingImageView = [[UIImageView alloc ] initWithImage: self.movingImage] ;
        _movingImageView.frame = self.normalRect;
        _movingImageView.hidden = YES;
        [self addIconImageView: _movingImageView];

        
        return _movingImageView;
    }
}


-(void)addIconImageView:(UIImageView *)imageView
{
    if(_icon)
    {
        UIImageView *icon = [[UIImageView alloc ] initWithImage: self.icon];
        icon.frame = CGRectMake((imageView.frame.size.width / 2) - 15, 12, 30, 30);
        [imageView addSubview: icon];
        
        
// What a nightmare, mixing contraints with AutoresizingMask!!!
// If I REALLY want the tabbar to be resizable, switch completely to using
// constraints.  Otherwise, just use frames.
//        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(icon);
//        NSArray *horizontalSizeContraint, *verticalSizeContraint;
//        
//
//        
//        horizontalSizeContraint = [NSLayoutConstraint
//                           constraintsWithVisualFormat: @"|-[icon(30)]-|"
//                                               options: NSLayoutFormatAlignAllCenterX
//                                               metrics: nil
//                                                 views: viewsDictionary
//                                   ];
//        verticalSizeContraint = [NSLayoutConstraint
//                         constraintsWithVisualFormat:@"V:|-10-[icon(30)]-|"
//                                             options: NSLayoutFormatAlignAllCenterY
//                                             metrics: nil
//                                               views: viewsDictionary
//                                 ];
//        
//        NSMutableArray *allContraints =
//            [NSMutableArray arrayWithArray: horizontalSizeContraint];
//        [allContraints addObjectsFromArray: verticalSizeContraint];
//
//        icon.translatesAutoresizingMaskIntoConstraints = NO;
//        imageView.translatesAutoresizingMaskIntoConstraints = NO;
//        [imageView addConstraints: allContraints];
        
    }
}

-(void)addBlackIconImageView:(UIImageView *)imageView
{
    if(_icon)
    {
        UIImageView *icon = [[UIImageView alloc ]
                             initWithImage: [self blackenImage: self.icon]];
        icon.frame = CGRectMake((imageView.frame.size.width / 2) - 15, 12, 30, 30);
        [imageView addSubview: icon];
    }
}

-(UIImage *)blackenImage:(UIImage *)image
{
    
    
    UIGraphicsBeginImageContext(image.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -area.size.height);
    
    CGContextSaveGState(context);
    CGContextClipToMask(context, area, image.CGImage);
    
    UIColor *color = [UIColor blackColor];
    [color set];
    CGContextFillRect(context, area);
    
    CGContextRestoreGState(context);
    
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    
    CGContextDrawImage(context, area, image.CGImage);
    
    UIImage *colorizedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    return colorizedImage;
}


#pragma mark - Size and Position

-(CGFloat)width
{
    
    
    CGFloat theWidestViewWidth = 0;
    
    for (UIView *aView in self.viewsForWidth)
    {
        if (theWidestViewWidth < aView.frame.size.width)
        {
            theWidestViewWidth = aView.frame.size.width;
        }
    }
    
    // The Default Width
    if (theWidestViewWidth == 0) theWidestViewWidth = defaultWidth;

    
    return theWidestViewWidth;
}

-(void)setWidth:(CGFloat)width
{
    
    for (UIView *aView in self.viewsForWidth)
    {
        CGRect aViewRect = aView.frame;
        aView.frame = CGRectMake(aViewRect.origin.x,
                                 aViewRect.origin.y,
                                 width,
                                 aViewRect.size.height);
    }
    
}

-(CGFloat)height
{
    
    
    CGFloat theHeighestViewHeight = 0;
    
    for (UIView *aView in self.viewsForHeight)
    {
        if (theHeighestViewHeight < aView.frame.size.height)
        {
            theHeighestViewHeight = aView.frame.size.height;
        }
    }
    
    // The Default Height
    if (theHeighestViewHeight == 0)  theHeighestViewHeight = defaultHeight;
    
    
    return theHeighestViewHeight;
}

-(void)setHeight:(CGFloat)height
{
    

    for (UIView *aView in self.viewsForHeight)
    {
        CGRect aViewRect = aView.frame;
        aView.frame = CGRectMake(aViewRect.origin.x,
                                 aViewRect.origin.y,
                                 aViewRect.size.width,
                                 height);
    }
    
    // If the height of the tab bar items is changing
    // reposition the label.
    [self reLayoutViews];
    
    
    
}


-(CGFloat)position
{
    
    
    CGFloat theFurthestViewPosition = 0;
    
    for (UIImageView *aView in self.viewsForWidth)
    {
        if (theFurthestViewPosition < aView.frame.origin.x)
        {
            theFurthestViewPosition = aView.frame.origin.x;
        }
    }
    
    
    return theFurthestViewPosition;
}

-(void)setPosition:(CGFloat)position
{
    
    for (UIImageView *aView in self.viewsForWidth)
    {
        CGRect aViewRect = aView.frame;
        aView.frame = CGRectMake(position,
                                 aViewRect.origin.y,
                                 aViewRect.size.width,
                                 aViewRect.size.height);
    }
        
}

-(void)reLayoutViews
{
    
    
    // TODO: When the height, width or position of an item is changed, reposition the linked views
    // This is not working. Maybe I need to call layoutIfNeed on each view to?
    // Currently, dynamic layout isn't needed, so I'll leave this until much later.
//    if (_titleLabel)           _titleLabel.frame = self.titleLabelRect;
//    if (_button)               _button.frame = self.titleLabelRect;
    
//    if (self.normalImageViewState == VIEW_NORMAL)
//    {
//        if (_normalImageView)      _normalImageView.frame = self.normalRect;
//        if (_movingImageView)      _movingImageView.frame = self.normalRect;
//        if (_selectedImageView)    _selectedImageView.frame = self.downRect;
//    } else {
//        if (_normalImageView)      _normalImageView.frame = self.downRect;
//        if (_movingImageView)      _movingImageView.frame = self.downRect;
//        if (_selectedImageView)    _selectedImageView.frame = self.normalRect;
//    }
    
//    if (_disabledImageView)    _disabledImageView.frame = self.normalRect;
    
}


#pragma mark - Tests

-(BOOL)imagesAreScaled
{
    
    
    BOOL areScaled = NO;
    
    CGFloat viewWidth, viewHeight, imageWidth, imageHeight;
    
    for (UIImageView *anImageView in self.imageViews) {
        viewWidth  = anImageView.frame.size.width;
        viewHeight = anImageView.frame.size.height;
        
        imageWidth  = anImageView.image.size.width;
        imageHeight = anImageView.image.size.height;
        
        if(viewWidth != imageWidth) areScaled = YES;
        if(viewHeight != imageHeight) areScaled = YES;
    }
    
    if (areScaled)
    {
        // NSLog(@"The images for Tab Bar Item '%@' are scaled: width %f -> %f height %f -> %f", _title ,imageWidth,viewWidth,imageHeight,viewHeight);
    }
    
    
    return areScaled;
}

#pragma mark - ImageView frame rects
-(CGRect)normalRect
{
    

    CGRect aRect = CGRectMake(self.position,
                              self.tabTopNormal,
                              self.width,
                              self.height);
    
    
    return aRect;

}

-(CGRect)halfUpRect
{
    
    
    CGRect aRect = CGRectMake(self.position,
                              self.tabTopNormal * .9,
                              self.width,
                              self.height);
        
    
    return aRect;
    
}

-(CGRect)upRect
{
    
    CGRect aRect = CGRectMake(self.position,
                             (self.topOverhang * -1),
                              self.width,
                              self.height);
    
    
    return aRect;
    
}

-(CGRect)downRect
{
        
    CGRect aRect = CGRectMake(self.position,
                              self.tabTopDown,
                              self.width,
                              self.height);
    
    
    return aRect;
    
}

#pragma mark - ImageView current states
-(ETTabBarItemSubviewState)normalImageViewState
{
    
    
    CGFloat currentPoint = self.normalImageView.frame.origin.y;
    
    if (currentPoint != (self.topOverhang * -1) &&
        currentPoint != self.tabTopDown)
    {
        
        return ETTabBarItemSubviewStateNormal;
    } else if (currentPoint != self.tabTopNormal &&
               currentPoint != self.tabTopDown) {
        
        return ETTabBarItemSubviewStateUp;
    } else if (currentPoint != (self.topOverhang * -1) &&
               currentPoint !=  self.tabTopNormal) {
        
        return ETTabBarItemSubviewStateDown;
    } else {
        NSLog(@"Unknown state of normalImageView for tab bar item '%@'", self.title);
        
        return ETTabBarItemSubviewStateDown;
    }
    
}

-(ETTabBarItemSubviewState)selectedImageViewState
{
    
    
    CGFloat currentPoint = self.selectedImageView.frame.origin.y;
    
    if (currentPoint != (self.topOverhang * -1) &&
        currentPoint !=  self.tabTopDown)
    {
        
        return ETTabBarItemSubviewStateNormal;
    } else if (currentPoint != self.tabTopNormal &&
               currentPoint != self.tabTopDown) {
        
        return ETTabBarItemSubviewStateUp;
    } else if (currentPoint != (self.topOverhang * -1) &&
               currentPoint !=  self.tabTopNormal) {
        
        return ETTabBarItemSubviewStateDown;
    } else {
        NSLog(@"Unknown state of selectedImageView for tab bar item '%@'", self.title);
        
        return ETTabBarItemSubviewStateDown;
    }
}



#pragma mark - Changing State and Animating

-(void)unselectedTabPressedWithAnimation: (BOOL) animation
       completion: (void (^)(BOOL finished))completion
{
    
    
    self.timeLastedTouched = [NSDate date];
    
    if (!self.imageOnly)
    {
        ETAnimationBlock animationBlock;
            animationBlock = ^{
                self.normalImageView.frame = self.upRect;
            };
        
        CGFloat duration = 0.0;
        if (animation)
        {
            duration = 0.0; //animationDuration * .2
        }
        
        [UIView
          animateWithDuration: duration 
                        delay: 0.0
                      options: UIViewAnimationOptionCurveEaseInOut
                   animations: animationBlock
                   completion: completion];
    }
    
}

-(void)selectedTabPressedWithAnimation: (BOOL) animation
                              completion: (void (^)(BOOL finished))completion
{
    
    
    self.timeLastedTouched = [NSDate date];

    if (!self.imageOnly)
    {
        ETAnimationBlock animationBlock;
        animationBlock = ^{
            self.selectedImageView.frame = self.upRect;
        };
        
        CGFloat duration = 0.0;
        if (animation)
        {
            duration = 0.0; //animationDuration * .2
        }

        [UIView
         animateWithDuration: duration
                       delay: 0.0
                     options: UIViewAnimationOptionCurveEaseInOut
                  animations: animationBlock
                  completion: completion];
    }
    
}


-(void)unselectedTabReleacedWithAnimation: (BOOL) animation
                              completion: (void (^)(BOOL finished))completion
{
    
    
    if (!self.imageOnly)
    {
        ETAnimationBlock animationBlock1;
        animationBlock1 = ^{
            self.normalImageView.frame = self.downRect;
            self.selectedImageView.frame = self.upRect;
        };
        
        ETAnimationBlock animationBlock2;
        animationBlock2 = ^{
           self.selectedImageView.frame = self.normalRect;
        };
        
        CGFloat duration1 = 0.0;
        CGFloat duration2 = 0.0;
        if (animation)
        {
            duration1 = animationDuration * .8;
            duration2 = animationDuration * .2;
        }
        
        [UIView
         animateWithDuration: duration1
                       delay: 0.0
                     options: UIViewAnimationOptionCurveEaseInOut
                  animations: animationBlock1
                  completion: ^(BOOL finished){
        [UIView
         animateWithDuration: duration2
                       delay: 0.0
                     options: UIViewAnimationOptionCurveEaseInOut
                  animations: animationBlock2
                  completion: completion];
        }];

    }
    
}

-(void)selectedTabReleacedWithAnimation: (BOOL) animation
                               completion: (void (^)(BOOL finished))completion
{
    
    
    if (!self.imageOnly)
    {
        ETAnimationBlock animationBlock;
        animationBlock = ^{
            self.normalImageView.frame = self.downRect;
            self.selectedImageView.frame = self.normalRect;
        };
        
        
        CGFloat duration = 0.0;
        if (animation)
        {
            duration = animationDuration * .2;
        }

        [UIView
         animateWithDuration: duration
                       delay: 0.0
                     options: UIViewAnimationOptionCurveEaseInOut
                  animations: animationBlock
                  completion: completion];
    }
    
}

-(void)unselectTabWithAnimation: (BOOL) animation
                             completion: (void (^)(BOOL finished))completion
{
    
    
    if (!self.imageOnly)
    {
        ETAnimationBlock animationBlock1 = ^{
            self.normalImageView.frame = self.halfUpRect;
            self.selectedImageView.frame = self.downRect;
       };
        ETAnimationBlock animationBlock2 = ^{
            self.normalImageView.frame = self.normalRect;
            self.selectedImageView.frame = self.downRect;
        };

        CGFloat duration1 = 0.0;
        CGFloat delay1    = 0.0;
        CGFloat duration2 = 0.0;
        if (animation)
        {
            duration1 = animationDuration * .8;
            delay1    = animationDuration * .25;
            duration2 = animationDuration * .2;
        }

        [UIView
         animateWithDuration: duration1
                       delay: delay1
                     options: UIViewAnimationOptionCurveEaseInOut
                  animations: animationBlock1
                  completion: ^(BOOL finished){
                      
        [UIView
         animateWithDuration: duration2
                       delay: 0
                     options: UIViewAnimationOptionCurveEaseInOut
                  animations: animationBlock2
                  completion: completion];
                      
                  }];

    }
    
}



@end

