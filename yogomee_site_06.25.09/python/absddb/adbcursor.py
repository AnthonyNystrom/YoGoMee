import bsddb.db as db
import absddb.pool as pool

class ADBCursor(object):
    
    def __init__(self, cursor):
        self.__cursor = cursor
        
    def close(self):
        """Discards the cursor. If the cursor is created within a
        transaction then you must be sure to close the cursor before commiting the transaction.
        """
        return pool.invoke(self.__cursor.close)
    
    def count(self, flags=0):
        """Returns a count of the number of duplicate data items for the key referenced by the cursor.
        """
        return pool.invoke(self.__cursor.count, flags)
    
    def delete(self, flags=0):
        """Deletes the key/data pair currently referenced by the cursor.
        """
        return pool.invoke(self.__cursor.delete, flags)
    
    def dup(self, flags=0):
        """Create a new cursor.
        """
        def dup_syc(flags):
            return ADBCursor(self.__cursor.dup(flags))
        return pool.invoke(dup_syc, flags)
    
    def put(self, key, data, flags=0, dlen=-1, doff=-1):
        """Stores the key/data pair into the database. Partial data records
        can be written using dlen and doff.
        """
        return pool.invoke(self.__cursor.put, key, data, flags, dlen, doff)
    
    def get(self, flags, dlen=-1, doff=-1):
        """See get(key, data, flags, dlen=-1, doff=-1)
        """
        return pool.invoke(self.__cursor.get, flags, dlen, doff)
    
    def get(self, key, flags, dlen=-1, doff=-1):
        """See get(key, data, flags, dlen=-1, doff=-1)
        """
        return pool.invoke(self.__cursor.get, key, flags, dlen, doff)
    
    def get(self, key, data, flags, dlen=-1, doff=-1):
        """Retrieves key/data pairs from the database using the cursor.
        All the specific functionalities of the get method are actually
        provided by the various methods below, which are the preferred way
        to fetch data using the cursor. These generic interfaces are only
        provided as an inconvenience. Partial data records are returned if
        dlen and doff are used in this method and in many of the specific
        methods below.
        """
        return pool.invoke(self.__cursor.get, key, data, flags, dlen, doff)
    
    def pget(self, flags, dlen=-1, doff=-1):
        """See pget(key, data, flags, dlen=-1, doff=-1)
        """
        return pool.invoke(self.__cursor.pget, flags, dlen, doff)
    
    def pget_(self, key, flags, dlen=-1, doff=-1):
        """See pget(key, data, flags, dlen=-1, doff=-1)
        """
        return pool.invoke(self.__cursor.pget, key, flags, dlen, doff)
    
    def pget(self, key, data, flags, dlen=-1, doff=-1):
        """Similar to the already described get(). This method is available only
        on secondary databases. It will return the primary key, given the secondary
        one, and associated data
        """
        return pool.invoke(self.__cursor.pget, key, data, flags, dlen, doff)
    
    def current(self, flags=0, dlen=-1, doff=-1):
        """Returns the key/data pair currently referenced by the cursor.
        """
        return pool.invoke(self.__cursor.current, flags, dlen, doff)
    
    def get_current_size(self):
        """Returns length of the data for the current entry referenced by the cursor.
        """
        return pool.invoke(self.__cursor.get_current_size)
    
    def first(self, flags=0, dlen=-1, doff=-1):
        """Position the cursor to the first key/data pair and return it.
        """
        return pool.invoke(self.__cursor.first, flags, dlen, doff)
    
    def last(self, flags=0, dlen=-1, doff=-1):
        """Position the cursor to the last key/data pair and return it.
        """
        return pool.invoke(self.__cursor.last, flags, dlen, doff)
    
    def next(self, flags=0, dlen=-1, doff=-1):
        """Position the cursor to the next key/data pair and return it.
        """
        return pool.invoke(self.__cursor.next, flags, dlen, doff)
    
    def prev(self, flags=0, dlen=-1, doff=-1):
        """Position the cursor to the previous key/data pair and return it.
        """
        return pool.invoke(self.__cursor.prev, flags, dlen, doff)
    
    def consume(self, flags=0, dlen=-1, doff=-1):
        """    For a database with the Queue access method, returns the record
        number and data from the first available record and deletes it from the queue.

        NOTE: This method is deprecated in Berkeley DB version 3.2 in favor of the
        new consume method in the DB class.
        """
        return pool.invoke(self.__cursor.consume, flags, dlen, doff)
    
    def get_both(self, key, data, flags=0):
        """Like set() but positions the cursor to the record matching both key and data.
        """
        return pool.invoke(self.__cursor.get_both, key, data, flags)
    
    def get_recno(self):
        """Return the record number associated with the cursor. The database must
        use the BTree access method and have been created with the DB_RECNUM flag.
        """
        return pool.invoke(self.__cursor.get_recno)
    
    def join_item(self, flags=0):
        """For cursors returned from the DB.join method, returns the combined key
        value from the joined cursors.
        """
        return pool.invoke(self.__cursor.join_item, flags)
    
    def next_dup(self, flags=0, dlen=-1, doff=-1):
        """If the next key/data pair of the database is a duplicate record for the
        current key/data pair, the cursor is moved to the next key/data pair of the
        database, and that pair is returned.
        """
        return pool.invoke(self.__cursor.next_dup, flags, dlen, doff)
    
    def next_nodup(self, flags=0, dlen=-1, doff=-1):
        """The cursor is moved to the next non-duplicate key/data pair of the database,
        and that pair is returned.
        """
        return pool.invoke(self.__cursor.next_nodup, flags, dlen, doff)
    
    def prev_nodup(self, flags=0, dlen=-1, doff=-1):
        """The cursor is moved to the previous non-duplicate key/data pair of the
        database, and that pair is returned.
        """
        return pool.invoke(self.__cursor.prev_nodup, flags, dlen, doff)
    
    def set(self, key, flags=0, dlen=-1, doff=-1):
        """Move the cursor to the specified key in the database and return the
        key/data pair found there.
        """
        return pool.invoke(self.__cursor.set, key, flags, dlen, doff)
    
    def set_range(self, key, flags=0, dlen=-1, doff=-1):
        """Identical to set() except that in the case of the BTree access method,
        the returned key/data pair is the smallest key greater than or equal to the
        specified key (as determined by the comparison function), permitting partial
        key matches and range searches.
        """
        return pool.invoke(self.__cursor.set_range, key, flags, dlen, doff)
    
    def set_recno(self, recno, flags=0, dlen=-1, doff=-1):
        """Move the cursor to the specific numbered record of the database, and return
        the associated key/data pair. The underlying database must be of type Btree and
        it must have been created with the DB_RECNUM flag.
        """
        return pool.invoke(self.__cursor.set_recno, recno, flags, dlen, doff)
    
    def set_both(self, key, data, flags=0):
        """See get_both(). The only difference in behaviour can be disabled using
        set_get_returns_none(2).
        """
        return pool.invoke(self.__cursor.set_both, key, data, flags)