"""
Builds the playable single-file game (../index.html) from the source files in this folder.

    python build.py

Requires Python 3.8+ and nothing else. Edit the story, events, art or template,
run this script, then open index.html in a browser to test.
"""
import base64, glob, json, os

HERE = os.path.dirname(os.path.abspath(__file__))
p = lambda *a: os.path.join(HERE, *a)

template = open(p("template.html"), encoding="utf-8").read()

art = {}
for f in sorted(glob.glob(p("assets", "*.webp"))):
    key = os.path.splitext(os.path.basename(f))[0]
    data = base64.b64encode(open(f, "rb").read()).decode()
    art[key] = {"src": "data:image/webp;base64," + data}

story = {}
for f in sorted(glob.glob(p("story", "*.json"))):
    scenes = json.load(open(f, encoding="utf-8"))
    clash = set(scenes) & set(story)
    if clash:
        raise SystemExit(f"Duplicate scene ids in {os.path.basename(f)}: {sorted(clash)}")
    story.update(scenes)

# Sanity check: every link in every scene must point at a node that exists.
problems = []
for sid, sc in story.items():
    nodes = sc["nodes"]
    if sc["start"] not in nodes:
        problems.append(f"{sid}: start node '{sc['start']}' is missing")
    for nid, n in nodes.items():
        targets = [n.get("next")] + [c.get("next") for c in n.get("choices", [])] + [v.get("next") for v in n.get("variants", [])]
        for t in targets:
            if t and t not in nodes:
                problems.append(f"{sid}/{nid}: points to missing node '{t}'")
if problems:
    raise SystemExit("Story errors:\n  " + "\n  ".join(problems))

events = json.load(open(p("data", "events.json"), encoding="utf-8"))
endings = json.load(open(p("data", "endings.json"), encoding="utf-8"))

def js(obj):
    # Safe to embed inside a <script> block: "</script>" in the data can never close the tag.
    return json.dumps(obj, ensure_ascii=False).replace("</", "<\\/").replace("\u2028", "\\u2028").replace("\u2029", "\\u2029")

out = (template
       .replace("/*__ART__*/", js(art))
       .replace("/*__STORY__*/", js(story))
       .replace("/*__EVENTS__*/", js(events))
       .replace("/*__ENDRULES__*/", js(endings)))
dest = os.path.join(HERE, "..", "index.html")
open(dest, "w", encoding="utf-8").write(out)
print(f"Built index.html: {len(story)} scenes, {len(events)} events, {len(art)} images, {len(out) // 1024} KB")
