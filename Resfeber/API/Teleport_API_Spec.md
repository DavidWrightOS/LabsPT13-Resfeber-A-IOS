#  Teleport API Specifications

## Teleport API

The Teleport.org API allows you to find and get information about:

- cities (by name, using auto-complete or by geographic coordinates)
- countries and their administrative divisions timezones
- urban areas: income, living costs & quality of life data in 264+ cities

## Table of Contents
- [Documentation](#Documentation)
- [Endpoints](#Endpoints)
- [Header](#Header)



### Documentation
https://developers.teleport.org/api/reference/#/

### Endpoints
The following are endpoints we intend to use for Resfeber datasourcing. 

#### Root
GET

https://api.teleport.org/api/

#### Cities
GET

/cities
 - Finds cities by name
 
/cities/{city_id}/
- Get city information

/cities/{city_id}/alternate_names/
- Get alternate names for a city

#### Urban Areas
GET

/urban_areas/
- Get a list of all urban areas

/urban_areas/{ua-id}
- Get urban area information

/urban_areas/{ua-id}/cities
- Get city information in a specific urban areas

/urban_areas/{ua-id}/details
- Get urban area detailed information

/urban_areas/{ua-id}/images
- Get urban area images

/urban_areas/{ua-id}/scores
- Get urban area scores

#### Locations
GET 

/locations/{coordinates}/
- Get geographical features at a location


### Header

The current API version is v1. It is recommended to include the following HTTP header in  API requests.

```Accept: application/vnd.teleport.v1+json```


