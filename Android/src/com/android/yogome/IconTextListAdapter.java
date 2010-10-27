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

import java.util.ArrayList;
import java.util.List;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;


/**
 * a Overwrite list adapter
 * @author Wang XinFeng
 *
 */
public class IconTextListAdapter extends BaseAdapter {

	private Context mContext;
	private List<IconText> mItems = new ArrayList<IconText>();
	public IconTextListAdapter(Context context) {
		mContext = context;
	}

	public void addItem(IconText it) { mItems.add(it); }

	public void setListItems(List<IconText> lit) { mItems = lit; }

	/** @return The number of items in the */
	public int getCount() { return mItems.size(); }

	public Object getItem(int position) { return mItems.get(position); }

	public boolean areAllItemsSelectable() { return false; }

	public boolean isSelectable(int position) { 
		return mItems.get(position).isSelectable();
	}

	/** Use the array index as a unique id. */
	public long getItemId(int position) {
		return position;
	}

	/** @param convertView The old view to overwrite, if one is passed
	 * @returns a IconifiedTextView that holds wraps around an IconifiedText */
	public View getView(int position, View convertView, ViewGroup parent) {
		IconTextView btv;
		if (convertView == null) {
			btv = new IconTextView(mContext, mItems.get(position));
		} else { // Reuse/Overwrite the View passed
			// We are assuming(!) that it is castable! 
			btv = (IconTextView) convertView;
			btv.setText(mItems.get(position).getText());
			btv.setIcon(mItems.get(position).getIcon());
		}
		return btv;
	}
}