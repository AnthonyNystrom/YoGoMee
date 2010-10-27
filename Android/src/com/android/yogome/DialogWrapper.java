package com.android.yogome;

import android.view.View;
import android.widget.EditText;

class DialogWrapper {
	EditText descriptionField=null;
	EditText titleField=null;
	View base=null;
	
	DialogWrapper(View base) {
		this.base=base;
	}
	DialogWrapper(View base, String sTitle, String sDescription) {
		this.base=base;
		getTitleField().setText(sTitle);
		getDescriptionField().setText(sDescription);
	}
	
	String getDescription() {
		return(getDescriptionField().getText().toString());
	}
	String getTitle() {
		return(getTitleField().getText().toString());
	}
	private EditText getDescriptionField() {
		if (descriptionField==null) 
			descriptionField=(EditText)base.findViewById(R.id.txtDescription);
		return(descriptionField);
	}
	private EditText getTitleField() {
		if (titleField==null) 
			titleField=(EditText)base.findViewById(R.id.txtTitle);
		return(titleField);
	}
	
}