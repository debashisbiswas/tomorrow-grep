#!/usr/bin/env python3
import json
import os
import re

EPISODES_FILE = "episodes.jsonl"
TRANSCRIPTS_DIR = "transcripts"


def slugify(text):
    text = text.lower()
    text = re.sub(r"[^a-z0-9]+", "-", text)
    return text.strip("-")


with open(EPISODES_FILE) as f:
    for line in f:
        ep = json.loads(line)
        slug = slugify(ep["title"])
        url = ep["url"]
        if os.path.exists(os.path.join(TRANSCRIPTS_DIR, f"{slug}.vtt")):
            continue
        print(f"{slug}\t{url}")
