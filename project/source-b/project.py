from twisted.protocols import basic
from twisted.internet import protocol, reactor
from twisted.application import service, internet
from twisted.web.client import getPage
import sys
import time
import conf
import logging
import json
import re

"""
adapted originally from twisted chatserver.py example: http://twistedmatrix.com/documents/14.0.0/_downloads/chatserver.py
"""

class ServerHerdProtocol(basic.LineReceiver):
    def __init__ (self, factory):
        self.factory = factory

    def connectionMade(self):
        timestamp = time.strftime("%Y-%m-%d %H:%M:%S")
        self.factory.connections = self.factory.connections + 1
        logging.debug("CONNECTION MADE: \n TOTAL CONNECTIONS: %s \n TIME - %s" % (self.factory.connections , timestamp))

    def connectionLost(self, reason):
        timestamp = time.strftime("%Y-%m-%d %H:%M:%S")
        self.factory.connections = self.factory.connections - 1
        logging.debug("CONNECTION LOST: \n TOTAL CONNECTIONS: %s \n REASON - %s \n TIME - %s" % (self.factory.connections, reason, timestamp))

    def lineReceived(self, line):
        logging.debug("LINE RECEIVED: \n INPUT - %s \n TIME - %s" % (line,time.strftime("%Y-%m-%d %H:%M:%S")))
    
        # get timestamp
        timestamp = time.time()

        # parse arguments
        args = line.split()

        # avoid index out of range errors
        if(len(args) < 3):
            self.handle_ERROR(line, "bad input")
            return

        # parse command
        command = args[0]

        # if invalid command return error
        commands = ["IAMAT", "AT", "WHATSAT"] 
        if(command not in commands):
            self.handle_ERROR(line, "invalid command")
            return   
 
        # route based on command
        if(command == "IAMAT"):
            self.handle_IAMAT(args[1:], timestamp)
        
        if(command == "AT"):
            self.handle_AT(args[1:], timestamp)
        
        if(command == "WHATSAT"):
            self.handle_WHATSAT(args[1:])

    def handle_WHATSAT(self, args):
        
        # return error if incorrect number of args
        if(len(args) != 3):
            self.handle_ERROR("WHATSAT " + " ".join(args), "Incorrect num of args")
            return

        # parse args
        client_requested = args[0]
        radius = args[1]
        size = args[2]

        # get cached location info and error if not found
        try:
            cachedData = self.factory.clients.get(client_requested)
            location = cachedData["location"]
            cachedRequest = cachedData["request"]
        except:
            self.handle_ERROR("WHATSAT " + " ".join(args),  "No info stored for client")
            return
        
        # format location
        location = re.sub(r'[-]', ' -', location)
        location = re.sub(r'[+]', ' +', location)
        location = ",".join(location.split())

        # build request: key, radius, location
        params = "key=%s&radius=%s&location=%s" % (conf.API_KEY, radius, location)
        request = conf.GOOGLE_API_URL + params
        
        # call google and format response in callback or error 
        d = getPage(request)
        d.addCallback(self.handle_G_RESPONSE, cachedRequest, size)


    def handle_G_RESPONSE(self, response, cachedRequest, size):

        # parse google respones
        data = json.loads(response)
        
        # limit to size
        size = int(size)
        data["results"] = data["results"][0:size]

        # re-encode json
        encoded_data = json.dumps(data, indent=4)

        # add in old request and put two new lines at end per spec
        formatted_response = "%s \n %s \n \n" % (cachedRequest, encoded_data)

        logging.debug("GOOGLE RESPONSE: \n RESPONSE - %s \n TIME - %s" % (encoded_data, time.strftime("%Y-%m-%d %H:%M:%S")))

        # send response 
        self.transport.write(formatted_response)
    
    def handle_IAMAT(self, args, timestamp):

        # return error if incorrect number of args
        if(len(args) != 3):
            self.handle_ERROR("IAMAT " + " ".join(args), "bad input")
            return

        # parse args
        client_id = args[0]
        location = args[1]
        client_timestamp = args[2]

        # verify that timestamp is valid by turning it into a float
        try:
           client_timestamp = float(client_timestamp)
        except:
            self.handle_ERROR("IAMAT " + " ".join(args),  "Invalid client timestamp")
            return

        # get time difference
        time_diff = timestamp - client_timestamp
        if(time_diff > 0):
            time_diff = "+%s" % (time_diff)
        else:
            time_diff = "-%s" % (time_diff)

        # format and send response
        response = "AT %s %s %s %s %s" % (self.factory.server, time_diff, client_id ,location, args[2])
        logging.debug("IAMAT RESPONSE: \n OUT - %s \n TIME - %s" % (response,time.strftime("%Y-%m-%d %H:%M:%S")))
        self.transport.write(response + "\n")

        # propogate response to neighbors
        self.handle_AT(response.split()[1:], timestamp)
    
    def handle_AT(self, args, timestamp):

        # return error if incorrect number of args
        if(len(args) != 5):
            self.handle_ERROR("AT " + " ".join(args), "Incorrect num of args")
            return

        # parse args
        sender = args[1]
        client_id = args[2]
        location = args[3]
        client_timestamp = args[4]

        # check if info in system is already up to date
        cachedData = self.factory.clients.get(client_id)

        # don't propogate old data
        if(cachedData != None and cachedData["timestamp"] <= client_timestamp):
            return

        # reconstruct original command
        update = "AT " + " ".join(args) 

        # log the update
        logging.debug("UPDATING CACHE: \n CLIENT - %s \n TIME - %s" % (client_id, time.strftime("%Y-%m-%d %H:%M:%S")))
        self.factory.clients[client_id] = {"location": location, "timestamp": client_timestamp, "request": update}

        # send to all neighbors but the original sender
        recipients = conf.NEIGHBORS[self.factory.server];
        if sender in recipients: recipients = recipients.remove(sender)
        for recipient in recipients:
            reactor.connectTCP("localhost", conf.PORT_NUM[recipient], ClientFactory(update))
    
    def handle_ERROR(self, message, error):    
        logging.error("CAUGHT ERROR: \n MSG - %s \n ERROR - %s \n TIME - %s" % (message, error, time.strftime("%Y-%m-%d %H:%M:%S")))
        self.transport.write("? {%s}\n" % (message))

    def stopFactory(self):
        logging.debug("SERVER SHUTDOWN: \n server - %s \n TIME - %s" % (self.factory.server, time.strftime("%Y-%m-%d %H:%M:%S")))

class ServerHerdFactory(protocol.ServerFactory):
    # init server with name, client dict, num connections and a log file
    def __init__(self,server):
        self.server = server
        self.clients = {}
        self.connections = 0
        timestamp = time.strftime("%Y-%m-%d %H:%M:%S")
        log_file = "%s.log" % (server)
        logging.basicConfig(filename=log_file,level=logging.DEBUG)
        logging.debug("SERVER STARTED: \n PORT - %s \n TIME - %s" % (conf.PORT_NUM[server], timestamp))

    # hook up server to the above protocol
    def buildProtocol(self, addr):
        return ServerHerdProtocol(self) 

"""
adapted from http://twistedmatrix.com/documents/12.1.0/core/howto/clients.html
"""

# basic client implemenation that allows servers to send atomic updates to other servers
class ClientFactory(protocol.ClientFactory):
    def __init__(self, msg):
        self.msg = msg

    def buildProtocol(self, addr):
        return Client(self)

class Client(basic.LineReceiver):
    def __init__ (self, factory):
        self.factory = factory

    def connectionMade(self):
        self.sendLine(self.factory.msg)
        self.transport.loseConnection()

def main():

    # server name required to run
    if len(sys.argv) != 2:
		print("Missing Server Info")
		exit()

    # get server name
    server = sys.argv[1] 

    # only support certain servers
    try:
        conf.PORT_NUM[server]
    except:
        print("Invalid server")     
        exit()
    
    # start server listening on that port
    factory = ServerHerdFactory(server)
    reactor.listenTCP(conf.PORT_NUM[server], factory)
    reactor.run()

if __name__ == "__main__":
    main()

