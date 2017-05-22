//
//  Print.m
//  testLIB
//
//  Created by LiPing on 16/2/19.
//  Copyright © 2016年 com.wewin.print. All rights reserved.
//

#import "Print.h"
#import "ModelUtil.h"
#import "DLAVAlertView.h"
#import "XmlUtil.h"
#import "XmlPrintData.h"
#import "printData.h"

@interface Print()<PrintUtilDelegate,PrintHelperDelegate>{
    PrintUtil *printUtil;//蓝牙打印
    
    PrintHelper *printHelper;//wifi打印
    
    NSMutableArray *LabelArray; //标签列表
    
    NSString *_printName;
    
    int printRes;//0空闲  202 成功  301失败 -1正在打印
    
    int xlabelIndex;
    UIAlertView *aseAlert;
}
@end

@implementation Print

//打印入口
-(int)printContent:(NSString *)xml printName:(NSString *)printName lableW:(CGFloat)lablewidth lableH:(CGFloat)lableheight{
    XmlUtil *xmlUtil = [[XmlUtil alloc]init];
    [xmlUtil parseXMLData:[xml dataUsingEncoding:NSUTF8StringEncoding]];
    _printName=printName;
    if (xmlUtil.printDatas.count<=0) {
        return -1;
    }
    LabelArray=[[NSMutableArray alloc] init];
    for (XmlPrintData *xmldata in xmlUtil.printDatas) {
        if ([@"60-40" isEqualToString:xmldata.PrintType]) {
            [LabelArray addObject:[ModelUtil create1103:xmldata]];
        }else if([@"02F" isEqualToString:xmldata.PrintType]){
            [LabelArray addObject:[ModelUtil create11031:xmldata]];
        }
    }
    
    if (LabelArray&&LabelArray.count>0) {
        printData *p=[[LabelArray objectAtIndex:0] objectAtIndex:0];
        if (p) {
            [_showParents setHidden:NO];
            NSLog(@"显示预览");
            [_showImgView setImage:p.image];
        }
        if (LabelArray.count>1) {
            printData *p2=[[LabelArray objectAtIndex:1] objectAtIndex:0];
            if (p2) {
                [_showParents setHidden:NO];
                NSLog(@"显示预览2");
                [_showImgView setImage:p2.image];
            }
        }
        if(nil==printUtil)
        {
            printUtil = [PrintUtil new];
            printUtil.delegate =self;
        }
        printUtil.view = _view;//弹出框需要的上下文
        printUtil.labelArray = LabelArray;//模板数组
        printUtil.copyNum = 1;//打印份数
        printUtil.isddf = NO;//ddf标记
        printUtil.labelWidth = lablewidth;//标签宽度
        printUtil.labelHeight = lableheight;//标签高度
        printUtil.printHeight = 0;//ddf为1时有效,ddf打印长度 8*n毫米
        printUtil.rfid_text = @"1234567890";
        printUtil.cutoption = 3;//p70机型的自动切纸选项
        [printUtil printLabel:_printName];
    }
    
    return 0;
}

-(int)closePrint{
    //蓝牙关闭
    return [printUtil closePrinter];
}

#pragma mark 蓝牙打印结果回调
-(void)printSuccess:(int)info{
    NSLog(@"%d sucess",info);
}

-(void)printFail:(int)info{
    NSLog(@"%d fail",info);
}

-(void)printStart:(int)info{
    NSLog(@"%d start",info);
}

#pragma mark WiFi打印结果回调
-(void)wifi_printSuccess:(int)info{
    xlabelIndex++;
    if(LabelArray.count>xlabelIndex){
        [printHelper LabelPrint:[LabelArray objectAtIndex:xlabelIndex] andPrintCount:1 andModelName:@"" andIsDdf:NO andLabelWidth:330.f andLabelHeight:720.f];
    }else{
        [printHelper closeConn];
        dispatch_async(dispatch_get_main_queue(), ^{
            //UI
            [aseAlert dismissWithClickedButtonIndex:1 animated:YES];
        });
    }
    NSLog(@"%d wifi sucess",info);
}

// @return 1 WiFi网络连接无效 2请连接打印机后再试
-(void)wifi_printFail:(int)info{
    dispatch_async(dispatch_get_main_queue(), ^{
        //UI
        [aseAlert dismissWithClickedButtonIndex:1 animated:YES];
        aseAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"打印出错，请检查连接" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [aseAlert show];
    });
    NSLog(@"%d wifi fail",info);
}
@end
