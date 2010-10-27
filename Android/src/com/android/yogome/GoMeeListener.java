package com.android.yogome;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.media.MediaPlayer;
import android.util.Log;
import android.widget.Toast;
import android.os.Bundle;

public class GoMeeListener extends BroadcastReceiver {
	
	@Override
	public void onReceive(Context context, Intent intent) {
		String intentAction = intent.getAction();
        Log.d("DEBUG", "Broadcast received"+intentAction);
        
    	    
        
        if (intentAction.equals("com.android.yogome.action.PROXIMITY_ALERT")) {
        	MediaPlayer mMediaPlayer = MediaPlayer.create(context, R.raw.proximity_alert);
            mMediaPlayer.start();
            Bundle b=intent.getExtras();
            boolean bIn=b.getBoolean("KEY_PROXIMITY_ENTERING", false);
            if (bIn)
            	Toast.makeText(context, "IN", Toast.LENGTH_SHORT).show();
            else
            	Toast.makeText(context, "OUT", Toast.LENGTH_SHORT).show();
            
        	Log.d("DEBUG", "Received Proximity Alert Broadcast");
        } 
	}

}
