#!/usr/bin/env python3

import argparse
import os
import hashlib
import json
from jinja2 import Environment, FileSystemLoader

# Capture our current directory
THIS_DIR = os.path.dirname(os.path.abspath(__file__))

h = "Hannover: "
domains = {
    0: { "names": { "legacy": "Legacy" } },
    10: { "names": { "hameln": "Hameln", "alfeld": "Alfeld" }, },
    11: { "names": { "lenthe": "Lenthe" } },
    12: { "names": { "steinhude": "Steinhude" } },
    13: { "names": { "springe": "Springe", "obernkirchen": "Obernkirchen" } },
    14: { "names": { "nordstadt": h+'Nordstadt' } },
    15: { "names": { "wunstorf": "Wunstorf", "neustadt": "Neustadt", "nienburg": "Nienburg/Weser" } },
    16: { "names": {
        "wettbergen": h+'Wettbergen',
        "oberricklingen": h+"Oberricklingen",
        "muehlenberg": h+"Mühlenberg",
        "bornum": h+"Bornum",
        "ricklingen": h+"Ricklingen",
        "barsinghausen": "Barsinghausen",
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
        "garbsen": 'Garbsen',
        "langenhagen": 'Langenhagen',
        "seelze": 'Seelze',
        "isernhagen": 'Isernhagen',
        "burgdorf": 'Burgdorf',
        "burgwedel": 'Burgwedel',
        "uetze": 'Uetze',
        "langenhagen": 'Langenhagen',
        "stoecken": h+'Stöcken',
        "marienwerder": h+'Marienwerder',
        "ledeburg": h+'Ledeburg',
        "nordhafen": h+'Nordhafen',
        "burg": h+'Burg',
        "hainholz": h+'Hainholz',
        "vahrenwald": h+'Vahrenwald',
        "herrenhausen": h+'Herrenhausen',
        "leinhausen": h+'Leinhausen',
        "vinnhorst": h+'Vinnhorst',
        "brinkhafen": h+'Brinkhafen',
        "schwarmstedt": 'Schwarmstedt'
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
        "laatzen": 'Laatzen',
        "sehnde": 'Sehnde',
        "sarstedt": 'Sarstedt',
        "pattensen": 'Pattensen',
        "hildesheim": 'Hildesheim'
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
        "lehrte": 'Lehrte',
        "isernhagensued": h+'Isernhagen Süd',
    } },
    22: { "names": {
        "umland": "Umland",
        "wennigsen": "Wennigsen",
        "gehrden": "Gehrden",
        "hemmingen": "Hemmingen",
        "ronnenberg": "Ronnenberg",
        "peinewest": "Peine-West"
	  } },
    23: { "names": { "special_port": "Special Port" }, "hide": True, "port": 500 },
    99: { "names": { "leetfeld": "Leetfeld (1337, invalid)"}, "hide": True }
}

def generate_domaincode_file(outpath=None):
    """
    Generate a json dict within a json dict beneath the key "domaincodes".
    The k-v-pairs within represent the association between bat-device and
    domaincode.
    The only argument is the full path of the json file to generate.
    This solution is expected to be temporary and is matter to be removed,
    as soon as https://github.com/freifunk-gluon/gluon/issues/1974
    is both decided on and implemented in gluon.
    """
    if None is outpath:
        outpath="{}/domaincodes.json".format(THIS_DIR)

    interface_pattern="bat{}"
    domaincode_pattern="dom{}"

    outdict = {"domaincodes": {}}
    for ids in domains:
        outdict["domaincodes"][interface_pattern.format(ids)]=domaincode_pattern.format(ids)

    with open(outpath, 'w') as json_file:
        json.dump(outdict, json_file)

def render(id, names, seed, hide, port):
    j2_env = Environment(loader=FileSystemLoader(THIS_DIR),
                         trim_blocks=True)
    return j2_env.get_template('template.j2').render(
        id=id,
        names=names,
        seed=seed,
        hide=hide,
        str=str,
        port=port
    )

if __name__ == '__main__':


    parser = argparse.ArgumentParser()
    parser.add_argument('--dcf', nargs='?', default="NOT_GIVEN", metavar='DCF_PATH')

    args = parser.parse_args()

    # if --dcf is given generate the domaincode-file
    if "NOT_GIVEN" != args.dcf:
        generate_domaincode_file(args.dcf)
        exit()

    # else head back to usual business and generate dom.confs
    for id, values in domains.items():
        primary_code = 'dom' + str(id)
        primary_name = 'Domain ' + str(id)

        names = values['names']
        names[primary_code] = primary_name

        seed = hashlib.sha256(b'ffh-' + primary_code.encode('utf-8')).hexdigest()

        hide = values.get('hide', False)
        port = values.get('port', 10000 + id)

        with open(THIS_DIR + '/' + primary_code + '.conf', 'w') as f:
            f.write(render(id, names, seed, hide, port))
