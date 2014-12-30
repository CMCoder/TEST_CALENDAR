//
//  LECCalendarContentView.m
//  LECCalendar

#import "LECCalendarContentView.h"

#import "LECCalendar.h"

#import "LECCalendarMonthView.h"
#import "LECCalendarWeekView.h"

#define NUMBER_PAGES_LOADED 5 // Must be the same in LECCalendarView, LECCalendarMenuView, LECCalendarContentView

@interface LECCalendarContentView(){
    NSMutableArray *monthsViews;
}

@end

@implementation LECCalendarContentView

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
    monthsViews = [NSMutableArray new];
    
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.pagingEnabled = YES;
    
    for(int i = 0; i < NUMBER_PAGES_LOADED; ++i){
        LECCalendarMonthView *monthView = [LECCalendarMonthView new];
        [self addSubview:monthView];
        [monthsViews addObject:monthView];
    }
}

- (void)layoutSubviews
{
    [self configureConstraintsForSubviews];
    
    [super layoutSubviews];
}

- (void)configureConstraintsForSubviews
{
    self.contentOffset = CGPointMake(self.contentOffset.x, 0); // Prevent bug when contentOffset.y is negative
 
    CGFloat x = 0;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    for(UIView *view in monthsViews){
        view.frame = CGRectMake(x, 0, width, height);
        x = CGRectGetMaxX(view.frame);
    }
    
    self.contentSize = CGSizeMake(width * NUMBER_PAGES_LOADED, height);
}

- (void)setCurrentDate:(NSDate *)currentDate
{
    self->_currentDate = currentDate;

    NSCalendar *calendar = self.calendarManager.calendarAppearance.calendar;
    
    for(int i = 0; i < NUMBER_PAGES_LOADED; ++i){
        LECCalendarMonthView *monthView = monthsViews[i];
        
        NSDateComponents *dayComponent = [NSDateComponents new];
        
        if(!self.calendarManager.calendarAppearance.isWeekMode){
            dayComponent.month = i - (NUMBER_PAGES_LOADED / 2);
         
            NSDate *monthDate = [calendar dateByAddingComponents:dayComponent toDate:self.currentDate options:0];
            monthDate = [self beginningOfMonth:monthDate];
            [monthView setBeginningOfMonth:monthDate];
        }
        else{
            dayComponent.day = 7 * (i - (NUMBER_PAGES_LOADED / 2));
            
            NSDate *monthDate = [calendar dateByAddingComponents:dayComponent toDate:self.currentDate options:0];
            monthDate = [self beginningOfWeek:monthDate];
            [monthView setBeginningOfMonth:monthDate];
        }
    }
}

- (NSDate *)beginningOfMonth:(NSDate *)date
{
    NSCalendar *calendar = self.calendarManager.calendarAppearance.calendar;
    NSDateComponents *componentsCurrentDate = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth fromDate:date];
    
    NSDateComponents *componentsNewDate = [NSDateComponents new];
    
    componentsNewDate.year = componentsCurrentDate.year;
    componentsNewDate.month = componentsCurrentDate.month;
    componentsNewDate.weekOfMonth = 1;
    componentsNewDate.weekday = calendar.firstWeekday;
    
    return [calendar dateFromComponents:componentsNewDate];
}

- (NSDate *)beginningOfWeek:(NSDate *)date
{
    NSCalendar *calendar = self.calendarManager.calendarAppearance.calendar;
    NSDateComponents *componentsCurrentDate = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth fromDate:date];
    
    NSDateComponents *componentsNewDate = [NSDateComponents new];
    
    componentsNewDate.year = componentsCurrentDate.year;
    componentsNewDate.month = componentsCurrentDate.month;
    componentsNewDate.weekOfMonth = componentsCurrentDate.weekOfMonth;
    componentsNewDate.weekday = calendar.firstWeekday;
    
    return [calendar dateFromComponents:componentsNewDate];
}

#pragma mark - LECCalendarManager

- (void)setCalendarManager:(LECCalendar *)calendarManager
{
    self->_calendarManager = calendarManager;
    
    for(LECCalendarMonthView *view in monthsViews){
        [view setCalendarManager:calendarManager];
    }
    
    for(LECCalendarMonthView *view in monthsViews){
        [view setCalendarManager:calendarManager];
    }
}

- (void)reloadData
{
    for(LECCalendarMonthView *monthView in monthsViews){
        [monthView reloadData];
    }
}

- (void)reloadAppearance
{
    // Fix when change mode during scroll
    self.scrollEnabled = YES;
    
    for(LECCalendarMonthView *monthView in monthsViews){
        [monthView reloadAppearance];
    }
}

@end
