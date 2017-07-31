//
//  RuntimeObject.h
//  RuntimeDemo
//
//  Created by 郭晓倩 on 2017/7/31.
//  Copyright © 2017年 郭晓倩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RuntimeObject: NSObject

@property (strong,nonatomic) NSString* name;
@property (assign,nonatomic) int age;

-(void)run;

@end
