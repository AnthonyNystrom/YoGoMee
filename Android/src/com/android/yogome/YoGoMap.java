package com.android.yogome;

import android.graphics.drawable.Drawable;
import android.graphics.*;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.provider.MediaStore.Images.Media;
import android.util.Log;
import android.view.*;
import android.widget.TextView;
import android.widget.ImageView;
import android.os.Vibrator;
import com.google.android.maps.*;
import java.io.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;  	
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.database.Cursor;
import android.location.*;
import android.preference.PreferenceManager;
  	 
public class YoGoMap extends MapActivity implements LocationListener, Runnable{
	private MapView map=null;
	private MyLocationOverlay me=null;
	private YoGoDB Db;
	private Cursor curDB;
	public LocationManager lm;
	private LocationProvider mLocationProviderFine = null; 
	private LocationProvider mLocationProviderCoarse = null;
	private Location curLoc;
	private SitesOverlay so;
	public double fLon, fLat;
	private boolean bGPSOn=false;
	private boolean bSat=false;
	boolean bEndThread;
	private Thread thread=null; 
	private boolean bWaitCamera=false;
	ProgressDialog dialog; 
	private int iThreadType;
	private String sFile;
	static final int TH_COPY_IMG = 0;
	static final int TH_LISTEN_IMG = 1;
	static final String THUMB_PREFIX="t_";
	PendingIntent[] mProximityPending = new PendingIntent[1024];
	
	protected static final String GOMEE_PROX_ALERT = new String("com.android.yogome.action.PROXIMITY_ALERT");
	protected static final String RADIUS_ALERT = "20";
	protected final IntentFilter myIntentFilter =  new IntentFilter(GOMEE_PROX_ALERT);
	protected GoMeeListener myGoMeeReceiver = null;
	NotificationManager nm;
	public SharedPreferences prefs=null;
	
	public void runThreadSaveImg(){
    	bEndThread = false;
    	thread = new Thread(this);
    	iThreadType = TH_COPY_IMG;
    	StartProgressDialog();
    	thread.start();
	}
	
	public void run() {
		
		Cursor ct, c;
		int iNPics=0;
		if (iThreadType==TH_LISTEN_IMG){
			ct = managedQuery(android.provider.MediaStore.Images.Thumbnails.EXTERNAL_CONTENT_URI,null,null,null,null);
			iNPics = ct.getCount();

			SharedPreferences.Editor editor = getSharedPreferences(PREF_FILE, 0).edit();
			editor.putString(PREF_CUR_IMAGE_NORMAL, "");
			editor.putString(PREF_CUR_IMAGE_THUMB, "");
	        editor.commit();
		}
		
        while(!bEndThread){
			switch (iThreadType){
				case TH_COPY_IMG:
					try{thread.sleep(1000);}catch (Exception ex){}
					
		        	SharedPreferences settings = getSharedPreferences(PREF_FILE, 0);
	    			try{
	    				try{
	    		        	String sImg=settings.getString(PREF_CUR_IMAGE_NORMAL, "");

	    					FileInputStream inps = new FileInputStream(new File(sImg)); 
		    				if (inps!=null){
			    				FileOutputStream fos = openFileOutput(sFile, MODE_WORLD_WRITEABLE);
			    				byte byBuff[] = new byte[1024];
			    				int iread=0;
			    				do{
			    					iread=inps.read(byBuff);
			    					if (iread>0)
			    						fos.write(byBuff, 0, iread);
			    				}while(iread>0);
			    	    		fos.close();
		    					inps.close();
		    				}
		    				sImg=settings.getString(PREF_CUR_IMAGE_THUMB, ""); 
	    					inps = new FileInputStream(new File(sImg)); 
		    				if (inps!=null){
		    					sFile = THUMB_PREFIX+sFile;
			    				FileOutputStream fos = openFileOutput(sFile, MODE_WORLD_WRITEABLE);
			    				byte byBuff[] = new byte[1024];
			    				int iread=0;
			    				do{
			    					iread=inps.read(byBuff);
			    					if (iread>0)
			    						fos.write(byBuff, 0, iread);
			    				}while(iread>0);
			    	    		fos.close();
		    					inps.close();
		    				}
                        } catch(FileNotFoundException e) {}
	    				/*Bitmap bm = Media.getBitmap(getContentResolver(), uri);
	    				ByteArrayOutputStream bytes = new ByteArrayOutputStream();
	    				bm.compress(Bitmap.CompressFormat.JPEG, 90, bytes);
	    				bm.recycle();
	    				FileOutputStream fos = openFileOutput(sFile, MODE_WORLD_WRITEABLE);
	    	    		fos.write(bytes.toByteArray());
	    	    		fos.close();
	    	    		bytes.close();*/
	    			}
	    			catch(IOException ex){
	    	    	}
	    			catch (Exception ex){
					}
	    			SharedPreferences.Editor editor = getSharedPreferences(PREF_FILE, 0).edit();
	    			editor.putString(PREF_CUR_IMAGE_NORMAL, "");
	    			editor.putString(PREF_CUR_IMAGE_THUMB, "");
	    	        editor.commit();
		            bEndThread=true;
    	    		EndProgressDialog();
		            break;

				case TH_LISTEN_IMG:
					try{
						ct = managedQuery(android.provider.MediaStore.Images.Thumbnails.EXTERNAL_CONTENT_URI,null,null,null,Media._ID + " ASC");
						if( ct.getCount()>iNPics ) {
							ct.moveToLast();
							iNPics = ct.getCount();
							
							String sPathThumbImage= ct.getString(ct.getColumnIndex(android.provider.MediaStore.Images.Thumbnails.DATA));
							String sPathFullImage;
							c = managedQuery(android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI,null,null,null,
									         android.provider.MediaStore.Images.Media._ID + " ASC");
							c.moveToLast();
							if (c.getCount()>0)
								sPathFullImage = c.getString(c.getColumnIndex(android.provider.MediaStore.Images.Media.DATA));
							else
								sPathFullImage = sPathThumbImage;
							
							c.close();
							
				    	    SharedPreferences.Editor editor1 = getSharedPreferences(PREF_FILE, 0).edit();
				            editor1.putString(PREF_CUR_IMAGE_NORMAL, sPathFullImage);
				            editor1.putString(PREF_CUR_IMAGE_THUMB, sPathThumbImage);
				            editor1.commit();
						}
						thread.sleep(1000);
					}
					catch (Exception ex){
						Log.i("EXCEPTION", ex.toString());
					}
					break;
			}
		}
	}	
	/*
	@Override
	public boolean onTouchEvent(MotionEvent event){
		super.onTouchEvent(event);
		if (event.getAction()==MotionEvent.ACTION_UP){
			Projection pro = map.getProjection();
			GeoPoint p = pro.fromPixels((int)event.getX(), (int)event.getY());
			curDB.requery();
			//Db.createPointItem(p.getLatitudeE6(), p.getLongitudeE6(), "CIAO");
			map.getOverlays().clear();
			map.getOverlays().add(so);
			map.invalidate();
			return true;
		}
		else
			return false;
	}*/
	@Override
	public void  onProviderDisabled(String provider) {
    }
	@Override
    public void  onProviderEnabled(String provider) {
		
    }
    @Override
    public void  onStatusChanged(String provider, int status, Bundle extras) {
    	switch (status){
    	case LocationProvider.OUT_OF_SERVICE:
    		if (provider.equals(LocationManager.GPS_PROVIDER))
    			bGPSOn=false;
    		break;
    	case LocationProvider.AVAILABLE:
    		if (provider.equals(LocationManager.GPS_PROVIDER))
    			bGPSOn=true;
    		break;
    	case LocationProvider.TEMPORARILY_UNAVAILABLE:
    		if (provider.equals(LocationManager.GPS_PROVIDER))
    			bGPSOn=false;    		
    		break;
    	}
    }
    static final String PREF_FILE = "yogome";
    static final String PREF_CUR_LOC = "cur_loc";
    static final String PREF_CUR_IMAGE_NORMAL = "cur_img_normal";
    static final String PREF_CUR_IMAGE_THUMB  = "cur_img_thumb";

    @Override
    public void  onLocationChanged(Location location) {
    	
        if (location.getProvider().equals(LocationManager.NETWORK_PROVIDER) && bGPSOn){
        	
        }
        else{
        	curLoc = location;
    	    SharedPreferences.Editor editor = getSharedPreferences(PREF_FILE, 0).edit();
            editor.putString(PREF_CUR_LOC, curLoc.getLatitude()+";"+curLoc.getLongitude());
            editor.commit();
        }
        
    	/*if (bAutoPosition){
    		if (location.getProvider().equals(LocationManager.NETWORK_PROVIDER) && bGPSOn){
    			// With GPS On all network provider change location are lost
    		}
    		else
    			ShowPoint(curLoc.getLatitude(), curLoc.getLongitude());
    	}*/
    } 
    public Location GetCurrentLocation(){
    	return curLoc;
    }
    
	public void ShowPoint(double flat, double flon){
		GeoPoint gp = getPoint(flat, flon);
		ShowPoint(gp);
	}
	public void ShowPoint(GeoPoint gp){
		MapController mc = map.getController();
		if (mc!=null){
			mc.animateTo(gp);
		}
	}
	
	@Override
	protected void onDestroy() {
		super.onDestroy();
		unregisterReceiver(myGoMeeReceiver);
		bEndThread=true;
		if (thread!=null)
			thread.stop();
		
		curDB.close();
		Db.close();
	}
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.yogomap);
		
		prefs=PreferenceManager.getDefaultSharedPreferences(this);
		
        // look up the notification manager service
        nm = (NotificationManager)getSystemService(NOTIFICATION_SERVICE);

		
    	Db = new YoGoDB(this);
        Db.open();
        curDB = Db.fetchAllPoints();
        
		myGoMeeReceiver= new GoMeeListener();
		
        map=(MapView)findViewById(R.id.map);
		ViewGroup zoom=(ViewGroup)findViewById(R.id.zoom);
		zoom.addView(map.getZoomControls());
		
		// Show icon current position 
		me=new MyLocationOverlay(this, map);
		map.getOverlays().add(me);		
		me.enableMyLocation();
		
		// start location service
		lm = (LocationManager)getSystemService(Context.LOCATION_SERVICE);
		Criteria criteria = new Criteria ();
        criteria.setAccuracy(Criteria.ACCURACY_FINE);
        List<String> providerIds=lm.getProviders(criteria, true);
        if (!providerIds.isEmpty()) {
                mLocationProviderFine =lm.getProvider(providerIds.get(0));
        }
        criteria.setAccuracy(Criteria.ACCURACY_COARSE);
        providerIds=lm.getProviders(criteria, true);
        if (!providerIds.isEmpty()) {
                mLocationProviderCoarse =lm.getProvider(providerIds.get(0));
        }        
        if (mLocationProviderFine!=null)
			lm.requestLocationUpdates(mLocationProviderFine.getName(),0, 0, this);
		if (mLocationProviderCoarse!=null)
			lm.requestLocationUpdates(mLocationProviderCoarse.getName(),1000L, 500.0f, this);
		map.getController().setZoom(17);
		
        // show makers on map and zoom controls
		Drawable marker=getResources().getDrawable(R.drawable.marker);
		marker.setBounds(0, 0, marker.getIntrinsicWidth(),marker.getIntrinsicHeight());
		so = new SitesOverlay(marker);
		map.getOverlays().add(so);
	}
	public void ShowMurales(){ 
		Intent intent = new Intent(this, GoMeeMurales.class);
		startActivity(intent);
	}
	
	
	@Override
	public void onResume() {
		super.onResume();
		
		registerReceiver(myGoMeeReceiver, myIntentFilter);
		if (me!=null)
			me.enableCompass();
		if (bWaitCamera){
			bWaitCamera=false;
			// stop thread
			bEndThread=true;
			if (thread!=null)
				thread.stop();
			showDialog(DIALOG_GOMEE_IMAGE);
		}
	}
	
	void EndProgressDialog()
	{	if (dialog!=null){
			dialog.cancel();
			dialog=null;
		}
	}
	void StartProgressDialog()
    {
    	dialog = new ProgressDialog(this);
        dialog.setMessage("Please wait ...");
        dialog.setIndeterminate(true);
        dialog.show(); 
    }
	
	@Override
	public void onPause() {
		super.onPause();
		if (me!=null)
			me.disableCompass();
	}		
	
 	@Override
	protected boolean isRouteDisplayed() {
		return(false);
	}
	
 	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_S) {
			map.setSatellite(!map.isSatellite());
			return(true);
		}
		else if (keyCode == KeyEvent.KEYCODE_Z) {
			map.displayZoomControls(true);
			return(true);
		}		
		return(super.onKeyDown(keyCode, event));
	}

	private GeoPoint getPoint(double lat, double lon) {
		return(new GeoPoint((int)(lat*1000000.0),(int)(lon*1000000.0)));
	}
	
	private void RefreshGoMeeOnMap(){
        curDB.requery();
        curDB.moveToFirst();
        map.getOverlays().clear();
		Drawable marker=getResources().getDrawable(R.drawable.marker);
		marker.setBounds(0, 0, marker.getIntrinsicWidth(),marker.getIntrinsicHeight());
		so = new SitesOverlay(marker);
		map.getOverlays().add(so);
		map.getOverlays().add(me);		
		
		int iNGoMee = curDB.getCount();
		curDB.moveToFirst();
		
		int i=0;
		while (mProximityPending[i]!=null){
			lm.removeProximityAlert(mProximityPending[i]);
			mProximityPending[i]=null;
			i++;
		}
			
		
		for (i=0; i<iNGoMee; i++){
			// setting proximity alert
        	double flat = curDB.getDouble(1);
        	double flon = curDB.getDouble(2);
			Intent proxIntent = new Intent(GOMEE_PROX_ALERT);
			proxIntent.putExtra("POSITION", i);
			// setting proximity alert
			mProximityPending[i] = PendingIntent.getBroadcast(YoGoMap.this, i, proxIntent, PendingIntent.FLAG_CANCEL_CURRENT);
	        // add proximity alerts
			int iRadius = Integer.parseInt(prefs.getString(getString(R.string.proximity_radius), RADIUS_ALERT));
		    lm.addProximityAlert(flat,flon,iRadius,-1,mProximityPending[i]);
		    curDB.moveToNext();
		}
		 
		map.invalidate();		
	}
		
	private class SitesOverlay extends ItemizedOverlay<OverlayItem> {
		private List<OverlayItem> items=new ArrayList<OverlayItem>();
		private Drawable marker=null;
		
		public SitesOverlay(Drawable marker) {
			super(marker);
			this.marker=marker;
					    
	        curDB.moveToFirst();
	        int i;
	        double flat, flon;
	        GeoPoint gp=null;
	        for (i=0;i<curDB.getCount(); i++){
	        	flat = curDB.getDouble(1);
	        	flon = curDB.getDouble(2);	        	
	        	gp   = getPoint(flat, flon);
				items.add(new OverlayItem(gp,curDB.getString(4), Integer.toString(curDB.getPosition())));
				
				Intent proxIntent = new Intent(GOMEE_PROX_ALERT);
				proxIntent.putExtra("POSITION", i);
				// setting proximity alert
				mProximityPending[i] = PendingIntent.getBroadcast(YoGoMap.this, i, proxIntent, PendingIntent.FLAG_CANCEL_CURRENT);
				int iRadius = Integer.parseInt(prefs.getString(getString(R.string.proximity_radius), RADIUS_ALERT));
		        // add proximity alerts
			    lm.addProximityAlert(flat,flon,iRadius,-1,mProximityPending[i]);			    
				curDB.moveToNext();			    
	        }
			populate();
		}
		
		@Override
		protected OverlayItem createItem(int i) {
			return(items.get(i));
		}
		
		@Override
		public void draw(Canvas canvas, MapView mapView,boolean shadow) {
			super.draw(canvas, mapView, shadow);
			boundCenterBottom(marker);
		}
 		
		@Override
		protected boolean onTap(int i) {
			//Toast.makeText(YoGoMap.this, items.get(i).getSnippet(),Toast.LENGTH_SHORT).show();
			curDB.moveToPosition(Integer.parseInt(items.get(i).getSnippet()));
			switch (curDB.getInt(6))
			{
			case GOMEE_TYPE_GRAFFITI:
				showDialog(DIALOG_GOMEE_POPUP);
				break;
			default:
				showDialog(DIALOG_GOMEE_POPUP);
			}
			return(true);
		}
		
		@Override
		public int size() {
			return(items.size());
		}
	}
	public void ShowGoMee(int iPosition){
		curDB.moveToPosition(iPosition);
		showDialog(DIALOG_GOMEE_POPUP);

	}
	private static final int NEW_GOMEE 				= Menu.FIRST+1;
	private static final int GOMEE_LIST 			= Menu.FIRST+2;
	private static final int GOTO_LOCATION 			= Menu.FIRST+3;
	private static final int MAP_SAT 				= Menu.FIRST+4;
	private static final int PREFERENCES 			= Menu.FIRST+5;	
	private static final int RESULT_GOMEE_LIST 		= 0;
	private static final int RESULT_GOMEE_PICK_IMG 	= 1;
	
    @Override
	public boolean onCreateOptionsMenu(Menu menu) {
		menu.add(Menu.NONE, NEW_GOMEE, Menu.NONE, "New GoMee")
		.setIcon(R.drawable.new_gomee);
		menu.add(Menu.NONE, GOMEE_LIST, Menu.NONE, "GoMee List")
		.setIcon(R.drawable.gomee_list);
		menu.add(Menu.NONE, GOTO_LOCATION, Menu.NONE, "My Position")
		.setIcon(R.drawable.my_position);
		menu.add(Menu.NONE, MAP_SAT, Menu.NONE, "Map/Sat Mode")
		.setIcon(R.drawable.map_sat);
		menu.add(Menu.NONE, PREFERENCES, Menu.NONE, "Preferences")
		.setIcon(R.drawable.preferences);
		
		return(super.onCreateOptionsMenu(menu));
	}
    @Override
	public boolean onOptionsItemSelected(MenuItem item) {
    	switch (item.getItemId()) {
			case NEW_GOMEE:
				showDialog(DIALOG_GOMEE_TYPE);
				return(true);
			case GOMEE_LIST:
				Intent intent = new Intent(this, YoGoAlert.class);
        		startActivityForResult(intent, RESULT_GOMEE_LIST);
				return true;
			case GOTO_LOCATION:
		    	ShowPoint(curLoc.getLatitude(), curLoc.getLongitude());
				return true;
			case MAP_SAT:
				bSat=!bSat;
				map.setSatellite(bSat);
				return true;
			case PREFERENCES:
				startActivity(new Intent(this, EditPreferences.class));
				return true;
		}
		return(super.onOptionsItemSelected(item));
	}
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == RESULT_GOMEE_LIST) {
            
            RefreshGoMeeOnMap();

    		if (resultCode != RESULT_CANCELED) {
				String sAction = data.getAction();
				String sLon=sAction.substring(sAction.lastIndexOf(";")+1);
				String sLat=sAction.substring(0,sAction.lastIndexOf(";"));
		    	ShowPoint(Double.parseDouble(sLat), Double.parseDouble(sLon));
            }
        }
        else if (requestCode==RESULT_GOMEE_PICK_IMG){
        	if (resultCode != RESULT_CANCELED) {
                if (data != null) {
        			//showDialog(DIALOG_GOMEE_IMAGE);
                }
        	}
        }
    }    
    
    private void AddGoMeeImgFile(){
    	Uri target = android.provider.MediaStore.Images.Thumbnails.EXTERNAL_CONTENT_URI;
        Intent intent = new Intent(Intent.ACTION_PICK, target);
        startActivityForResult(intent, RESULT_GOMEE_PICK_IMG);    	
    }
    
    private void AddGoMeeCaptureImg(){
        // run thread to listen new images
    	bEndThread = false;
    	thread = new Thread(this);
    	iThreadType = TH_LISTEN_IMG;
    	thread.start();
    	
    	// run camera app
    	ComponentName toLaunch; 
    	toLaunch = new ComponentName("com.android.camera","com.android.camera.Camera"); 
    	Intent intent = new Intent(Intent.ACTION_MAIN);
        intent.addCategory(Intent.CATEGORY_LAUNCHER);
        intent.setComponent(toLaunch);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK|Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED);
        bWaitCamera=true;
        startActivity(intent);
    }
    
    private void SaveGoMee(String sTitle, String sDescription, int iType, double fLat, double fLon, String sMedia) {
        Db.createPointItem(iType, fLat, fLon, sTitle, sDescription, sMedia);
        RefreshGoMeeOnMap();
	}	    
	
	static final int GOMEE_TYPE_TEXT 	= 0;
	static final int GOMEE_TYPE_MEDIA	= 1;
	static final int GOMEE_TYPE_FILES	= 2;
	static final int GOMEE_TYPE_WALL 	= 3;
	static final int GOMEE_TYPE_LINK 	= 4;
	static final int GOMEE_TYPE_VIDEO	= 5;
	static final int GOMEE_TYPE_GRAFFITI= 6;
	static final int GOMEE_TYPE_FILE 	= 7;
	
	static final int DIALOG_GOMEE_TYPE  = 0;
	static final int DIALOG_GOMEE_TEXT  = 1;
	static final int DIALOG_GOMEE_IMAGE = 2;
	static final int DIALOG_MESSAGE     = 3;
	static final int DIALOG_GOMEE_POPUP = 4;
	static final int DIALOG_GOMEE_GRAFFITI = 5;
	private String sMessage;
	
		
	@Override
    protected Dialog onCreateDialog(int id) {

		View addView;
		LayoutInflater inflater;
		ImageView img;
		final Bitmap bm;
		
		switch (id) {
		case DIALOG_GOMEE_GRAFFITI:
			break;
			
		case DIALOG_GOMEE_POPUP:
			inflater=LayoutInflater.from(YoGoMap.this);
			addView=inflater.inflate(R.layout.goome_popup, null);
			//TextView txtTitle = (TextView) addView.findViewById(R.id.txtTitle);
			TextView txtDesc = (TextView) addView.findViewById(R.id.txtDesc);
			TextView txtDate = (TextView) addView.findViewById(R.id.txtDate);
			img              = (ImageView) addView.findViewById(R.id.imgThumb);
			txtDesc.setText(curDB.getString(3));
			//txtTitle.setText(curDB.getString(4));
			txtDate.setText(curDB.getString(7));
			boolean bShowFullScreenButton=false;
			if (!curDB.getString(5).equals("")){
				String sMedia;
				switch (curDB.getInt(6))
				{
				case GOMEE_TYPE_GRAFFITI:
					sMedia = getFilesDir().getPath()+"/"+curDB.getString(5);
					break;
				default:
					sMedia = getFilesDir().getPath()+"/"+THUMB_PREFIX+curDB.getString(5);
					break;
				}
				File ff = new File(sMedia);
				if (ff.exists()){
					bShowFullScreenButton=true;
					bm=BitmapFactory.decodeFile(sMedia);
					img.setImageBitmap(bm);
				
				}
			}
			
			AlertDialog.Builder dlg = new AlertDialog.Builder(YoGoMap.this);
			dlg.setTitle(curDB.getString(4));
			dlg.setView(addView);
			
			if (bShowFullScreenButton){
				dlg.setNeutralButton("Full Screen", new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog,int whichButton) {
						Intent intent = new Intent(YoGoMap.this, FullScreenImage.class);
						switch (curDB.getInt(6))
						{
						case GOMEE_TYPE_GRAFFITI:
							intent.setAction(getFilesDir().getPath()+"/"+curDB.getString(5));
							break;
						default:
							intent.setAction(getFilesDir().getPath()+"/"+THUMB_PREFIX+curDB.getString(5));
							break;
						}						
						startActivity(intent);
					}
				});
			}
			dlg.setPositiveButton(R.string.ok, new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog,int whichButton) {
					nm.cancelAll();
					removeDialog(DIALOG_GOMEE_POPUP);
				}
			});
			return dlg.create();
			
        case DIALOG_MESSAGE:
        	return new AlertDialog.Builder(YoGoMap.this)
            .setIcon(R.drawable.alert_dialog_icon)
            .setMessage(sMessage)
            .setPositiveButton(R.string.alert_dialog_ok, new DialogInterface.OnClickListener() {
                public void onClick(DialogInterface dialog, int whichButton) {

                    /* User clicked OK so do some stuff */
                }
            })
            .create();
        case DIALOG_GOMEE_IMAGE:
        case DIALOG_GOMEE_TEXT:
        	SharedPreferences settings = getSharedPreferences(PREF_FILE, 0);
        	String sImgThumb=settings.getString(PREF_CUR_IMAGE_THUMB, "");
        	
    		inflater=LayoutInflater.from(this);
    		
    		if (sImgThumb.equals(""))
    			addView=inflater.inflate(R.layout.gomee_text, null);
    		else{
    			Uri uri = new Uri.Builder().path(sImgThumb).build(); 
    			addView=inflater.inflate(R.layout.gomee_image, null);
    			img = (ImageView)addView.findViewById(R.id.img);
    			img.setImageURI(uri);
    		}
    		final DialogWrapper wrapper=new DialogWrapper(addView);

    		if (curLoc!=null){
    			fLon = curLoc.getLongitude();
    			fLat = curLoc.getLatitude();
    		}
    		else
    		{
    			String sCurLoc=settings.getString(PREF_CUR_LOC, "");
    			if (sCurLoc.equals("")){
    				sMessage = getString(R.string.msg_no_location);
    				showDialog(DIALOG_MESSAGE);
    				return null;
    			}
    			else{
	    			String sLon=sCurLoc.substring(sCurLoc.lastIndexOf(";")+1);
	    			String sLat=sCurLoc.substring(0,sCurLoc.lastIndexOf(";"));
	    			fLat = Double.parseDouble(sLat);
	    			fLon = Double.parseDouble(sLon);
    			}
    		}

    		return new AlertDialog.Builder(this)
			.setTitle(R.string.add_gomee)
			.setView(addView)
			.setPositiveButton(R.string.ok, new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog,int whichButton) {
		        	SharedPreferences settings = getSharedPreferences(PREF_FILE, 0);
		        	String sImg=settings.getString(PREF_CUR_IMAGE_NORMAL, "");
		        	if (sImg.equals("")){
		        		SaveGoMee(wrapper.getTitle(), wrapper.getDescription(), GOMEE_TYPE_TEXT, fLat, fLon, sImg);
		        		removeDialog(DIALOG_GOMEE_TEXT);
		        	}
		        	else{
		        		SimpleDateFormat timeStampFormat = new SimpleDateFormat("yyyyMMddHHmmssSS");
		        		sFile = timeStampFormat.format(new Date())+".jpg";
		        		SaveGoMee(wrapper.getTitle(), wrapper.getDescription(), GOMEE_TYPE_MEDIA, fLat, fLon, sFile);
		        		runThreadSaveImg();
		        		removeDialog(DIALOG_GOMEE_IMAGE);
		        	}
				}
				 
			})
			.setNegativeButton(R.string.cancel, new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog,int whichButton) {
		    	    /*SharedPreferences.Editor editor = getSharedPreferences(PREF_FILE, 0).edit();
					editor.putString(PREF_CUR_IMAGE_NORMAL, "");
					editor.putString(PREF_CUR_IMAGE_THUMB, "");
		            editor.commit();
		            SharedPreferences settings = getSharedPreferences(PREF_FILE, 0);
		            String sImg=settings.getString(PREF_CUR_IMAGE_NORMAL, "");
		            removeDialog(DIALOG_GOMEE_IMAGE);
		            removeDialog(DIALOG_GOMEE_TEXT);*/
				}
			})
			.create();
        case DIALOG_GOMEE_TYPE:
        	return new AlertDialog.Builder(YoGoMap.this)
            .setTitle(R.string.title_gomee_type)
            .setItems(R.array.gomee_types, new DialogInterface.OnClickListener() {
                public void onClick(DialogInterface dialog, int which) {

                    switch (which){
                    case 0:	// Text
                    	showDialog(DIALOG_GOMEE_TEXT);
                    	break;
                    case 1: // Capture image
                    	AddGoMeeCaptureImg();
                    	break;
                    case 2:	// Select image
                    	AddGoMeeImgFile();
                    	break;
                    case 3:	// Select video
                    	break;
                    case 4: // Murales
                    	ShowMurales();
                    	SaveGoMee("", "", GOMEE_TYPE_GRAFFITI, fLat, fLon, "graffiti.jpg");
                    	break;
                    case 5: // Files
                    	Intent i = new Intent();
            			i.setClass(getApplicationContext(), FileBrowser.class);
            			startActivity(i);
                    	break;
                    case 6:	// Wall
                    	break;
                    case 7: // Link
                    	break;
                    }
                }
            })
            .create();
        
        }
        return null;
	}
	
	
    public void ShowNotification(int iPosition) {

        // The PendingIntent to launch our activity if the user selects this notification
        PendingIntent contentIntent = PendingIntent.getActivity(this, 0, new Intent(this, YoGoMap.class), 0);

        curDB.moveToPosition(iPosition);
        // construct the Notification object.
        Notification notif = new Notification(R.drawable.marker, getString(R.string.gomee)+" "+curDB.getString(4), System.currentTimeMillis());
     // Set the info for the views that show in the notification panel.
        notif.setLatestEventInfo(this, curDB.getString(4),curDB.getString(3), contentIntent);
        //notif.defaults = Notification.DEFAULT_VIBRATE;
        nm.notify(R.layout.yogomap, notif);
        /*Vibrator vibrator = (Vibrator)getSystemService(Context.VIBRATOR_SERVICE);
        vibrator.vibrate(500); */
        
    }
	/*************************************************************************/
	//GoMeeListener
	/*************************************************************************/
	public class GoMeeListener extends BroadcastReceiver {
		
		@Override
		public void onReceive(Context context, Intent intent) {
			String intentAction = intent.getAction();
			
	        //Log.d("DEBUG", "Broadcast received"+intentAction);
	        
	        
	        if (intentAction.equals("com.android.yogome.action.PROXIMITY_ALERT")) {
	            Bundle b=intent.getExtras();
	            boolean bIn=b.getBoolean(LocationManager.KEY_PROXIMITY_ENTERING, false);
	            int iCursor = b.getInt("POSITION");
	            /*if (bIn)
	            	Toast.makeText(context, "IN", Toast.LENGTH_SHORT).show();
	            else
	            	Toast.makeText(context, "OUT", Toast.LENGTH_SHORT).show();*/
	            if (bIn){
	            	Log.d("GOMEEEEE", "SONO DENTRO:"+iCursor);
	            	//MediaPlayer mMediaPlayer = MediaPlayer.create(context, R.raw.proximity_alert);
	                //mMediaPlayer.start();
	                MediaPlayer mp = new MediaPlayer();
	                String sTone=prefs.getString(getString(R.string.ringtone_alert), "");
	                try{
		                mp.setDataSource(sTone);
		                mp.prepare();
		                mp.start();
		            }
	    			catch(IOException ex){
	    	    	}	                
	                
	                YoGoMap.this.ShowGoMee(iCursor);
	                YoGoMap.this.ShowNotification(iCursor);
	            }
	            else
	            	Log.d("GOMEEEEE", "SONO FUORI:"+iCursor);
	        } 
		}
	}
	
}