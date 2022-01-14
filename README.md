# bimba-elixir 🚋 🚌 

Quite simple backend application written in Elixir and Phoenix. Consumes real-time monitoring trams and busses API of ZTM Poznań API (which is public). 

ℹ️ Created back in 2019 as a hobby to learn Elixir/Phoenix and React.js (project not published). 

At the moment consists only two endpoints:
- `/request` - proxy to PEKA Wirtualny Monitor (https://www.peka.poznan.pl/vm/).
- `/search` - returns stops matched by provided pattern.

✏️ Features:
- `Ztm.Workers.ImportStops` daily running worker which downloads list of stops/bollards and updates the database.

💡 Ideas:
1. Get rid of `Ztm.Workers.ImportStops` worker and `/search` endpoint in favor of caching search requests for bollards. The reason is that stops/bollards data apparently contains inactive stops.
2. Create LiveView UI to replace React.js application.
