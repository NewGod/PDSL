from typing import Dict, Union, Tuple, List, Optional
from python import Unit


def check_name(unit: Union[str, Unit]):
    if isinstance(unit, str):
        if unit not in name2unit:
            raise Exception(f"Unit {unit} not defined")
    else:
        for name, power in unit.items():
            if name not in name2unit:
                raise Exception(f"Unit {name} not defined")


def check_unit(unit: Union[str, Unit]):
    if isinstance(unit, str):
        if unit not in unit2name:
            raise Exception(f"Unit {unit} not defined")
    else:
        for name, power in unit.items():
            if name not in unit2name:
                raise Exception(f"Unit {name} not defined")


class UnitInfo:
    name: str
    base: str
    relation: Unit

    def __init__(self, name: str, base: str):
        self.name = name
        self.base = base
        self.relation: Optional[Unit] = None
        self.subunit: Unit = {base: 1}


name2unit: Dict[str, UnitInfo] = {}
unit2name: Dict[str, str] = {}


def add_var(name: str, base: Optional[str], vector=False):
    """
    register a new variable
    """
    if name in name2unit:
        raise Exception(f"Unit {name} has been defined")
    if base is not None and base in unit2name:
        raise Exception(f"Unit {base} has been defined")
    unit = UnitInfo(name, base)
    name2unit[name] = unit
    if base is not None:
        unit2name[base] = name


def get_base_unit(name: str) -> Unit:
    if name2unit[name].relation is None:
        return {name: 1}
    ret: Unit = {}
    for unit, power in name2unit[name].relation.items():
        tmp = get_base_unit(unit)
        for tname, tpower in tmp.items():
            if tname not in ret:
                ret[tname] = 0
            ret[tname] += tpower * power
    return ret


def decode_unit(unit: Unit) -> Tuple[Unit, float]:
    """
    return a normalize express and it's rate
    example:
    decode({"km", 1}) -> {"Dist", 1}, 0.001
    """
    check_unit(unit)
    ret: Unit = {}
    rate = 1
    for name, power in unit.items():
        rate *= name2unit[unit2name[name]].subunit[name]
        tmp = get_base_unit(unit2name[name])
        for tname, tpower in tmp.items():
            if tname not in ret:
                ret[tname] = 0
            ret[tname] += tpower * power
    return ret, rate


def unit2str(unit: Unit) -> str:
    """
    unit2str({"km": 1, "s": -1}) -> "km/s"
    """
    s = list(sorted(unit.items(), key=lambda kv: (kv[1], kv[0]), reverse=True))
    ret = ""
    for idx, (x, y) in enumerate(s):
        if idx != 0:
            ret += '*'
        if y == 1:
            ret += x
        elif y < 0:
            ret += x + "^(" + str(y) + ")"
        else:
            ret += x + "^" + str(y)
    return ret


def encode_unit(unit: Unit) -> Unit:
    """
    encode a normalize express
    """
    check_name(unit)
    ret: Unit = {}
    for name, power in unit.items():
        if name2unit[name].base is None:
            raise Exception(f"Unit {name} don't have a base Unit")
        ret[name2unit[name].base] = power
    return ret


def add_subunit(base: str, sub: str, rate: float):
    """
    1 base = rate sub
    """
    check_unit(base)
    if sub in unit2name:
        raise Exception(f"unit {sub} has been defined")
    rate *= name2unit[unit2name[base]].subunit[base]
    unit2name[sub] = unit2name[base]
    name2unit[unit2name[sub]].subunit[sub] = rate


def add_relation(name: str, relation: Dict[str, float]):
    """
    speed = dist / time
    ==>
    add_relation(speed, {"dist": 1, "time": -1})
    """
    check_name(relation)
    name2unit[name].relation = relation


def delete_unit(name: str):
    tmp = name2unit[name]
    for unit, rate in tmp.subunit.items():
        del unit2name[unit]
    del name2unit[name]
