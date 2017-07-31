//
//  MessageDeliver.m
//  RuntimeDemo
//
//  Created by 郭晓倩 on 2017/7/31.
//  Copyright © 2017年 郭晓倩. All rights reserved.
//

#import "MessageDeliver.h"
#import <objc/runtime.h>


@interface MessageDeliverBackup : NSObject
-(void)methodNotImplemented2;
@end

@implementation MessageDeliverBackup

-(void)methodNotImplemented2{
    NSLog(@"methodNotImplemented2 exectue");
}

@end



@implementation MessageDeliver

#pragma mark - 方法决议

void methodImplemention(id self,SEL _cmd){
    NSLog(@"methodImplemention execute for sel:%@",NSStringFromSelector(_cmd));
}

void clasMethodImplemention(id self,SEL _cmd){
    NSLog(@"clasMethodImplemention execute for sel:%@",NSStringFromSelector(_cmd));
}


+(BOOL)resolveInstanceMethod:(SEL)sel{
    NSString* selName = NSStringFromSelector(sel);
    if ([selName isEqualToString:@"methodNotImplemented1:"]) {
        class_addMethod([self class], sel, (IMP)methodImplemention, "v@:"); //参数个数不匹配，也能Work
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

+(BOOL)resolveClassMethod:(SEL)sel{
    if (sel == @selector(classMethodNotImplemented)) {
        //参数class必须是元类型，元类中储存的是类对象的元数据，比如类方法就储存在这里。
        // object_getClass(obj)返回的是obj中的isa指针；而[obj class]则分两种情况：一是当obj为实例对象时，[obj class]中class是实例方法：- (Class)class，返回的obj对象中的isa指针；二是当obj为类对象（包括元类和根类以及根元类）时，调用的是类方法：+ (Class)class，返回的结果为其本身。
        class_addMethod(object_getClass([self class]), sel, (IMP)clasMethodImplemention, "v@:");
        return YES;
    }
    return [super resolveClassMethod:sel];
}

#pragma mark - 消息转发

-(id)forwardingTargetForSelector:(SEL)aSelector{
    NSString* selName = NSStringFromSelector(aSelector);
    if ([selName isEqualToString:@"methodNotImplemented2"]) {
        return [[MessageDeliverBackup alloc] init];
    }
    return [super forwardingTargetForSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    NSString* selName = NSStringFromSelector(aSelector);
    if ([selName isEqualToString:@"methodNotImplemented3"]) {
        NSMethodSignature* sig = [NSMethodSignature signatureWithObjCTypes:"v@:"];
        return sig;
    }
    return [super methodSignatureForSelector:aSelector];
}

-(void)forwardInvocation:(NSInvocation *)anInvocation{
    NSString* selName = NSStringFromSelector(anInvocation.selector);
    if ([selName isEqualToString:@"methodNotImplemented3"]) {
        NSLog(@"methodNotImplemented3 invoke");
    }else{
        [super forwardInvocation:anInvocation];
    }
}

//-(BOOL)respondsToSelector:(SEL)aSelector{
//    //需重写,仅调用respondsToSelector时有用
//    NSString* selName = NSStringFromSelector(aSelector);
//    if([selName isEqualToString:@"methodNotImplemented1"] ||
//       [selName isEqualToString:@"methodNotImplemented2"] ||
//       [selName isEqualToString:@"methodNotImplemented3"] ||
//       [selName isEqualToString:@"classMethodNotImplemented"]
//       ){
//        return YES;
//    }
//    return [super respondsToSelector:aSelector];
//}


@end


//    Objective-C type encodings  (@encode(int))
//
//    c     A char
//    i     An int
//    s     A short
//    l     A long  l is treated as a 32-bit quantity on 64-bit programs.
//    q     A long long
//    C     An unsigned char
//    I     An unsigned int
//    S     An unsigned short
//    L     An unsigned long
//    Q     An unsigned long long
//    f     A float
//    d     A double
//    B     A C++ bool or a C99 _Bool
//    v     A void
//    *     A character string (char *)
//    @     An object (whether statically typed or typed id)
//    #     A class object (Class)
//    :     A method selector (SEL)
//    [array type]      An array
//    {name=type...}    A structure
//    (name=type...)    A union
//    bnum              A bit field of num bits
//    ^type             A pointer to type
//    ?         An unknown type (among other things, this code is used for function pointers)
