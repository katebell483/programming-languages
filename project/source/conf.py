# A configuration file for the Twisted Places proxy herd

# Google Places API key
API_KEY="removed"
GOOGLE_API_URL="https://maps.googleapis.com/maps/api/place/nearbysearch/json?"

# TCP port numbers for each server instance (server ID: case sensitive)
# Please use the port numbers allocated by the TA.
PORT_NUM = {
    'Alford': 12160,
    'Ball': 12161,
    'Hamilton': 12162,
    'Holiday': 12163,
    'Welsh': 12164
}

NEIGHBORS = {
    "Alford": ["Hamilton", "Welsh"],
    "Hamilton": ["Alford", "Holiday"],
    "Holiday": ["Ball", "Hamilton"],
    "Welsh": ["Ball", "Alford"],
    "Ball": ["Holiday", "Welsh"]
}

PROJ_TAG="Fall 2016"
