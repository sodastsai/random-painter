//
//  WindowController.h
//  Painter
//
//  Created by sodas on 10/31/16.
//  Copyright © 2016 sodastsai. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

extern NSNotificationName const WindowControllerRectanglesCountDidChange;

@interface WindowController : NSWindowController

@property (nonatomic, readonly) NSInteger rectanglesMinCount;
@property (nonatomic, readonly) NSInteger rectanglesMaxCount;
@property (nonatomic) NSInteger rectanglesCount;

@end

NS_ASSUME_NONNULL_END
