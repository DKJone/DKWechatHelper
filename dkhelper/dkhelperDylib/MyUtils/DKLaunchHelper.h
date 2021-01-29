//  DKLaunchHelper.h
//  launchDemo
//  Created by ___ORGANIZATIONNAME___ on 2021/1/18
//  
//
//
//                    ██████╗ ██╗  ██╗     ██╗ ██████╗ ███╗   ██╗███████╗
//                    ██╔══██╗██║ ██╔╝     ██║██╔═══██╗████╗  ██║██╔════╝
//                    ██║  ██║█████╔╝      ██║██║   ██║██╔██╗ ██║█████╗
//                    ██║  ██║██╔═██╗ ██   ██║██║   ██║██║╚██╗██║██╔══╝
//                    ██████╔╝██║  ██╗╚█████╔╝╚██████╔╝██║ ╚████║███████╗
//                    ╚═════╝ ╚═╝  ╚═╝ ╚════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QGVAPlayer.h"

@interface DKLaunchHelper : NSObject
+ (void)clearLaunchScreenCache;
+ (NSArray<NSDictionary<NSString *,NSObject*>*> *)animaNames;
@end

/// 自定义校验规则，originImage为原始系统缓存启动图，yourImage为替代的启动图，返回YES代表本次替换，否则本次不会进行替换
typedef BOOL(^BBACustomValicationBlock)(UIImage *originImage, UIImage *yourImage);

/**
 动态启动图（请确保替换的图片尺寸与屏幕分辨率一致，否则替换不成功）
*/
@interface BBADynamicLaunchImage : NSObject

/// 替换系统缓存启动图，图片压缩质量默认0.8，覆盖原有系统启动图文件
/// @param replacementImage 替代图片
/// @return 替换是否成功
+ (BOOL)replaceLaunchImage:(UIImage *)replacementImage;

/// 替换系统缓存启动图，将替换图片以指定的压缩质量写入系统启动图缓存目录，覆盖原有系统启动图文件
/// @param replacementImage 替代图片
/// @param quality 压缩质量
/// @return 替换是否成功
+ (BOOL)replaceLaunchImage:(UIImage *)replacementImage compressionQuality:(CGFloat)quality;

/// 替换系统缓存启动图，按自定义的校验规则将替代图片以指定的压缩质量写入系统启动图缓存目录，覆盖原有系统启动图文件
/// @param replacementImage 替代图片
/// @param quality 压缩质量
/// @param validationBlock 自定义校验回调，校验通过表示本次替换，否则不替换
/// @return 替换是否成功
+ (BOOL)replaceLaunchImage:(UIImage *)replacementImage
        compressionQuality:(CGFloat)quality
          customValidation:(BBACustomValicationBlock)validationBlock;



/// 获取image对象
+ (UIImage *)imageFromData:(NSData *)data;

/// 获取图片大小
+ (CGSize)getImageSize:(NSData *)imageData;

@end


@interface LaunchImageHelper : NSObject

+ (UIImage *)snapshotStoryboardForPortrait:(NSString *)sbName;
+ (UIImage *)snapshotStoryboardForLandscape:(NSString *)sbName;

/// 替换所有的启动图为竖屏
+ (void)changeAllLaunchImageToPortrait:(UIImage *)image;
/// 替换所有的启动图为横屏
+ (void)changeAllLaunchImageToLandscape:(UIImage *)image;
/// 使用单独的图片分别替换竖、横屏启动图
+ (void)changePortraitLaunchImage:(UIImage *)portraitImage
             landscapeLaunchImage:(UIImage *)landScapeImage;

@end


@interface UIView (DKScreenShoot)

- (UIImage *)dkScreenShoot;

@end
