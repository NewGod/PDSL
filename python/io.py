from python.phyvar import PhyVar
from python import Unit


def read_var(unit: Unit) -> PhyVar:
    s = input()
    return PhyVar(s, unit, True)
