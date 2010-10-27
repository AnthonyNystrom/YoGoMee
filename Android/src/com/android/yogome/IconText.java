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

import android.graphics.drawable.Drawable;

/**
 * This class for a item contain icon,text and selectable
 * @author Wang XinFeng
 * @version 1.0
 *
 */
public class IconText implements Comparable<IconText>{
    /**the text*/
	private String mText = "";
	
	/**icon*/
	private Drawable mIcon;
	/**can be select?*/
	private boolean mSelectable = true;

	public IconText(String text, Drawable bullet) {
		mIcon = bullet;
		mText = text;
	}
	
	public boolean isSelectable() {
		return mSelectable;
	}
	
	public void setSelectable(boolean selectable) {
		mSelectable = selectable;
	}
	
	public String getText() {
		return mText;
	}
	
	public void setText(String text) {
		mText = text;
	}
	
	public void setIcon(Drawable icon) {
		mIcon = icon;
	}
	
	public Drawable getIcon() {
		return mIcon;
	}

	@Override
	public int compareTo(IconText other) {
		if(this.mText != null)
			return this.mText.compareTo(other.getText()); 
		else 
			throw new IllegalArgumentException();
	}
}
