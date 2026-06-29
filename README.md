## KoShelf Docker

Unofficial Docker image for [KoShelf](https://github.com/paviro/KoShelf). \
A reading companion powered by KOReader metadata — browse your library, highlights, annotations, and reading statistics from a web dashboard.

## Breaking changes

### 2026.4
- new cli interface
- folder data required for serve option

---
### With Docker Compose

⚡️the volume /path/to/your/books needs to be rw if KOSHELF_ENABLE_WRITEBACK is used!

```yaml
services:
  koshelf:
    image: ghcr.io/devtigro/koshelf:latest
    ports:
     - "3000:3000"
    volumes:
      - /path/to/your/books:/books:rw
      - /path/to/your/settings:/settings:ro
      - /path/to/koshelfdata
    environment:
      KOSHELF_TITLE: "My KoShelf"
    restart: "unless-stopped"
```
---

### CLI interface
#### serve           Start the web server (API + live data refresh)
Start the web server. Serves the embedded React app at / with API endpoints under /api/**, and automatically refreshes data on library changes. (Default in the container)
#### export          Generate a static site
Generate a static site to the given directory. This is not tested right now for the docker container
#### set-password    Set the authentication passwor
`docker exec koshelf koshelf github` 
set or rotate the serve-mode authentication password, for details see https://github.com/paviro/KoShelf/blob/main/docs/authentication.md
#### list-languages  List all supported UI languages and exit
`docker exec koshelf koshelf list-languages` 
Print all supported UI locales and exit.
#### github          Print the GitHub repository URL and exit
`docker exec koshelf koshelf github` 
Print the repository URL and exit.

### Usage of toml file for confguration
Currently the configuration with a toml file is not supported

### Using Syncthing for Live Data Sync

The two volumes mounted into the container (/books and /settings) can be kept up to date automatically by syncing them with [Syncthing](https://syncthing.net/) or any other file synchronization tool. This means:

You can run Syncthing on your host or across multiple devices to sync your KOReader books and settings folders in real-time.

The KoShelf Docker container will automatically reflect the latest notes, highlights, and settings without needing to restart or manually update data.

This setup allows for seamless syncing of your reading data between devices while KoShelf always serves the most recent version.

### Enviroment Variables
|Enviroment Variable| cli flag|explanaition|
|-------------------|---------|------------|
|KOSHELF_LIBRARY_PATH: "/books"|--library-path|Path(s) to folders containing ebooks (EPUB, FB2, MOBI) and/or comics (CBZ, CBR) with KoReader metadata. Can be specified multiple times. <br> replaces the deprecated KOSHELF_BOOKS_PATH (can still be used for now)|
|KOSHELF_STATISTICS_DB: "/settings"|--statistics-db| Path to the folder with the statistics.sqlite3 file for additional reading stats|
|KOSHELF_PORT: 3000|--port|Port for web server mode (default: 3000)|
|KOSHELF_DOCSETTINGS_PATH: "/docsettings"|--docsettings-path|Path to KOReader's docsettings folder for users who store metadata separately (requires KOSHELF_BOOKS_PATH, mutually exclusive with KOSHELF_HASHDOCSETTINGS_PATH)|
|KOSHELF_HASHDOCSETTINGS_PATH: "/hashdocsettings"|--hashdocsettings-path|Path to KOReader's hashdocsettings folder for users who store metadata by content hash (requires KOSHELF_BOOKS_PATH, mutually exclusive with KOSHELF_DOCSETTINGS_PATH)|
|KOSHELF_OUTPUT: True|--output|Output directory for the generated site|
|KOSHELF_WATCH: True|--watch|Enable file watching with static output (requires KOSHELF_OUTPUT)|
|KOSHELF_TITLE: "My KoShelf"|--title|Site title (default: "KoShelf")|
|KOSHELF_INCLUDE_UNREAD: True|--include-unread|Include unread items (files without KoReader metadata)|
|KOSHELF_HEATMAP_SCALE_MAX: "auto"|--heatmap-scale-max|Maximum value for heatmap color intensity scaling (e.g., "auto", "1h", "1h30m", "45min"). Values above this will still be shown but use the highest color intensity. Default is "auto" for automatic scaling|
|KOSHELF_TIMEZONE: "Europe/Oslo" |--timezone|Timezone to interpret timestamps (IANA name, e.g., Australia/Sydney); defaults to system local|
|KOSHELF_DAY_START_TIME: "02:00" |--day-start-time|Logical day start time as HH:MM (default: 00:00)|
|KOSHELF_MIN_PAGES_PER_DAY: 3|--min-pages-per-day|Minimum pages read per book per day to be counted in statistics|
|KOSHELF_MIN_TIME_PER_DAY: "10m"|--min-time-per-day|Minimum reading time per book per day to be counted in statistics (e.g., "15m", "1h") <br> Note: If both KOSHELF_MIN_PAGES_PER_DAY and KOSHELF_MIN_TIME_PER_DAY are provided, a book's data for a day is counted if either condition is met for that book on that day. These filters apply per book per day, meaning each book must individually meet the threshold for each day to be included in statistics.|
|KOSHELF_INCLUDE_ALL_STATS: True|--include-all-stats|By default, statistics are filtered to only include books present in your KOSHELF_BOOKS_PATH directory. This prevents deleted books or external files (like Wallabag articles) from skewing your recap and statistics. Use this flag to include statistics for all books in the database, regardless of whether they exist in your library.|
|KOSHELF_IGNORE_STABLE_METADATA: "FALSE"|--ignore-stable-page-metadata|Ignore KOReader stable page metadata for page totals and page-based stats scaling. By default, stable metadata is used when available.|
|KOSHELF_LANGUAGE: "de_DE"|--language|Language for UI translations. Use full locale code (e.g., en_US, de_DE, pt_BR) for correct date formatting. Default: en_US|
|KOSHELF_ENABLE_AUTH: TRUE|--enable-auth|start server with auth enabled (on first run, KoShelf generates a password and prints it once) for details see https://github.com/paviro/KoShelf/blob/main/docs/authentication.md|
|KOSHELF_ENABLE_WRITEBACK: TRUE|--enable-writeback|writeback enabled (edit annotations and metadata from the UI) for this to work the folder 
|KOSHELF_TRUSTED_PROXIES: TRUE|--trusted-proxies|Comma-separated or repeated trusted reverse proxy IP/CIDR entries for forwarded client IP/proto resolution|
|KOSHELF_ENABLE_WRITEBACK: FALSE|--kobo-db|Path to Kobo's KoboReader.sqlite database. Used to discover matched extensionless kepub files and parse them as EPUBs. Requires --library-path.|

KOSHELF_LIBRARY_PATH (or if used KOSHELF_DOCSETTINGS_PATH or KOSHELF_HASHDOCSETTINGS_PATH)  needs to be writable for user with id 1000


for detailed information regarding the cli flags please look at the [Koshelf](https://github.com/paviro/KoShelf) repository too.
