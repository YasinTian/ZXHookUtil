//
//  NSObject+ZXGetProperty.m
//  ZXDataHandleDemo
//
//  Created by 李兆祥 on 2019/1/27.
//  Copyright © 2019 李兆祥. All rights reserved.
//  GitHub:https://github.com/SmileZXLee/ZXDataHandle

#import "NSObject+ZXGetProperty.h"
#import <objc/runtime.h>
#import "ZXDataHandle.h"
#import "ZXDataConvert.h"
#import "NSObject+ZXToModel.h"

@implementation NSObject (ZXGetProperty)
+(NSMutableArray *)getAllPropertyNames{
    if([[ZXDataConvert shareInstance].allPropertyDic.allKeys containsObject:NSStringFromClass([self class])]){
        return [[ZXDataConvert shareInstance].allPropertyDic zx_dicSafetyReadForKey:NSStringFromClass([self class])];
    }
    NSMutableArray *propertyNamesArr = [NSMutableArray array];
    [self getEnumPropertyNamesCallBack:^(NSString *proName,NSString *proType) {
        if(proName.length){
            [propertyNamesArr addObject:proName];
        }
    }];
    [[ZXDataConvert shareInstance].allPropertyDic zx_dicSaftySetValue:propertyNamesArr forKey:NSStringFromClass([self class])];
    return propertyNamesArr;
}
+(void)getEnumPropertyNamesCallBack:(kEnumEventHandler)_result{
    u_int count;
    objc_property_t *properties  = class_copyPropertyList([self class],&count);
    for(NSUInteger i = 0;i < count;i++){
        const char *propertyNameChar = property_getName(properties[i]);
        const char *propertyTypeChar = property_getAttributes(properties[i]);
        NSString *propertyNameStr = [NSString stringWithUTF8String: propertyNameChar];
        NSString *propertyTypeStr = [NSString stringWithUTF8String: propertyTypeChar];
        _result(propertyNameStr,propertyTypeStr);
    }
    free(properties);
}

@end
