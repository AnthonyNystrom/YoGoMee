from twisted.internet import reactor, defer
from twisted.web import server

from yogomee.core.storage import sabsddb

from yogomee.service.service import Service
from yogomee.resource import api


stoargeFactory = sabsddb.AbsddbStorageFactory("/home/yogomee/data")
srv = Service(stoargeFactory)

def complete(_):        
    reactor.listenTCP(8080, server.Site(api.ApiResource(srv)))

def print_error(err):
    print err

d = defer.Deferred()
 
d.addCallback(complete)
d.addErrback(print_error)

reactor.callLater(0, d.callback, None)
reactor.run()