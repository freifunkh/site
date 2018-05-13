#!/usr/bin/env python3

import os
import hashlib
from jinja2 import Environment, FileSystemLoader

# Capture our current directory
THIS_DIR = os.path.dirname(os.path.abspath(__file__))

h = "Hannover: "
domains = {
    0: { "names": { "legacy": "Legacy" } },
    10: { "names": { "hameln": "Hameln", "alfeld": "Alfeld" }, },
    11: { "names": { "lenthe": "Lenthe" } },
    12: { "names": { "steinhude": "Steinhude" } },
    13: { "names": { "springe": "Springe" } },
    14: { "names": { "nordstadt": h+'Nordstadt' } },
    15: { "names": { "wunstorf": "Wunstorf", "neustadt": "Neustadt" } },
    16: { "names": {
        "wettbergen": h+'Wettbergen',
        "oberricklingen": h+"Oberricklingen",
        "muehlenberg": h+"Mühlenberg",
        "bornum": h+"Bornum",
        "ricklingen": h+"Ricklingen",
        "barsinghausen": h+"Barsinghausen",
        "davenstedt": h+"Davenstedt",
        "ahlem": h+"Ahlem",
        "badenstedt": h+"Badenstedt"
    } },
    17: { "names": {
        "lindenmitte": h+'Linden Mitte',
        "lindennord": h+'Linden Nord',
        "lindensued": h+'Linden Sued',
        "limmer": h+'Limmer',
        "calenbergerneustadt": h+'Calenberger Neustadt'
    } },
    18: { "names": {
        "garbsen": h+'Garbsen',
        "stoecken": h+'Stöcken',
        "marienwerder": h+'Marienwerder',
        "ledeburg": h+'Ledeburg',
        "nordhafen": h+'Nordhafen',
        "burg": h+'Burg',
        "hainholz": h+'Hainholz',
        "vahrenwald": h+'Vahrenwald',
        "herrenhausen": h+'Herrenhausen',
        "leinhausen": h+'Leinhausen',
        "langenhagen": h+'Langenhagen',
        "vinnhorst": h+'Vinnhorst',
        "brinkhafen": h+'Brinkhafen'
    } },
    19: { "names": {
        "mitte": h+'Mitte',
        "suedstadt": h+'Südstadt',
        "bult": h+'Bult',
        "zoo": h+'Zoo'
    } },
    20: { "names": {
        "wuelfel": h+'Wülfel',
        "doehren": h+'Döhren',
        "waldhausen": h+'Waldhausen',
        "waldheim": h+'Waldheim',
        "seelhorst": h+'Seelhorst',
        "mittelfeld": h+'Mittelfeld',
        "bemerode": h+'Bemerode',
        "kirchrode": h+'Kirchrode',
        "anderten": h+'Anderten',
        "wuelferode": h+'Wülferode',
        "anderten": h+'Anderten',
        "laatzen": h+'Laatzen',
        "pattensen": h+'Pattensen'
    } },
    21: { "names": {
        "heideviertel": h+'Heideviertel',
        "misburgnord": h+'Misburg Nord',
        "misburgsued": h+'Misburg Süd',
        "kleefeld": h+'Kleefeld',
        "grossbuchholz": h+'Grossbuchholz',
        "lahe": h+'Lahe',
        "bothfeld": h+'Bothfeld',
        "sahlkamp": h+'Sahlkamp',
        "vahrenheide": h+'Vahrenheide',
        "list": h+'List',
        "oststadt": h+'Oststadt',
        "lehrte": h+'Lehrte',
        "isernhagensued": h+'Isernhagen Süd',
    } },
    22: { "names": { "umland": "Umland" } },
    99: { "names": { "leetfeld": "Leetfeld (1337, invalid)"}, "hide": True }
}

def render(id, names, seed, hide):
    j2_env = Environment(loader=FileSystemLoader(THIS_DIR),
                         trim_blocks=True)
    return j2_env.get_template('template.j2').render(
        id=id,
        names=names,
        seed=seed,
        hide=hide,
        str=str
    )

if __name__ == '__main__':

    for id, values in domains.items():
        primary_code = 'dom' + str(id)
        primary_name = 'Domain ' + str(id)

        names = values['names']
        names[primary_code] = primary_name

        seed = hashlib.sha256(b'ffh-' + primary_code.encode('utf-8')).hexdigest()

        hide = values.get('hide', False)

        with open(THIS_DIR + '/' + primary_code + '.conf', 'w') as f:
            f.write(render(id, names, seed, hide))
