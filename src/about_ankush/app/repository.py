from sqlalchemy import select 
from sqlalchemy.orm import Session

from about_ankush.app.database import engine
from about_ankush.app.models import Note

def get_notes(session: Session):
    notes = session.scalars(select(Note)).all()

    return [
        {"id": note.id, "content": note.content, "created_at": note.created_at}
        for note in notes
    ]

def add_note(session: Session, content: str):
        note = Note(content=content)

        session.add(note)
        session.commit()
        session.refresh(note)

        return {"id": note.id, "content": note.content, "created_at": note.created_at }

