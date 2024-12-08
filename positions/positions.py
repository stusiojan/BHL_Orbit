from skyfield.api import N, S, E, W, wgs84, load, Star
from skyfield.data import hipparcos

from fastapi import FastAPI
from models import CelestialPosition
app = FastAPI()


CONSTELLATIONS = {
    "Orion": [24436, 25336, 26727, 27989, 29426],
    "Ursa_Major": [54061, 53910, 58001, 59774, 62956],
    "Ursa_Minor": [35764, 47235, 45593, 11215, 34783],
    "Leo": [21627, 45325, 55132, 49168, 34531],
    "Taurus": [28988, 34475, 31514, 54498, 45298],
    "Scorpius": [45299, 34122, 48595, 22465, 20346],
    "Cassiopeia": [18192, 50204, 21376, 54892, 39347],
    "Aquarius": [45467, 32456, 26714, 40567, 22765],
    "Virgo": [50325, 43352, 45623, 22343, 31576],
    "Aries": [23054, 41764, 26450, 32021, 39917]
}


@app.get('/planets')
async def getPlanets():
    """
    Returns a list of all the planets in the solar system.
    
    This endpoint retrieves the names of the celestial bodies in the solar system from 
    the ephemeris and returns them in a list. The list contains the names of planets
    and major solar system bodies such as the Sun and the Moon.

    **Response Format:**
    - `planets`: List of planet names in the solar system.
    
    **Example Response:**
    ```json
    {
        "planets": ["Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune", "Pluto"]
    }
    ```
    """
    planets = load('de421.bsp')
    planet_dict = [dict(planets.names().items())[key][0] for key in dict(planets.names().items())]
    return {"planets": planet_dict[:]}

@app.get('/constellations')
async def getConstellations():
    """
    Returns a list of all the available constellations in the system.

    This endpoint returns the names of the constellations that are stored in the `CONSTELLATIONS` dictionary.
    
    **Response Format:**
    - `constellations`: List of constellation names.
    
    **Example Response:**
    ```json
    {
        "constellations": ["Orion", "Ursa_Major", "Ursa_Minor", "Leo", "Taurus", "Scorpius", "Cassiopeia", "Aquarius", "Virgo", "Aries"]
    }
    ```
    """
    constellations_names = [key for key in CONSTELLATIONS]
    return {'constellations': constellations_names}

@app.get('/position/planet/{name}')
async def getPlanetPosition(name: str):
    """
    Returns the current position (altitude, azimuth, and distance) of a specified planet.

    This endpoint calculates the current position of a planet in the sky as seen from Warsaw, Poland.
    It provides the altitude and azimuth of the planet, as well as the distance from Earth in Astronomical Units (AU).

    **Path Parameters:**
    - `name`: The name of the planet (e.g., "Earth", "Mars", "Jupiter").

    **Response Format:**
    - `name`: The name of the planet.
    - `altitude`: The altitude of the planet in degrees.
    - `azimuth`: The azimuth of the planet in degrees.
    - `distance`: The distance from Earth in Astronomical Units (AU).

    **Example Response:**
    ```json
    {
        "name": "Mars",
        "altitude": "45deg 30' 15.2\"",
        "azimuth": "120deg 12' 53.8\"",
        "distance": 1.234
    }
    ```
    """
    planets = load('de421.bsp')

    if name not in planets:
            raise ValueError(f"Body '{name}' not found in the ephemeris file.")
    
    warsaw = planets['earth'] + wgs84.latlon(52.2360430 * N, 20.9785987 * W, elevation_m=20)
    ts = load.timescale()
    t = ts.now()
    celestial =  warsaw.at(t).observe(planets[name]).apparent()
    alt, az, dist = celestial.altaz()
    return CelestialPosition(
        name=name,
        altitude=str(alt),
        azimuth=str(az),
        distance=dist.au
    )

@app.get('/position/constellation/{name}')
async def getConstellationPosition(name: str):
    """
    Returns the positions (altitude, azimuth, and distance) of the stars in a specified constellation.

    This endpoint calculates the current positions of the stars in a specified constellation 
    as seen from Warsaw, Poland. The positions include altitude, azimuth, and distance in 
    Astronomical Units (AU) for each star within the constellation.

    **Path Parameters:**
    - `name`: The name of the constellation (e.g., "Orion", "Ursa_Major").

    **Response Format:**
    - `constellation`: The name of the constellation.
    - `stars`: A list of stars within the constellation, each containing:
      - `id`: The star's ID from the Hipparcos catalog.
      - `position`: A dictionary containing:
        - `name`: The ID of the star.
        - `altitude`: The altitude of the star in degrees.
        - `azimuth`: The azimuth of the star in degrees.
        - `distance`: The distance from Earth in Astronomical Units (AU).

    **Example Response:**
    ```json
    {
        "constellation": "Orion",
        "stars": [
            {
                "id": 24436,
                "position": {
                    "name": "24436",
                    "altitude": "-07deg 01' 53.0\"",
                    "azimuth": "265deg 43' 09.1\"",
                    "distance": 48877915.33432836
                }
            },
            {
                "id": 25336,
                "position": {
                    "name": "25336",
                    "altitude": "-02deg 10' 20.5\"",
                    "azimuth": "274deg 32' 02.3\"",
                    "distance": 23165400.2104783
                }
            }
        ]
    }
    ```
    """
    planets = load('de421.bsp')
    with load.open(hipparcos.URL) as f:
        df = hipparcos.load_dataframe(f)
    warsaw = planets['earth'] + wgs84.latlon(52.2360430 * N, 20.9785987 * W, elevation_m=20)
    ts = load.timescale()
    t = ts.now()

    positions = []
    for star_id in CONSTELLATIONS[name]:
        celestial = warsaw.at(t).observe(Star.from_dataframe(df.loc[star_id]))
        alt, az, dist = celestial.apparent().altaz()
        
        positions.append({
            "id": star_id,
            'position': CelestialPosition( name = str(star_id),
                                          altitude = str(alt),
                                          azimuth = str(az),
                                          distance = dist.au)
        })
    return {
            "constellation": name,
            "stars": positions,
        }