# Test for labels_front.py. Run: python -B diagram/test_labels_front.py
import os, sys, tempfile
import xml.etree.ElementTree as ET
sys.path.insert(0, os.path.dirname(__file__))
from labels_front import labels_front

SRC = '''<mxfile><diagram id="d"><mxGraphModel><root><mxCell id="0"/><mxCell id="1" parent="0"/>
<mxCell id="g" value="Group" style="mxgraph.aws4.group;" vertex="1" parent="1"><mxGeometry x="0" y="0" width="10" height="10" as="geometry"/></mxCell>
<mxCell id="e1" value="&lt;span style=&quot;background-color:#232F3E;color:#ffffff;&quot;&gt;1&lt;/span&gt; HTTPS" style="html=1;strokeColor=#545B64;labelBackgroundColor=#ffffff;" edge="1" parent="1" source="a" target="b"><mxGeometry x="-0.2" relative="1" as="geometry"><Array as="points"><mxPoint x="5" y="5"/></Array></mxGeometry></mxCell>
<mxCell id="e2" value="faded" style="html=1;strokeColor=#545B64;opacity=20;textOpacity=20;" edge="1" parent="1" source="a" target="b"><mxGeometry relative="1" as="geometry"/></mxCell>
<mxCell id="e3" value="" style="html=1;" edge="1" parent="1" source="a" target="b"><mxGeometry relative="1" as="geometry"/></mxCell>
<mxCell id="a" value="A" style="icon" vertex="1" parent="1"><mxGeometry x="0" y="0" width="64" height="64" as="geometry"/></mxCell>
<mxCell id="b" value="B" style="icon" vertex="1" parent="1"><mxGeometry x="100" y="0" width="64" height="64" as="geometry"/></mxCell>
</root></mxGraphModel></diagram></mxfile>'''

d = tempfile.mkdtemp()
src, out = os.path.join(d, 'in.drawio'), os.path.join(d, 'out.drawio')
open(src, 'w', encoding='utf-8').write(SRC)
labels_front(src, out)
cells = ET.parse(out).getroot().find('.//root').findall('mxCell')
ids = [c.get('id') for c in cells]
by = {c.get('id'): c for c in cells}

# order: groups, original edges, label copies, then icons (icons stay on top)
assert ids == ['0', '1', 'g', 'e1', 'e2', 'e3', 'e1_label', 'e2_label', 'a', 'b'], ids
# originals keep their line but lose the text
assert by['e1'].get('value') == '' and by['e2'].get('value') == ''
assert 'strokeColor=#545B64' in by['e1'].get('style')
# empty-label edge gets no copy
assert 'e3_label' not in by
# copy: same ends + same route, invisible line, solid white label background
c = by['e1_label']
assert (c.get('source'), c.get('target')) == ('a', 'b')
assert 'HTTPS' in c.get('value')
st = c.get('style')
assert st.endswith('strokeColor=none;startArrow=none;endArrow=none;labelBackgroundColor=#ffffff;'), st
g = c.find('mxGeometry')
assert g.get('x') == '-0.2' and g.find('Array/mxPoint').get('x') == '5'
# faded copy: no see-through text, grey text + grey badge instead, still solid white background
f = by['e2_label']
fs = f.get('style')
assert 'textOpacity' not in fs and 'opacity=20' not in fs, fs
assert 'fontColor=#AAB0B8' in fs and fs.endswith('labelBackgroundColor=#ffffff;'), fs
# faded badge colour swap
open(src, 'w', encoding='utf-8').write(SRC.replace('value="faded"', 'value="&lt;span style=&quot;background-color:#232F3E;&quot;&gt;2&lt;/span&gt; x"'))
labels_front(src, out)
fv = {c.get('id'): c for c in ET.parse(out).getroot().iter('mxCell')}['e2_label'].get('value')
assert '#232F3E' not in fv and 'background-color:#C8CCD1' in fv, fv
print('labels_front: all tests passed')
