import unittest
from unittest.mock import patch, MagicMock
from python.phyvar import PhyVar, compare_float, compare_unit
import builtins
import sys


class TestPhyVar(unittest.TestCase):
    unit = {'weight': 1, 'dist': 1, 'time': -2}

    def test_compare_float(self):
        self.assertEqual(compare_float(1), 1)
        self.assertEqual(compare_float(-1), -1)
        self.assertEqual(compare_float(0), 0)

    def test_compare_unit(self):
        self.assertEqual(compare_unit(self.unit, self.unit), False)
        self.assertEqual(compare_unit(self.unit, {}), True)

    def test_init(self):
        with patch('python.phyvar.decode_unit') as func:
            func.return_value = (self.unit, 0.001)
            a = PhyVar(1, {'N': 1}, is_ori=True)
            func.assert_called_once_with({'N': 1})
            self.assertDictEqual(a.unit, self.unit)
            self.assertEqual(a.val, 1000)
            self.assertEqual(a.is_vector, False)

        with patch('python.phyvar.decode_unit') as func:
            a = PhyVar([1], self.unit)
            func.assert_not_called()
            self.assertDictEqual(a.unit, self.unit)
            self.assertEqual(type(a.val), list)
            self.assertSequenceEqual(a.val, [1])
            self.assertEqual(a.is_vector, True)

    def test_comparable(self):
        a = PhyVar([1], self.unit)
        a.comparable(a)
        b = PhyVar([1], {})
        self.assertRaises(Exception, a.comparable, b)
        b = PhyVar(1, self.unit)
        self.assertEqual(b.is_vector, False)
        self.assertEqual(a.is_vector, True)
        self.assertRaises(Exception, a.comparable, b)
        b = PhyVar([1, 2], self.unit)
        self.assertRaises(Exception, a.comparable, b)

    def test_eq(self):
        a = PhyVar([1], self.unit)
        b = PhyVar([-1], self.unit)
        self.assertEqual(a == b, False)
        self.assertEqual(a != b, True)
        a = PhyVar(1, self.unit)
        b = PhyVar(1, self.unit)
        self.assertEqual(a == b, True)
        self.assertEqual(a != b, False)
        a = PhyVar([1], self.unit)
        b = PhyVar(1, self.unit)
        self.assertRaises(Exception, a.__eq__, b)

    def test_gtlt(self):
        a = PhyVar([1], self.unit)
        b = PhyVar([-1], self.unit)
        self.assertEqual(a > b, False)
        self.assertEqual(a < b, False)
        self.assertEqual(a >= b, True)
        self.assertEqual(a <= b, True)
        b = PhyVar(-1, self.unit)
        self.assertRaises(Exception, a.__le__, b)
        self.assertRaises(Exception, a.__ge__, b)
        a = PhyVar(1, self.unit)
        self.assertEqual(a > b, True)
        self.assertEqual(a < b, False)
        a = PhyVar([1], self.unit)
        b = PhyVar([-2], self.unit)
        self.assertEqual(a > b, False)
        self.assertEqual(a < b, True)

    def test_addsub(self):
        a = PhyVar([1], self.unit)
        b = PhyVar([-1], self.unit)
        c = a + b
        self.assertDictEqual(c.unit, a.unit)
        self.assertEqual(c.is_vector, a.is_vector)
        self.assertSequenceEqual(c.val, [0])
        c = -a
        self.assertDictEqual(c.unit, a.unit)
        self.assertEqual(c.is_vector, a.is_vector)
        self.assertSequenceEqual(c.val, [-1])
        c = a-b
        self.assertDictEqual(c.unit, a.unit)
        self.assertEqual(c.is_vector, a.is_vector)
        self.assertSequenceEqual(c.val, [2])
        b = PhyVar(1, self.unit)
        self.assertRaises(Exception, a.__add__, b)
        self.assertRaises(Exception, a.__sub__, b)
        a = PhyVar(-1, self.unit)
        c = a - b
        self.assertDictEqual(c.unit, a.unit)
        self.assertEqual(c.is_vector, a.is_vector)
        self.assertEqual(c.val, -2)

    def test_mul(self):
        a = PhyVar([2], self.unit)
        b = PhyVar([-2, 0], self.unit)
        self.assertRaises(Exception, a.__mul__, b)
        b = PhyVar([-2], self.unit)
        c = a * b
        unit = {'weight': 2, 'dist': 2, 'time': -4}
        self.assertDictEqual(c.unit, unit)
        self.assertEqual(c.is_vector, False)
        self.assertEqual(c.val, -4)
        b = PhyVar(-2, self.unit)
        c = a * b
        self.assertDictEqual(c.unit, unit)
        self.assertEqual(c.is_vector, True)
        self.assertSequenceEqual(c.val, [-4])
        a = PhyVar(2, self.unit)
        c = a * b
        self.assertDictEqual(c.unit, unit)
        self.assertEqual(c.is_vector, False)
        self.assertEqual(c.val, -4)
        b = 2
        c = a * b
        self.assertDictEqual(c.unit, a.unit)
        self.assertEqual(c.is_vector, False)
        self.assertEqual(c.val, 4)
        c = b * a

    def test_div(self):
        a = PhyVar([2], self.unit)
        b = PhyVar([-2], self.unit)
        self.assertRaises(Exception, a.__truediv__, b)
        b = PhyVar(-2, self.unit)
        c = a / b
        self.assertDictEqual(c.unit, {})
        self.assertEqual(c.is_vector, True)
        self.assertSequenceEqual(c.val, [-1])
        a = PhyVar(2, self.unit)
        c = a / b
        self.assertDictEqual(c.unit, {})
        self.assertEqual(c.is_vector, False)
        self.assertEqual(c.val, -1)

    def test_cross(self):
        a = PhyVar([2, 0], self.unit)
        b = PhyVar([2], self.unit)
        unit = {'weight': 2, 'dist': 2, 'time': -4}
        self.assertRaises(Exception, a.cross, b)
        b = PhyVar([0, 2], self.unit)
        c = PhyVar.cross(a, b)
        self.assertDictEqual(c.unit, unit)
        self.assertEqual(c.is_vector, False)
        self.assertEqual(c.val, 4)

    def test_str(self):
        with patch("python.phyvar.encode_unit") as func:
            func.return_value = {'N': 1}
            a = PhyVar([2, 0], self.unit)
            b = PhyVar([2], self.unit)
            self.assertEqual(str(a), str([2., 0.]) + 'N')
            func.assert_called_once_with(self.unit)
            self.assertEqual(str(b), str([2.]) + 'N')
            func.assert_called_with(self.unit)

    def test_format(self):
        with patch('python.phyvar.decode_unit') as func:
            func.return_value = (self.unit, 0.001)
            a = PhyVar(1, {'N': 1}, True)
            self.assertEqual(a.format({'N': 1}), '1.0N')
            func.assert_called_with({'N': 1})

    @patch('logging.warning')
    def test_setval(self, func):
        a = PhyVar([2, 0], self.unit)
        b = PhyVar(2, self.unit)
        a.set_val(b)
        func.assert_called()

    def test_len(self):
        a = PhyVar([3, 4], self.unit)
        self.assertEqual(a.len, 5)
        a = PhyVar(-5, self.unit)
        self.assertEqual(a.len, -5)

    def test_get_dim(self):
        a = PhyVar([2, 0], self.unit)
        self.assertEqual(a.get_dim(), 2)
        a = PhyVar(2, self.unit)
        self.assertRaises(Exception, a.get_dim)

    def test_setitem(self):
        a = PhyVar([2, 0], self.unit)
        a[0] = 1
        self.assertDictEqual(a.unit, self.unit)
        self.assertEqual(a.is_vector, True)
        self.assertSequenceEqual(a.val, (1, 0))
        a = PhyVar(2, self.unit)
        self.assertRaises(Exception, a.__setitem__, 0, 1)

    def test_getitem(self):
        a = PhyVar([2, 0], self.unit)
        self.assertEqual(a[0], PhyVar([2], self.unit))
        self.assertEqual(a[:], a)
        a = PhyVar(2, self.unit)
        self.assertRaises(Exception, a.__getitem__, 0)


if __name__ == '__main__':
    unittest.main()
