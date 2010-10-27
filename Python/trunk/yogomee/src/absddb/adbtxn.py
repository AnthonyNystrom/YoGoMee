import bsddb.db as db
import absddb.pool as pool

class ADBTxn(object):
    
    def __init__(self, txn):
        self.__txn = txn
        
    def abort(self):
        """Aborts the transaction.
        """
        return pool.invoke(self.__txn.abort)
    
    def commit(self, flags=0):
        """Ends the transaction, committing any changes to the databases.
        """
        return pool.invoke(self.__txn.commit, flags)
    
    def id(self):
        """The txn_id function returns the unique transaction id associated
        with the specified transaction.
        """
        return pool.invoke(self.__txn.id)
    
    def prepare(self, gid):
        """Initiates the beginning of a two-phase commit. Begining with
        Berkeley DB 3.3 a global identifier paramater is required, which
        is a value unique across all processes involved in the commit. It
        must be a string of DB_XIDDATASIZE bytes.
        """
        return pool.invoke(self.__txn.prepare, gid)
    
    def discard(self):
        """This method frees up all the per-process resources associated with
        the specified transaction, neither committing nor aborting the transaction.
        The transaction will be keep in "unresolved" state. This call may be used
        only after calls to "dbenv.txn_recover()". A "unresolved" transaction will
        be returned again thru new calls to "dbenv.txn_recover()".

        For example, when there are multiple global transaction managers recovering
        transactions in a single Berkeley DB environment, any transactions returned
        by "dbenv.txn_recover()" that are not handled by the current global transaction
        manager should be discarded using "txn.discard()"
        """
        return pool.invoke(self.__txn.discard)
    
    def set_timeout(self, timeout, flags):
        """Sets timeout values for locks or transactions for the specified transaction.
        """
        return pool.invoke(self.__txn.set_timeout, timeout, flags)
    
    def get_name(self, name):
        """Returns the string associated with the transaction.
        """
        return pool.invoke(self.__txn.get_name, name)
    
    def set_name(self, name):
        """Associates the specified string with the transaction.
        """
        return pool.invoke(self.__txn.set_name, name)