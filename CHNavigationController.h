//
//  CHNavigationController.h
//  AviationNews
//
//  Created by apple on 17/1/23.
//  Copyright © 2017年 庄春辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CHNavigationControllerDelegate <NSObject>

- (void)didLeftPush;

@end

@interface CHWrapViewController : UIViewController

@property (nonatomic, strong, readonly) UIViewController *rootViewController;

+ (CHWrapViewController *)wrapWithViewController:(UIViewController *)viewController;

@end

///

@interface CHNavigationController : UINavigationController

@property (nonatomic, strong) UIImage *backButtonImage;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, copy, readonly) NSArray *ch_viewControllers;
@property (nonatomic, weak) id<CHNavigationControllerDelegate> nav_delegate;

- (void)insertViewController:(UIViewController *)viewController index:(NSInteger)index;
- (void)removeViewController:(NSInteger)index;

@end
