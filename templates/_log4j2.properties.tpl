{{- define "log4j2.properties" -}}
status = error

######## Server JSON ############################
appender.rolling.type = Console
appender.rolling.name = rolling
appender.rolling.layout.type = ECSJsonLayout
appender.rolling.layout.dataset = elasticsearch.server

################################################

################################################

rootLogger.level = info
rootLogger.appenderRef.rolling.ref = rolling

######## Deprecation JSON #######################
appender.deprecation_rolling.type = Console
appender.deprecation_rolling.name = deprecation_rolling
appender.deprecation_rolling.layout.type = ECSJsonLayout
appender.deprecation_rolling.layout.dataset = elasticsearch.deprecation
appender.deprecation_rolling.filter.rate_limit.type = RateLimitingFilter

appender.header_warning.type = HeaderWarningAppender
appender.header_warning.name = header_warning
#################################################

logger.deprecation.name = org.elasticsearch.deprecation
logger.deprecation.level = deprecation
logger.deprecation.appenderRef.deprecation_rolling.ref = deprecation_rolling
logger.deprecation.appenderRef.header_warning.ref = header_warning
logger.deprecation.additivity = false

######## Search slowlog JSON ####################
appender.index_search_slowlog_rolling.type = Console
appender.index_search_slowlog_rolling.name = index_search_slowlog_rolling
appender.index_search_slowlog_rolling.layout.type = ECSJsonLayout
appender.index_search_slowlog_rolling.layout.dataset = elasticsearch.index_search_slowlog

#################################################

#################################################
logger.index_search_slowlog_rolling.name = index.search.slowlog
logger.index_search_slowlog_rolling.level = trace
logger.index_search_slowlog_rolling.appenderRef.index_search_slowlog_rolling.ref = index_search_slowlog_rolling
logger.index_search_slowlog_rolling.additivity = false

######## Indexing slowlog JSON ##################
appender.index_indexing_slowlog_rolling.type = Console
appender.index_indexing_slowlog_rolling.name = index_indexing_slowlog_rolling
appender.index_indexing_slowlog_rolling.layout.type = ECSJsonLayout
appender.index_indexing_slowlog_rolling.layout.dataset = elasticsearch.index_indexing_slowlog

#################################################

logger.index_indexing_slowlog.name = index.indexing.slowlog.index
logger.index_indexing_slowlog.level = trace
logger.index_indexing_slowlog.appenderRef.index_indexing_slowlog_rolling.ref = index_indexing_slowlog_rolling
logger.index_indexing_slowlog.additivity = false

appender.audit_rolling.type = Console
appender.audit_rolling.name = audit_rolling
appender.audit_rolling.layout.type = PatternLayout
appender.audit_rolling.layout.pattern = {\
                "type":"audit", \
                "timestamp":"%d{yyyy-MM-dd'T'HH:mm:ss,SSSZ}"\
                %varsNotEmpty{, "node.name":"%enc{%map{node.name}}{JSON}"}\
                %varsNotEmpty{, "node.id":"%enc{%map{node.id}}{JSON}"}\
                %varsNotEmpty{, "host.name":"%enc{%map{host.name}}{JSON}"}\
                %varsNotEmpty{, "host.ip":"%enc{%map{host.ip}}{JSON}"}\
                %varsNotEmpty{, "event.type":"%enc{%map{event.type}}{JSON}"}\
                %varsNotEmpty{, "event.action":"%enc{%map{event.action}}{JSON}"}\
                %varsNotEmpty{, "authentication.type":"%enc{%map{authentication.type}}{JSON}"}\
                %varsNotEmpty{, "user.name":"%enc{%map{user.name}}{JSON}"}\
                %varsNotEmpty{, "user.run_by.name":"%enc{%map{user.run_by.name}}{JSON}"}\
                %varsNotEmpty{, "user.run_as.name":"%enc{%map{user.run_as.name}}{JSON}"}\
                %varsNotEmpty{, "user.realm":"%enc{%map{user.realm}}{JSON}"}\
                %varsNotEmpty{, "user.run_by.realm":"%enc{%map{user.run_by.realm}}{JSON}"}\
                %varsNotEmpty{, "user.run_as.realm":"%enc{%map{user.run_as.realm}}{JSON}"}\
                %varsNotEmpty{, "user.roles":%map{user.roles}}\
                %varsNotEmpty{, "apikey.id":"%enc{%map{apikey.id}}{JSON}"}\
                %varsNotEmpty{, "apikey.name":"%enc{%map{apikey.name}}{JSON}"}\
                %varsNotEmpty{, "origin.type":"%enc{%map{origin.type}}{JSON}"}\
                %varsNotEmpty{, "origin.address":"%enc{%map{origin.address}}{JSON}"}\
                %varsNotEmpty{, "realm":"%enc{%map{realm}}{JSON}"}\
                %varsNotEmpty{, "url.path":"%enc{%map{url.path}}{JSON}"}\
                %varsNotEmpty{, "url.query":"%enc{%map{url.query}}{JSON}"}\
                %varsNotEmpty{, "request.method":"%enc{%map{request.method}}{JSON}"}\
                %varsNotEmpty{, "request.body":"%enc{%map{request.body}}{JSON}"}\
                %varsNotEmpty{, "request.id":"%enc{%map{request.id}}{JSON}"}\
                %varsNotEmpty{, "action":"%enc{%map{action}}{JSON}"}\
                %varsNotEmpty{, "request.name":"%enc{%map{request.name}}{JSON}"}\
                %varsNotEmpty{, "indices":%map{indices}}\
                %varsNotEmpty{, "opaque_id":"%enc{%map{opaque_id}}{JSON}"}\
                %varsNotEmpty{, "x_forwarded_for":"%enc{%map{x_forwarded_for}}{JSON}"}\
                %varsNotEmpty{, "transport.profile":"%enc{%map{transport.profile}}{JSON}"}\
                %varsNotEmpty{, "rule":"%enc{%map{rule}}{JSON}"}\
                %varsNotEmpty{, "put":%map{put}}\
                %varsNotEmpty{, "delete":%map{delete}}\
                %varsNotEmpty{, "change":%map{change}}\
                %varsNotEmpty{, "create":%map{create}}\
                %varsNotEmpty{, "invalidate":%map{invalidate}}\
                }%n
# "node.name" node name from the `elasticsearch.yml` settings
# "node.id" node id which should not change between cluster restarts
# "host.name" unresolved hostname of the local node
# "host.ip" the local bound ip (i.e. the ip listening for connections)
# "origin.type" a received REST request is translated into one or more transport requests. This indicates which processing layer generated the event "rest" or "transport" (internal)
# "event.action" the name of the audited event, eg. "authentication_failed", "access_granted", "run_as_granted", etc.
# "authentication.type" one of "realm", "api_key", "token", "anonymous" or "internal"
# "user.name" the subject name as authenticated by a realm
# "user.run_by.name" the original authenticated subject name that is impersonating another one.
# "user.run_as.name" if this "event.action" is of a run_as type, this is the subject name to be impersonated as.
# "user.realm" the name of the realm that authenticated "user.name"
# "user.run_by.realm" the realm name of the impersonating subject ("user.run_by.name")
# "user.run_as.realm" if this "event.action" is of a run_as type, this is the realm name the impersonated user is looked up from
# "user.roles" the roles array of the user; these are the roles that are granting privileges
# "apikey.id" this field is present if and only if the "authentication.type" is "api_key"
# "apikey.name" this field is present if and only if the "authentication.type" is "api_key"
# "event.type" informs about what internal system generated the event; possible values are "rest", "transport", "ip_filter" and "security_config_change"
# "origin.address" the remote address and port of the first network hop, i.e. a REST proxy or another cluster node
# "realm" name of a realm that has generated an "authentication_failed" or an "authentication_successful"; the subject is not yet authenticated
# "url.path" the URI component between the port and the query string; it is percent (URL) encoded
# "url.query" the URI component after the path and before the fragment; it is percent (URL) encoded
# "request.method" the method of the HTTP request, i.e. one of GET, POST, PUT, DELETE, OPTIONS, HEAD, PATCH, TRACE, CONNECT
# "request.body" the content of the request body entity, JSON escaped
# "request.id" a synthentic identifier for the incoming request, this is unique per incoming request, and consistent across all audit events generated by that request
# "action" an action is the most granular operation that is authorized and this identifies it in a namespaced way (internal)
# "request.name" if the event is in connection to a transport message this is the name of the request class, similar to how rest requests are identified by the url path (internal)
# "indices" the array of indices that the "action" is acting upon
# "opaque_id" opaque value conveyed by the "X-Opaque-Id" request header
# "x_forwarded_for" the addresses from the "X-Forwarded-For" request header, as a verbatim string value (not an array)
# "transport.profile" name of the transport profile in case this is a "connection_granted" or "connection_denied" event
# "rule" name of the applied rule if the "origin.type" is "ip_filter"
# the "put", "delete", "change", "create", "invalidate" fields are only present
# when the "event.type" is "security_config_change" and contain the security config change (as an object) taking effect

logger.xpack_security_audit_logfile.name = org.elasticsearch.xpack.security.audit.logfile.LoggingAuditTrail
logger.xpack_security_audit_logfile.level = info
logger.xpack_security_audit_logfile.appenderRef.audit_rolling.ref = audit_rolling
logger.xpack_security_audit_logfile.additivity = false

logger.xmlsig.name = org.apache.xml.security.signature.XMLSignature
logger.xmlsig.level = error
logger.samlxml_decrypt.name = org.opensaml.xmlsec.encryption.support.Decrypter
logger.samlxml_decrypt.level = fatal
logger.saml2_decrypt.name = org.opensaml.saml.saml2.encryption.Decrypter
logger.saml2_decrypt.level = fatal
{{- end }}