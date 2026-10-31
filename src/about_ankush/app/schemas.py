from datetime import datetime
from pydantic import BaseModel

class NoteCreate(BaseModel):
    content: str


class NoteResponse(BaseModel):
    id: int
    content: str
    created_at: datetime
