
MATCH (route:Route ), (airline:Airline) WHERE route.airlineId = airline.airlineId
CREATE (route)-[:FOLLOWS]->(airline)

MATCH (route:Route), (airport:Airport) WHERE route.destinationId = airport.airportId
CREATE (route)-[:TO]->(airport)

MATCH (route:Route), (airport:Airport) WHERE route.sourceID = airport.airportId
CREATE (route)-[:FROM]->(airport)

MATCH (airport:Airport), (city:City) WHERE city.cityId = airport.airportId
CREATE (airport)-[:SITUATED_IN]->(city)

MATCH (airline: Airline), (country: Country) 
WHERE airline.country = country.countryName
CREATE (airline)-[:CONTROLLED_BY]->(country)

//Question 1
MATCH (route:Route)-[:TO]->(airport:Airport)
MATCH (route:Route)-[:FROM]->(airport:Airport)
RETURN airport.name AS airportName, COUNT(*) AS count
ORDER BY count DESC
LIMIT 5;

//Question 2
MATCH (airport:Airport)
RETURN airport.country, COUNT(*) as num_of_airports
ORDER BY num_of_airports DESC
LIMIT 5;

//Question 3
MATCH (airport1:Airport), (route:Route), (airport2:Airport), (airline:Airline)
WHERE route.source=airport1.IATA
AND route.destination=airport2.IATA 
AND route.airlineId = airline.airlineId
AND (airport1.country='Greece' OR airport2.country='Greece')
RETURN airline.name AS AIRLINE, COUNT(*) AS INTERNATIONAL_FLIGHTS_TO_FROM_GREECE
ORDER BY INTERNATIONAL_FLIGHTS_TO_FROM_GREECE DESC
LIMIT 5

//Question 4 
MATCH (airport1:Airport), (route:Route), (airport2:Airport), (airline:Airline)
WHERE route.source=airport1.IATA
AND route.destination=airport2.IATA 
AND route.airlineId = airline.airlineId
AND airport1.country='Germany'
AND airport2.country='Germany'
RETURN airline.name AS AIRLINE, COUNT(*) AS FLIGHTS_INSIDE_GERMANY
ORDER BY  FLIGHTS_INSIDE_GERMANY DESC
LIMIT 5

//Question 5
MATCH (airline:Airline), (route:Route), (airport:Airport)
WHERE airline.airlineId=route.airlineId
AND route.destination=airport.IATA
AND airport.country="Greece"
RETURN airline.country AS COUNTRY, COUNT(*) AS NUMBER_OF_FLIIGHTS_TO_GREECE
ORDER BY NUMBER_OF_FLIIGHTS_TO_GREECE DESC
LIMIT 10

//Question 6
MATCH (route:Route)-[:TO]->(airport:Airport {country:'Greece'}) 
OPTIONAL MATCH (route:Route)-[:FROM]->(airport:Airport  {country:'Greece'})
WITH COUNT(*) AS total
MATCH (route:Route)-[:TO]->(airport:Airport {country:'Greece'}) 
OPTIONAL MATCH (route:Route)-[:FROM]->(airport:Airport  {country:'Greece'})
RETURN airport.city AS CITY, 100*COUNT(*)/total AS percentage
ORDER BY percentage DESC

// Question 7
MATCH (airline:Airline),(route:Route), (airport:Airport)
WHERE airline.airlineId=route.airlineId
AND(route.destination=airport.IATA OR route.source=airport.IATA)
AND airport.country="Greece"
AND (route.equipment="738" OR route.equipment="320")
RETURN route.equipment AS PLANE_TYPE, COUNT(*) AS NUMBER_OF_FLIIGHTS
ORDER BY NUMBER_OF_FLIIGHTS DESC

// Question 8
MATCH (airport1:Airport), (route:Route), (airport2:Airport)
WHERE route.source=airport1.IATA
AND route.destination=airport2.IATA 
WITH airport1 AS a1, airport2 AS a2
WITH a1, a2, point({ longitude: toFloat(a1.longitude), latitude: toFloat(a1.latitude) }) AS source, point({ longitude: toFloat(a2.longitude), latitude: toFloat(a2.latitude) }) AS destination
RETURN  a1.city AS SOURCE, a2.city AS DESTINATION, round(distance(source, destination))/1000 AS travelDistance
ORDER BY travelDistance DESC
LIMIT 10

//Question 9
match (a1:Airport)-[:CONNECTED_WITH]->(a2:Airport )
WHERE a1.city<>"Berlin"  AND a2.city<>"Berlin"
AND EXISTS ((a2)-[:CONNECTED_WITH]->(:Airport {city:"Berlin"}))
WITH COUNT(a1.city) as total, a1 AS scr
RETURN scr.city AS CITY, count(*)/total AS FLIGHTS
ORDER BY FLIGHTS DESC
LIMIT 5

//Question 10
MATCH (route:Route)-[:TO]->(airport:Airport)
MATCH (route:Route)-[:FROM]->(airport:Airport)
MATCH (airportSource:Airport {city: 'Athens', country:'Greece'}),(airportDest:Airport {city: 'Sydney', country:'Australia'}),
p = shortestPath((airportSource)-[*]-(airportDest))
RETURN p

