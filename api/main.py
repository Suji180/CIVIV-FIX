from fastapi import FastAPI, File, UploadFile
import exifread

app = FastAPI()

@app.post("/extract")
async def extract_metadata(file: UploadFile = File(...)):
    tags = exifread.process_file(file.file)
    data = {
        "DateTime": str(tags.get("EXIF DateTimeOriginal")),
        "GPSLatitude": str(tags.get("GPS GPSLatitude")),
        "GPSLongitude": str(tags.get("GPS GPSLongitude")),
    }
    return data