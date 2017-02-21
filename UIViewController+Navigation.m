//
//  UIViewController+Navigation.m
//  AviationNews
//
//  Created by apple on 17/2/17.
//  Copyright © 2017年 庄春辉. All rights reserved.
//

#import "UIViewController+Navigation.h"
#import <objc/runtime.h>

@implementation UIViewController (Navigation)

- (BOOL)ch_fullScreenEnabled
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setCh_fullScreenEnabled:(BOOL)fullScreenEnabled
{
    objc_setAssociatedObject(self, @selector(ch_fullScreenEnabled), @(fullScreenEnabled), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)ch_leftGestureEnabled
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setCh_leftGestureEnabled:(BOOL)leftGestureEnabled
{
    objc_setAssociatedObject(self, @selector(ch_leftGestureEnabled), @(leftGestureEnabled), OBJC_ASSOCIATION_RETAIN);
}

- (CHNavigationController *)ch_navigationController
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCh_navigationController:(CHNavigationController *)navigationController
{
    objc_setAssociatedObject(self, @selector(ch_navigationController), navigationController, OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)ch_gestureEnabled
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setCh_gestureEnabled:(BOOL)gestureEnabled
{
    objc_setAssociatedObject(self, @selector(ch_gestureEnabled), @(gestureEnabled), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)ch_isDefaultStatusBar
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setCh_isDefaultStatusBar:(BOOL)isDefaultStatusBar
{
    objc_setAssociatedObject(self, @selector(ch_isDefaultStatusBar), @(isDefaultStatusBar), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)didPopClick
{
    return YES;
}

@end
