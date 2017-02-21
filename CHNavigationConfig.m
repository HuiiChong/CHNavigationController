//
//  CHNavigationConfig.m
//  AviationNews
//
//  Created by Huii on 2017/2/19.
//  Copyright © 2017年 庄春辉. All rights reserved.
//

#import "CHNavigationConfig.h"

#define kShadowImageName @"navbar_shadow"

@implementation CHNavigationConfig

+(UIImage *)snapShotWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *aImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return aImage;
}

+(UIImage *)mixShadowWithView:(UIView *)view
{
    UIImage *aImage = [self snapShotWithView:view];
    
    UIImage *shadow = [UIImage imageNamed:kShadowImageName];
    CGRect snapRect = CGRectMake(0, 0, shadow.size.width+shadowWidth, CHScreenHeight);
    CGRect imageRect = CGRectMake(shadowWidth, 0, CHScreenWidth, CHScreenHeight);
    
    UIGraphicsBeginImageContextWithOptions(snapRect.size, NO, aImage.scale);
    [shadow drawInRect:snapRect];
    [aImage drawInRect:imageRect];
    UIImage *snapImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapImage;
}

+(UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
