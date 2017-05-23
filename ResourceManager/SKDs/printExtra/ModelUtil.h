//
//  ModelUtil.h
//  testLIB
//
//  Created by LiPing on 15/7/7.
//  Copyright (c) 2015年 com.wewin.print. All rights reserved.
//
#import "Data.h"
#import "XmlPrintData.h"
#import <UIKit/UIKit.h>
#import "printData.h"

@interface ModelUtil : NSObject

+(NSMutableArray *)createBitmap_2002_ModelArray4Ble:(Data *)data;
+(NSMutableArray *)createBitmap_2002_ModelArray4Wifi:(Data *)data;

//
+(NSMutableArray *)create1103:(XmlPrintData *)data;
+(NSMutableArray *)create11031:(XmlPrintData *)data;

@end


