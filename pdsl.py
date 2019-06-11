#!/usr/local/bin/python3
import click
import subprocess
from pdsl import PhyVar
import pdsl.phymanager as Phymanager
@click.command()
@click.argument('script-file')
def run(script_file):
    print(script_file)
    with open(script_file) as f:
        process = subprocess.Popen(['bin/pdsl'], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        process.stdin.write(bytes(f.read(), 'utf-8'))
        stdout, stderr = process.communicate()
    stdout = stdout.decode('utf-8')
    stderr = stderr.decode('utf-8')
    print(stdout)
    print(f'STDERR:{stderr}')
    print("")
    exec(stdout)


if __name__ == '__main__':
    run()
