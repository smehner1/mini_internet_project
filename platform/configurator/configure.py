import os
import argparse

from configure_intern import configure_intern
from configure_balancing import configure_balancing
from config_helper import extract_infos, get_routers_info
from configure_extern import configure_extern, toggle_ipd, define_egress_links, configure_external_interfaces


def init_parser() -> argparse.ArgumentParser:
    '''initializes a parser for the CLI'''
    parser = argparse.ArgumentParser()
    parser.add_argument('--dir',
                        help='path to directory of mini internet',
                        type=str,
                        default=os.getcwd(),
                        )

    return parser


def main() -> None:
    parser: argparse.ArgumentParser = init_parser()
    args: argparse.Namespace = parser.parse_args()

    minidir: str = args.dir
    print(minidir)

    routers_info = get_routers_info(minidir)
    num_routers, ases, edges = extract_infos(minidir)

    configure_intern(len(ases)+1, num_routers, routers_info['name'].to_list(), minidir)
    configure_external_interfaces(len(ases)+1, routers_info['name'].to_list(), minidir)
    configure_extern(len(ases)+1, routers_info['name'].to_list(), minidir)
    toggle_ipd(True, len(ases)+1, minidir)
    define_egress_links(minidir)
    configure_balancing(num_routers, ases, edges, minidir)


if __name__ == '__main__':
    main()
