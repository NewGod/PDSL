from typing import Dict, Union, Tuple, List

"""
A variable formate list:
initial:
int, str -normalize-> int, dict[str, int]

"""


class PhyManager:
    """
    add_var and add_subunit for class define
    and decode and encode for PhyVar
    """

    def __init__(self):
        pass

    def add_var(self, name: str, base: str, vector=False):
        """
        register a new variable
        """
        pass

    def decode(self, unit: str) -> Tuple[Dict[str, float], float]:
        """
        return a normalize express and it's rate
        example:
        decode("km") -> {"Dist", 1}, 0.001
        """
        pass

    def encode(self, unit: Dict[str, float]) -> str:
        """
        encode a normalize express
        """
        pass

    def add_subunit(self, base: str, sub: str, rate: float):
        """
        1 base = rate sub
        """
        pass

    def set_dim(self, dim: int):
        pass


class PhyVar:
    def __init__(self, val: Union[float, Tuple[float]], unit: str):
        pass

    def __eq__(self, value: 'PhyVar') -> bool:
        pass

    def __gt__(self, value: 'PhyVar') -> bool:
        pass

    def __add__(self, value: 'PhyVar') -> 'PhyVar':
        pass

    def __sub__(self, value: 'PhyVar') -> 'PhyVar':
        pass

    def __mul__(self, value: 'PhyVar') -> 'PhyVar':
        pass

    def __div__(self, value: 'PhyVar') -> 'PhyVar':
        pass

    def __str__(self) -> str:
        pass

    def set_val(self, val: 'PhyVar'):
        """
        a = balabala
        ==========>
        if isinstance(a, PhyVar):
            a = a.set_val(balabala)
        else:
            a = balabala
        """
        pass

    def format(self, unit: str) -> str:
        """
        return a string with a specific unit
        """
        pass

    def __len__(self) -> float:
        """
        return the len of the variable
        example:
        a = (3, 4)N
        len(a) = 5 "N?"
        """
        pass

    def get_dim(self, key: int) -> float:
        pass

    def get_slice(self, start: int, end: int, step: int) -> List:
        pass

    def __setitem__(self, key: int, value: float):
        pass

    def __getitem__(self, key):
        if isinstance(key, int):
            return self.get_dim(key)
        elif isinstance(key, slice):
            start, end, step = key
            return self.get_slice(start, end, step)
