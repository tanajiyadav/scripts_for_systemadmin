#!/usr/bin/env python
import sys
import dns.resolver
def arecord(site):
    try:
        ip = dns.resolver.query(site,"A")
        for i in ip:
            print i
    except Exception,e:
        ' ' 

def mxrecord(site):
    try:
        ip = dns.resolver.query(site,"MX")
        for i in ip:
            return i
    except Exception,e:
        '' 

if __name__ == "__main__":
    from optparse import OptionParser
    parser = OptionParser()
    parser.add_option("-a", dest="a", help="Search A Record")
    parser.add_option("-x", dest="mx", help="Search MX Record")
    (options, args) = parser.parse_args()
    if options.a:     
        arecord(options.a)
    if options.mx:
        mxrecord(options.mx)
    if not len(sys.argv) == 3:
        print "-h to help"
