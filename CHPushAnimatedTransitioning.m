//
//  CHPushAnimatedTransitioning.m
//  AviationNews
//
//  Created by Huii on 2017/2/19.
//  Copyright © 2017年 庄春辉. All rights reserved.
//

#import "CHPushAnimatedTransitioning.h"
#import "CHNavigationConfig.h"

const CGFloat moveFactor = 0.35;

@interface CHPushAnimatedTransitioning ()

@property (nonatomic, weak) id <UIViewControllerContextTransitioning> transitionContext;

@property (nonatomic, weak) UIViewController  *fromViewController;
@property (nonatomic, weak) UIViewController  *toViewController;
@property (nonatomic, weak) UIView            *containerView;

@end

@implementation CHPushAnimatedTransitioning

- (instancetype)init
{
    self = [super init];
    if (self) {
        _transitionDuration = 0.35f;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return _transitionDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    self.fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    self.toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    self.containerView      = [transitionContext containerView];
    self.transitionContext  = transitionContext;
    
    [self animateTransitionEvent];
}

- (void)completeTransition
{
    [self.transitionContext completeTransition:!self.transitionContext.transitionWasCancelled];
}

- (void)animateTransitionEvent
{
    // Mix shadow for toViewController' view.
    [self.containerView insertSubview:self.toViewController.view aboveSubview:self.fromViewController.view];
    UIImage *snapImage = [CHNavigationConfig mixShadowWithView:self.toViewController.view];
    
    // Alloc toView's ImageView.
    UIImageView *ivForToView = [[UIImageView alloc]initWithImage:snapImage];
    [self.toViewController.view removeFromSuperview];
    ivForToView.frame = CGRectMake(CHScreenWidth, 0, snapImage.size.width, CHScreenHeight);
    [self.containerView insertSubview:ivForToView aboveSubview:self.fromViewController.view];
    
    // Alloc fromView's ImageView.
    UIImageView *ivForSnap = [[UIImageView alloc]initWithImage:self.snapImage];
    ivForSnap.frame = CGRectMake(0, 0, CHScreenWidth, CHScreenHeight);
    [self.containerView insertSubview:ivForSnap belowSubview:ivForToView];
    
    // A gray color shadow view for formView.
    UIColor *grayColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    UIImage *grayImage = [CHNavigationConfig imageWithColor:grayColor];
    UIImageView *grayImageView = [[UIImageView alloc]initWithFrame:ivForSnap.bounds];
    grayImageView.image = grayImage;
    [ivForSnap addSubview:grayImageView];
    grayImageView.alpha = 0;
    
    // Hide tabBar if need.
    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([rootVc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *r = (UITabBarController *)rootVc;
        UITabBar *tabBar = r.tabBar;
        tabBar.hidden = YES;
    }
    
    self.fromViewController.view.hidden = YES;
    [UIView animateWithDuration:self.transitionDuration animations:^{
        // Interative transition animation.
        ivForToView.frame = CGRectMake(-shadowWidth, 0, snapImage.size.width, CHScreenHeight);
        ivForSnap.frame = CGRectMake(-moveFactor*CHScreenWidth, 0, CHScreenWidth, CHScreenHeight);
        grayImageView.alpha = 0.1;
    }completion:^(BOOL finished) {
        self.fromViewController.view.hidden = NO;
        self.toViewController.view.frame = CGRectMake(0, 0, CHScreenWidth, CHScreenHeight);
        [self.containerView insertSubview:self.toViewController.view belowSubview:ivForToView];
        [ivForToView removeFromSuperview];
        [ivForSnap removeFromSuperview];
        [self completeTransition];
    }];
}

@end
