//
//  ModelUtil.m
//  testLIB
//
//  Created by LiPing on 15/7/7.
//  Copyright (c) 2015年 com.wewin.print. All rights reserved.
//
#import "ModelUtil.h"
#import "XmlUtil.h"
#import "ZXingObjC.h"
#import "printData.h"

@implementation ModelUtil

#pragma mark 设备标识
+(NSMutableArray *)createBitmap_2002_ModelArray4Ble:(Data *)data
{
    NSMutableArray *totalArray = [[NSMutableArray alloc]initWithCapacity:0];//所有图片列表
    return totalArray;
}

+(NSMutableArray *)createBitmap_2002_ModelArray4Wifi:(Data *)data
{
    NSMutableArray *totalArray = [[NSMutableArray alloc]initWithCapacity:0];//所有图片列表
    return totalArray;
}
//60*40
+(NSMutableArray *)create1103:(XmlPrintData *)data
{
    NSMutableArray *array=[[NSMutableArray alloc] init];
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];
    //UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 200, 84)];
    //[image setImage:[UIImage imageNamed:@"logo.bmp"]];
    //[view addSubview:image];
    if (data.Code) {
        UIImageView *v=[[UIImageView alloc] initWithFrame:CGRectMake(308, 78.f, 164.f, 164.f)];
        
        ZXEncodeHints *hints = [[ZXEncodeHints alloc] init];
        hints.margin = 0;
        hints.encoding = NSUTF8StringEncoding;
        
        NSError *error = nil;
        ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
        ZXBitMatrix* result = [writer encode:data.Code
                                      format:kBarcodeFormatQRCode
                                       width:164.f
                                      height:164.f
                                       hints:hints
                                       error:&error];
        CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
        [v setImage:[UIImage imageWithCGImage:image]];
        [view addSubview:v];
    }
    if (data.textArray&&data.textArray[0]) {
        UILabel *lable=[[UILabel alloc] initWithFrame:CGRectMake(8, 78, 300, 164)];
        CGFloat fount=22;
        [lable setLineBreakMode:NSLineBreakByCharWrapping];
        [lable setNumberOfLines:0];
        [lable setFont:[UIFont systemFontOfSize:fount]];
        [lable setText:data.textArray[0]];
        [lable sizeToFit];
        if (lable.frame.size.width>300) {
            while (lable.frame.size.width>300) {
                fount--;
                [lable setFont:[UIFont systemFontOfSize:fount]];
                [lable sizeToFit];
            }
        }else if(lable.frame.size.height<300-fount){
            while (lable.frame.size.height<84-fount) {
                fount++;
                [lable setFont:[UIFont systemFontOfSize:fount]];
                [lable sizeToFit];
            }
        }
        lable.frame=CGRectMake(8, (320-lable.frame.size.height)/2.0f, 300, lable.frame.size.height);
        [view addSubview:lable];
        if(data.textArray.count>1){
            UILabel *tel=[[UILabel alloc] initWithFrame:CGRectMake(180, 0, 300, 80)];
            [tel setTextAlignment:NSTextAlignmentCenter];
            [tel setNumberOfLines:1];
            if (fount<22) {
                [tel setFont:[UIFont systemFontOfSize:22]];
            }else{
                [tel setFont:[UIFont systemFontOfSize:fount]];
            }
            [view addSubview:tel];
            
        }
    }
    
    UIImage *img=[self transUI2Image:view];
    printData *d = [[printData alloc]init];
    d.type=4;    //1文字 2条形码 3二维码 4图标
    d.newtype = 4;
    d.rotation=1;   //是否旋转 0不旋转 1：90  2：180  3：270
    d.image = img ;
    d.x=0.f;
    d.y=0.f;
    [array addObject:d];
    return array;
}
//38*25
+(NSMutableArray *)create11031:(XmlPrintData *)data
{
    NSMutableArray *array=[[NSMutableArray alloc] init];
    if (data.textArray) {
        
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 304, 200)];
        UILabel *lable=[[UILabel alloc] initWithFrame:CGRectMake(80, 8 , 214, 84)];
        CGFloat fount=22;
        [lable setLineBreakMode:NSLineBreakByCharWrapping];
        [lable setNumberOfLines:0];
        [lable setFont:[UIFont systemFontOfSize:fount]];
        [lable setText:data.textArray[0]];
        [lable sizeToFit];
        if (lable.frame.size.height>84) {
            while (lable.frame.size.height>84) {
                fount--;
                [lable setFont:[UIFont systemFontOfSize:fount]];
                [lable sizeToFit];
            }
        }else if(lable.frame.size.height<84-fount){
            while (lable.frame.size.height<84-fount) {
                fount++;
                [lable setFont:[UIFont systemFontOfSize:fount]];
                [lable sizeToFit];
            }
        }
        [view addSubview:lable];
        
        if (data.Code) {
            UIImageView *v=[[UIImageView alloc] initWithFrame:CGRectMake(102, 0, 100.f, 100.f)];
            
            ZXEncodeHints *hints = [[ZXEncodeHints alloc] init];
            hints.margin = 0;
            hints.encoding = NSUTF8StringEncoding;
            
            NSError *error = nil;
            ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
            ZXBitMatrix* result = [writer encode:data.Code
                                          format:kBarcodeFormatQRCode
                                           width:100.f
                                          height:100.f
                                           hints:hints
                                           error:&error];
            CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
            [v setImage:[UIImage imageWithCGImage:image]];
            [view addSubview:v];
        }
        
        printData *d = [[printData alloc]init];
        d.type=4;    //1文字 2条形码 3二维码 4图标
        d.newtype = 4;
        d.rotation=1;   //是否旋转 0不旋转 1：90  2：180  3：270
        d.image = [self transUI2Image:view] ;
        
        d.x=0.f;
        d.y=0.f;
        [array addObject:d];
    }
    return array;
}

#pragma mark 文字自适应
+(CGFloat)getFontSizeFitArea:(NSString *)textstr withMode:(NSLineBreakMode)mode andMaxw:(int)titlew maxh:(int)titleh
{
    CGFloat currentFontSize=24;
    CGSize requiredSize = [textstr sizeWithFont:[UIFont systemFontOfSize:currentFontSize] constrainedToSize:CGSizeMake(titlew,MAXFLOAT) lineBreakMode:mode];
    if (requiredSize.height>titleh) {
        while (requiredSize.height>titleh||requiredSize.width>titlew) {
            currentFontSize--;
            requiredSize=[textstr sizeWithFont:[UIFont systemFontOfSize:currentFontSize] constrainedToSize:CGSizeMake(titlew,MAXFLOAT) lineBreakMode:mode];
        }
    }else if(requiredSize.height<titleh){
        while (requiredSize.height<=titleh&&requiredSize.width<titlew) {
            currentFontSize++;
            requiredSize=[textstr sizeWithFont:[UIFont systemFontOfSize:currentFontSize] constrainedToSize:CGSizeMake(titlew,MAXFLOAT) lineBreakMode:mode];
        }
    }
    return currentFontSize;
}
#pragma mark 文字转图片自适应
+(UIImage *)getPrintTextImage:(NSString *)text Width:(CGFloat)Width Height:(CGFloat)Height textHeight:(CGFloat)textHeight
{
    NSLineBreakMode mode = NSLineBreakByCharWrapping;
    UIFont *fn = [UIFont systemFontOfSize:textHeight];
    UILabel *textlable = [[UILabel alloc]initWithFrame: CGRectMake(0, 0, Width, Height)];
    [textlable setText:text];
    [textlable setBackgroundColor:[UIColor clearColor]];
    [textlable setFont:fn];
    [textlable setTextColor:[UIColor blackColor]];
    textlable.textAlignment = NSTextAlignmentLeft;
    [textlable setLineBreakMode:mode];
    [textlable setNumberOfLines:0];
    UIGraphicsBeginImageContextWithOptions(textlable.frame.size, NO, 0.0);
    [textlable.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *r=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return r;
}
#pragma mark 讲UI控件转化成图片
+(UIImage *)transUI2Image:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *r=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return r;
}
#pragma mark 旋转图片
+(UIImage *)rotateImage:(UIImage *)aImage orient:(UIImageOrientation)orient
{
    CGImageRef imgRef = aImage.CGImage;
    CGFloat width = aImage.size.width;//CGImageGetWidth(imgRef);
    CGFloat height = aImage.size.height;//CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;
    switch(orient)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}

@end
