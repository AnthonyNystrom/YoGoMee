package com.android.yogome;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.os.Bundle;
import android.view.View;
import android.content.Intent;

public class FullScreenImage extends GraphicsActivity {
	private String mFileBitmap;
	
	@Override
    protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		Intent in = getIntent();
		mFileBitmap = in.getAction();
		setContentView(new MyView(this));
	}
	 public class MyView extends View 
	 {
        private Bitmap  mBitmap;
        private Paint   mBitmapPaint;
        
        public MyView(Context c) {
            super(c);
            
            mBitmap = BitmapFactory.decodeFile(mFileBitmap);
            mBitmapPaint = new Paint(Paint.DITHER_FLAG);
        }

        @Override
        protected void onSizeChanged(int w, int h, int oldw, int oldh) {
            super.onSizeChanged(w, h, oldw, oldh);
        }
        
        @Override
        protected void onDraw(Canvas canvas) {
            canvas.drawBitmap(mBitmap, 0, 0, mBitmapPaint);
        }
	 }
}
