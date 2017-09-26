pkill -f 'Python project.py'
pkill -f 'python project.py'

echo starting servers
python project.py Alford &
python project.py Ball &
python project.py Hamilton &
python project.py Welsh &
python project.py Holiday &
echo done starting servers: Alford, Ball, Hamilton, Welsh, Holiday

# test IAMAT command
sleep 1

{
	sleep 1
	echo IAMAT kiwi.cs.ucla.edu +34.068930-118.445127 1479413884.392014450	
    sleep 1
	echo quit
} | telnet localhost 12160 # alford


{
	sleep 1
	echo IAMAT mark.cs.ucla.edu +48.8566+2.3522 1479413884.392014450 	
    sleep 1
	echo quit
} | telnet localhost 12163 # holiday


# test IAMAT propagation by askign WHATSAT to servers different from above. Also test error message 

{
	sleep 1
	echo WHATSAT kiwi.cs.ucla.edu 10 1
    sleep 5
	echo quit
} | telnet localhost 12161 # ball


{
	sleep 1
	echo WHATSAT fake.cs.ucla.edu 20 3
	sleep 1
	echo quit
} | telnet localhost 12162 # hamilton


{
	sleep 1
	echo WHATSAT mark.cs.ucla.edu 15 1
	sleep 5
	echo quit
} | telnet localhost 12164 # welsh

# test bad timestamp
{
	sleep 1
	echo IAMAT mark.cs.ucla.edu +48.8566+2.3522 turkey 	
    sleep 1
	echo quit
} | telnet localhost 12163 # holiday


pkill -f 'Python project.py'
pkill -f 'python project.py'

