import bsddb.db as db
import absddb.pool as pool
from absddb.adbtxn import ADBTxn

class ADBEnv(object):
    """Provides a Database Environment for more advanced database use.
    Apps using transactions, logging, concurrent access, etc. will
    need to have an environment object.
    """
    
    def __init__(self, flags=0):
        self.__dbenv = db.DBEnv(flags)
        
    def set_rpc_server(self, host, cl_timeout=0, sv_timeout=0):
        """Establishes a connection for this dbenv to a RPC server.
        """
        return pool.invoke(self.__dbenv.set_rpc_server, host, cl_timeout, sv_timeout)
        
    def close(self, flags=0):
        """Close the database environment, freeing resources.
        """
        return pool.invoke(self.__dbenv.close, flags)
        
    def open(self, homedir, flags=0, mode=0660):
        """Prepare the database environment for use.
        """
        return pool.invoke(self.__dbenv.open, homedir, flags, mode)
        
    def remove(self, homedir, flags=0):
        """Remove a database environment.
        """
        return pool.invoke(self.__dbenv.remove, homedir, flags)
        
    def dbremove(self, file, database=None, txn=None, flags=0):
        """Removes the database specified by the file and database parameters.
        If no database is specified, the underlying file represented by file
        is removed, incidentally removing all of the databases it contained.
        """
        return pool.invoke(self.__dbenv.dbremove, file, database, txn, flags)
        
    def dbrename(self, file, newname, database=None, txn=None, flags=0):
        """Renames the database specified by the file and database parameters
        to newname. If no database is specified, the underlying file represented
        by file is renamed, incidentally renaming all of the databases it contained.
        """
        return pool.invoke(self.__dbenv.dbrename, self, file, database, newname, txn, flags)
        
    def fileid_reset(self, file, flags=0):
        """All databases contain an ID string used to identify the database in the
        database environment cache. If a physical database file is copied, and used
        in the same environment as another file with the same ID strings, corruption
        can occur. The DB_ENV->fileid_reset method creates new ID strings for all of
        the databases in the physical file.
        """
        return pool.invoke(self.__dbenv.fileid_reset, file, flags)
        
    def set_encrypt(self, passwd, flags=0):
        """Set the password used by the Berkeley DB library to perform encryption
        and decryption.
        """
        return pool.invoke(self.__dbenv.set_encrypt, passwd, flags)
        
    def get_timeout(self, flags):
        """Returns a timeout value, in microseconds.
        """
        return pool.invoke(self.__dbenv.get_timeout, flags)
        
    def set_timeout(self, timeout, flags):
        """Sets timeout values for locks or transactions in the database environment.
        """
        return pool.invoke(self.__dbenv.set_timeout, timeout, flags)
        
    def set_shm_key(self, key):
        """Specify a base segment ID for Berkeley DB environment shared memory regions
        created in system memory on VxWorks or systems supporting X/Open-style shared
        memory interfaces; for example, UNIX systems supporting shmget(2) and related
        System V IPC interfaces.
        """
        return pool.invoke(self.__dbenv.set_shm_key, key)
        
    def set_cachesize(self, gbytes, bytes, ncache=0):
        """Set the size of the shared memory buffer pool.
        """
        return pool.invoke(self.__dbenv.set_cachesize, gbytes, bytes, ncache)
        
    def set_data_dir(self, dir):
        """Set the environment data directory.
        """
        return pool.invoke(self.__dbenv.set_data_dir, dir)
        
    def set_flags(self, flags, onoff):
        """Set additional flags for the ADBEnv. The onoff parameter specifes if the flag
        is set or cleared.
        """
        return pool.invoke(self.__dbenv.set_flags, flags, onoff)
        
    def set_tmp_dir(self, dir):
        """Set the directory to be used for temporary files.
        """
        return pool.invoke(self.__dbenv.set_tmp_dir, dir)
        
    def set_get_returns_none(self, flag):
        """By default when ADB.get or ADBCursor.get, get_both, first, last, next or prev
        encounter a DB_NOTFOUND error they return None instead of raising DBNotFoundError.
        This behaviour emulates Python dictionaries and is convenient for looping.
        
        You can use this method to toggle that behaviour for all of the aformentioned
        methods or extend it to also apply to the ADBCursor.set, set_both, set_range, and
        set_recno methods.
        """
        return pool.invoke(self.__dbenv.set_get_returns_none, flag)
        
    def set_private(self, object):
        """Link an arbitrary object to the ADBEnv.
        """
        return pool.invoke(self.__dbenv.set_private, object)
        
    def get_private(self):
        """Give the object linked to the ADBEnv.
        """
        return pool.invoke(self.__dbenv.get_private)
        
    def set_lg_bsize(self, size):
        """Set the size of the in-memory log buffer, in bytes.
        """
        return pool.invoke(self.__dbenv.set_lg_bsize, size)
        
    def set_lg_dir(self, dir):
        """The path of a directory to be used as the location
        of logging files. Log files created by the Log Manager
        subsystem will be created in this directory.
        """
        return pool.invoke(self.__dbenv.set_lg_dir, dir)
        
    def set_lg_max(self, size):
        """Set the maximum size of a single file in the log, in bytes.
        """
        return pool.invoke(self.__dbenv.set_lg_max, size)
        
    def get_lg_max(self, size):
        """Returns the maximum log file size.
        """
        return pool.invoke(self.__dbenv.get_lg_max, size)
        
    def set_lg_regionmax(self, size):
        """Set the maximum size of a single region in the log, in bytes.
        """
        return pool.invoke(self.__dbenv.set_lg_regionmax, size)
        
    def set_lk_detect(self, mode):
        """Set the automatic deadlock detection mode.
        """
        return pool.invoke(self.__dbenv.set_lk_detect, mode)
        
    def set_lk_max(self, max):
        """Set the maximum number of locks. (This method is deprecated.)
        """
        return pool.invoke(self.__dbenv.set_lk_max, max)
        
    def set_lk_max_locks(self, max):
        """Set the maximum number of locks supported by the Berkeley DB lock subsystem.
        """
        return pool.invoke(self.__dbenv.set_lk_max_locks, max)
        
    def set_lk_max_lockers(self, max):
        """Set the maximum number of simultaneous locking entities supported by the
        Berkeley DB lock subsystem.
        """
        return pool.invoke(self.__dbenv.set_lk_max_lockers, max)
        
    def set_lk_max_objects(self, max):
        """Set the maximum number of simultaneously locked objects supported by
        the Berkeley DB lock subsystem.
        """
        return pool.invoke(self.__dbenv.set_lk_max_objects, max)
        
    def set_mp_mmapsize(self, size):
        """Files that are opened read-only in the memory pool (and that satisfy
        a few other criteria) are, by default, mapped into the process address space
        instead of being copied into the local cache. This can result in better-than-usual
        performance, as available virtual memory is normally much larger than the local
        cache, and page faults are faster than page copying on many systems. However, in
        the presence of limited virtual memory it can cause resource starvation, and in the
        presence of large databases, it can result in immense process sizes.

        This method sets the maximum file size, in bytes, for a file to be mapped into the
        process address space. If no value is specified, it defaults to 10MB.
        """
        return pool.invoke(self.__dbenv.set_mp_mmapsize, size)
        
    def log_archive(self, flags=0):
        """Returns a list of log or database file names. By default, log_archive returns
        the names of all of the log files that are no longer in use (e.g., no longer
        involved in active transactions), and that may safely be archived for catastrophic
        recovery and then removed from the system.
        """
        return pool.invoke(self.__dbenv.log_archive, flags)
        
    def log_flush(self):
        """Force log records to disk. Useful if the environment, database or transactions
        are used as ACI, instead of ACID. For example, if the environment is opened as DB_TXN_NOSYNC.
        """
        return pool.invoke(self.__dbenv.log_flush)
        
    def log_set_config(self, flags, onoff):
        """Configures the Berkeley DB logging subsystem.
        """
        return pool.invoke(self.__dbenv.log_set_config, flags, onoff)
        
    def lock_detect(self, atype, flags=0):
        """Run one iteration of the deadlock detector, returns the number of transactions aborted.
        """
        return pool.invoke(self.__dbenv.lock_detect, atype, flags)
        
    def lock_get(self, locker, obj, lock_mode, flags=0):
        """Acquires a lock and returns a handle to it as a DBLock object.
        The locker parameter is an integer representing the entity doing the locking, and
        obj is an object representing the item to be locked.
        """
        return pool.invoke(self.__dbenv.lock_get, locker, obj, lock_mode, flags)
        
    def lock_id(self):
        """Acquires a locker id, guaranteed to be unique across all threads and processes
        that have the DBEnv open.
        """
        return pool.invoke(self.__dbenv.lock_id)
        
    def lock_id_free(self, id):
        """Frees a locker ID allocated by the dbenv.lock_id() method.
        """
        return pool.invoke(self.__dbenv.lock_id_free, id)
        
    def lock_put(self, lock):
        """Release the lock.
        """
        return pool.invoke(self.__dbenv.lock_put, lock)
        
    def lock_stat(self, flags=0):
        """Returns a dictionary of locking subsystem statistics.
        """
        return pool.invoke(self.__dbenv.lock_stat, flags)
        
    def get_tx_max(self):
        """Returns the number of active transactions.
        """
        return pool.invoke(self.__dbenv.get_tx_max)
        
    def set_tx_max(self, max):
        """Set the maximum number of active transactions.
        """
        return pool.invoke(self.__dbenv.set_tx_max, max)
        
    def get_tx_timestamp(self):
        """Returns the recovery timestamp.
        """
        return pool.invoke(self.__dbenv.get_tx_timestamp)
        
    def set_tx_timestamp(self, timestamp):
        """Recover to the time specified by timestamp rather than to the most current possible date.
        """
        return pool.invoke(self.__dbenv.set_tx_timestamp, timestamp)
        
    def txn_begin(self, parent=None, flags=0):
        """Creates and begins a new transaction. A ADBTxn object is returned.
        """
        def txn_begin_sync(parent, flags):
            return ADBTxn(self.__dbenv.txn_begin(parent, flags))
        return pool.invoke(txn_begin_sync, parent, flags)
        
    def txn_checkpoint(self, kbyte=0, min=0, flag=0):
        """Flushes the underlying memory pool, writes a checkpoint record to the log and then
        flushes the log.
        """
        return pool.invoke(self.__dbenv.txn_checkpoint, kbyte, min, flag)
        
    def txn_stat(self, flags=0):
        """Return a dictionary of transaction statistics.
        """
        return pool.invoke(self.__dbenv.txn_stat, flags)
        
    def txn_stat_print(self, flags=0):
        """Displays the transaction subsystem statistical information.
        """
        return pool.invoke(self.__dbenv.txn_stat_print, flags)
        
    def lsn_reset(self, file=None, flags=0):
        """This method allows database files to be moved from one transactional database
        environment to another.
        """
        return pool.invoke(self.__dbenv.lsn_reset, file, flags)
        
    def log_stat(self, flags=0):
        """Returns a dictionary of logging subsystem statistics.
        """
        return pool.invoke(self.__dbenv.log_stat, flags)
        
    def txn_recover(self):
        """Returns a list of tuples (GID, TXN) of transactions prepared but still unresolved.
        This is used while doing environment recovery in an application using distributed transactions.

        This method must be called only from a single thread at a time. It should be called after DBEnv recovery.
        """
        def txn_recover_sync():
            return map(self.__dbenv.txn_recover(), lambda (gid, txn): (gid, ADBTxn(txn)))
        return pool.invoke(txn_recover_sync)
        
    def set_verbose(self, which, onoff):
        """Turns specific additional informational and debugging messages in the Berkeley DB message output on
        and off. To see the additional messages, verbose messages must also be configured for the application.
        """
        return pool.invoke(self.__dbenv.set_verbose, which, onoff)
        
    def get_verbose(self, which):
        """Returns whether the specified which parameter is currently set or not.
        """
        return pool.invoke(self.__dbenv.get_verbose, which)
        
    def set_event_notify(self, eventFunc):
        """Configures a callback function which is called to notify the process of specific Berkeley DB events.
        """
        return pool.invoke(self.__dbenv.set_event_notify, eventFunc)
        
    def repmgr_start(self, nthreads, flags):
        """Starts the replication manager.
        """
        return pool.invoke(self.__dbenv.repmgr_start, nthreads, flags)
        
    def repmgr_set_local_site(self, host, port, flags=0):
        """Specifies the host identification string and port number for the local system.
        """
        return pool.invoke(self.__dbenv.repmgr_set_local_site, host, port, flags)
        
    def repmgr_add_remote_site(self, host, port, flags=0):
        """Adds a new replication site to the replication manager's list of known sites.
        It is not necessary for all sites in a replication group to know about all other sites in the group.
        
        Method returns the environment ID assigned to the remote site.
        """
        return pool.invoke(self.__dbenv.repmgr_add_remote_site, host, port, flags)
        
    def repmgr_set_ack_policy(self, ack_policy):
        """Specifies how master and client sites will handle acknowledgment of replication messages which
        are necessary for "permanent" records.
        """
        return pool.invoke(self.__dbenv.repmgr_set_ack_policy, ack_policy)
        
    def repmgr_get_ack_policy(self):
        """Returns the replication manager's client acknowledgment policy.
        """
        return pool.invoke(self.__dbenv.repmgr_get_ack_policy)
        
    def repmgr_site_list(self):
        """Returns a dictionary with the status of the sites currently known by the replication manager.

        The keys are the Environment ID assigned by the replication manager. This is the same value that is
        passed to the application's event notification function for the DB_EVENT_REP_NEWMASTER event.

        The values are tuples containing the hostname, the TCP/IP port number and the link status.
        """
        return pool.invoke(self.__dbenv.repmgr_site_list)
        
    def repmgr_stat(self, flags=0):
        """Returns a dictionary with the replication manager statistics.
        """
        return pool.invoke(self.__dbenv.repmgr_stat, flags)
        
    def repmgr_stat_print(self, flags=0):
        """Displays the replication manager statistical information.
        """
        return pool.invoke(self.__dbenv.repmgr_stat_print, flags)
        
    def rep_elect(self, nsites, nvotes):
        """Holds an election for the master of a replication group.
        """
        return pool.invoke(self.__dbenv.rep_elect, nsites, nvotes)
        
    def rep_set_transport(self, envid, transportFunc):
        """Initializes the communication infrastructure for a database environment participating
        in a replicated application.
        """
        return pool.invoke(self.__dbenv.rep_set_transport, envid, transportFunc)
        
    def rep_process_messsage(self, control, rec, envid):
        """Processes an incoming replication message sent by a member of the replication group
        to the local database environment.

        Returns a two element tuple.
        """
        return pool.invoke(self.__dbenv.rep_process_messsage, control, rec, envid)
        
    def rep_start(self, flags, cdata=None):
        """Configures the database environment as a client or master in a group of replicated database environments.

        The DB_ENV->rep_start method is not called by most replication applications. It should only be called by
        applications implementing their own network transport layer, explicitly holding replication group
        elections and handling replication messages outside of the replication manager framework.
        """
        return pool.invoke(self.__dbenv.rep_start, flags, cdata)
        
    def rep_sync(self):
        """Forces master synchronization to begin for this client. This method is the other half of setting the
        DB_REP_CONF_DELAYCLIENT flag via the DB_ENV->rep_set_config method.
        """
        return pool.invoke(self.__dbenv.rep_sync)
        
    def rep_set_config(self, which, onoff):
        """Configures the Berkeley DB replication subsystem.
        """
        return pool.invoke(self.__dbenv.rep_set_config, which, onoff)
        
    def rep_get_config(self, which):
        """Returns whether the specified which parameter is currently set or not.
        """
        return pool.invoke(self.__dbenv.rep_get_config, which)
        
    def rep_set_limit(self, bytes):
        """Sets a byte-count limit on the amount of data that will be transmitted from a site in
        response to a single message processed by the DB_ENV->rep_process_message method. The limit is
        not a hard limit, and the record that exceeds the limit is the last record to be sent.
        """
        return pool.invoke(self.__dbenv.rep_set_limit, bytes)
        
    def rep_get_limit(self):
        """Gets a byte-count limit on the amount of data that will be transmitted from a site in
        response to a single message processed by the DB_ENV->rep_process_message method.
        The limit is not a hard limit, and the record that exceeds the limit is the last record to be sent.
        """
        return pool.invoke(self.__dbenv.rep_get_limit)
        
    def rep_set_request(self, minimum, maximum):
        """Sets a threshold for the minimum and maximum time that a client waits before requesting
        retransmission of a missing message. Specifically, if the client detects a gap in the sequence
        of incoming log records or database pages, Berkeley DB will wait for at least min microseconds
        before requesting retransmission of the missing record. Berkeley DB will double that amount
        before requesting the same missing record again, and so on, up to a maximum threshold of max microseconds. 
        """
        return pool.invoke(self.__dbenv.rep_set_request, minimum, maximum)
        
    def rep_get_request(self):
        """Returns a tuple with the minimum and maximum number of microseconds a client waits before
        requesting retransmission. 
        """
        return pool.invoke(self.__dbenv.rep_get_request)
        
    def rep_set_nsites(self, nsites):
        """Specifies the total number of sites in a replication group.
        """
        return pool.invoke(self.__dbenv.rep_set_nsites, nsites)
        
    def rep_get_nsites(self):
        """Returns the total number of sites in the replication group.
        """
        return pool.invoke(self.__dbenv.rep_get_nsites)
        
    def rep_set_priority(self, priority):
        """Specifies the database environment's priority in replication group elections. The priority
        must be a positive integer, or 0 if this environment cannot be a replication group master.
        """
        return pool.invoke(self.__dbenv.rep_set_priority, priority)
        
    def rep_get_priority(self):
        """Returns the database environment priority.
        """
        return pool.invoke(self.__dbenv.rep_get_priority)
        
    def rep_set_timeout(self, which, timeout):
        """Specifies a variety of replication timeout values.
        """
        return pool.invoke(self.__dbenv.rep_set_timeout, which, timeout)
        
    def rep_get_timeout(self, which):
        """Returns the timeout value for the specified which parameter.
        """
        return pool.invoke(self.__dbenv.rep_get_timeout, which)