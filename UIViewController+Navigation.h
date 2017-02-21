//
//  UIViewController+Navigation.h
//  AviationNews
//
//  Created by apple on 17/2/17.
//  Copyright © 2017年 庄春辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHNavigationController.h"

@interface UIViewController (Navigation)

@property (nonatomic, assign) BOOL ch_fullScreenEnabled;
@property (nonatomic, assign) BOOL ch_leftGestureEnabled;
@property (nonatomic, assign) BOOL ch_gestureEnabled;
@property (nonatomic, assign) BOOL ch_isDefaultStatusBar;
@property (nonatomic, strong) CHNavigationController *ch_navigationController;

- (BOOL)didPopClick;

@end
