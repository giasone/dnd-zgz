# dnd-zgz
Assignment for a ‘Zaragoza’s bus info’ app. The app display a listing of all the bus stops in the city and some details.

Information for each stop:
* The number of the bus stop
* The name of the bus stop
* A small map image of the area around the bus stop 
* Time until the next bus arrives the bus stop

###Help tools Bus API
Zaragoza’s Bus information can be queried from ‘Dónde en Zaragoza’ API: http://www.dndzgz.com/web/api.html
To get the bus stop list perform an HTTP GET request to: http://api.dndzgz.com/services/bus
To get real time info from a bus stop, perform an HTTP GET request to: http://api.dndzgz.com/services/bus/<id>

###Map API
Map images can be fetched from the google maps API: https://developers.google.com/maps/documentation/imageapis/

