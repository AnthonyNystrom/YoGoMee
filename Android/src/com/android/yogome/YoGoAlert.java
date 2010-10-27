package com.android.yogome;


import android.app.AlertDialog;
import android.app.ListActivity;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.database.Cursor;
import android.os.Bundle;
import android.view.ContextMenu;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.view.ContextMenu.ContextMenuInfo;
import android.widget.BaseAdapter;
import android.widget.TextView;
import android.widget.ImageView;
import android.graphics.BitmapFactory;
import android.graphics.Bitmap;
import android.widget.ListView;
import android.widget.AdapterView.AdapterContextMenuInfo;
import android.app.Dialog;


import com.android.yogome.R;

public class YoGoAlert extends ListActivity {
    private YoGoDB Db;
    public Cursor curDB;
    EfficientAdapter list; 
    public String sGoMeeSelected;
    
    static final int DIALOG_GOMEE_DELETE = 0;
    static final int DIALOG_GOMEE_TEXT = 1;

    
    private static class EfficientAdapter extends BaseAdapter {
        private LayoutInflater mInflater;
        private Bitmap mIconText;
        private Bitmap mIconImage;
        private Bitmap mIconVideo;
        private Bitmap mIconGraffiti;
        private Bitmap mIconWall;
        private Bitmap mIconLink;
        private Bitmap mIconFile;
        YoGoAlert act;

        public EfficientAdapter(Context context) {
        	act = (YoGoAlert)context;
            // Cache the LayoutInflate to avoid asking for a new one each time.
            mInflater = LayoutInflater.from(context);

            // Icons bound to the rows.
            mIconText 		= BitmapFactory.decodeResource(context.getResources(), R.drawable.text);
            mIconImage 		= BitmapFactory.decodeResource(context.getResources(), R.drawable.image);
            mIconVideo 		= BitmapFactory.decodeResource(context.getResources(), R.drawable.video);
            mIconGraffiti 	= BitmapFactory.decodeResource(context.getResources(), R.drawable.mural);
            mIconWall 		= BitmapFactory.decodeResource(context.getResources(), R.drawable.wall);
            mIconLink 		= BitmapFactory.decodeResource(context.getResources(), R.drawable.link);
            mIconFile 		= BitmapFactory.decodeResource(context.getResources(), R.drawable.files);
        }

        /**
         * The number of items in the list is determined by the number of speeches
         * in our array.
         *
         * @see android.widget.ListAdapter#getCount()
         */
        public int getCount() {
            return act.curDB.getCount();
        }

        /**
         * Since the data comes from an array, just returning the index is
         * sufficent to get at the data. If we were using a more complex data
         * structure, we would return whatever object represents one row in the
         * list.
         *
         * @see android.widget.ListAdapter#getItem(int)
         */
        public Object getItem(int position) {
            return position;
        }

        /**
         * Use the array index as a unique id.
         *
         * @see android.widget.ListAdapter#getItemId(int)
         */
        public long getItemId(int position) {
            return position;
        }

        /**
         * Make a view to hold each row.
         *
         * @see android.widget.ListAdapter#getView(int, android.view.View,
         *      android.view.ViewGroup)
         */
        public View getView(int position, View convertView, ViewGroup parent) {
            // A ViewHolder keeps references to children views to avoid unneccessary calls
            // to findViewById() on each row.
            ViewHolder holder;

            // When convertView is not null, we can reuse it directly, there is no need
            // to reinflate it. We only inflate a new View when the convertView supplied
            // by ListView is null.
            if (convertView == null) {
                convertView = mInflater.inflate(R.layout.yogoalert, null);

                // Creates a ViewHolder and store references to the two children views
                // we want to bind data to.
                holder = new ViewHolder();
                holder.title = (TextView) convertView.findViewById(R.id.txtTitle);
                holder.description = (TextView) convertView.findViewById(R.id.txtDesc);
                holder.icon = (ImageView) convertView.findViewById(R.id.icon);

                convertView.setTag(holder);
            } else {
                // Get the ViewHolder back to get fast access to the TextView
                // and the ImageView.
                holder = (ViewHolder) convertView.getTag();
            }

            
            act.curDB.moveToPosition(position);
            // Bind the data efficiently with the holder.
            holder.title.setText(act.curDB.getString(4));
            holder.description.setText(act.curDB.getString(3));
            switch (act.curDB.getInt(6)){
            case YoGoMap.GOMEE_TYPE_TEXT:
            	holder.icon.setImageBitmap(mIconText);
            	break;
            case YoGoMap.GOMEE_TYPE_MEDIA:
            	holder.icon.setImageBitmap(mIconImage);
            	break;
            case YoGoMap.GOMEE_TYPE_VIDEO:
            	holder.icon.setImageBitmap(mIconVideo);
            	break;
            case YoGoMap.GOMEE_TYPE_GRAFFITI:
            	holder.icon.setImageBitmap(mIconGraffiti);
            	break;
            case YoGoMap.GOMEE_TYPE_WALL:
            	holder.icon.setImageBitmap(mIconWall);
            	break;
            case YoGoMap.GOMEE_TYPE_LINK:
            	holder.icon.setImageBitmap(mIconLink);
            	break;
            case YoGoMap.GOMEE_TYPE_FILE:
            	holder.icon.setImageBitmap(mIconFile);
            	break;
            default:
            	holder.icon.setImageBitmap(mIconText);
            	break;
        	}
            return convertView;
        }

        static class ViewHolder {
            TextView title;
            TextView description;
            ImageView icon;
        }
        public void RefrehList(){
        	notifyDataSetChanged();
        }
    }

    protected void onListItemClick(ListView l, View v, int position, long id) {
    	super.onListItemClick(l, v, position, id);
    	curDB.moveToPosition(position);
    	setResult(RESULT_OK, (new Intent()).setAction(curDB.getDouble(1)+";"+curDB.getDouble(2)));
    	finish();
    }
	@Override
	protected void onDestroy() {
		super.onDestroy();
		curDB.close();
		Db.close();
	}
    
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    	Db = new YoGoDB(this);
        Db.open();
        curDB = Db.fetchAllPoints();
        curDB.moveToFirst();
     // Inform the list we provide context menus for items
        getListView().setOnCreateContextMenuListener(this);
        list = new EfficientAdapter(this);
        setListAdapter(list);
    }
    
    public void RefrehList(){
    	list.RefrehList();
    }
    
    public static final int MENU_ITEM_DELETE = Menu.FIRST+1;
    public static final int MENU_ITEM_EDIT_TITLE = Menu.FIRST+2;
    public static final int MENU_ITEM_EDIT_PICTURE = Menu.FIRST+3;
    @Override
    public void onCreateContextMenu(ContextMenu menu, View view, ContextMenuInfo menuInfo) {
        menu.add(0, MENU_ITEM_DELETE, 0, "Delete");
        menu.add(0, MENU_ITEM_EDIT_TITLE, 0, "Edit Title");
        menu.add(0, MENU_ITEM_EDIT_PICTURE, 0, "Edit Picture");
    }
    @Override
    public boolean onContextItemSelected(MenuItem item) {
    	AdapterContextMenuInfo info = (AdapterContextMenuInfo) item.getMenuInfo();
    	curDB.moveToPosition(info.position);
        switch (item.getItemId()) {
        	case MENU_ITEM_DELETE:
        		showDialog(DIALOG_GOMEE_DELETE);
        		break;
        	case MENU_ITEM_EDIT_TITLE:
        		showDialog(DIALOG_GOMEE_TEXT);
        		break;
        	
        }
        return true;
    }       
    @Override
    protected Dialog onCreateDialog(int id) {
    	String sMsg;
        switch (id) {
        case DIALOG_GOMEE_TEXT:
        	LayoutInflater inflater=LayoutInflater.from(this);
    		
        	View addView=inflater.inflate(R.layout.gomee_text, null);
    		final DialogWrapper wrapper=new DialogWrapper(addView, curDB.getString(4), curDB.getString(3));

    		return new AlertDialog.Builder(this)
			.setTitle(R.string.add_gomee)
			.setView(addView)
			.setPositiveButton(R.string.ok, new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog,int whichButton) {
					Db.UpdateTitleDescPoint(curDB.getLong(0), wrapper.getTitle(), wrapper.getDescription());
					curDB.requery();
					list.RefrehList();
					removeDialog(DIALOG_GOMEE_TEXT);
				}
			})
			.setNegativeButton(R.string.cancel, new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog,int whichButton) {
		            removeDialog(DIALOG_GOMEE_TEXT);
				}
			})
			.create();        
            case DIALOG_GOMEE_DELETE:
            	sMsg = getString(R.string.msg_delete_gomee)+" \n' "+curDB.getString(4)+" ' ?";
            	return new AlertDialog.Builder(YoGoAlert.this)
                .setIcon(R.drawable.alert_dialog_icon)
                .setTitle(R.string.title_delete_gomee)
                .setMessage(sMsg)
                .setPositiveButton(R.string.alert_dialog_ok, new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int whichButton) {
                        Db.deletePoint(curDB.getLong(0));
                        curDB.requery();
                        list.RefrehList();
                        removeDialog(DIALOG_GOMEE_DELETE);
                    }
                })
                .setNegativeButton(R.string.alert_dialog_cancel, new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int whichButton) {
                    	removeDialog(DIALOG_GOMEE_DELETE);
                        /* User clicked Cancel so do some stuff */
                    }
                })
                .create();        }
        return null;
    }

}
