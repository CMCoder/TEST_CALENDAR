//
//  LECCalendarDayView.m
//  LECCalendar

#import "LECCalendarDayView.h"

#import "LECCircleView.h"
#import "LECLineView.h"

@interface LECCalendarDayView (){
    UILabel *textLabel;
    BOOL isSelected;
    int cacheIsToday;
    NSString *cacheCurrentDateText;
    
    LECLineView *lineView;
    UIView *dotRGBView;
}
@end

static NSString *const kLECCalendarDaySelected = @"kLECCalendarDaySelected";

@implementation LECCalendarDayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}

- (void)commonInit
{
    isSelected = NO;
    self.isOtherMonth = NO;
    
    
    {
        textLabel = [UILabel new];
        [self addSubview:textLabel];
    }
    
    {
        dotRGBView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 4)];
        dotRGBView.backgroundColor = [UIColor clearColor];
        for (int num = 0; num <= 2; ++num) {
            LECCircleView *dot = [LECCircleView new];
            [dot setFrame:CGRectMake(num*8, 0, 4.5, 4.5)];
            [dot setColor:(num != 0)?((num==1)?[UIColor greenColor]:[UIColor blueColor]):[UIColor redColor]];
            [dotRGBView addSubview:dot];
        }
        dotRGBView.hidden = YES;
        [self addSubview:dotRGBView];
    }
    
    {
        lineView = [LECLineView new];
        [lineView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [lineView setColor:[UIColor redColor]];
        [self addSubview:lineView];
        
        _lineViews = [[NSMutableArray alloc] init];
        for (int num = 1 ; num <= 4; ++num) {
            LECLineView *line = [LECLineView new];
            [line setColor:[UIColor colorWithRed:77/255 green:60.0*num/255 blue:244/255 alpha:1]];
            //[line setFrame:CGRectMake(0, num-1, self.frame.size.width, self.frame.size.height)];
            line.hidden = YES;
            [_lineViews addObject:line];
            [self addSubview:line];
        }
    }
    
    {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouch)];

        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:gesture];
    }
    
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDaySelected:) name:kLECCalendarDaySelected object:nil];
    }
}

- (void)layoutSubviews
{
    [self configureConstraintsForSubviews];
    
    // No need to call [super layoutSubviews]
}

// Avoid to calcul constraints (very expensive)
- (void)configureConstraintsForSubviews
{
    textLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    textLabel.center = CGPointMake(self.frame.size.width * 0.7, self.frame.size.height * 0.73);
    
    NSLog(@"\ntextLabel frames : %@",NSStringFromCGRect(textLabel.frame));
    
    lineView.frame = CGRectMake(self.frame.size.width * 0.52, self.frame.size.height * 0.95, self.frame.size.width * 0.43, 3);
    
    dotRGBView.frame = CGRectMake(1, self.frame.size.height * 0.5, 20, 4);
    //NSLog(@"Width:%.2f, Height:%.2f",self.frame.size.width, self.frame.size.height);
    
    //NSLog(@"dotRGB frames : %@",NSStringFromCGRect(dotRGBView.frame));
    
    int num = 1;
    for (LECLineView *line in _lineViews) {
        [line setFrame:CGRectMake(0, 4*num-1, self.frame.size.width, 1)];
        num ++;
    }
    
//    CGFloat sizeCircle = MIN(self.frame.size.width, self.frame.size.height);
//    CGFloat sizeDot = sizeCircle;
    
//    sizeCircle = sizeCircle * self.calendarManager.calendarAppearance.dayCircleRatio;
//    sizeDot = sizeDot * self.calendarManager.calendarAppearance.dayDotRatio;
}

- (void)setDate:(NSDate *)date
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = self.calendarManager.calendarAppearance.calendar.timeZone;
        [dateFormatter setDateFormat:@"dd"];
    }
    
    self->_date = date;
    
    textLabel.text = [dateFormatter stringFromDate:date];
    
    cacheIsToday = -1;
    cacheCurrentDateText = nil;
}

- (void)didTouch
{
    [self setSelected:YES animated:YES];
    [self.calendarManager setCurrentDateSelected:self.date];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLECCalendarDaySelected object:self.date];
    
    [self.calendarManager.dataSource calendarDidDateSelected:self.calendarManager date:self.date];
    
    if(!self.isOtherMonth || !self.calendarManager.calendarAppearance.autoChangeMonth){
        [self.calendarManager setCurrentDateDirectly:self.date];
        return;
    }
    
    NSInteger currentMonthIndex = [self monthIndexForDate:self.date];
    NSInteger calendarMonthIndex = [self monthIndexForDate:self.calendarManager.currentDate];
        
    currentMonthIndex = currentMonthIndex % 12;
    
    if(currentMonthIndex == (calendarMonthIndex + 1) % 12){
        [self.calendarManager loadNextMonth];
    }
    else if(currentMonthIndex == (calendarMonthIndex + 12 - 1) % 12){
        [self.calendarManager loadPreviousMonth];
    }
}

- (void)didDaySelected:(NSNotification *)notification
{
    NSDate *dateSelected = [notification object];
    
    if([self isSameDate:dateSelected]){
        if(!isSelected){
            [self setSelected:YES animated:YES];
        }
    }
    else if(isSelected){
        [self setSelected:NO animated:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if(isSelected == selected){
        animated = NO;
    }
    
    isSelected = selected;
    
    lineView.transform = CGAffineTransformIdentity;
    CGAffineTransform tr = CGAffineTransformIdentity;
    CGFloat opacity = 1.;
    
    if(selected){
        if(!self.isOtherMonth){
            textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorSelected];
        }
        else{
            textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorSelectedOtherMonth];
        }
        
        lineView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
        tr = CGAffineTransformIdentity;
    }
    else if([self isToday]){
        if(!self.isOtherMonth){
            textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorToday];
        }
        else{
            textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorTodayOtherMonth];
        }
        
        opacity = 0.;
    }
    else{
        if(!self.isOtherMonth){
            textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColor];
        }
        else{
            textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorOtherMonth];
        }
        
        opacity = 0.;
    }
    
    if(animated){
        [UIView animateWithDuration:.2 animations:^{
            lineView.layer.opacity = opacity;
            lineView.transform = tr;
        }];
    }
    else{
        lineView.layer.opacity = opacity;
        lineView.transform = tr;
    }
}

- (void)setIsOtherMonth:(BOOL)isOtherMonth
{
    self->_isOtherMonth = isOtherMonth;
    [self setSelected:isSelected animated:NO];
}

- (void)reloadData
{
    dotRGBView.hidden = !self.calendarManager.calendarAppearance.dayExBlock(self.date, self.calendarManager, _lineViews);
    
    BOOL selected = [self isSameDate:[self.calendarManager currentDateSelected]];
    [self setSelected:selected animated:NO];
}

- (BOOL)isToday
{
    if(cacheIsToday == 0){
        return NO;
    }
    else if(cacheIsToday == 1){
        return YES;
    }
    else{
        if([self isSameDate:[NSDate date]]){
            cacheIsToday = 1;
            return YES;
        }
        else{
            cacheIsToday = 0;
            return NO;
        }
    }
}

- (BOOL)isSameDate:(NSDate *)date
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = self.calendarManager.calendarAppearance.calendar.timeZone;
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    }
    
    if(!cacheCurrentDateText){
        cacheCurrentDateText = [dateFormatter stringFromDate:self.date];
    }
    
    NSString *dateText2 = [dateFormatter stringFromDate:date];
    
    if ([cacheCurrentDateText isEqualToString:dateText2]) {
        return YES;
    }
    
    return NO;
}

- (NSInteger)monthIndexForDate:(NSDate *)date
{
    NSCalendar *calendar = self.calendarManager.calendarAppearance.calendar;
    NSDateComponents *comps = [calendar components:NSCalendarUnitMonth fromDate:date];
    return comps.month;
}

- (void)reloadAppearance
{
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = self.calendarManager.calendarAppearance.dayTextFont;
    
    [self configureConstraintsForSubviews];
    [self setSelected:isSelected animated:NO];
}

@end
