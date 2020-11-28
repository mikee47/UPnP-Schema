#!/usr/bin/env python3
#
# Script to generate device class units
#

from lxml import etree
import os
import argparse


def quote(s):
    if s[0].isdigit():
        s = '_' + s;
    return '"' + s + '"'


if __name__ == "__main__":

    parser = argparse.ArgumentParser(description='UPnP Code Generator')
    parser.add_argument('-t', '--transform', metavar='filename', required=True, help='XSLT transform file')
    parser.add_argument('-i', '--input', metavar='filename', required=True, help='Device description .xml or directory path')
    parser.add_argument('-o', '--output', metavar='filename', required=True, help='Output filename')
    args = parser.parse_args()

    srcfile = args.input.replace("\\", "/")
    dstfile = args.output.replace("\\", "/")

    if os.path.isdir(srcfile):
        # Combine all files into single tree under 'root'
        root = etree.Element('root')
        original_tree = etree.ElementTree(root)

        def list(kind):
            objects = []
            path = os.path.join(srcfile, kind)
            if os.path.exists(path):
                for f in os.listdir(path):
                    objects.append(os.path.join(path, f))
            return objects

        objects = list('device')
        objects.extend(list('service'))

        for schema in objects:
            tree = etree.parse(schema)
            t = tree.getroot()
            t.attrib['schema'] = schema.replace('\\', '/')
            root.append(t)

#         with open('merged.xml', 'wb') as f:
#             original_tree.write_c14n(f)
    else:
        original_tree = etree.parse(srcfile)
        t = original_tree.getroot()
        t.attrib['schema'] = srcfile

    xslt_tree = etree.parse(args.transform)
    xslt = etree.XSLT(xslt_tree)

    dstDir = os.path.dirname(dstfile)
    if dstDir != '':
        os.makedirs(dstDir, exist_ok=True)

    lom_tree = xslt(original_tree)
    with open(dstfile, 'w') as f:
        f.write(str(lom_tree))
