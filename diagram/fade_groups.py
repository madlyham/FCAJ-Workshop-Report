# Fade the coloured section boxes (Global edge, API backend, ...) whose icons are ALL faded.
# Runs after focus_view.py, which fades icons but leaves every group box solid.
# AWS Cloud / Region boxes (they carry a grIcon) never fade. Boxes with no icons are left alone.
# Usage: python -B diagram/fade_groups.py in.drawio out.drawio   (in == out is fine)
import sys
import xml.etree.ElementTree as ET

FADE = 'opacity=20;textOpacity=20;'


def _box(cell):
    g = cell.find('mxGeometry')
    x, y = float(g.get('x', 0)), float(g.get('y', 0))
    return x, y, float(g.get('width', 0)), float(g.get('height', 0))


def fade_groups(src, out):
    tree = ET.parse(src)
    verts = [c for c in tree.getroot().iter('mxCell') if c.get('vertex') == '1']
    groups = [c for c in verts if 'mxgraph.aws4.group' in (c.get('style') or '')]
    icons = [c for c in verts if c not in groups]
    for g in groups:
        st = g.get('style') or ''
        if 'grIcon=' in st or 'opacity=' in st:
            continue
        gx, gy, gw, gh = _box(g)
        inside = []
        for i in icons:
            x, y, w, h = _box(i)
            cx, cy = x + w / 2, y + h / 2
            if gx <= cx <= gx + gw and gy <= cy <= gy + gh:
                inside.append(i)
        if inside and all('opacity=' in (i.get('style') or '') for i in inside):
            g.set('style', st if st.endswith(';') or not st else st + ';')
            g.set('style', g.get('style') + FADE)
    tree.write(out, encoding='utf-8')


if __name__ == '__main__':
    fade_groups(sys.argv[1], sys.argv[2])
