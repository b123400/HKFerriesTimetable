//
//  PieSliceLayer.m
//  PieChart
//
//  Created by Pavan Podila on 2/20/12.
//  Copyright (c) 2012 Pixel-in-Gene. All rights reserved.
//

#import "BRClockLayer.h"

@implementation BRClockLayer

@dynamic startAngle, endAngle;
@synthesize fillColor;

-(CABasicAnimation *)makeAnimationForKey:(NSString *)key {
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:key];
    anim.fromValue = [[self presentationLayer] valueForKey:key];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    anim.duration = 0.5;
    
    return anim;
}

- (id)init {
    self = [super init];
    if (self) {
        self.fillColor = [UIColor redColor];
        
        [self setNeedsDisplay];
    }
    
    return self;
}

-(id<CAAction>)actionForKey:(NSString *)event {
    if ([event isEqualToString:@"startAngle"] ||
        [event isEqualToString:@"endAngle"]) {
        return [self makeAnimationForKey:event];
    }
    
    return [super actionForKey:event];
}

- (id)initWithLayer:(id)layer {
    if (self = [super initWithLayer:layer]) {
        if ([layer isKindOfClass:[BRClockLayer class]]) {
            BRClockLayer *other = (BRClockLayer *)layer;
            self.startAngle = other.startAngle;
            self.endAngle = other.endAngle;
            self.fillColor = other.fillColor;
        }
    }
    
    return self;
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"startAngle"] || [key isEqualToString:@"endAngle"]) {
        return YES;
    }
    
    return [super needsDisplayForKey:key];
}


-(void)drawInContext:(CGContextRef)ctx {
    
    UIGraphicsPushContext(ctx);
    
    float outerRadius = MIN(self.bounds.size.width, self.bounds.size.height)/2.0;
    float innerRadius = outerRadius-10.0;
    
    //draw arc
    CGPoint center = CGPointMake(self.bounds.size.width/2,self.bounds.size.height/2);
    UIBezierPath *arc = [UIBezierPath bezierPath];
    
    CGPoint innerFrom = CGPointMake(
                                center.x + innerRadius * cos(self.startAngle),
                                center.y + innerRadius * sin(self.startAngle)
                                    );
    CGPoint outerFrom = CGPointMake(
                                center.x + outerRadius * cos(self.startAngle),
                                center.y + outerRadius * sin(self.startAngle)
                                    );
    [arc moveToPoint:innerFrom];
    [arc addLineToPoint:outerFrom];
    
    [arc addArcWithCenter:center radius:outerRadius startAngle:self.startAngle endAngle:self.endAngle clockwise:YES];
    
    CGPoint innerTo = CGPointMake(
                              center.x + innerRadius * cos(self.endAngle),
                              center.y + innerRadius * sin(self.endAngle)
                                  );
    
    [arc addLineToPoint:innerTo];
    [arc addArcWithCenter:center radius:innerRadius startAngle:self.endAngle endAngle:self.startAngle clockwise:NO];
    
    [self.fillColor setFill];
    [arc fill];
    
    UIGraphicsPopContext();
}
@end