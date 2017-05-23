//
//  Print.h
//  testLIB
//
//  Created by LiPing on 16/2/19.
//  Copyright © 2016年 com.wewin.print. All rights reserved.
//
#import <UIKit/UIKit.h>
@interface Print:NSObject

@property(nonatomic,weak) UIView *view;

@property(nonatomic,assign) UIImageView *showImgView;
@property(nonatomic,assign) UIView *showParents;

-(int)printContent:(NSString *)xml printName:(NSString *)printName lableW:(CGFloat)lablewidth lableH:(CGFloat)lableheight;
-(int)closePrint;

@end
