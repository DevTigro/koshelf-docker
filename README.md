## KoShelf Docker

Unofficial Docker image for [KoShelf](https://github.com/paviro/KoShelf). \
All your KOReader notes & highlights combined into a beautiful reading dashboard with statistics.

---
### With Docker Compose

```yaml
services:
  koshelf:
    image: ghcr.io/devtigro/koshelf:latest
    ports:
     - "3000:3000"
    volumes:
      - /path/to/your/books:/books:ro
      - /path/to/your/settings:/settings:ro
    environment:
      KOSHELF_TITLE: "My KoShelf"
    restart: "unless-stopped"
```
---

### Using Syncthing for Live Data Sync

The two volumes mounted into the container (/books and /settings) can be kept up to date automatically by syncing them with [Syncthing](https://syncthing.net/) or any other file synchronization tool. This means:

You can run Syncthing on your host or across multiple devices to sync your KOReader books and settings folders in real-time.

The KoShelf Docker container will automatically reflect the latest notes, highlights, and settings without needing to restart or manually update data.

This setup allows for seamless syncing of your reading data between devices while KoShelf always serves the most recent version.

### Enviroment Variables
|Enviroment Variable| cli flag|
|-------------------|---------|
|KOSHELF_BOOKS_PATH|flag|--books-path|
|KOSHELF_STATISTICS_DB|--statistics-db| 
|KOSHELF_PORT|--port|
|KOSHELF_DOCSETTINGS_PATH|--docsettings-path|
|KOSHELF_HASHDOCSETTINGS_PATH|--hashdocsettings-path|
|KOSHELF_OUTPUT|--output|
|KOSHELF_WATCH|--watch|
|KOSHELF_TITLE|--title|
|KOSHELF_INCLUDE_UNREAD|--include-unread|
|KOSHELF_HEATMAP_SCALE_MAX|--heatmap-scale-max|
|KOSHELF_TIMEZONE|--timezone|
|KOSHELF_DAY_START_TIME|--day-start-time|
|KOSHELF_MIN_PAGES_PER_DAY|--min-pages-per-day|
|KOSHELF_MIN_TIME_PER_DAY|--min-time-per-day|
|KOSHELF_INCLUDE_ALL_STATS|--include-all-stats|

for detailed information regarding the cli flags please look at the https://github.com/paviro/KoShelf repository
