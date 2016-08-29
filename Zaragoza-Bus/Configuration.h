//
//  Configuration.h
//  Zaragoza-Bus
//
//  Created by Giasone on 27/08/16.
//  Copyright © 2016 Gianluca Urgese. All rights reserved.
//

#ifndef Configuration_h
#define Configuration_h


#define WS_BASE_URL @"http://api.dndzgz.com/services"

#define WS_BUS_ALL_URL (WS_BASE_URL @"/bus")
#define WS_BUS_DETAILS_URL (WS_BASE_URL @"/bus/%@")

#define MAP_IMAGE_URL @"https://maps.googleapis.com/maps/api/staticmap?zoom=%@&size=%@&sensor=true&center=%@,%@"
/*
zoom level:
1: World
5: Landmass/continent
10: City
15: Streets
20: Buildings
*/
#define MAP_IMAGE_ZOOM @"18"
#define MAP_IMAGE_SIZE @"300x180"



#endif /* Configuration_h */


