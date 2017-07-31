//
//  RuntimeObject+AddProperty.m
//  RuntimeDemo
//
//  Created by 郭晓倩 on 2017/7/31.
//  Copyright © 2017年 郭晓倩. All rights reserved.
//

#import "RuntimeObject+AddProperty.h"
#import <objc/runtime.h>

@implementation RuntimeObject (AddProperty)

static char key;

-(void)setAddress:(NSString *)address{
    //key只要是唯一的标示就行，比如一个固定的地址
    //    objc_setAssociatedObject(self, @selector(address), address, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &key, address, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString*)address{
    return objc_getAssociatedObject(self, &key);
}

@end
