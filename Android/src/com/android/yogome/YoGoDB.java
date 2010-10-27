package com.android.yogome;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.SQLException;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;
import java.text.SimpleDateFormat;
import java.util.Date;

public class YoGoDB {

    public static final String KEY_GOMEE_ID = "_id";
    public static final String KEY_GOMEE_TYPE = "type";
    public static final String KEY_GOMEE_LAT = "lat";
    public static final String KEY_GOMEE_LON = "lon";
    public static final String KEY_GOMEE_TITLE = "title";
    public static final String KEY_GOMEE_DES = "description";
    public static final String KEY_GOMEE_MEDIA = "media_file";
    public static final String KEY_GOMEE_DATE = "date";
    
    
    private DatabaseHelper mDbHelper;
    private SQLiteDatabase mDb;

    private static final String DATABASE_NAME = "yogome";
    private static final String DATABASE_TABLE_GOMEE = "gomee";
    private static final int DATABASE_VERSION = 5;
    
    private static final String DATABASE_CREATE_TAB_GOMEE =
        "create table "+DATABASE_TABLE_GOMEE+" ("
        +KEY_GOMEE_ID+" integer primary key autoincrement, "
        +KEY_GOMEE_TYPE+" integer,"
        +KEY_GOMEE_DATE+" text,"
        +KEY_GOMEE_LAT+" real,"
        +KEY_GOMEE_LON+" real," 
        +KEY_GOMEE_TITLE+" text," 
        +KEY_GOMEE_DES+" text,"
    	+KEY_GOMEE_MEDIA+" text);";

    private final Context mCtx;

    private static class DatabaseHelper extends SQLiteOpenHelper {

        DatabaseHelper(Context context) {
            super(context, DATABASE_NAME, null, DATABASE_VERSION);
        }

        @Override
        public void onCreate(SQLiteDatabase db) {

        	try{
        		db.execSQL(DATABASE_CREATE_TAB_GOMEE);
            }
        	catch(SQLException ex){
        		Log.i("onCreate DB", ex.getMessage());
        	}
        }

        @Override
        public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
            db.execSQL("DROP TABLE IF EXISTS "+DATABASE_TABLE_GOMEE);
            onCreate(db);
        }
    }

    /**
     * Constructor - takes the context to allow the database to be
     * opened/created
     * 
     * @param ctx the Context within which to work
     */
    public YoGoDB(Context ctx) {
        this.mCtx = ctx;
    }

    
    public YoGoDB open() throws SQLException {
        mDbHelper = new DatabaseHelper(mCtx);
        mDb = mDbHelper.getWritableDatabase();
        return this;
    }
    
    public void close() {
        mDbHelper.close();
    }
    
    public long createPointItem(int iType, double fLat, double fLon, String sTitle, String sDes, String sMedia){
    	ContentValues initialValues = new ContentValues();
    	initialValues.put(KEY_GOMEE_TYPE, iType);
        initialValues.put(KEY_GOMEE_LAT, fLat);
        initialValues.put(KEY_GOMEE_LON, fLon);
        initialValues.put(KEY_GOMEE_TITLE, sTitle);
        initialValues.put(KEY_GOMEE_DES, sDes);
        initialValues.put(KEY_GOMEE_MEDIA, sMedia);
        
        SimpleDateFormat formatter = new SimpleDateFormat("E, dd MMM yyyy HH:mm:ss");
        String dateFormatted = formatter.format(new Date()); 
        initialValues.put(KEY_GOMEE_DATE, dateFormatted);

        return mDb.insert(DATABASE_TABLE_GOMEE, null, initialValues);
    }

    public boolean deletePoint(long rowId) {

        return mDb.delete(DATABASE_TABLE_GOMEE, KEY_GOMEE_ID + "=" + rowId, null) > 0;
    }
    
    public Cursor fetchAllPoints() {

        return mDb.query(DATABASE_TABLE_GOMEE, new String[] 
               {KEY_GOMEE_ID, 
        		KEY_GOMEE_LAT,
        		KEY_GOMEE_LON, 
        		KEY_GOMEE_DES,
        		KEY_GOMEE_TITLE,
        		KEY_GOMEE_MEDIA,
        		KEY_GOMEE_TYPE,
        		KEY_GOMEE_DATE,
        		}, null, null, null, null, null);
    }
    public boolean UpdateTitleDescPoint(long rowId, String sTitle, String sDesc){
        ContentValues args = new ContentValues();
        args.put(KEY_GOMEE_TITLE, sTitle);
        args.put(KEY_GOMEE_DES, sDesc);

        return mDb.update(DATABASE_TABLE_GOMEE, args, KEY_GOMEE_ID + "=" + rowId, null) > 0;
    }    
}
