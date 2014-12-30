//
//  LECCalendarMonthView.m
//  LECCalendar

#import "LECCalendarMonthView.h"

#import "LECCalendarMonthWeekDaysView.h"
#import "LECCalendarWeekView.h"

#define WEEKS_TO_DISPLAY 6

@interface LECCalendarMonthView (){
    LECCalendarMonthWeekDaysView *weekdaysView;
    NSArray *weeksViews;
    
    NSUInteger currentMonthIndex;
    BOOL cacheLastWeekMode; // Avoid some operations
};

@end

@implementation LECCalendarMonthView

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

- (void)commonInit
{    
    NSMutableArray *views = [NSMutableArray new];
    
    {
        weekdaysView = [LECCalendarMonthWeekDaysView new];
        [self addSubview:weekdaysView];
    }
    
    for(int i = 0; i < WEEKS_TO_DISPLAY; ++i){
        UIView *view = [LECCalendarWeekView new];
        
        [views addObject:view];
        [self addSubview:view];
    }
    
    weeksViews = views;
    
    cacheLastWeekMode = self.calendarManager.calendarAppearance.isWeekMode;
}

- (void)layoutSubviews
{
    [self configureConstraintsForSubviews];
    
    [super layoutSubviews];
}

- (void)configureConstraintsForSubviews
{
    CGFloat weeksToDisplay;
    
    if(cacheLastWeekMode){
        weeksToDisplay = 2.;
    }
    else{
        weeksToDisplay = (CGFloat)(WEEKS_TO_DISPLAY + 1); // + 1 for weekDays
    }
    
    CGFloat y = 0;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height / weeksToDisplay;
    
    for(int i = 0; i < self.subviews.count; ++i){
        UIView *view = self.subviews[i];
        
        view.frame = CGRectMake(0, y, width, height);
        y = CGRectGetMaxY(view.frame);
        
        if(cacheLastWeekMode && i == weeksToDisplay - 1){
            height = 0.;
        }
    }
}

- (void)setBeginningOfMonth:(NSDate *)date
{
    NSDate *currentDate = date;
    
    NSCalendar *calendar = self.calendarManager.calendarAppearance.calendar;
    
    {
        NSDateComponents *comps = [calendar components:NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
                
        currentMonthIndex = comps.month;
        
        // Hack
        if(comps.day > 7){
            currentMonthIndex = (currentMonthIndex % 12) + 1;
        }
    }
    
    int num = 0;
    for(LECCalendarWeekView *view in weeksViews){
        view.currentMonthIndex = currentMonthIndex;
        [view setBeginningOfWeek:currentDate];
                
        NSDateComponents *dayComponent = [NSDateComponents new];
        dayComponent.day = 7;
        
        currentDate = [calendar dateByAddingComponents:dayComponent toDate:currentDate options:0];
        
        // Doesn't need to do other weeks
//        if(self.calendarManager.calendarAppearance.isWeekMode){
//            break;
        //        }
        
        view.hidden = NO;
        if (num > 0 && self.calendarManager.calendarAppearance.isWeekMode) {
            view.hidden = YES;
        }
        num ++;
    }
}

#pragma mark - LECCalendarManager

- (void)setCalendarManager:(LECCalendar *)calendarManager
{
    self->_calendarManager = calendarManager;
    
    [weekdaysView setCalendarManager:calendarManager];
    for(LECCalendarWeekView *view in weeksViews){
        [view setCalendarManager:calendarManager];
    }
}

- (void)reloadData
{
    for(LECCalendarWeekView *view in weeksViews){
        [view reloadData];
        
        // Doesn't need to do other weeks
        if(self.calendarManager.calendarAppearance.isWeekMode){
            break;
        }
    }
}

- (void)reloadAppearance
{
    if(cacheLastWeekMode != self.calendarManager.calendarAppearance.isWeekMode){
        cacheLastWeekMode = self.calendarManager.calendarAppearance.isWeekMode;
        [self configureConstraintsForSubviews];
    }
    
    [LECCalendarMonthWeekDaysView beforeReloadAppearance];
    [weekdaysView reloadAppearance];
    
    for(LECCalendarWeekView *view in weeksViews){
        [view reloadAppearance];
    }
}

@end
