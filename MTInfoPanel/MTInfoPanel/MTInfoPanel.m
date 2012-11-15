//
//  MTInfoPanel.m
//  MTInfoPanel
//
//  Created by Tretter Matthias on 14.12.11.
//  Copyright (c) 2011 @myell0w. All rights reserved.
//

#import "MTInfoPanel.h"
#import <QuartzCore/QuartzCore.h>


#define MT_RGBA(r, g, b, a) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]


@interface MTInfoPanel ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *thumbImage;
@property (nonatomic, strong) UIView *backgroundGradient;

@end


@implementation MTInfoPanel

////////////////////////////////////////////////////////////////////////
#pragma mark - Lifecycle
////////////////////////////////////////////////////////////////////////

+ (MTInfoPanel *)showPanelInView:(UIView *)view 
                            type:(MTInfoPanelType)type 
                           title:(NSString *)title
                        subtitle:(NSString *)subtitle {
    return [self showPanelInView:view type:type title:title subtitle:subtitle hideAfter:-1.];
}

+(MTInfoPanel *)showPanelInView:(UIView *)view
                           type:(MTInfoPanelType)type
                          title:(NSString *)title 
                       subtitle:(NSString *)subtitle
                      hideAfter:(NSTimeInterval)interval {    
    return [self showPanelInView:view type:type title:title subtitle:subtitle image:nil hideAfter:interval];
}

+ (MTInfoPanel *)showPanelInView:(UIView *)view 
                            type:(MTInfoPanelType)type
                           title:(NSString *)title 
                        subtitle:(NSString *)subtitle 
                           image:(UIImage *)image {
    return [self showPanelInView:view type:type title:title subtitle:subtitle image:image hideAfter:-1.];
}

+ (MTInfoPanel *)showPanelInView:(UIView*)view 
                            type:(MTInfoPanelType)type 
                           title:(NSString *)title
                        subtitle:(NSString *)subtitle
                           image:(UIImage *)image
                       hideAfter:(NSTimeInterval)interval {
    UIColor *startColor = nil;
    UIColor *endColor = nil;
    UIFont *titleFont = [UIFont boldSystemFontOfSize:14.f];
    UIFont *detailFont = [UIFont systemFontOfSize:14.f];
    UIColor *titleColor = [UIColor whiteColor];
    UIColor *detailColor = nil;
    
    switch (type) {
        case MTInfoPanelTypeInfo: {
            startColor = MT_RGBA(91.f, 134.f, 206.f, 1.f);
            endColor = MT_RGBA(69.f, 106.f, 177.f, 1.f);
            detailColor = MT_RGBA(210.f, 210.f, 235.f, 1.f);
            
            if (image == nil) {
                image = [UIImage imageNamed:@"MTInfoPanel.bundle/Tick"];
            }
            break;
        }
            
        case MTInfoPanelTypeNotice: {
            startColor = MT_RGBA(118, 119, 120, 1.f);
            endColor = MT_RGBA(63, 65, 67, 1.f);
            detailColor = MT_RGBA(210, 210, 235, 1.0);
            
            if (image == nil) {
                image = [UIImage imageNamed:@"MTInfoPanel.bundle/Notice"];
            }
            break;
        }
            
        case MTInfoPanelTypeSuccess: {
            startColor = MT_RGBA(127, 191, 34, 1.0000);
            endColor = MT_RGBA(136, 159, 86, 1.0000);
            detailColor = MT_RGBA(59, 69, 39, 1.0000);
            
            if (image == nil) {
                image = [UIImage imageNamed:@"MTInfoPanel.bundle/Tick"];
            }
            break;
        }
            
            
        case MTInfoPanelTypeWarning: {
            startColor = MT_RGBA(253, 178, 77, 1.0);
            endColor = MT_RGBA(196, 123, 20, 1.0);
            detailColor = MT_RGBA(97, 61, 24, 1.0000);
            
            if (image == nil) {
                image = [UIImage imageNamed:@"MTInfoPanel.bundle/Warning"];
            }
            break;
        }
            
        case MTInfoPanelTypeError:
        default: {
            startColor = MT_RGBA(200, 36, 0, 1.0);
            endColor = MT_RGBA(150, 24, 0, 1.0);
            detailColor = MT_RGBA(255, 166, 166, 1.0);
            
            if (image == nil) {
                image = [UIImage imageNamed:@"MTInfoPanel.bundle/Warning"];
            }            
            break;
        }
    }
    
    return [self showPanelInView:view
                           title:title
                        subtitle:subtitle
                           image:image
                      startColor:startColor
                        endColor:endColor
                      titleColor:titleColor
                 detailTextColor:detailColor
                       titleFont:titleFont
                  detailTextFont:detailFont
                       hideAfter:interval];
}

+ (MTInfoPanel *)showPanelInView:(UIView *)view 
                           title:(NSString *)title
                        subtitle:(NSString *)subtitle 
                           image:(UIImage *)image
                      startColor:(UIColor *)startColor
                        endColor:(UIColor *)endColor
                      titleColor:(UIColor *)titleColor
                 detailTextColor:(UIColor *)detailColor
                       titleFont:(UIFont *)titleFont
                  detailTextFont:(UIFont *)detailFont
                       hideAfter:(NSTimeInterval)interval
{
    MTInfoPanel *panel = [MTInfoPanel infoPanel];
    // panel height when no subtitle set
    CGFloat panelHeight = 50.f;
    
    // update appearance of panel
    panel.titleLabel.textColor = titleColor;
    panel.titleLabel.font = titleFont;
    panel.detailLabel.textColor = detailColor;
    panel.detailLabel.font = detailFont;
    
    // set values of views
    panel.titleLabel.text = title;
    subtitle = [subtitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (subtitle.length > 0) {
        panel.detailLabel.text = subtitle;
        [panel.detailLabel sizeToFit];
        
        panelHeight = MAX(CGRectGetMaxY(panel.thumbImage.frame), CGRectGetMaxY(panel.detailLabel.frame));
        // padding at bottom
        panelHeight += 7.f;
    } else {
        panel.detailLabel.hidden = YES;
        panel.thumbImage.frame = CGRectMake(15, 5, 35, 35);
        panel.titleLabel.frame = CGRectMake(57, 12, 240, 21);
    }
    
    if (image != nil) {
        panel.thumbImage.image = image;
    }
    
    // update frame of panel
    panel.frame = CGRectMake(0, 0, view.bounds.size.width, panelHeight);
    [panel setBackgroundGradientFrom:startColor to:endColor];
    [view addSubview:panel];
    
    if (interval > 0) {
        [panel performSelector:@selector(hidePanel) withObject:view afterDelay:interval]; 
    }
    
    return panel;
}

+ (MTInfoPanel *)showPanelInWindow:(UIWindow *)window type:(MTInfoPanelType)type title:(NSString *)title subtitle:(NSString *)subtitle {
    return [self showPanelInWindow:window type:type title:title subtitle:subtitle hideAfter:-1];
}

+(MTInfoPanel *)showPanelInWindow:(UIWindow *)window type:(MTInfoPanelType)type title:(NSString *)title subtitle:(NSString *)subtitle hideAfter:(NSTimeInterval)interval {
    return [self showPanelInWindow:window type:type title:title subtitle:subtitle image:nil hideAfter:interval];
}

+ (MTInfoPanel *)showPanelInWindow:(UIWindow*)window type:(MTInfoPanelType)type title:(NSString *)title subtitle:(NSString *)subtitle image:(UIImage *)image {
    return [self showPanelInWindow:window type:type title:title subtitle:subtitle image:image hideAfter:-1.];
}
+ (MTInfoPanel *)showPanelInWindow:(UIWindow*)window type:(MTInfoPanelType)type title:(NSString *)title subtitle:(NSString *)subtitle image:(UIImage *)image hideAfter:(NSTimeInterval)interval {
    MTInfoPanel *panel = [self showPanelInView:window type:type title:title subtitle:subtitle image:image hideAfter:interval];
    
    if (![UIApplication sharedApplication].statusBarHidden) {
        CGRect frame = panel.frame;
        frame.origin.y += [UIApplication sharedApplication].statusBarFrame.size.height;
        panel.frame = frame;
    }
    
    return panel;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self setup];
    }
    
    return self;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - UIView
////////////////////////////////////////////////////////////////////////

- (void)layoutSubviews {
    [super layoutSubviews];

    // update width of sublayers
    for (CALayer *layer in self.backgroundGradient.layer.sublayers) {
        if ([layer isKindOfClass:[CAGradientLayer class]]) {
            CGRect layerFrame = layer.frame;

            layerFrame.size.width = CGRectGetWidth(self.bounds);
            layer.frame = layerFrame;
        }
    }
}

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Setter/Getter
////////////////////////////////////////////////////////////////////////

-(void)setBackgroundGradientFrom:(UIColor *)fromColor to:(UIColor *)toColor {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    CGFloat lineHeight = 1.f;
    UIColor *lightColor = [self changeColor:fromColor withFactor:1.2];
    UIColor *darkColor = [self changeColor:toColor withFactor:0.25];
    
    gradient.frame = self.backgroundGradient.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[fromColor CGColor], (id)[toColor CGColor], nil];
    
    CAGradientLayer *darkTopLine = [CAGradientLayer layer];
    darkTopLine.frame = CGRectMake(0, 0, self.backgroundGradient.bounds.size.width, lineHeight);
    darkTopLine.colors = [NSArray arrayWithObjects:(id)[darkColor CGColor], (id)[darkColor CGColor], nil];
    
    CAGradientLayer *lightTopLine = [CAGradientLayer layer];
    lightTopLine.frame = CGRectMake(0, 1, self.backgroundGradient.bounds.size.width, lineHeight);
    lightTopLine.colors = [NSArray arrayWithObjects:(id)[lightColor CGColor], (id)[lightColor CGColor], nil];
    
    CAGradientLayer *darkEndLine = [CAGradientLayer layer];
    darkEndLine.frame = CGRectMake(0, self.backgroundGradient.bounds.size.height - lineHeight, self.backgroundGradient.bounds.size.width, lineHeight);
    darkEndLine.colors = [NSArray arrayWithObjects:(id)[darkColor CGColor], (id)[darkColor CGColor], nil];
    
    [self.backgroundGradient.layer insertSublayer:gradient atIndex:0];
    [self.backgroundGradient.layer insertSublayer:darkTopLine atIndex:1];
    [self.backgroundGradient.layer insertSublayer:lightTopLine atIndex:2];
    [self.backgroundGradient.layer insertSublayer:darkEndLine atIndex:3];
}

- (UIColor *)changeColor:(UIColor *)sourceColor withFactor:(CGFloat)factor {
    // oldComponents is the array INSIDE the original color
    // changing these changes the original, so we copy it
    CGFloat *oldComponents = (CGFloat *)CGColorGetComponents([sourceColor CGColor]);
    CGFloat newComponents[4];
    int numComponents = CGColorGetNumberOfComponents([sourceColor CGColor]);
    
    switch (numComponents) {
        case 2: {
            //grayscale
            newComponents[0] = oldComponents[0]*factor;
            newComponents[1] = oldComponents[0]*factor;
            newComponents[2] = oldComponents[0]*factor;
            newComponents[3] = oldComponents[1];
            break;
        }
            
        case 4: {
            //RGBA
            newComponents[0] = oldComponents[0]*factor;
            newComponents[1] = oldComponents[1]*factor;
            newComponents[2] = oldComponents[2]*factor;
            newComponents[3] = oldComponents[3];
            break;
        }
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef newColor = CGColorCreate(colorSpace, newComponents);
    CGColorSpaceRelease(colorSpace);
    
    UIColor *retColor = [UIColor colorWithCGColor:newColor];
    CGColorRelease(newColor);
    
    return retColor;
}

-(void)hidePanel {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    CATransition *transition = [CATransition animation];
	transition.duration = 0.25;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionPush;	
	transition.subtype = kCATransitionFromTop;
	[self.layer addAnimation:transition forKey:nil];
    self.frame = CGRectMake(0.f, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
    
    [self performSelector:@selector(finish) withObject:nil afterDelay:transition.duration];
}

- (void)finish {
    [self removeFromSuperview];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [_delegate performSelector:_onFinished];
#pragma clang diagnostic pop
}

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Touch Recognition
////////////////////////////////////////////////////////////////////////

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:_onTouched];
#pragma clang diagnostic pop
}

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private
////////////////////////////////////////////////////////////////////////

+ (MTInfoPanel *)infoPanel {
    MTInfoPanel *panel =  [[MTInfoPanel alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 50.f)];
    
    CATransition *transition = [CATransition animation];
	transition.duration = 0.25;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionPush;	
	transition.subtype = kCATransitionFromBottom;
	[panel.layer addAnimation:transition forKey:nil];
    
    return panel;
}

- (void)setup {
    self.opaque = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.layer.shadowOffset = CGSizeMake(0.f, 2.f);
    self.layer.shadowRadius = 2.5f;
    self.layer.shadowOpacity = 0.7;
    
    _backgroundGradient = [[UIView alloc] initWithFrame:self.bounds];
    _backgroundGradient.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _backgroundGradient.alpha = 0.88f;
    [self addSubview:_backgroundGradient];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(57.f,7.f,240.f,19.f)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    _titleLabel.layer.shadowOffset = CGSizeMake(0.f, -0.5f);
    _titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
	_titleLabel.layer.shadowRadius = 0.5f;
	_titleLabel.layer.shadowOpacity = 0.95;
    [self addSubview:_titleLabel];
    
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(57.f, 26.f, 251.f, 32.f)];
    _detailLabel.backgroundColor = [UIColor clearColor];
    _detailLabel.numberOfLines = 0;
    _detailLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:_detailLabel];
    
    _thumbImage = [[UIImageView alloc] initWithFrame:CGRectMake(9.f, 9.f, 37.f, 34.f)];
    [self addSubview:_thumbImage];
    
    _onTouched = @selector(hidePanel);
}


@end
