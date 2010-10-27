import bsddb.db as db
import absddb.pool as pool
from absddb.adb import ADB
from absddb.adbtxn import ADBTxn

class ADBSequence(object):
    """Sequences provide an arbitrary number of persistent objects that return an increasing
    or decreasing sequence of integers. Opening a sequence handle associates it with a record
    in a database. The handle can maintain a cache of values from the database so that a
    database update is not needed as the application allocates a value.
    """
    
    def __init__(self, adb, flags=0):
        self.__db = adb
        self.__seq = db.DBSequence(adb._ADB__db, flags)
        
    def open(self, key, txn=None, flags=0):
        """Opens the sequence represented by the key.
        """
        return pool.invoke(self.__seq.open, key, txn and txn._ADBTxn__txn, flags)
    
    def close(self, flags=0):
        """Close a DBSequence handle.
        """
        return pool.invoke(self.__seq.close, flags)
    
    def initial_value(self, value):
        """Set the initial value for a sequence. This call is only effective when the
        sequence is being created.
        """
        return pool.invoke(self.__seq.initial_value, value)
    
    def get(self, delta=1, txn=None, flags=0):
        """Returns the next available element in the sequence and changes the sequence value by delta.
        """
        return pool.invoke(self.__seq.get, delta, txn and txn._ADBTxn__txn, flags)
    
    def get_dbp(self):
        """Returns the DB object associated to the DBSequence.
        """
        def get_dbp_sync():
            return self.__db
        return pool.invoke(get_dbp_sync)
    
    def get_key(self):
        """Returns the key for the sequence.
        """
        return pool.invoke(self.__seq.get_key)
    
    def remove(self, txn=None, flags=0):
        """Removes the sequence from the database. This method should not be called if there
        are other open handles on this sequence.
        """
        return pool.invoke(self.__seq.remove, txn and txn._ADBTxn__txn, flags)
    
    def get_cachesize(self):
        """Returns the current cache size.
        """
        return pool.invoke(self.__seq.get_cachesize)
    
    def set_cachesize(self, size):
        """Configure the number of elements cached by a sequence handle.
        """
        return pool.invoke(self.__seq.set_cachesize, size)
    
    def get_flags(self):
        """Returns the current flags.
        """
        return pool.invoke(self.__seq.get_flags)
    
    def set_flags(self, flags):
        """Configure a sequence.
        """
        return pool.invoke(self.__seq.set_flags, flags)
    
    def stat(self, flags=0):
        """Returns a dictionary of sequence statistics.
        """
        return pool.invoke(self.__seq.stat, flags)
    
    def stat_print(self, flags=0):
        """Prints diagnostic information.
        """
        return pool.invoke(self.__seq.stat_print, flags)
    
    def get_range(self):
        """Returns a tuple representing the range of values in the sequence.
        """
        return pool.invoke(self.__seq.get_range)
    
    def set_range(self, (min, max)):
        """Configure a sequence range.
        """
        return pool.invoke(self.__seq.set_range, (min, max))