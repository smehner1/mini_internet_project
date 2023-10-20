import glob
import argparse
import subprocess
import pandas as pd

from typing import Tuple
from datetime import datetime, timedelta


def init_parser() -> argparse.ArgumentParser:
    '''initializes a parser for the CLI'''
    parser = argparse.ArgumentParser()
    parser.add_argument('--minidir',
                        help='path to directory of mini internet',
                        type=str,
                        default='/home/max/WORK/mini-internet/',
                        )
    parser.add_argument('--netflowdir',
                        help='directory that includes the netflow',
                        type=str,
                        default='/home/max/WORK/masterthesis/mini_internet/router_files/netflow_mini-internet',
                        )
    parser.add_argument('-i',
                        help='interval of garbage collection in hours',
                        type=int,
                        default=1,
                        )

    return parser


def get_removals(interval: int, num_groups: int, routers: list, netflowdir: str) -> Tuple[list, list]:
    '''
    determines the files and directories to delete (older than interval hours)

    Arguments
    ---------
    interval (int): time between each iteration of garbage collection
    num_groups (int): number of AS's in Mini-Internet
    routers (list[str]): list of routernames within each AS
    netflowdir (str): path to directory of generated netflow

    Returns
    -------
    remove_dirs (list): list of directories that need to be removed
    remove_files (list): list of files that need to be removed
    '''
    remove_dirs: list = []  # list that will include the directories to delete
    remove_files: list = []  # list that will include the files to delete

    # determine the cutoff time/date
    date: datetime = datetime.now()
    cutoff: datetime = date - timedelta(hours=interval)
    print(f'NOW:                 {date}')
    print(f'DELETE EARLIER THAN: {cutoff}')

    # extract the specific values
    year: int = cutoff.year
    month: int = cutoff.month
    day: int = cutoff.day
    hour: int = cutoff.hour
    minute: int = cutoff.minute

    # determine files and directories for each group/AS
    for i in range(num_groups):
        for router in routers:
            ports: list = glob.glob(f'{netflowdir}/AS_{i+1}/{i+1}_{router}router/*/')  # read all port folders
            for port in ports:
                years: list = glob.glob(f'{port}/*/')  # read all year folders
                years = [int(y.split('/')[-2]) for y in years]

                for y in years:
                    if y < year:  # should year directory be deleted
                        remove_dirs.append(f'{port}{str(y)}')
                    else:
                        months: list = glob.glob(f'{port}{str(y)}/*/')  # read all month folders
                        months = [int(m.split('/')[-2]) for m in months]
                        for m in months:
                            # convert month to string with possible leading 0
                            if m < 10:
                                o_m: str = f'0{m}'
                            else:
                                o_m: str = f'{m}'
                            if m < month:  # should month directory be deleted
                                remove_dirs.append(f'{port}{str(y)}/{str(o_m)}')
                            else:
                                days: list = glob.glob(f'{port}{str(y)}/{str(o_m)}/*/')  # read all day folders
                                days = [int(d.split('/')[-2]) for d in days]
                                for d in days:
                                    # convert day to string with possible leading 0
                                    if d < 10:
                                        o_d: str = f'0{str(d)}'
                                    else:
                                        o_d: str = f'{str(d)}'
                                    if d < day:  # should day directory be deleted
                                        remove_dirs.append(f'{port}{str(y)}/{str(o_m)}/{str(o_d)}')
                                    else:
                                        # read all files
                                        files: list = glob.glob(f'{port}{str(y)}/{str(o_m)}/{str(o_d)}/*')
                                        for file in files:
                                            file_tmp: str = file.split('/')[-1].split('.')[1]
                                            f_h: int = int(file_tmp[8:10])
                                            f_min: int = int(file_tmp[10:])
                                            # check if file is earlier than cutoff time and add it to remove list
                                            if f_h < hour:
                                                remove_files.append(file)
                                            elif f_h == hour:
                                                if f_min < minute:
                                                    remove_files.append(file)

    return remove_dirs, remove_files


def main() -> None:
    parser: argparse.ArgumentParser = init_parser()
    args: argparse.Namespace = parser.parse_args()

    num_groups: int = len(pd.read_csv(f'{args.minidir}/platform/config/AS_config.txt', header=None))
    router_file: str = f'{args.minidir}/platform/config/router_config_full.txt'
    router_info: pd.DataFrame = pd.read_csv(router_file, header=None, sep=' ')
    router_info.columns = ['name', '_', '__', '___']

    directories, files = get_removals(args.i, num_groups, router_info['name'].to_list(), args.netflowdir)

    for path in directories:
        subprocess.run(f'rm -rf {path}', shell=True)
    for path in files:
        subprocess.run(f'rm -f {path}', shell=True)
    print('------------ DELETED ------------')


if __name__ == '__main__':
    main()
