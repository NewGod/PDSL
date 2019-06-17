#!/usr/local/bin/python3
import click
import subprocess
from python import PhyVar
import python.phymanager as Phymanager
import logging


@click.command()
@click.argument('script-files', type=click.File('r'), nargs=-1)
def run(script_files):
    if script_files is None:
        pass
    else:
        for script_file in script_files:
            process = subprocess.Popen(
                ['bin/pdsl'],
                stdin=subprocess.PIPE,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE
            )
            process.stdin.write(bytes(script_file.read(), 'utf-8'))
            stdout, stderr = process.communicate()
            stdout = stdout.decode('utf-8')
            stderr = stderr.decode('utf-8')
            if stderr != "":
                logging.error(stderr)
            else:
                exec(stdout)


if __name__ == '__main__':
    run()
