from Queue import Queue
from threading import Thread
import time
from twisted.internet import reactor, defer
from twisted.internet.defer import Deferred
from twisted.python.failure import Failure

class Pool(object):
    
    def __init__(self):
        self.__queue_ = Queue()
        self.__thread_ = Thread(group=None, target = self.__thread_func_)
        self.__started = False
        
    def invoke(self, d, func, args, kwargs):
        self.__queue_.put_nowait((d, func, args, kwargs))
        
    def start(self):
        if not self.__started:
            self.__started = True
            self.__thread_.start()
        return defer.succeed(True)
    
    def stop(self):
        self.__started = False
        
    def __thread_func_(self):
        while self.__started:
            (d, func, args, kwargs) = self.__queue_.get(True)
            try:
                result = func(*args, **kwargs)
                reactor.callFromThread(d.callback, *(result,))
            except Exception, e:
                reactor.callFromThread(d.errback, Failure(e, Exception))
                
def invoke(func, *args, **kwargs):
    d = Deferred()
    __pool_.invoke(d, func, args, kwargs)
    return d

__pool_ = Pool()

reactor.addSystemEventTrigger("after", "startup", __pool_.start)
reactor.addSystemEventTrigger("before", "shutdown", invoke, __pool_.stop)