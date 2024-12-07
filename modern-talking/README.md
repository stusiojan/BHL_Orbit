# morder-talking morgan-freeman talking

Mocking endpoints:

```
http://127.0.0.1:8000/get_initial?input=hello
http://127.0.0.1:8000/get_followup?input=hello
```

We have data for followng celestial bodies (`input` parameter):
- `mars`
- `venus`
- `big_dipper`
- `casseiopia`


How to run service:

```bash
pip install -r requirements.txt
uvicorn app:app --reload
```

What were original followup questions?

- mars - "If Mars once had rivers and oceans, where did all the water go? Could it ever return?"
- venus - "If Venus is so hostile, how could we ever hope to explore her, let alone understand her mysteries?"
- big dipper - "You speak of these stars with such reverence, but are they truly eternal, or will the Big Dipper too vanish someday?"
- cassiopeia - "You spoke of the Heart Nebula within Cassiopeia—what makes it so special, and can we truly glimpse its secrets from here on Earth?"

