//
//  XmlUtil.m
//  wewinprinter2015
//
//  Created by wewin on 15/4/16.
//  Copyright (c) 2015年 wewin. All rights reserved.
//

#import "XmlUtil.h"
@implementation XmlUtil

//解析XML数据
-(void)parseXMLData:(NSData *)xmlData
{
    _printDatas=[[NSMutableArray alloc] init];
    //1.创建解析器
    NSXMLParser *parser=[[NSXMLParser alloc]initWithData:xmlData];
    //2.设置代理
    parser.delegate=self;
    
    //3.开始解析
    [parser parse];  //这个方法会卡住（同步解析，解析完毕后才会返回）
}

#pragma mark-NSXMLParserDelegate
//解析到一个元素的开头时调用
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.currentTag = elementName;
    if ([elementName isEqualToString:@"Print"]) {
        self.xmlPrintData = [[XmlPrintData alloc] init];
        self.xmlPrintData.textArray = [[NSMutableArray alloc] init];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (self.currentString == nil) {
        self.currentString = [[NSMutableString alloc] initWithString:@""];
    }
    
    if ([self.currentTag isEqualToString:@"CodeType"] ||[self.currentTag isEqualToString:@"Code"] ||[self.currentTag isEqualToString:@"Text"]) {
        NSString *tmps = [[[string stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@""];
        [self.currentString appendString:tmps];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"CodeType"]){
        self.xmlPrintData.PrintType = self.currentString;
        [self.currentString setString:@""];
    }else if ([elementName isEqualToString:@"Code"]) {
        self.xmlPrintData.Code = _currentString;
        [self.currentString setString:@""];
    }else if ([elementName isEqualToString:@"Text"]) {
        [self.xmlPrintData.textArray addObject:self.currentString];
        [self.currentString setString:@""];
    }else if([elementName isEqualToString:@"Print"]){
        [_printDatas addObject:_xmlPrintData];
    }
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    NSLog(@"开始解析xml文件");
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"解析xml文件完成");
}

@end
