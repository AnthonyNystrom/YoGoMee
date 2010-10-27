import bsddb.db as db
import absddb.pool as pool
from absddb.adbtxn import ADBTxn
from absddb.adbcursor import ADBCursor

class ADB(object):
    
    def __init__(self, dbEnv=None, flags=0):
        self.__db = db.DB(dbEnv and dbEnv._ADBEnv__dbenv, flags)
        
    def append(self, data, txn=None):
        """A convenient version of put() that can be used for Recno
        or Queue databases. The DB_APPEND flag is automatically used,
        and the record number is returned.
        """
        return pool.invoke(self.__db.append, data, txn and txn._ADBTxn__txn)
    
    def associate(self, secondaryDB, callback, flags=0, txn=None):
        """Used to associate secondaryDB to act as a secondary index for
        this (primary) database. The callback parameter should be a reference
        to a Python callable object that will construct and return the secondary
        key or DB_DONOTINDEX if the item should not be indexed. The parameters
        the callback will receive are the primaryKey and primaryData values.
        """
        return pool.invoke(self.__db.associate, secondaryDB and secondaryDB._ADB__db, callback, flags, txn and txn._ADBTxn__txn)
    
    def close(self, flags=0):
        """Flushes cached data and closes the database.
        """
        return pool.invoke(self.__db.close, flags)
    
    def compact(self, start=None, stop=None, flags=0, compact_fillpercent=0, compact_pages=0, compact_timeout=0):
        """Compacts Btree and Recno access method databases, and optionally returns
        unused Btree, Hash or Recno database pages to the underlying filesystem.

        The method returns the number of pages returned to the filesystem.
        """
        return pool.invoke(self.__db.compact, start, stop, flags, compact_fillpercent, compact_pages, compact_timeout)
    
    def consume(self, txn=None, flags=0):
        """For a database with the Queue access method, returns the record number
        and data from the first available record and deletes it from the queue.
        """
        return pool.invoke(self.__db.consume, txn and txn._ADBTxn__txn, flags)
    
    def consume_wait(self, txn=None, flags=0):
        """For a database with the Queue access method, returns the record number
        and data from the first available record and deletes it from the queue.
        If the Queue database is empty, the thread of control will wait until there
        is data in the queue before returning.
        """
        return pool.invoke(self.__db.consume_wait, txn and txn._ADBTxn__txn, flags)
    
    def cursor(self, txn=None, flags=0):
        """Create a cursor on the DB and returns a DBCursor object. If a transaction
        is passed then the cursor can only be used within that transaction and you must
        be sure to close the cursor before commiting the transaction.
        """
        def cursor_sync(txn, flags):
            return ADBCursor(self.__db.cursor(txn and txn._ADBTxn__txn, flags))
        return pool.invoke(cursor_sync, txn, flags)
    
    def delete(self, key, txn=None, flags=0):
        """Removes a key/data pair from the database.
        """
        return pool.invoke(self.__db.delete, key, txn and txn._ADBTxn__txn, flags)
    
    def exists(self, key, txn=None, flags=0):
        """Test if a key exists in the database. Returns True or False.
        """
        return pool.invoke(self.__db.has_key, key)
    
    def fd(self):
        """Returns a file descriptor for the database.
        """
        return pool.invoke(self.__db.fd)
    
    def get(self, key, default=None, txn=None, flags=0, dlen=-1, doff=-1):
        """Returns the data object associated with key. If key is an integer then
        the DB_SET_RECNO flag is automatically set for BTree databases and the actual
        key and the data value are returned as a tuple. If default is given then it
        is returned if the key is not found in the database. Partial records can be read
        using dlen and doff, however be sure to not read beyond the end of the actual
        data or you may get garbage.
        """
        return pool.invoke(self.__db.get, key, default, txn and txn._ADBTxn__txn, flags, dlen, doff)
    
    def pget(self, key, default=None, txn=None, flags=0, dlen=-1, doff=-1):
        """This method is available only on secondary databases. It will return the
        primary key, given the secondary one, and associated data.
        """
        return pool.invoke(self.__db.pget, key, default, txn and txn._ADBTxn__txn, flags, dlen, doff)
    
    def set_private(self, object):
        """Link an arbitrary object to the DB.
        """
        return pool.invoke(self.__db.set_private, object)
    
    def get_private(self):
        """Give the object linked to the DB.
        """
        return pool.invoke(self.__db.get_private)
    
    def get_both(self, key, data, txn=None, flags=0):
        """A convenient version of get() that automatically sets the DB_GET_BOTH flag, and which
        will be successful only if both the key and data value are found in the database.
        (Can be used to verify the presence of a record in the database when duplicate keys are allowed.)
        """
        return pool.invoke(self.__db.get_both, key, data, txn and txn._ADBTxn__txn, flags)
    
    def get_byteswapped(self):
        """May be used to determine if the database was created on a machine with the same endianess as
        the current machine.
        """
        return pool.invoke(self.__db.get_byteswapped)
    
    def get_size(self, key, txn=None):
        """Return the size of the data object associated with key.
        """
        return pool.invoke(self.__db.get_size, key, txn and txn._ADBTxn__txn)
    
    def get_type(self):
        """Return the database's access method type.
        """
        return pool.invoke(self.__db.get_type)
    
    def join(self, cursorList, flags=0):
        """Create and return a specialized cursor for use in performing joins on secondary indices.
        """
        def join_sync(cursorList, flags):
            return ADBCursor(self.__db.join(map(cursorList, lambda cursor: cursor._ADBCursor__cursor), flags))
        return pool.invoke(join_sync, cursorList, flags)
    
    def key_range(self, key, txn=None, flags=0):
        """Returns an estimate of the proportion of keys that are less than, equal to and
        greater than the specified key.
        """
        return pool.invoke(self.__db.key_range, key, txn and txn._ADBTxn__txn, flags)
    
    def open(self, filename, dbname=None, dbtype=db.DB_UNKNOWN, flags=0, mode=0660, txn=None):
        """Opens the database named dbname in the file named filename. The dbname argument is optional
        and allows applications to have multiple logical databases in a single physical file. It is an
        error to attempt to open a second database in a file that was not initially created using a
        database name. In-memory databases never intended to be shared or preserved on disk may be
        created by setting both the filename and dbname arguments to None.
        """
        return pool.invoke(self.__db.open, filename, dbname, dbtype, flags, mode, txn and txn._ADBTxn__txn)
    
    def put(self, key, data, txn=None, flags=0, dlen=-1, doff=-1):
        """Stores the key/data pair in the database. If the DB_APPEND flag is used and the database
        is using the Recno or Queue access method then the record number allocated to the data is returned.
        Partial data objects can be written using dlen and doff.
        """
        return pool.invoke(self.__db.put, key, data, txn and txn._ADBTxn__txn, flags, dlen, doff)
    
    def remove(self, filename, dbname=None, flags=0):
        """Remove a database.
        """
        return pool.invoke(self.__db.remove, filename, dbname, flags)
    
    def rename(self, filename, dbname, newname, flags=0):
        """Rename a database.
        """
        return pool.invoke(self.__db.rename, filename, dbname, newname, flags)
    
    def set_encrypt(self, passwd, flags=0):
        """Set the password used by the Berkeley DB library to perform encryption and decryption.
        Because databases opened within Berkeley DB environments use the password specified to the
        environment, it is an error to attempt to set a password in a database created within an environment.
        """
        return pool.invoke(self.__db.set_encrypt, passwd, flags)
    
    def set_bt_compare(self, compareFunc):
        """Set the B-Tree database comparison function. This can only be called once before the database has
        been opened. compareFunc takes two arguments: (left key string, right key string) It must
        return a -1, 0, 1 integer similar to cmp. You can shoot your database in the foot, beware!
        Read the Berkeley DB docs for the full details of how the comparison function MUST behave.
        """
        return pool.invoke(self.__db.set_bt_compare, compareFunc)
    
    def set_bt_minkey(self, minKeys):
        """Set the minimum number of keys that will be stored on any single BTree page.
        """
        return pool.invoke(self.__db.set_bt_minkey, minKeys)
    
    def set_cachesize(self, gbytes, bytes, ncache=0):
        """Set the size of the database's shared memory buffer pool.
        """
        return pool.invoke(self.__db.set_cachesize, gbytes, bytes, ncache)
    
    def set_get_returns_none(self, flag):
        """Controls what get and related methods do when a key is not found.
        See the DBEnv set_get_returns_none documentation.
        The previous setting is returned.
        """
        return pool.invoke(self.__db.set_get_returns_none, flag)
    
    def set_flags(self, flags):
        """Set additional flags on the database before opening.
        """
        return pool.invoke(self.__db.set_flags, flags)
    
    def set_h_ffactor(self, ffactor):
        """Set the desired density within the hash table.
        """
        return pool.invoke(self.__db.set_h_ffactor, ffactor)
    
    def set_h_nelem(self, nelem):
        """Set an estimate of the final size of the hash table.
        """
        return pool.invoke(self.__db.set_h_nelem, nelem)
    
    def set_lorder(self, lorder):
        """Set the byte order for integers in the stored database metadata.
        """
        return pool.invoke(self.__db.set_lorder, lorder)
    
    def set_pagesize(self, pagesize):
        """Set the size of the pages used to hold items in the database, in bytes.
        """
        return pool.invoke(self.__db.set_pagesize, pagesize)
    
    def set_re_delim(self, delim):
        """Set the delimiting byte used to mark the end of a record in the backing
        source file for the Recno access method.
        """
        return pool.invoke(self.__db.set_re_delim, delim)
    
    def set_re_len(self, length):
        """For the Queue access method, specify that the records are of length length.
        For the Recno access method, specify that the records are fixed-length, not byte
        delimited, and are of length length.
        """
        return pool.invoke(self.__db.set_re_len, length)
    
    def set_re_pad(self, pad):
        """Set the padding character for short, fixed-length records for the Queue
        and Recno access methods.
        """
        return pool.invoke(self.__db.set_re_pad, pad)
    
    def set_re_source(self, source):
        """Set the underlying source file for the Recno access method.
        """
        return pool.invoke(self.__db.set_re_source, source)
    
    def set_q_extentsize(self, extentsize):
        """Set the size of the extents used to hold pages in a Queue database, specified
        as a number of pages. Each extent is created as a separate physical file. If no extent
        size is set, the default behavior is to create only a single underlying database file. 
        """
        return pool.invoke(self.__db.set_q_extentsize, extentsize)
    
    def stat(self, flags=0, txn=None):
        """Return a dictionary containing database statistics.
        """
        return pool.invoke(self.__db.stat, flags, txn and txn._ADBTxn__txn)
    
    def sync(self, flags=0):
        """Flushes any cached information to disk.
        """
        return pool.invoke(self.__db.sync, flags)
    
    def truncate(self, txn=None, flags=0):
        """Empties the database, discarding all records it contains. The number of records discarded
        from the database is returned.
        """
        return pool.invoke(self.__db.truncate, txn and txn._ADBTxn__txn, flags)
    
    def upgrade(self, filename, flags=0):
        """Upgrades all of the databases included in the file filename, if necessary.
        """
        return pool.invoke(self.__db.upgrade, filename, flags)
    
    def verify(self, filename, dbname=None, outfile=None, flags=0):
        """Verifies the integrity of all databases in the file specified by the filename argument, and
        optionally outputs the databases key/data pairs to a file.
        """
        return pool.invoke(self.__db.verify, filename, dbname, outfile, flags)