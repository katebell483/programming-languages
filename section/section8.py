#python classes

class BaseClass(object):
    def __init__(self, arg1, arg2): #remember self!
        self.x = arg1
        self.y = arg2

    def getX(self):
        return self.x
    
    def getY(self):
        return self.y

foo=BaseClass(3,4)
print 'foo', foo, foo.getX(), foo.getY()

#client and servers will each have their own class

l = [1,2,3,4,5,6,7,8,9]
print 'l', l[1:5:2] #grab everything from 1 to 5 and print in steps of 2
print l[2:]
print l[-1]

#project

'''
SERVERS: H A B C
CLIENTS: kiwi.cs.ucla.edu, bono.cs.ucla.edu
Two parts:
1. client server communication
    - client tell server where she is
        IMAT <client_name> <latitude> <posix_time>
        WHATSAT <some_client_name> ...
    - server to client 
        AT <responding_server_name> <localtime_difference> <copy_of_client_message> (acknowledgint that server got message)
        AT json response (giving client google data)
2. server server communication
    - all servers have local caches that know where the clients are + if server fails it should retain that info (?)


'''
