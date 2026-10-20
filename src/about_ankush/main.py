from fastapi import FastAPI

app = FastAPI(title="About Ankush");

@app.get("/")
async def root():
  return { "message" : "hello, world" }

