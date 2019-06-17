from typing import Dict, Union, List, Optional
from python.phymanager import decode_unit, encode_unit, unit2str
from python import Unit
from copy import copy
import numpy as np
from numbers import Number

"""
A variable formate list:
initial:
int, str -normalize-> int, dict[str, int]
"""


def compare_float(x: float) -> float:
    EPS = 1e-5
    if (x > EPS):
        return 1
    elif x < -EPS:
        return -1
    else:
        return 0


def compare_unit(x: Unit, y: Unit) -> bool:
    """
    return True if the two units not the same
    """
    if (len(x) != len(y)):
        return True
    for a, b in x.items():
        if a not in y:
            return True
        if compare_float(b-y[a]) != 0:
            return True
    return False


class PhyVar:
    def __init__(self, val: Union[float, List[float]], unit: Unit, is_ori=False):
        if is_ori:
            unit, rate = decode_unit(unit)
        else:
            rate = 1
        self.unit = unit  # type: Unit
        if isinstance(val, Number):
            self.val = val / rate
            self.is_vector = False
        else:
            self.val = [x / rate for x in val]
            self.is_vector = True

    def comparable(self, var: 'PhyVar'):
        if compare_unit(self.unit, var.unit):
            raise Exception("The two variables don't have the same value")
        if self.is_vector != var.is_vector:
            raise Exception("The two variables aren't vector or scalar both")
        if self.is_vector and len(self.val) != len(var.val):
            raise Exception("The two variables don't have the same dim")
        return

    def __eq__(self, var: 'PhyVar') -> bool:
        self.comparable(var)
        if self.is_vector:
            for x, y in zip(self.val, var.val):
                if (compare_float(x-y)):
                    return False
        else:
            if (compare_float(self.val - var.val)):
                return False
        return True

    def __gt__(self, var: 'PhyVar') -> bool:
        self.comparable(var)
        return compare_float(self.len - var.len) == 1

    def __lt__(self, var: 'PhyVar') -> bool:
        self.comparable(var)
        return compare_float(self.len - var.len) == -1

    def __ge__(self, var: 'PhyVar') -> bool:
        return not self.__lt__(var)

    def __le__(self, var: 'PhyVar') -> bool:
        return not self.__gt__(var)

    def __add__(self, var: 'PhyVar') -> 'PhyVar':
        self.comparable(var)
        if self.is_vector:
            ret = list(x + y for x, y in zip(self.val, var.val))
        else:
            ret = self.val + var.val
        return PhyVar(ret, self.unit)

    def __neg__(self) -> 'PhyVar':
        if self.is_vector:
            return PhyVar(list(-x for x in self.val), self.unit)
        else:
            return PhyVar(-self.val, self.unit)

    def __sub__(self, var: 'PhyVar') -> 'PhyVar':
        return self.__add__(-var)

    def __mul__(self, var: 'PhyVar') -> 'PhyVar':
        if self.is_vector and var.is_vector:
            if len(self.val) != len(var.val):
                raise Exception("The two variable don't have the same dim")
            val = sum((x*y for x, y in zip(self.val, var.val)))
        elif not self.is_vector and not var.is_vector:
            val = self.val * var.val
        elif not self.is_vector and var.is_vector:
            val = (self.val*y for y in var.val)
        else:
            val = (x * var.val for x in self.val)
        unit = copy(self.unit)
        for x, y in var.unit.items():
            if x in unit:
                unit[x] += y
            else:
                unit[x] = y
        return PhyVar(val, unit)

    @classmethod
    def cross(cls, a: 'PhyVar', var: 'PhyVar') -> 'PhyVar':
        if not a.is_vector or not var.is_vector:
            raise Exception("The two variable should be scalar")
        val = np.cross(a.val, var.val).tolist()
        unit = copy(a.unit)
        for x, y in var.unit.items():
            if x in unit:
                unit[x] += y
            else:
                unit[x] = y
        return PhyVar(val, unit)

    def __truediv__(self, var: 'PhyVar') -> 'PhyVar':
        if var.is_vector:
            raise Exception('the divisor should not be a vector')
        if self.is_vector:
            val = (x / var.val for x in self.val)
        else:
            val = self.val / var.val
        unit = copy(self.unit)
        for x, y in var.unit.items():
            if x in unit:
                unit[x] -= y
                if compare_float(unit[x]) == 0:
                    del unit[x]
            else:
                unit[x] = -y
        return PhyVar(val, unit)

    def __str__(self) -> str:
        return str(self.val) + unit2str(encode_unit(self.unit))

    def __float__(self) -> float:
        if self.is_vector:
            raise Exception('The variable should be a scalar')
        for x in self.unit.values():
            if x != 0:
                raise Exception('The variable is not a number')
        return self.val

    def __int__(self) -> int:
        return int(self.__float__())

    def set_val(self, var):
        """
        a = balabala
        ==========>
        if isinstance(a, PhyVar):
            a = a.set_val(balabala)
        else:
            a = balabala
        """
        try:
            self.comparable(var)
        except Exception as e:
            print(e)  # TODO: Need to distinguish output, warning and error
        return var

    def format(self, unit: Unit) -> str:
        """
        return a string with a specific unit
        """
        tmp, rate = decode_unit(unit)
        print(tmp, self.unit)
        if compare_unit(self.unit, tmp):
            raise Exception(
                "The variable cannot tranform to the specific unit")
        if (self.is_vector):
            ret = list(x * rate for x in self.val)
        else:
            ret = self.val * rate
        return str(ret) + unit2str(unit)

    @property
    def len(self) -> float:
        """
        return the len of the variable
        example:
        a = (3, 4)N
        len(a) = 5
        """
        if (self.is_vector):
            return sum((x * x for x in self.val)) ** 0.5
        else:
            return self.val

    def get_dim(self) -> int:
        if not self.is_vector:
            raise Exception('This variable should be a vector')
        return len(self.val)

    def __setitem__(self, key: int, value: float):
        if not self.is_vector:
            raise Exception('This variable should be a vector')
        self.val[key] = value

    def __getitem__(self, key) -> 'PhyVar':
        if not self.is_vector:
            raise Exception('This variable should be a vector')
        if isinstance(key, int):
            return PhyVar([self.val[key]], self.unit)
        else:
            return PhyVar(self.val[key], self.unit)
