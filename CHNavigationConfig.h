//
//  CHNavigationConfig.h
//  AviationNews
//
//  Created by Huii on 2017/2/19.
//  Copyright © 2017年 庄春辉. All rights reserved.
//

#import <UIKit/UIKit.h>

#define  CHScreenWidth   [UIScreen mainScreen].bounds.size.width
#define  CHScreenHeight  [UIScreen mainScreen].bounds.size.height
#define shadowWidth 24

@interface CHNavigationConfig : NSObject

+(UIImage *)snapShotWithView:(UIView *)view;

+(UIImage *)mixShadowWithView:(UIView *)view;

+(UIImage *)imageWithColor:(UIColor *)color;

@end
