from skyfield.api import N, S, E, W, wgs84, load
from fastapi import FastAPI
from models import CelestialPosition
app = FastAPI()



@app.get('/position/{name}')
async def getCelestalPosiition(name):
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