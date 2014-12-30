//
//  LECCalendarMenuView.m
//  LECCalendar

#import "LECCalendarMenuView.h"

#import "LECCalendar.h"
#import "LECCalendarMenuMonthView.h"

#define NUMBER_PAGES_LOADED 5 // Must be the same in LECCalendarView, LECCalendarMenuView, LECCalendarContentView

@interface LECCalendarMenuView(){
    NSMutableArray *monthsViews;
}

@end

@implementation LECCalendarMenuView

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
        LECCalendarMenuMonthView *monthView = [LECCalendarMenuMonthView new];
                
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
    
    if(self.calendarManager.calendarAppearance.ratioContentMenu != 1.){
        width = self.frame.size.width / self.calendarManager.calendarAppearance.ratioContentMenu;
        x = (self.frame.size.width - width) / 2.;
    }
    
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
    NSDateComponents *dayComponent = [NSDateComponents new];
    
    for(int i = 0; i < NUMBER_PAGES_LOADED; ++i){
        LECCalendarMenuMonthView *monthView = monthsViews[i];
        
        dayComponent.month = i - (NUMBER_PAGES_LOADED / 2);
        NSDate *monthDate = [calendar dateByAddingComponents:dayComponent toDate:self.currentDate options:0];
        [monthView setCurrentDate:monthDate];
    }
}

#pragma mark - LECCalendarManager

- (void)setCalendarManager:(LECCalendar *)calendarManager
{
    self->_calendarManager = calendarManager;
    
    for(LECCalendarMenuMonthView *view in monthsViews){
        [view setCalendarManager:calendarManager];
    }
}

- (void)reloadAppearance
{
    self.scrollEnabled = !self.calendarManager.calendarAppearance.isWeekMode;
    
    [self configureConstraintsForSubviews];
    for(LECCalendarMenuMonthView *view in monthsViews){
        [view reloadAppearance];
    }
}

@end
