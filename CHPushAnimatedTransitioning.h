//
//  CHPushAnimatedTransitioning.h
//  AviationNews
//
//  Created by Huii on 2017/2/19.
//  Copyright © 2017年 庄春辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHPushAnimatedTransitioning : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic) NSTimeInterval transitionDuration;
@property (nonatomic, readonly, weak) UIViewController *fromViewController;
@property (nonatomic, readonly, weak) UIViewController *toViewController;
@property (nonatomic, readonly, weak) UIView *containerView;
@property (nonatomic, strong) UIImage *snapImage;

- (void)animateTransitionEvent;
- (void)completeTransition;

@end
