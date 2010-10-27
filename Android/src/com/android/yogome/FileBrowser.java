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

import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import android.app.AlertDialog;
import android.app.Dialog;
import android.app.ListActivity;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.DialogInterface.OnClickListener;
import android.content.pm.ActivityInfo;
import android.content.res.Configuration;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.AdapterView.OnItemLongClickListener;

/**
 * This class for file browser
 * 
 * @author Wang XinFeng
 * @version 1.0
 * 
 */
public class FileBrowser extends ListActivity {
		
	/** exit system menu id */
	private static final int EXIT = Menu.FIRST;

	private static final int CIRC_SCREEN = Menu.FIRST+1;
	
	/** display file mode */
	private enum DISPLAYMODE {
		ABSOLUTE, RELATIVE;
	}

	private final DISPLAYMODE mDisplayMode = DISPLAYMODE.RELATIVE;
	private List<IconText> mDirectoryList = new ArrayList<IconText>();
	private File mCurrentDirectory = new File("/sdcard/");

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle icicle) {
		super.onCreate(icicle);
		requestWindowFeature(Window.FEATURE_INDETERMINATE_PROGRESS);
		//setTheme(android.R.style.Theme_Black);
		browseToSdCard();
		this.setSelection(0);
		this.getListView().setOnItemLongClickListener(onItemLongClickListener);
	}

	/**
	 * This function browses to the sdcard directory of the file-system.
	 */
	private void browseToSdCard() {
		browseToWhere(new File("/sdcard/"));
	}

	/**
	 * This function browses up one level according to the field:
	 * currentDirectory
	 */
	private void upOneLevel() {
		/** forbidden visit the root directory */
		//if (!this.mCurrentDirectory.getParent().equals("/"))
			this.browseToWhere(this.mCurrentDirectory.getParentFile());
	}

	private void browseToWhere(final File aDirectory) {
		if (this.mDisplayMode == DISPLAYMODE.RELATIVE)
			this.setTitle(aDirectory.getAbsolutePath() + " - "
					+ getString(R.string.app_name));
		if (aDirectory.isDirectory()) {
			this.mCurrentDirectory = aDirectory;
			fill(aDirectory.listFiles());
		} else {
			OnClickListener okButtonListener = new OnClickListener() {
				public void onClick(DialogInterface arg0, int arg1) {

				}
			};
			OnClickListener cancelButtonListener = new OnClickListener() {
				public void onClick(DialogInterface arg0, int arg1) {
				}
			};
		}
	}

	private void fill(File[] files) {
		this.mDirectoryList.clear();

		/** Add the "." == "current directory" */
		//this.mDirectoryList.add(new IconText(getString(R.string.current_dir),
		//		getResources().getDrawable(R.drawable.folder32)));
		//this.mDirectoryList.add(new IconText(getString(R.string.ad),
		//		getResources().getDrawable(R.drawable.folder32)));
		/** and the ".." == 'Up one level' */
		/** forbidden visit root */
		//if (!this.mCurrentDirectory.getParent().equals("/"))
			this.mDirectoryList.add(new IconText(
					getString(R.string.up_one_level), getResources()
							.getDrawable(R.drawable.uponelevel)));

		Drawable currentIcon = null;
		for (File currentFile : files) {
			if (currentFile.isDirectory()) {
				currentIcon = getResources().getDrawable(R.drawable.folder32);
			} else {
				String fileName = currentFile.getName();
				
				if (checkEnds(fileName, getResources().getStringArray(R.array.textEnds))) {
					currentIcon = getResources().getDrawable(R.drawable.text32);
				}
				if (checkEnds(fileName, getResources().getStringArray(R.array.imageEnds))) {
					currentIcon = getResources().getDrawable(R.drawable.image32);
				}
			}
			switch (this.mDisplayMode) {
			case ABSOLUTE:
				this.mDirectoryList.add(new IconText(currentFile.getPath(),
						currentIcon));
				break;
			case RELATIVE:
					
				int currentPathStringLenght = this.mCurrentDirectory
						.getAbsolutePath().length();
				this.mDirectoryList.add(new IconText(currentFile
						.getAbsolutePath().substring(currentPathStringLenght),
						currentIcon));

				break;
			}
		}
		Collections.sort(this.mDirectoryList);
		IconTextListAdapter iconTextListAdapter = new IconTextListAdapter(this);
		iconTextListAdapter.setListItems(this.mDirectoryList);
		this.setListAdapter(iconTextListAdapter);
	}

	@Override
	protected void onListItemClick(ListView l, View v, int position, long id) {
		String tag ="onListItemClick";
		int selectionRowID = (int) id;
		String selectedFileString = this.mDirectoryList.get(selectionRowID)
				.getText();

		if (selectedFileString.equals(getString(R.string.current_dir))) {
			// Refresh
			this.browseToWhere(this.mCurrentDirectory);
		} else if (selectedFileString.equals(getString(R.string.up_one_level))) {
			this.upOneLevel();

		} else {
			File file = null;
			switch (this.mDisplayMode) {
			case RELATIVE:
				file = new File(this.mCurrentDirectory.getAbsolutePath()
						+ this.mDirectoryList.get(selectionRowID).getText());
				if (file.isFile()) {
					this.finish();
				}
				else
					this.browseToWhere(new File(this.mCurrentDirectory+selectedFileString+"/"));
				break;
			case ABSOLUTE:
				file = new File(this.mDirectoryList.get(selectionRowID).getText());
				if (file.isFile()) {
					this.finish();
				}
				else
					this.browseToWhere(this.mCurrentDirectory);
				break;
			}
		}
	}

	/**
	 * Check the string ends
	 * 
	 * @param checkItsEnd
	 * @param fileEndings
	 * @return
	 */
	private boolean checkEnds(String checkItsEnd, String[] fileEndings) {
		for (String aEnd : fileEndings) {
			if (checkItsEnd.endsWith(aEnd))
				return true;
		}
		return false;
	}

	private OnItemLongClickListener onItemLongClickListener = new OnItemLongClickListener() {
		@Override
		public boolean onItemLongClick(AdapterView<?> arg0, View arg1,
				int arg2, long id) {
			return true;
		}
	};

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		menu.add(1, EXIT, 1, R.string.exit).setShortcut('3', 'a').setIcon(
				R.drawable.close);
		menu.add(1, CIRC_SCREEN, 0, R.string.circumgyrate).setShortcut('3', 'c').setIcon(
				R.drawable.circscreen);
		return super.onCreateOptionsMenu(menu);
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		int id = item.getItemId();
		switch (id) {
		case CIRC_SCREEN:
			circumgyrateScreen();
			return true;
		case EXIT:// exit system
			this.finish();
			return true;
		default:
			break;
		}
		return false;
	}
	
	/**
	 * ��ת��Ļ
	 */
	private void circumgyrateScreen(){
		if(getRequestedOrientation() == ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE){
			setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
		}else{
			setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
		}
	}
	
	
	@Override
	public void onConfigurationChanged(Configuration newConfig) {
		super.onConfigurationChanged(newConfig);
		if(getResources().getConfiguration().orientation == Configuration.ORIENTATION_LANDSCAPE){
			this.browseToWhere(this.mCurrentDirectory);
    	}
    	if(getResources().getConfiguration().orientation == Configuration.ORIENTATION_PORTRAIT){
    		this.browseToWhere(this.mCurrentDirectory);
    	}
    	if(getResources().getConfiguration().keyboardHidden == Configuration.KEYBOARDHIDDEN_NO){
    		this.browseToWhere(this.mCurrentDirectory);
    	}
    	if(getResources().getConfiguration().keyboardHidden == Configuration.KEYBOARDHIDDEN_YES){
    		this.browseToWhere(this.mCurrentDirectory);
    	}
		
	}
	
	
}