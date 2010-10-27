
/**
 * Copyright (C) 2009 Android OS Community Inc (http://androidos.cc/bbs).
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.android.yogome;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;


/**
 * This class for Icon Text View when browser file
 * @author Wang XinFeng
 * @version 1.0
 *
 */
public class IconTextView extends LinearLayout {
	/**for the text view*/
	private TextView mText;
	/**file icon view*/
	private ImageView mIcon;
	
	public IconTextView(Context context, IconText iconText) {
		super(context);
		this.setOrientation(HORIZONTAL);

		mIcon = new ImageView(context);
		mIcon.setImageDrawable(iconText.getIcon());
		mIcon.setPadding(0, 2, 5, 0); 
		
		addView(mIcon,  new LinearLayout.LayoutParams(
				LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT));
		
		mText = new TextView(context);
		mText.setText(iconText.getText());
		addView(mText, new LinearLayout.LayoutParams(
				LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT));
	}

	public void setText(String words) {
		mText.setText(words);
	}
	
	public void setIcon(Drawable bullet) {
		mIcon.setImageDrawable(bullet);
	}
}