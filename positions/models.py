from pydantic import BaseModel

class CelestialPosition(BaseModel):
    name: str
    altitude: str
    azimuth: str
    distance: float

