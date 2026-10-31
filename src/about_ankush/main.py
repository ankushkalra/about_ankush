from fastapi import FastAPI, Body, Depends
from sqlalchemy import text
from sqlalchemy.orm import Session
from about_ankush.app.database import engine, get_session
from about_ankush.app.schemas import NoteCreate, NoteResponse
from about_ankush.app.repository import get_notes, add_note

app = FastAPI()

@app.get("/")
async def root():
    with engine.connect() as connection:
        result = connection.execute(text("SELECT 1"))
        value = result.scalar()

    return { "database_value" : value }


@app.get("/notes", response_model=list[NoteResponse])
def read_notes(session: Session = Depends(get_session)):
    return get_notes(session)


@app.post("/notes", response_model=NoteResponse)
def create_note(
    note: NoteCreate,
    session: Session = Depends(get_session)
):
    return add_note(session, note.content)

