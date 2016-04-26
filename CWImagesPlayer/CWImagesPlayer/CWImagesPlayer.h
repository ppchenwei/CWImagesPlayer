//
//  CWImagesPlayer.h
//  Test
//
//  Created by 陈威 on 16/4/11.
//  Copyright © 2016年 陈威. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,  CWImageObjectType)
{
    CWImageObjectTypeImage = 0,       //直接传入图片
    CWImageObjectTypeUrl,             //传入图片的URL地址
};

/**
 *  此类主要是为了让图片展示支持图片和图片链接两种方式
 */
@interface CWImageObject : NSObject

/**
 *  图片的类型:是图片链接  还是 图片
 */
@property (assign, nonatomic)CWImageObjectType type;

/**
 *  如果类型为图片，需要给这个赋值
 */
@property (strong, nonatomic) UIImage *image;

/**
 *  如果类型为图片链接，需要把链接赋给这个属性
 */
@property (strong, nonatomic) NSString *imageUrl;

/**
 *  占位图片，当传入的是图片下载链接时候，下载时会先显示占位图片
 */
@property (strong, nonatomic) UIImage *placeholderImage;

- (instancetype)initWithImageType:(CWImageObjectType)type  image:(UIImage *)image  imageUrl:(NSString *)imageUrl placeholderImage:(UIImage *)placeholderImage;

@end


@protocol CWImagesPlayerDelegate <NSObject>

@optional
/**
 *  当点击图片轮播中的图片时候，会回调此方法.
 *
 *  @param imageView 当前点击的图片视图
 *  @param index     点击的图片视图的位置
 */
- (void)didSelectImageViewAtIndex:(NSInteger)index;

@end


@interface CWImagesPlayer : UIView
/**
 *  需要显示的图片资源
 */
@property (strong, nonatomic) NSArray <CWImageObject *>*images;
/**
 *  设置页面控制的圆点颜色
 */
@property (strong, nonatomic) UIColor *pageIndicatorTintColor;

/**
 *  获取当前的图片位置
 */
@property (assign, nonatomic, readonly) NSInteger currentIndex;

/**
 *  图片轮播的时间间隔,默认为2秒。
 */
@property (assign, nonatomic) CGFloat timeInterval;

@property (assign, nonatomic) id<CWImagesPlayerDelegate>delegate;

- (instancetype)initWithImages:(NSArray *)images;


@end
