/* $Id$ */

/*
 *  Copyright (c) 2003-2009 Axel Andersson
 *  All rights reserved.
 *
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions
 *  are met:
 *  1. Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *  2. Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
 * ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#import <WiredFoundation/NSDate-WIFoundation.h>

@implementation NSDate(WIFoundation)

+ (NSDate *)dateAtStartOfCurrentDay {
	return [[NSDate date] dateAtStartOfDay];
}



+ (NSDate *)dateAtStartOfCurrentWeek {
	return [[NSDate date] dateAtStartOfWeek];
}



+ (NSDate *)dateAtStartOfCurrentMonth {
	return [[NSDate date] dateAtStartOfMonth];
}



+ (NSDate *)dateAtStartOfCurrentYear {
	return [[NSDate date] dateAtStartOfYear];
}



#pragma mark -

- (NSDate *)dateAtStartOfDay {
	NSDateComponents	*components;
	
	components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:self];
	
	[components setHour:-[components hour]];
	[components setMinute:-[components minute]];
	[components setSecond:-[components second]];
	
	return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
}



- (NSDate *)dateAtStartOfWeek {
	NSDate				*date;
	NSDateComponents	*components;
	NSInteger			firstWeekday;
	
	date			= [self dateAtStartOfDay];
	firstWeekday	= [[NSCalendar currentCalendar] firstWeekday];
	components		= [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date];
	
	if([components weekday] < firstWeekday)
		[components setWeekday:-[components weekday] + firstWeekday - 7];
	else
		[components setWeekday:-[components weekday] + firstWeekday];
	
	return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:date options:0];
}



- (NSDate *)dateAtStartOfMonth {
	NSDate				*date;
	NSDateComponents	*components;
	
	date			= [self dateAtStartOfDay];
	components		= [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:date];
	
	[components setDay:-[components day] + 1];
	
	return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:date options:0];
}



- (NSDate *)dateAtStartOfYear {
	NSDate				*date;
	NSDateComponents	*components;
	
	date			= [self dateAtStartOfMonth];
	components		= [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:date];
	
	[components setMonth:-[components month] + 1];
	
	return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:date options:0];
}



#pragma mark -

- (BOOL)isAtBeginningOfAnyEpoch {
	return ([self isEqualToDate:[NSDate dateWithTimeIntervalSince1970:0.0]] ||
			[self isEqualToDate:[NSDate dateWithTimeIntervalSinceReferenceDate:0.0]]);
}



- (NSDate *)dateByAddingDays:(NSInteger)days {
	NSDateComponents	*components;
	
	components = [[[NSDateComponents alloc] init] autorelease];
	[components setDay:days];
	
	return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
}

@end



@interface NSDate()
-(NSString *)getLocaleFormatUnderscoresWithValue:(double)value;
@end

@implementation NSDate (TimeAgo)

#ifndef NSDateTimeAgoLocalizedStrings
#define NSDateTimeAgoLocalizedStrings(key) \
NSLocalizedStringFromTable(key, @"NSDateTimeAgo", nil)
#endif

- (NSString *)timeAgo
{
    NSDate *now = [NSDate date];
    double deltaSeconds = fabs([self timeIntervalSinceDate:now]);
    double deltaMinutes = deltaSeconds / 60.0f;
    
    int minutes;
    NSString *localeFormat;
    
    if(deltaSeconds < 5)
    {
        return NSDateTimeAgoLocalizedStrings(@"Just now");
    }
    else if(deltaSeconds < 60)
    {
        localeFormat = [NSString stringWithFormat:@"%%d %@seconds ago", [self getLocaleFormatUnderscoresWithValue:(int)deltaSeconds]];
        return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(localeFormat), (int)deltaSeconds];
    }
    else if(deltaSeconds < 120)
    {
        return NSDateTimeAgoLocalizedStrings(@"A minute ago");
    }
    else if (deltaMinutes < 60)
    {
        localeFormat = [NSString stringWithFormat:@"%%d %@minutes ago", [self getLocaleFormatUnderscoresWithValue:(int)deltaMinutes]];
        return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(localeFormat), (int)deltaMinutes];
    }
    else if (deltaMinutes < 120)
    {
        return NSDateTimeAgoLocalizedStrings(@"An hour ago");
    }
    else if (deltaMinutes < (24 * 60))
    {
        minutes = (int)floor(deltaMinutes/60);
        localeFormat = [NSString stringWithFormat:@"%%d %@hours ago", [self getLocaleFormatUnderscoresWithValue:minutes]];
        return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(localeFormat), minutes];
    }
    else if (deltaMinutes < (24 * 60 * 2))
    {
        return NSDateTimeAgoLocalizedStrings(@"Yesterday");
    }
    else if (deltaMinutes < (24 * 60 * 7))
    {
        minutes = (int)floor(deltaMinutes/(60 * 24));
        localeFormat = [NSString stringWithFormat:@"%%d %@days ago", [self getLocaleFormatUnderscoresWithValue:minutes]];
        return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(localeFormat), minutes];
    }
    else if (deltaMinutes < (24 * 60 * 14))
    {
        return NSDateTimeAgoLocalizedStrings(@"Last week");
    }
    else if (deltaMinutes < (24 * 60 * 31))
    {
        minutes = (int)floor(deltaMinutes/(60 * 24 * 7));
        localeFormat = [NSString stringWithFormat:@"%%d %@weeks ago", [self getLocaleFormatUnderscoresWithValue:minutes]];
        return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(localeFormat), minutes];
    }
    else if (deltaMinutes < (24 * 60 * 61))
    {
        return NSDateTimeAgoLocalizedStrings(@"Last month");
    }
    else if (deltaMinutes < (24 * 60 * 365.25))
    {
        minutes = (int)floor(deltaMinutes/(60 * 24 * 30));
        localeFormat = [NSString stringWithFormat:@"%%d %@months ago", [self getLocaleFormatUnderscoresWithValue:minutes]];
        return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(localeFormat), minutes];
    }
    else if (deltaMinutes < (24 * 60 * 731))
    {
        return NSDateTimeAgoLocalizedStrings(@"Last year");
    }
    
    minutes = (int)floor(deltaMinutes/(60 * 24 * 365));
    localeFormat = [NSString stringWithFormat:@"%%d %@years ago", [self getLocaleFormatUnderscoresWithValue:minutes]];
    return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(localeFormat), minutes];
}

- (NSString *) timeAgoWithLimit:(NSTimeInterval)limit
{
    return [self timeAgoWithLimit:limit dateFormat:NSDateFormatterShortStyle andTimeFormat:NSDateFormatterShortStyle];
}

- (NSString *) timeAgoWithLimit:(NSTimeInterval)limit dateFormat:(NSDateFormatterStyle)dFormatter andTimeFormat:(NSDateFormatterStyle)tFormatter
{
    if (fabs([self timeIntervalSinceDate:[NSDate date]]) <= limit)
        return [self timeAgo];
    
    return [NSDateFormatter localizedStringFromDate:self
                                          dateStyle:dFormatter
                                          timeStyle:tFormatter];
}

// Helper functions

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

/*
 - Author  : Almas Adilbek
 - Method  : getLocaleFormatUnderscoresWithValue
 - Param   : value (Double value of seconds or minutes)
 - Return  : @"" or the set of underscores ("_")
 in order to define exact translation format for specific translation rules.
 (Ex: "%d _seconds ago" for "%d секунды назад", "%d __seconds ago" for "%d секунда назад",
 and default format without underscore %d seconds ago" for "%d секунд назад")
 Updated : 12/12/2012
 
 Note    : This method must be used for all languages that have specific translation rules.
 Using method argument "value" you must define all possible conditions language have for translation
 and return set of underscores ("_") as it is an ID for locale format. No underscore ("") means default locale format;
 */
-(NSString *)getLocaleFormatUnderscoresWithValue:(double)value
{
    NSString *localeCode = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    // Russian (ru)
    if([localeCode isEqual:@"ru"]) {
        NSString *valueStr = [NSString stringWithFormat:@"%.f", value];
        int l = (int)valueStr.length;
        int XY = [[valueStr substringWithRange:NSMakeRange(l - 2, l)] intValue];
        int Y = (int)floor(value) % 10;
        
        if(Y == 0 || Y > 4 || XY == 11) return @"";
        if(Y != 1 && Y < 5)             return @"_";
        if(Y == 1)                      return @"__";
    }
    
    // Add more languages here, which are have specific translation rules...
    
    return @"";
}

#pragma clang diagnostic pop

@end



@implementation NSDate (Javascript)

- (NSString *)JSDate {
    NSDateFormatter     *dateFormatter;
    NSCalendar          *calendar;
    
    dateFormatter   = [[[NSDateFormatter alloc] init] autorelease];
    calendar        = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormatter setCalendar:calendar];
    
    return [dateFormatter stringFromDate:self];
}

@end
