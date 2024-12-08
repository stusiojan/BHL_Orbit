#  Demo app

For demo purpuses star posisions are mocked in `data.swift` and audio_files in `Resources/`

Otherwise we would use ours sercives to get:
- star posisions
- some quick LLM model response from RAG with curated stars data ( f. ex. Gemini Flash 1.5, GPT o1 mini)
- generate audio files with ElevenLabs

So user can get informative answer to every question that occurs.

## Architecture

We used MVVM, which is common choise for scalable and testable apps.

We store data models and mock data in `Models` directory

`Views` holds all view rendering logic

View Model part of MVVM is represented here by `Managers` and `Services`(where would API calls to our python services: RAG, speach-to-text, text-to-speach and star posisions)

UI and Unit test would be in a different target called SkySenseTests


## Launch

You must use iPhone and have apple account.

1. Sign this project with you apple developer ID

2. Turn on developer mode in iPhone

3. Select your phone as the targer build output

4. build and run

