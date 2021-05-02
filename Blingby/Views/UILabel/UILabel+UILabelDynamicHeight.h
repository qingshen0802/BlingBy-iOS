//
//  UILabel+UILabelDynamicHeight.h
//  Blingby
//
//  Created by Simon Weingand on 20/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UILabel (UILabelDynamicHeight)

#pragma mark - Calculate the size the Multi line Label
/*====================================================================*/

/* Calculate the size of the Multi line Label */

/*====================================================================*/
/**
 *  Returns the size of the Label
 *
 *  @param aLabel To be used to calculte the height
 *
 *  @return size of the Label
 */
-(CGSize)sizeOfMultiLineLabel:(CGFloat)aLabelSizeWidth;

@end