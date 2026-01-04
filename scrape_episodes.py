#!/usr/bin/env python3
import random
from bs4 import BeautifulSoup
import json
import re
import time
import urllib.request
import urllib.parse

from markdownify import markdownify

CHANNEL_ID = "5189486"
CHANNEL_URL = (
    f"https://castbox.fm/channel/How-About-Tomorrow--id{CHANNEL_ID}?country=us"
)


def get(url):
    return urllib.request.urlopen(url).read().decode("utf-8")


def random_sleep():
    seconds = random.uniform(0.1, 0.3)
    time.sleep(seconds)


html = get(CHANNEL_URL)
match = re.search(r'window\.__INITIAL_STATE__\s*=\s*"([^"]+)"', html)
data = json.loads(urllib.parse.unquote(match.group(1)))
eids = data.get("ch", {}).get("overview", {}).get("eids", [])

for i, eid in enumerate(eids):
    ep_url = f"https://castbox.fm/episode/id{CHANNEL_ID}-id{eid}?country=us"
    ep_html = get(ep_url)
    soup = BeautifulSoup(ep_html, "html.parser")

    title = soup.select_one(".trackinfo-title")["title"]
    mp3_url = soup.select_one("audio > source")["src"]
    desc = markdownify(str(soup.select_one(".trackinfo-des")))

    episode = {
        "title": title,
        "url": mp3_url,
        "description": desc,
    }
    print(json.dumps(episode), flush=True)

    random_sleep()
