//
//  WebView-WIAppKit.m
//  wired
//
//  Created by Rafaël Warnault on 19/05/12.
//  Copyright (c) 2012 Read-Write.fr. All rights reserved.
//

#import "WebView-WIAppKit.h"




@interface WebView (WIAppKitPrivate)

- (void)_exportWebArchiveToPath:(NSString *)path;
- (void)_exportHTMLToPath:(NSString *)path;
- (void)_exportRTFDToPath:(NSString *)path;
- (void)_exportTXTToPath:(NSString *)path;

@end



@implementation WebView (WIAppKitPrivate)

- (void)_exportWebArchiveToPath:(NSString *)path {
	WebResource		*dataSource;
	WebArchive		*archive;
	
	dataSource		= [[[[self mainFrame] DOMDocument] webArchive] mainResource];
	archive			= [[WebArchive alloc]
					   initWithMainResource:dataSource
					   subresources:nil
					   subframeArchives:nil];
	
	[[archive data] writeToFile:path atomically:YES];
	
	[archive release];
}


- (void)_exportHTMLToPath:(NSString *)path {
	WebResource		*dataSource;
	WebArchive		*archive;
	NSString		*htmlString;
	NSError			*error;
	
	dataSource		= [[[[self mainFrame] DOMDocument] webArchive] mainResource];
	archive			= [[WebArchive alloc]
					   initWithMainResource:dataSource
					   subresources:nil
					   subframeArchives:nil];
	
	htmlString = [self stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('html')[0].innerHTML"];
	
	[htmlString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
	
	[htmlString release];
	[archive release];
}


- (void)_exportRTFDToPath:(NSString *)path {
	WebResource				*dataSource;
	WebArchive				*archive;
	NSDictionary			*options;
	NSAttributedString		*attributedSting;
	
	dataSource		= [[[[self mainFrame] DOMDocument] webArchive] mainResource];
	archive			= [[WebArchive alloc]
					   initWithMainResource:dataSource
					   subresources:nil
					   subframeArchives:nil];
	
	options = [NSDictionary dictionaryWithObject:[NSNumber numberWithUnsignedInteger:NSUTF8StringEncoding] 
										  forKey: NSCharacterEncodingDocumentOption];
	
	attributedSting	= [[NSAttributedString alloc] initWithHTML:[archive data] options:options documentAttributes:NULL];
	
	[[attributedSting RTFDFromRange:NSMakeRange(0, [attributedSting length]) documentAttributes:nil] writeToFile:path 
																									  atomically:YES];
	
	[attributedSting autorelease];
	[archive release];
}


- (void)_exportTXTToPath:(NSString *)path {
	WebResource				*dataSource;
	WebArchive				*archive;
	NSDictionary			*options;
	NSAttributedString		*attributedSting;
	NSString				*string;
	NSError					*error;
	
	dataSource		= [[[[self mainFrame] DOMDocument] webArchive] mainResource];
	archive			= [[WebArchive alloc]
					   initWithMainResource:dataSource
					   subresources:nil
					   subframeArchives:nil];
	
	options = [NSDictionary dictionaryWithObject:[NSNumber numberWithUnsignedInteger:NSUTF8StringEncoding] 
										  forKey: NSCharacterEncodingDocumentOption];
	
	attributedSting	= [[NSAttributedString alloc] initWithHTML:[archive data] options:options documentAttributes:NULL];
	string = [attributedSting string];
	
	[string writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
	
	[attributedSting autorelease];
	[archive release];
}


@end






@implementation WebView (WIAppKit)



#pragma mark -

- (void)scrollToBottom {
	DOMNodeList *bodyNodeList   = [[[self mainFrame] DOMDocument] getElementsByTagName:@"body"];
	DOMHTMLElement *bodyNode    = (DOMHTMLElement *)[bodyNodeList item:0];
	
	NSNumber    *bodyHeight = [bodyNode valueForKey:@"scrollHeight"];
	NSRect		rect;
	
	rect = [[[[[self mainFrame] frameView] documentView] enclosingScrollView] documentVisibleRect];
	rect.origin.y =  [bodyHeight doubleValue] + 50;
	[[[[self mainFrame] frameView] documentView] scrollRectToVisible:rect];
	
}



#pragma mark -

- (void)appendElement:(DOMElement *)element toTopOfElementWithID:(NSString *)elementID scroll:(BOOL)scroll {
	DOMHTMLElement		*containerElement;
	DOMNode				*refElement;
	
	containerElement	= (DOMHTMLElement *)[[[self mainFrame] DOMDocument] getElementById:elementID];
	refElement			= [containerElement firstChild];
	
	if(!refElement)
		[containerElement appendChild:element];
	else
		[containerElement insertBefore:element refChild:refElement];
	
	if(scroll)
		[self scrollToBottom];
}


- (void)appendElement:(DOMElement *)element toBottomOfElementWithID:(NSString *)elementID scroll:(BOOL)scroll {
	DOMElement *contentElement = [[[self mainFrame] DOMDocument] getElementById:elementID];
	[contentElement appendChild:element];
	
	if(scroll)
		[self scrollToBottom];
}




#pragma mark -

- (void)reloadStylesheetWithID:(NSString *)elementID withTemplate:(WITemplateBundle *)template type:(WITemplateType)type {
	DOMHTMLElement *header = (DOMHTMLElement *)[[[self mainFrame] DOMDocument] getElementById:elementID];
	[header setAttribute:@"href" value:[template defaultStylesheetPathForType:type]];
	
//	NSString *scriptString = [NSString stringWithFormat:@"document.getElementById('%@').href = '%@';", elementID, [template defaultStylesheetPathForType:type]];
//	
//	[[self windowScriptObject] evaluateWebScript:scriptString];
}

- (void)clearChildrenElementsOfElementWithID:(NSString *)elementID {
	DOMHTMLElement *contentElement = (DOMHTMLElement *)[[[self mainFrame] DOMDocument] getElementById:elementID];
	[contentElement setInnerHTML:@""];
}




#pragma mark -

- (void)exportContentToFileAtPath:(NSString *)path forType:(WIChatLogType)type {
	
	switch (type) {
		case WIChatLogTypeWebArchive:	[self _exportWebArchiveToPath:path];	break;
		case WIChatLogTypeTXT:			[self _exportTXTToPath:path];			break;
		default:						[self _exportWebArchiveToPath:path];	break;
	}
}


@end
