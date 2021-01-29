//  DKLaunchHelper.m
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

#import "DKLaunchHelper.h"
#import <ImageIO/ImageIO.h>


@implementation DKLaunchHelper

+ (void)clearLaunchScreenCache {
    // 异步删除缓存
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error;
        [NSFileManager.defaultManager removeItemAtPath:[NSString stringWithFormat:@"%@/Library/SplashBoard",NSHomeDirectory()] error:&error];
        if (error) {
            NSLog(@"Failed to delete launch screen cache: %@",error);
        }
    });
}

+ (NSArray<NSDictionary<NSString *,NSObject *> *> *)animaNames{
    return @[
        @{@"name":@"earth",@"desc":@"地球",@"color":[UIColor colorWithRed:0.430 green:0.632 blue:0.854 alpha:1.000]},
        @{@"name":@"venus",@"desc":@"金星",@"color":[UIColor colorWithRed:0.662 green:0.392 blue:0.140 alpha:1.000]},
        @{@"name":@"mercury",@"desc":@"水星",@"color":[UIColor colorWithRed:0.629 green:0.594 blue:0.745 alpha:1.000]},
        @{@"name":@"mars",@"desc":@"火星",@"color":[UIColor colorWithRed:0.905 green:0.624 blue:0.519 alpha:1.000]},
        @{@"name":@"moon",@"desc":@"月球",@"color":[UIColor colorWithRed:0.831 green:0.831 blue:0.831 alpha:1.000]},//d4d4d4
        @{@"name":@"jupitre",@"desc":@"木星",@"color":[UIColor colorWithRed:0.629 green:0.542 blue:0.518 alpha:1.000]},
        @{@"name":@"nepture",@"desc":@"海王星",@"color":[UIColor colorWithRed:0.428 green:0.470 blue:0.753 alpha:1.000]},
        @{@"name":@"pluto",@"desc":@"冥王星",@"color":[UIColor colorWithRed:0.611 green:0.539 blue:0.531 alpha:1.000]},
        @{@"name":@"sun",@"desc":@"太阳",@"color":[UIColor colorWithRed:0.624 green:0.206 blue:0.117 alpha:1.000]},
        @{@"name":@"sature",@"desc":@"木星",@"color":[UIColor colorWithRed:0.582 green:0.520 blue:0.429 alpha:1.000]},//94856d
        @{@"name":@"uranus",@"desc":@"天王星",@"color":[UIColor colorWithRed:0.436 green:0.677 blue:0.720 alpha:1.000]},//6fadb8
        @{@"name":@"sedna",@"desc":@"塞德娜",@"color":[UIColor colorWithRed:0.496 green:0.117 blue:0.067 alpha:1.000]},//7f1e11
        @{@"name":@"blackhole",@"desc":@"黑洞",@"color":[UIColor colorWithRed:0.688 green:0.398 blue:0.306 alpha:1.000]}//af664e
    ];
}
@end


@implementation BBADynamicLaunchImage

/// 系统启动图缓存路径
+ (NSString *)launchImageCacheDirectory {

    NSString *bundleID = [NSBundle mainBundle].infoDictionary[@"CFBundleIdentifier"];
    NSFileManager *fm = [NSFileManager defaultManager];

    // iOS13之前
    NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *snapshotsPath = [[cachesDirectory stringByAppendingPathComponent:@"Snapshots"] stringByAppendingPathComponent:bundleID];
    if ([fm fileExistsAtPath:snapshotsPath]) {
        return snapshotsPath;
    }

    // iOS13
    NSString *libraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    snapshotsPath = [NSString stringWithFormat:@"%@/SplashBoard/Snapshots/%@ - {DEFAULT GROUP}", libraryDirectory, bundleID];
    if ([fm fileExistsAtPath:snapshotsPath]) {
        return snapshotsPath;
    }

    return nil;
}

/// 系统缓存启动图后缀名
+ (BOOL)isSnapShotName:(NSString *)name {
    // 新系统后缀
    NSString *snapshotSuffixs = @".ktx";
    if ([name hasSuffix:snapshotSuffixs]) {
        return YES;
    }
    // 老系统后缀
    snapshotSuffixs = @".png";
    if ([name hasSuffix:snapshotSuffixs]) {
        return YES;
    }
    return NO;
}

/// 替换启动图
+ (BOOL)replaceLaunchImage:(UIImage *)replacementImage {
    return [self replaceLaunchImage:replacementImage compressionQuality:0.8 customValidation:nil];
}

/// 替换启动图
+ (BOOL)replaceLaunchImage:(UIImage *)replacementImage compressionQuality:(CGFloat)quality {
    return [self replaceLaunchImage:replacementImage compressionQuality:quality customValidation:nil];
}

/// 替换启动图
+ (BOOL)replaceLaunchImage:(UIImage *)replacementImage
        compressionQuality:(CGFloat)quality
          customValidation:(BBACustomValicationBlock)validationBlock {
    if (!replacementImage) return NO;

    // 转为jpeg
    NSData *data = UIImageJPEGRepresentation(replacementImage, quality);
    if (!data) return NO;

    // 检查图片尺寸是否等同屏幕分辨率
//    if (![self checkImageMatchScreenSize:replacementImage]) {
//        return NO;
//    }

    // 获取系统缓存启动图路径
    NSString *cacheDir = [self launchImageCacheDirectory];
    if (!cacheDir) return NO;

    // 工作目录
    NSString *cachesParentDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *tmpDir = [cachesParentDir stringByAppendingPathComponent:@"_tmpLaunchImageCaches"];

    // 清理工作目录
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:tmpDir]) {
        [fm removeItemAtPath:tmpDir error:nil];
    }

    // 移动系统缓存目录内容至工作目录
    BOOL moveResult = [fm moveItemAtPath:cacheDir toPath:tmpDir error:nil];
    if (!moveResult) return NO;

    // 操作工作目录
    // 记录需要操作的图片名
    NSMutableArray *cacheImageNames = [NSMutableArray array];
    for (NSString *name in [fm contentsOfDirectoryAtPath:tmpDir error:nil]) {
        if ([self isSnapShotName:name]) {
            [cacheImageNames addObject:name];
        }
    }

    // 写入替换图片
    for (NSString *name in cacheImageNames) {
        NSString *filePath = [tmpDir stringByAppendingPathComponent:name];
        // 自定义校验
        BOOL result = YES;
        if (validationBlock) {
            NSData *cachedImageData = [NSData dataWithContentsOfFile:filePath];
            UIImage *cachedImage = [self imageFromData:cachedImageData];
            if (cachedImage) {
                result = validationBlock(cachedImage, replacementImage);
            }
        }
        if (result) {
            [data writeToFile:filePath atomically:YES];
        }
    }

    // 还原系统缓存目录
    moveResult = [fm moveItemAtPath:tmpDir toPath:cacheDir error:nil];

    // 清理工作目录
    if ([fm fileExistsAtPath:tmpDir]) {
        [fm removeItemAtPath:tmpDir error:nil];
    }

    return YES;
}

/// 获取image对象
+ (UIImage *)imageFromData:(NSData *)data {
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    if (source) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, NULL);
        if (imageRef) {
            UIImage *originImage = [UIImage imageWithCGImage:imageRef];
            CFRelease(imageRef);
            CFRelease(source);
            return originImage;
        }
    }
    return nil;
}

/// 获取图片大小
+ (CGSize)getImageSize:(NSData *)imageData {
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, NULL);
    if (imageRef) {
        CGFloat width = CGImageGetWidth(imageRef);
        CGFloat height = CGImageGetHeight(imageRef);
        CFRelease(imageRef);
        CFRelease(source);
        return CGSizeMake(width, height);
    }
    return CGSizeZero;
}

/// 检查图片大小
+ (BOOL)checkImageMatchScreenSize:(UIImage *)image {
    CGSize screenSize = CGSizeApplyAffineTransform([UIScreen mainScreen].bounds.size,
                                                   CGAffineTransformMakeScale([UIScreen mainScreen].scale,
                                                                              [UIScreen mainScreen].scale));
    CGSize imageSize = CGSizeApplyAffineTransform(image.size,
                                                  CGAffineTransformMakeScale(image.scale, image.scale));
    if (CGSizeEqualToSize(imageSize, screenSize)) {
        return YES;
    }
    if (CGSizeEqualToSize(CGSizeMake(imageSize.height, imageSize.width), screenSize)) {
        return YES;
    }
    return NO;
}

@end


@implementation LaunchImageHelper

+ (UIImage *)snapshotStoryboard:(NSString *)sbName isPortrait:(BOOL)isPortrait {
    if (!sbName) {
        return nil;
    }

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:sbName bundle:nil];
    UIViewController *vc = storyboard.instantiateInitialViewController;
    vc.view.frame = [UIScreen mainScreen].bounds;
    if (isPortrait) {
        if (vc.view.frame.size.width > vc.view.frame.size.height) {
            vc.view.frame = CGRectMake(0, 0, vc.view.frame.size.height, vc.view.frame.size.width);
        }
    } else {
        if (vc.view.frame.size.width < vc.view.frame.size.height) {
            vc.view.frame = CGRectMake(0, 0, vc.view.frame.size.height, vc.view.frame.size.width);
        }
    }

    [vc.view setNeedsLayout];
    [vc.view layoutIfNeeded];

    UIGraphicsBeginImageContextWithOptions(vc.view.frame.size, NO, [UIScreen mainScreen].scale);
    [vc.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)snapshotStoryboardForPortrait:(NSString *)sbName {
    return [self snapshotStoryboard:sbName isPortrait:YES];
}

+ (UIImage *)snapshotStoryboardForLandscape:(NSString *)sbName {
    return [self snapshotStoryboard:sbName isPortrait:NO];
}

+ (void)changeAllLaunchImageToPortrait:(UIImage *)image {
    if (!image) {
        return;
    }
    // 全部替换为竖屏启动图
    image = [self resizeImage:image toPortraitScreenSize:YES];
    [BBADynamicLaunchImage replaceLaunchImage:image];
}

+ (void)changeAllLaunchImageToLandscape:(UIImage *)image {
    if (!image) {
        return;
    }
    // 全部替换为横屏启动图
    image = [self resizeImage:image toPortraitScreenSize:NO];
    [BBADynamicLaunchImage replaceLaunchImage:image];
}

+ (void)changePortraitLaunchImage:(UIImage *)portraitImage
             landscapeLaunchImage:(UIImage *)landscapeImage {
    if (!portraitImage || !landscapeImage) {
        return;
    }

    // 替换竖屏启动图
    portraitImage = [self resizeImage:portraitImage toPortraitScreenSize:YES];
    [BBADynamicLaunchImage replaceLaunchImage:portraitImage compressionQuality:0.8 customValidation:^BOOL(UIImage *systemImage, UIImage *yourImage) {
        return [self checkImage:systemImage sizeEqualToImage:yourImage];
    }];

    // 替换横屏启动图
    landscapeImage = [self resizeImage:landscapeImage toPortraitScreenSize:NO];
    [BBADynamicLaunchImage replaceLaunchImage:landscapeImage compressionQuality:0.8 customValidation:^BOOL(UIImage *systemImage, UIImage *yourImage) {
        return [self checkImage:systemImage sizeEqualToImage:yourImage];
    }];
}

// 通过图片尺寸匹配，竖屏方向图只替换竖屏，横屏方向图只替换横屏
+ (BOOL)checkImage:(UIImage *)aImage sizeEqualToImage:(UIImage *)bImage {
    return CGSizeEqualToSize([self obtainImageSize:aImage], [self obtainImageSize:bImage]);
}

+ (CGSize)obtainImageSize:(UIImage *)image {
    return CGSizeMake(CGImageGetWidth(image.CGImage), CGImageGetHeight(image.CGImage));
}

+ (CGSize)contextSizeForPortrait:(BOOL)isPortrait {
    CGFloat screenScale = [UIScreen mainScreen].scale;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat width = MIN(screenSize.width, screenSize.height);;
    CGFloat height = MAX(screenSize.width, screenSize.height);
    if (!isPortrait) {
        width = MAX(screenSize.width, screenSize.height);
        height = MIN(screenSize.width, screenSize.height);
    }
    CGSize contextSize = CGSizeMake(width * screenScale, height * screenScale);
    return contextSize;
}

+ (UIImage *)resizeImage:(UIImage *)image toPortraitScreenSize:(BOOL)isPortrait {
    CGSize imageSize = CGSizeApplyAffineTransform(image.size,
                                                  CGAffineTransformMakeScale(image.scale, image.scale));
    CGSize contextSize = [self contextSizeForPortrait:isPortrait];

    if (!CGSizeEqualToSize(imageSize, contextSize)) {
        UIGraphicsBeginImageContext(contextSize);
        CGFloat ratio = MAX((contextSize.width / image.size.width),
                            (contextSize.height / image.size.height));
        CGRect rect = CGRectMake(0, 0, image.size.width * ratio, image.size.height * ratio);
        [image drawInRect:rect];
        UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return resizedImage;
    }

    return image;
}

@end


@implementation UIView (DKScreenShoot)

- (UIImage *)dkScreenShoot{
    UIImage *imageRet = nil;
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    imageRet = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageRet;
}

@end
