//
//  canvas.h
//  Painter
//
//  Created by sodas on 10/31/16.
//  Copyright © 2016 sodastsai. All rights reserved.
//

#ifndef canvas_h
#define canvas_h

#define PT_EXTERN extern
#define PT_SWIFT_NAME(_name) __attribute__((swift_name(#_name)))
#define PT_REFINED_FOR_SWIFT __attribute__((swift_private))

#pragma mark - Point

typedef struct {
    double x, y;
} CVCanvasPoint PT_SWIFT_NAME(CanvasPoint);
PT_EXTERN CVCanvasPoint const kCVCanvasPointOrigin PT_SWIFT_NAME(CanvasPoint.origin);

#pragma mark - Size

typedef struct {
    double width, height;
} CVCanvasSize PT_SWIFT_NAME(CanvasSize);

#pragma mark - Rect

typedef struct {
    CVCanvasPoint origin;
    CVCanvasSize size;
} CVCanvasRect PT_SWIFT_NAME(CanvasRect);

PT_EXTERN
CVCanvasRect CVCanvasRectMake(double x, double y, double width, double height)
PT_SWIFT_NAME(CanvasRect.init(x:y:width:height:));

PT_EXTERN
CVCanvasPoint CVCanvasRectGetCenter(CVCanvasRect rect)
PT_SWIFT_NAME(getter:CVCanvasRect.center(self:));

PT_EXTERN
void CVCanvasRectSetCenter(CVCanvasRect rect, CVCanvasPoint center)
PT_SWIFT_NAME(setter:CVCanvasRect.center(self:newValue:));

#pragma mark - Color

typedef struct {
    double r, g, b, a;
} CVCanvasColor PT_SWIFT_NAME(CanvasColor);
PT_EXTERN CVCanvasColor const kCVCanvasColorWhite PT_SWIFT_NAME(CanvasColor.white);
PT_EXTERN CVCanvasColor const kCVCanvasColorBlack PT_SWIFT_NAME(CanvasColor.black);
PT_EXTERN CVCanvasColor const kCVCanvasColorRed PT_SWIFT_NAME(CanvasColor.red);
PT_EXTERN CVCanvasColor const kCVCanvasColorOrange PT_SWIFT_NAME(CanvasColor.orange);
PT_EXTERN CVCanvasColor const kCVCanvasColorYellow PT_SWIFT_NAME(CanvasColor.yellow);
PT_EXTERN CVCanvasColor const kCVCanvasColorGreen PT_SWIFT_NAME(CanvasColor.green);
PT_EXTERN CVCanvasColor const kCVCanvasColorCyan PT_SWIFT_NAME(CanvasColor.cyan);
PT_EXTERN CVCanvasColor const kCVCanvasColorBlue PT_SWIFT_NAME(CanvasColor.blue);
PT_EXTERN CVCanvasColor const kCVCanvasColorPurple PT_SWIFT_NAME(CanvasColor.purple);

PT_EXTERN CVCanvasColor CVCanvasColorFromRGBAValues(const double values[]) PT_REFINED_FOR_SWIFT;

#pragma mark - Drawable

typedef struct {
    CVCanvasRect rect;
    CVCanvasColor fillColor;
    CVCanvasColor strokeColor;
    double strokeWidth;
} CVCanvasDrawable PT_SWIFT_NAME(CanvasDrawable);

PT_EXTERN
CVCanvasDrawable CVCanvasDrawableFromRect(CVCanvasRect rect)
PT_SWIFT_NAME(CanvasDrawable.init(rect:));

PT_EXTERN
CVCanvasDrawable CVCanvasDrawableCreateRandomly(double xBound, double yBound, double widthBound, double heightBound)
PT_SWIFT_NAME(CanvasDrawable.init(randomlyWithXBound:yBound:widthBound:heightBound:));

PT_EXTERN
CVCanvasDrawable CVCanvasDrawableRevertColor(CVCanvasDrawable drawable)
PT_SWIFT_NAME(CanvasDrawable.revertedColor(self:));

#endif /* canvas_h */
