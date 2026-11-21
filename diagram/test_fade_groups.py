# Test for fade_groups.py. Run: python -B diagram/test_fade_groups.py
import os, sys, tempfile
import xml.etree.ElementTree as ET
sys.path.insert(0, os.path.dirname(__file__))
from fade_groups import fade_groups

F = 'opacity=20;textOpacity=20;'
SRC = '''<mxfile><diagram id="d"><mxGraphModel><root><mxCell id="0"/><mxCell id="1" parent="0"/>
<mxCell id="cloud" value="AWS Cloud" style="shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_aws_cloud_alt;dashed=0;" vertex="1" parent="1"><mxGeometry x="0" y="0" width="1000" height="1000" as="geometry"/></mxCell>
<mxCell id="region" value="Region" style="shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_region;dashed=1;" vertex="1" parent="1"><mxGeometry x="0" y="0" width="1000" height="1000" as="geometry"/></mxCell>
<mxCell id="gAll" value="all faded" style="rounded=0;dashed=1;mxgraph.aws4.group;" vertex="1" parent="1"><mxGeometry x="0" y="0" width="300" height="100" as="geometry"/></mxCell>
<mxCell id="gMix" value="one solid" style="rounded=0;dashed=1;mxgraph.aws4.group;" vertex="1" parent="1"><mxGeometry x="400" y="0" width="300" height="100" as="geometry"/></mxCell>
<mxCell id="gEmpty" value="no icons" style="rounded=0;dashed=1;mxgraph.aws4.group;" vertex="1" parent="1"><mxGeometry x="0" y="500" width="100" height="100" as="geometry"/></mxCell>
<mxCell id="e" value="x" style="html=1;" edge="1" parent="1" source="a" target="c"><mxGeometry relative="1" as="geometry"/></mxCell>
<mxCell id="a" value="A" style="icon;opacity=20;textOpacity=20;" vertex="1" parent="1"><mxGeometry x="10" y="10" width="64" height="64" as="geometry"/></mxCell>
<mxCell id="b" value="B" style="icon;opacity=20;textOpacity=20;" vertex="1" parent="1"><mxGeometry x="200" y="10" width="64" height="64" as="geometry"/></mxCell>
<mxCell id="c" value="C" style="icon;" vertex="1" parent="1"><mxGeometry x="410" y="10" width="64" height="64" as="geometry"/></mxCell>
<mxCell id="d" value="D" style="icon;opacity=20;textOpacity=20;" vertex="1" parent="1"><mxGeometry x="600" y="10" width="64" height="64" as="geometry"/></mxCell>
<mxCell id="out" value="far" style="icon;" vertex="1" parent="1"><mxGeometry x="280" y="10" width="64" height="64" as="geometry"/></mxCell>
</root></mxGraphModel></diagram></mxfile>'''

d = tempfile.mkdtemp()
src, out = os.path.join(d, 'in.drawio'), os.path.join(d, 'out.drawio')
open(src, 'w', encoding='utf-8').write(SRC)
fade_groups(src, out)
by = {c.get('id'): c for c in ET.parse(out).getroot().iter('mxCell')}
st = lambda i: by[i].get('style') or ''

# every icon inside is faded -> box faded (icon "out" has centre x=312, outside gAll which ends at 300)
assert st('gAll').endswith(F), st('gAll')
# at least one solid icon inside -> box stays solid
assert 'opacity' not in st('gMix'), st('gMix')
# box with no icons is left alone
assert 'opacity' not in st('gEmpty'), st('gEmpty')
# outer AWS Cloud and Region boxes never fade (Region is dashed too)
assert 'opacity' not in st('cloud') and 'opacity' not in st('region')
# icons and edges untouched, cell order untouched
assert st('a') == 'icon;opacity=20;textOpacity=20;' and st('c') == 'icon;' and st('e') == 'html=1;'
assert [c.get('id') for c in by.values()] == ['0', '1', 'cloud', 'region', 'gAll', 'gMix', 'gEmpty', 'e', 'a', 'b', 'c', 'd', 'out']

# running twice does not stack opacity; in-place (src == out) works
fade_groups(out, out)
assert ET.parse(out).getroot().find(".//mxCell[@id='gAll']").get('style').count('opacity=20') == 1

# nothing faded (overview / 5.12) -> no box faded
open(src, 'w', encoding='utf-8').write(SRC.replace('opacity=20;textOpacity=20;', ''))
fade_groups(src, out)
assert 'opacity' not in ET.tostring(ET.parse(out).getroot(), encoding='unicode')
print('fade_groups: all tests passed')
