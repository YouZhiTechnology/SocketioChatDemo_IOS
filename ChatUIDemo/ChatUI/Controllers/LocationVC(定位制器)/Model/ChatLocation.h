//
//  ChatLocation.h
//  ChatUIDemo
//
//  Created by GXL on 16/8/8.
//  Copyright © 2016年 GXL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
/**
 *  位置模型
 */

@interface ChatLocation : NSObject<MKAnnotation>

/**
 *  实现MKAnnotation协议必须要定义这个属性
 */
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  子标题
 */
@property (nonatomic, copy) NSString *subtitle;


@end
