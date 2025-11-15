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
```
---

### Using Syncthing for Live Data Sync

The two volumes mounted into the container (/books and /settings) can be kept up to date automatically by syncing them with [Syncthing](https://syncthing.net/) or any other file synchronization tool. This means:

You can run Syncthing on your host or across multiple devices to sync your KOReader books and settings folders in real-time.

The KoShelf Docker container will automatically reflect the latest notes, highlights, and settings without needing to restart or manually update data.

This setup allows for seamless syncing of your reading data between devices while KoShelf always serves the most recent version.