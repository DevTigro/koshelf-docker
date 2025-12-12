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
|Enviroment Variable| cli flag|explanaition|
|-------------------|---------|------------|
|KOSHELF_BOOKS_PATH: "/books"|--books-path|Path to your folder containing EPUB files and KoReader metadata (optional if KOSHELF_STATISTICS_DB is provided)|
|KOSHELF_STATISTICS_DB: "/settings"|--statistics-db| Path to the folder with the statistics.sqlite3 file for additional reading stats (optional if KOSHELF_BOOKS_PATH is provided)|
|KOSHELF_PORT: 3000|--port|Port for web server mode (default: 3000)|
|KOSHELF_DOCSETTINGS_PATH: "/docsettings"|--docsettings-path|Path to KOReader's docsettings folder for users who store metadata separately (requires KOSHELF_BOOKS_PATH, mutually exclusive with KOSHELF_HASHDOCSETTINGS_PATH)|
|KOSHELF_HASHDOCSETTINGS_PATH|--hashdocsettings-path|Path to KOReader's hashdocsettings folder for users who store metadata by content hash (requires KOSHELF_BOOKS_PATH, mutually exclusive with KOSHELF_DOCSETTINGS_PATH)|
|KOSHELF_OUTPUT: True|--output|Output directory for the generated site|
|KOSHELF_WATCH: True|--watch|Enable file watching with static output (requires KOSHELF_OUTPUT)|
|KOSHELF_TITLE: "My KoShelf"|--title|Site title (default: "KoShelf")|
|KOSHELF_INCLUDE_UNREAD: True|--include-unread|Include unread books (EPUBs without KoReader metadata)|
|KOSHELF_HEATMAP_SCALE_MAX: "auto"|--heatmap-scale-max|Maximum value for heatmap color intensity scaling (e.g., "auto", "1h", "1h30m", "45min"). Values above this will still be shown but use the highest color intensity. Default is "auto" for automatic scaling|
|KOSHELF_TIMEZONE: "Europe/Oslo" |--timezone|Timezone to interpret timestamps (IANA name, e.g., Australia/Sydney); defaults to system local|
|KOSHELF_DAY_START_TIME: "02:00" |--day-start-time|Logical day start time as HH:MM (default: 00:00)|
|KOSHELF_MIN_PAGES_PER_DAY: 3|--min-pages-per-day|Minimum pages read per book per day to be counted in statistics (optional)|
|KOSHELF_MIN_TIME_PER_DAY: "10m"|--min-time-per-day|Minimum reading time per book per day to be counted in statistics (e.g., "15m", "1h") (optional) \
Note: If both KOSHELF_MIN_PAGES_PER_DAY and KOSHELF_MIN_TIME_PER_DAY are provided, a book's data for a day is counted if either condition is met for that book on that day. These filters apply per book per day, meaning each book must individually meet the threshold for each day to be included in statistics.|
|KOSHELF_INCLUDE_ALL_STATS: True|--include-all-stats|By default, statistics are filtered to only include books present in your KOSHELF_BOOKS_PATH directory. This prevents deleted books or external files (like Wallabag articles) from skewing your recap and statistics. Use this flag to include statistics for all books in the database, regardless of whether they exist in your library.|
|KOSHELF_LANGUAGE: "de_DE"|--language|Language for UI translations. Supported: de, en, fr, pt. Use full locale code (e.g., en_US, de_DE, pt_BR) for correct date formatting. Default: en_US|

for detailed information regarding the cli flags please look at the https://github.com/paviro/KoShelf repository too.
