# MetroTransit API - Ruby
This API provides data from MetroTransit.org in a JSON encoded format.

Written by [Joe Pintozzi](http://pintozzi.com), source available on [github](https://github.com/pyro2927/MetroTransit-API).

## Update!!
Stops are now returned as an array so they maintain the correct order from <http://MetroTransit.org>.

**This takes much influence from [cmaul](https://github.com/cmaul)'s [MetroTransit-API](https://github.com/cmaul/MetroTransit-API).  The [current implementation](http://metrotransitapi.appspot.com/) on Google's App Engine seems to no longer work, so I decided to rewrite it in ruby.**

[hkp](https://github.com/hkp)'s [heroku-sinatra-app](https://github.com/hkp/heroku-sinatra-app) was used as a base to quickly get this up onto Heroku.

Currently Supported Interfaces:

* routes - Displays the list of all routes provided by MetroTransit.
* directions - Displays the list of potential directions for a given route.
* stops - Displays the list of stops given a route and a direction
* nextrip/nextTrip - Displays a list of times for the bus to arrive given a stop, direction, and route

##Routes

Example: <http://metrotransit.heroku.com/routes>

Sample output:

	{"55x":"55 - Hiawatha Light Rail","888x":"888 - Northstar Commuter Rail","2":"2 - Franklin Av - Riverside Av - U of M - 8th St SE","3":"3 - U of M - Como Av - Energy Park Dr - Maryland Av","4":"4 - New Brighton - Johnson St - Bryant Av - Southtown","5":"5 - Brklyn Center - Fremont - 26th Av - Chicago - MOA","6":"6 - U of M - Hennepin - Xerxes - France - Southdale","7":"7 - Plymouth - 27Av - Midtown - 46St LRT - 34Av S","8":"8 - Franklin Av LRT - Franklin Av SE",...

##Direction

Example: <http://metrotransit.heroku.com/directions?route=50>

Required parameters:

* route

Sample output:

	{"2":"EASTBOUND","3":"WESTBOUND"}
    
##Stops

Example: <http://metrotransit.heroku.com/stops?route=50&direction=3>

Required parameters:

* route
* direction

Sample output:

	[{"key":"4MIN","name":"Minnesota St and 4th St"},{"key":"RIUN","name":"University Ave and Rice St"},{"key":"UNDA","name":"University Ave and Dale St"},{"key":"OXUN","name":"University Ave and Oxford St"},{"key":"SNUN","name":"University Ave W and Snelling Ave"},{"key":"FAUN","name":"University Ave and Fairview Ave"},{"key":"EMUN","name":"University Ave and Berry St"},{"key":"HURN","name":"Huron Station and I-94"},{"key":"OAUN","name":"University Ave SE and Oak St SE"},{"key":"JOED","name":"Jones Hall and Eddy Hall (U of M)"},{"key":"WIHA","name":"Willey Hall (U of M)"},{"key":"4NIC","name":"4th St S  and Nicollet Mall"},{"key":"5GAR","name":"Ramp B/5th St Transit Center"}]

##Nextrip

Example: <http://metrotransit.heroku.com/nextTrip?route=50&direction=3&stop=FAUN>

Required parameters:

* route
* direction
* stop

Sample output:

	[{"number":"50","time":"10:52"}]