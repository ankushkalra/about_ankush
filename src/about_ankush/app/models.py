from sqlalchemy import Integer, Text, DateTime, func
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column
from datetime import datetime

class Base(DeclarativeBase):
    pass

class Note(Base):
    __tablename__ = "notes"

    id: Mapped[int] = mapped_column(
        Integer, primary_key=True, autoincrement=True
    )
    content: Mapped[str] = mapped_column(Text, nullable=False)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False,
    )

class ModelDemo(Base):
    __tablename__ = "model_demo"

    id: Mapped[int] = mapped_column(
        Integer, primary_key=True, autoincrement=True
    )
    message: Mapped[str] = mapped_column(Text, nullable=False)
