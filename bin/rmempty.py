#!/usr/bin/python
'''
'''

import sys
import os
import argparse
from bunch import Bunch
import traceback


APP_NAME = 'rmempty'

GV = Bunch()


def main(args=sys.argv[1:]):
    parser = argparse.ArgumentParser()
    parser.add_argument('-v', '--verbosity', action="count",
                        help="increase output verbosity (e.g., -vv is more than -v)")
    parser.add_argument('--dry-run', action='store_true')
    parser.add_argument('places', nargs='+')

    GV.update(vars(parser.parse_args(args)))
    GV.verbose = GV.verbosity

    dir_count = 0
    limit = 0
    for place in GV.places:
        if GV.verbose:
            print 'Checking place:', place
        for root, dirs, files in os.walk(place):
            dir_count += 1
            if limit and dir_count > limit:
                return
            if GV.verbose:
                print 'Checking dir:', root
            for f in files:
                fp = os.path.join(root, f)
                try:
                    if os.path.getsize(fp) == 0:
                        print 'Removing:', fp, 'size', os.path.getsize(fp)
                        if not GV.dry_run:
                            os.remove(fp)
                except Exception as e:
                    print e
            for d in dirs:
                dp = os.path.join(root, d)
                try:
                    if not os.listdir(dp):
                        print 'Removing:', dp, 'file count', len(os.listdir(dp))
                        if not GV.dry_run:
                            os.rmdir(dp)
                except Exception as e:
                    print e


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
