# Put arrow labels in FRONT of the lines, on a solid white box.
# draw.io draws all edges in file order, so a label can be crossed by a later line.
# Fix: blank each edge's text, then add an invisible copy of that edge (same route, text only)
# after all edges -> every label is drawn above every line. Icons stay on top.
# Usage: python -B diagram/labels_front.py in.drawio out.drawio
import sys
import xml.etree.ElementTree as ET

FRONT = 'strokeColor=none;startArrow=none;endArrow=none;labelBackgroundColor=#ffffff;'
FADED_TEXT = '#AAB0B8'   # grey text for faded (out-of-scope) labels
FADED_BADGE = '#C8CCD1'  # grey number badge for faded labels


def _parts(style):
    return [p for p in (style or '').split(';') if p]


def _key(part):
    return part.split('=', 1)[0]


def labels_front(src, out):
    tree = ET.parse(src)
    root = tree.getroot().find('.//root')
    cells = list(root)
    edges = [i for i, c in enumerate(cells) if c.get('edge') == '1']
    if not edges:
        tree.write(out, encoding='utf-8', xml_declaration=False)
        return
    copies = []
    for i in edges:
        e = cells[i]
        val = e.get('value') or ''
        if not val.strip():
            continue
        parts = _parts(e.get('style'))
        faded = any(_key(p) in ('opacity', 'textOpacity') for p in parts)
        drop = {'strokeColor', 'startArrow', 'endArrow', 'labelBackgroundColor'}
        if faded:
            drop |= {'opacity', 'textOpacity', 'fontColor'}
        keep = [p for p in parts if _key(p) not in drop]
        if faded:
            keep.append('fontColor=' + FADED_TEXT)
            val = val.replace('background-color:#232F3E', 'background-color:' + FADED_BADGE)
        style = (';'.join(keep) + ';' if keep else '') + FRONT
        c = ET.fromstring(ET.tostring(e))
        c.set('id', e.get('id') + '_label')
        c.set('value', val)
        c.set('style', style)
        c.tail = e.tail
        copies.append(c)
        e.set('value', '')
    pos = edges[-1] + 1
    for k, c in enumerate(copies):
        root.insert(pos + k, c)
    tree.write(out, encoding='utf-8', xml_declaration=False)


if __name__ == '__main__':
    if len(sys.argv) != 3:
        sys.exit('usage: labels_front.py in.drawio out.drawio')
    labels_front(sys.argv[1], sys.argv[2])
