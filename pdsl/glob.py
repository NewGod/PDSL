from typing import Dict, Union, Tuple, List
Unit = Dict[str, float]


def add_var(name: str, base: str, vector=False):
    """
    register a new variable
    """
    raise NotImplementedError


def decode_unit(unit: str) -> Unit:
    """
    return a normalize express and it's rate
    example:
    decode("km") -> {"Dist", 1}, 0.001
    """
    raise NotImplementedError


def encode_unit(unit: Unit) -> str:
    """
    encode a normalize express
    """
    raise NotImplementedError


def add_subunit(base: str, sub: str, rate: float):
    """
    1 base = rate sub
    """
    raise NotImplementedError


def set_dim(dim: int):
    raise NotImplementedError
