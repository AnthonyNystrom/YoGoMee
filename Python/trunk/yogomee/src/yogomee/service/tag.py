from zope.interface import implements
from twisted.internet import defer, reactor
from twisted.python import components

import interface
import service

from yogomee.core import entity, storage
from yogomee.entity import gomee, tag

class TagService(object):
    
    implements(interface.ITagService)
    
    def __init__(self, srv):
        self.service = interface.IService(srv)
        self.storageFactory = storage.interface.IStorageFactory(self.service.storageFactory)
        
    def get_gomee_tags(self, gm):
        gomeeTagRepository = entity.repository.Repository(gomee.GomeeTag, self.storageFactory)
        return gomeeTagRepository.where(gomee = gm)
    
    def set_gomee_tags(self, gm, data):
        
        def get_current_tags(_):
            return gomeeTagRepository.where(gomee = gm)
        
        def update_tags(current_tags):
            
            if data.has_key("tags"):
                tags = map(lambda t: str(t), data["tags"])
            else:
                return defer.succeed(current_tags)
            
            current_tags_names = map(lambda t: t.tag.name, current_tags)
            tags_to_del = filter(lambda t: t.tag.name not in tags, current_tags)
            tags_to_add = filter(lambda t: t not in current_tags_names, tags)
            
            def remove_tags(_):
                dlist = map(lambda t: gomeeTagRepository.remove(t), tags_to_del)
                return defer.DeferredList(dlist)
            
            def add_tags(_):
                
                def get_existing_tags(_):
                    dlist = map(lambda t: tagRepository.where(name = str(t)), tags_to_add)
                    return defer.DeferredList(dlist)
                
                def create_and_add_tags(existing_tags):
                    
                    existing_tags = map(lambda (s, t): t, existing_tags)
                    existing_tags = filter(lambda t: len(t) == 1, existing_tags)
                    existing_tags = map(lambda t: t[0], existing_tags)
                    existing_tags_names = map(lambda t: t.name, existing_tags)
                    tags_to_create = filter(lambda t: t not in existing_tags_names, tags_to_add)
                    
                    def create_tags(_):
                        dlist = map(lambda t: tagFactory.create(name = str(t)), tags_to_create)
                        return defer.DeferredList(dlist)
                    
                    def add_tags(created_tags):
                        created_tags = map(lambda (s, t): t, created_tags)
                        dlist = map(lambda t: tagRepository.add(t), created_tags)
                        return defer.DeferredList(dlist)
                    
                    def persist_tags(added_tags):
                        
                        added_tags = map(lambda (s, t): t, added_tags)
                        
                        def complete(_):
                            return defer.succeed(added_tags + existing_tags)
                        
                        d = tagRepository.persist()
                        d.addCallback(complete)
                        return d
                    
                    d = defer.Deferred()
                    
                    d.addCallback(create_tags)
                    d.addCallback(add_tags)
                    d.addCallback(persist_tags)
                    
                    reactor.callLater(0, d.callback, None)
                    return d
                
                def create_and_add_gomee_tags(tags):
                    
                    def create(_):
                        dlist  = map(lambda t: gomeeTagFactory.create(gomee = gm, tag = t), tags)
                        return defer.DeferredList(dlist)
                    
                    def add(created_tags):
                        created_tags = map(lambda (s, t): t, created_tags)
                        dlist = map(lambda t: gomeeTagRepository.add(t), created_tags)
                        return defer.DeferredList(dlist)
                
                    def persist(added_tags):
                        
                        def complete(_):
                            return gomeeTagRepository.where(gomee = gm)
                        
                        d = gomeeTagRepository.persist()
                        d.addCallback(complete)
                        return d
                    
                    d = defer.Deferred()
                    
                    d.addCallback(create)
                    d.addCallback(add)
                    d.addCallback(persist)
                    
                    reactor.callLater(0, d.callback, None)
                    return d
                        
                d = defer.Deferred()
                
                d.addCallback(get_existing_tags)
                d.addCallback(create_and_add_tags)
                d.addCallback(create_and_add_gomee_tags)
                
                reactor.callLater(0, d.callback, None)
                return d
            
            d = defer.Deferred()
            
            d.addCallback(remove_tags)
            d.addCallback(add_tags)
            
            reactor.callLater(0, d.callback, None)
            return d
            
        
        gomeeTagRepository = entity.repository.Repository(gomee.GomeeTag, self.storageFactory)
        gomeeTagFactory = entity.factory.Factory(gomee.GomeeTag)
        tagRepository = entity.repository.Repository(tag.Tag, self.storageFactory)
        tagFactory = entity.factory.Factory(tag.Tag)
        
        d = defer.Deferred()
        
        d.addCallback(get_current_tags)
        d.addCallback(update_tags)
        
        reactor.callLater(0, d.callback, None)
        return d
    
components.registerAdapter(
                           TagService,
                           service.Service,
                           interface.ITagService)