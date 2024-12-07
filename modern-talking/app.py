from fastapi import FastAPI, HTTPException
from fastapi.responses import FileResponse
from typing import Optional

app = FastAPI()

# Predefined dictionaries mapping input strings to audio file paths.
initial_audio_map = {
    "mars": "audio_files/mars1.mp3",
    "big_dipper": "audio_files/dipp1.mp3",
    "venus": "audio_files/venus1.mp3",
    "cassiopeia": "audio_files/cass1.mp3"
}

followup_audio_map = {
    "mars": "audio_files/mars2.mp3",
    "big_dipper": "audio_files/dipp2.mp3",
    "venus": "audio_files/venus2.mp3",
    "cassiopeia": "audio_files/cass2.mp3"
}

@app.get("/get_initial")
def get_initial(input: Optional[str] = None):
    """
    For a given 'input' string, return the corresponding initial audio file.
    """
    if input is None:
        raise HTTPException(status_code=400, detail="Query parameter 'input' is required.")
    
    if input in initial_audio_map:
        file_path = initial_audio_map[input]
        return FileResponse(file_path, media_type="audio/wav", filename=file_path.split("/")[-1])
    else:
        raise HTTPException(status_code=404, detail=f"No audio file found for input: {input}")

@app.get("/get_followup")
def get_followup(input: Optional[str] = None):
    """
    For a given 'input' string, return the corresponding follow-up audio file.
    """
    if input is None:
        raise HTTPException(status_code=400, detail="Query parameter 'input' is required.")
    
    if input in followup_audio_map:
        file_path = followup_audio_map[input]
        return FileResponse(file_path, media_type="audio/wav", filename=file_path.split("/")[-1])
    else:
        raise HTTPException(status_code=404, detail=f"No audio file found for input: {input}")
