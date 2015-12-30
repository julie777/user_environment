#!/usr/bin/python
'''
'''

import sys
import os
import logging
import argparse
import bunch
from config import CONFIG, load_config
from <myapp> import APP_NAME, add_args, config_definition


APP_NAME = 'NEEDS NAME'
LOG = logging.getLogger(__name__)
GV = bunch.Bunch()


def main(args):
    process_args(args)
    load_config()
    set_up_logging()
    run()


def run():
    pass


def set_up_logging():
    logging.basicConfig(filename=APP_NAME + '.log', level=logging.WARNING, format="%(name)s %(process)d")


def load_config():
    load_config(config_definition, config_settings, commandline_args=opts)


def process_args(args):
    parser = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter))
    parser.add_argument('-v', '--verbosity', action="count",
                        help="increase output verbosity (e.g., -vv is more than -v)")
    opts = parser.parse_args(args)


if __name__ == '__main__':
    try:
        sys.exit(main(sys.argv[1:]))
    except KeyboardInterrupt:
        print 'Execution interrupted by user'
