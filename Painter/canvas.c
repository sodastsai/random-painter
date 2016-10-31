//
//  canvas.c
//  Painter
//
//  Created by sodas on 10/31/16.
//  Copyright © 2016 sodastsai. All rights reserved.
//

#include "canvas.h"
#include <stdlib.h>

CVCanvasPoint const kCVCanvasPointOrigin = {.x = 0, .y = 0};

#pragma mark - Rect

CVCanvasRect CVCanvasRectMake(double x, double y, double width, double height) {
    return (CVCanvasRect){.origin = (CVCanvasPoint){.x = x, .y = y},
                          .size = (CVCanvasSize){.width = width, .height = height}};
}

CVCanvasPoint CVCanvasRectGetCenter(CVCanvasRect rect) {
    return (CVCanvasPoint){.x = rect.origin.x + rect.size.width/2,
                           .y = rect.origin.y + rect.size.height/2};
}

void CVCanvasRectSetCenter(CVCanvasRect rect, CVCanvasPoint center) {
    rect.origin = (CVCanvasPoint){.x = center.x - rect.size.width/2, .y = center.y - rect.size.height/2};
}

#pragma mark - Color

CVCanvasColor const kCVCanvasColorWhite  = {.r=1.0, .g=1.0, .b=1.0, .a=1.0};
CVCanvasColor const kCVCanvasColorBlack  = {.r=0.0, .g=0.0, .b=0.0, .a=1.0};
CVCanvasColor const kCVCanvasColorRed    = {.r=1.0, .g=0.0, .b=0.0, .a=1.0};
CVCanvasColor const kCVCanvasColorOrange = {.r=1.0, .g=0.5, .b=0.0, .a=1.0};
CVCanvasColor const kCVCanvasColorYellow = {.r=1.0, .g=1.0, .b=0.0, .a=1.0};
CVCanvasColor const kCVCanvasColorGreen  = {.r=0.0, .g=1.0, .b=0.0, .a=1.0};
CVCanvasColor const kCVCanvasColorCyan   = {.r=0.0, .g=1.0, .b=1.0, .a=1.0};
CVCanvasColor const kCVCanvasColorBlue   = {.r=0.0, .g=0.0, .b=1.0, .a=1.0};
CVCanvasColor const kCVCanvasColorPurple = {.r=1.0, .g=0.0, .b=1.0, .a=1.0};

CVCanvasColor CVCanvasColorFromRGBAValues(const double values[]) {
    return (CVCanvasColor){.r = values[0], .g = values[1], .b = values[2], .a = values[3]};
}

#pragma mark - Drawable

CVCanvasDrawable CVCanvasDrawableFromRect(CVCanvasRect rect) {
    return (CVCanvasDrawable){.rect = rect,
                              .fillColor = kCVCanvasColorWhite,
                              .strokeColor = kCVCanvasColorBlack,
                              .strokeWidth = 1.0 };
}

CVCanvasDrawable CVCanvasDrawableRevertColor(CVCanvasDrawable drawable) {
    return (CVCanvasDrawable){.rect = drawable.rect,
                              .fillColor = drawable.strokeColor,
                              .strokeColor = drawable.fillColor,
                              .strokeWidth = drawable.strokeWidth };
}

static inline double CVColorRandomChannelValue() {
    uint32_t randomValue = arc4random_uniform(255);
    return randomValue/255.0;
}

static inline CVCanvasColor CVColorRandomColor() {
    return (CVCanvasColor){.r = CVColorRandomChannelValue(),
                           .g = CVColorRandomChannelValue(),
                           .b = CVColorRandomChannelValue(),
                           .a = CVColorRandomChannelValue()/2+0.5};
}

CVCanvasDrawable CVCanvasDrawableCreateRandomly(double xBound, double yBound, double widthBound, double heightBound) {
    CVCanvasColor fillColor = CVColorRandomColor();
    CVCanvasColor strokeColor = CVColorRandomColor();
    double strokeWidth = arc4random_uniform(20) + 1;
    CVCanvasPoint origin = {.x = arc4random_uniform(xBound), .y = arc4random_uniform(yBound)};
    CVCanvasSize size = {.width = arc4random_uniform(widthBound), .height = arc4random_uniform(heightBound)};
    return (CVCanvasDrawable){.rect = (CVCanvasRect){.origin = origin, .size = size},
                              .fillColor = strokeColor,
                              .strokeColor = fillColor,
                              .strokeWidth = strokeWidth};
}
