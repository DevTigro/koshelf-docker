#!/bin/sh
set -e

ARGS=""

if [ -n "$KOSHELF_BOOKS_PATH" ]; then
    ARGS="$ARGS --books-path $KOSHELF_BOOKS_PATH"
fi

if [ -n "$KOSHELF_STATISTICS_DB" ]; then
    ARGS="$ARGS --statistics-db $KOSHELF_STATISTICS_DB"
fi

if [ -n "$KOSHELF_PORT" ]; then
    ARGS="$ARGS --port $KOSHELF_PORT"
fi

if [ -n "$KOSHELF_DOCSETTINGS_PATH" ]; then
    ARGS="$ARGS --docsettings-path $KOSHELF_DOCSETTINGS_PATH"
elif [ -n "$KOSHELF_HASHDOCSETTINGS_PATH" ]; then
    ARGS="$ARGS --hashdocsettings-path $KOSHELF_HASHDOCSETTINGS_PATH"
fi

if [ -n "$KOSHELF_OUTPUT" ]; then
    ARGS="$ARGS --output $KOSHELF_OUTPUT"
fi

if [ "$KOSHELF_WATCH" = "true" ]; then
    ARGS="$ARGS --watch"
fi

if [ -n "$KOSHELF_TITLE" ]; then
    ARGS="$ARGS --title \"$KOSHELF_TITLE\""
fi

if [ "$KOSHELF_INCLUDE_UNREAD" = "true" ]; then
    ARGS="$ARGS --include-unread"
fi

if [ -n "$KOSHELF_HEATMAP_SCALE_MAX" ]; then
    ARGS="$ARGS --heatmap-scale-max $KOSHELF_HEATMAP_SCALE_MAX"
fi

if [ -n "$KOSHELF_TIMEZONE" ]; then
    ARGS="$ARGS --timezone $KOSHELF_TIMEZONE"
fi

if [ -n "$KOSHELF_DAY_START_TIME" ]; then
    ARGS="$ARGS --day-start-time $KOSHELF_DAY_START_TIME"
fi

if [ -n "$KOSHELF_MIN_PAGES_PER_DAY" ]; then
    ARGS="$ARGS --min-pages-per-day $KOSHELF_MIN_PAGES_PER_DAY"
fi

if [ -n "$KOSHELF_MIN_TIME_PER_DAY" ]; then
    ARGS="$ARGS --min-time-per-day $KOSHELF_MIN_TIME_PER_DAY"
fi

echo "Starting KoShelf with: /koshelf $ARGS $@"
eval exec /koshelf $ARGS "$@"
