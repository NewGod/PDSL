import unittest
from pdsl.glob import add_var, add_subunit, add_relation, UnitInfo, delete_unit, decode_unit, encode_unit, unit2str
import pdsl.glob as g


class TestGlob(unittest.TestCase):
    def tearDown(self):
        g.unit2name = {}
        g.name2unit = {}

    def test_add_var(self):
        add_var("Force", "N")
        self.assertRaises(Exception, add_var, "Force", 'bad')
        self.assertRaises(Exception, add_var, 'bad', 'N')
        self.assertEqual(g.unit2name["N"], "Force")
        self.assertEqual(g.name2unit["Force"].base, "N")

    def test_decode_unit(self):
        g.name2unit["Force"] = UnitInfo("Force", "N")
        g.unit2name["N"] = "Force"
        g.name2unit["Time"] = UnitInfo("Time", "s")
        g.unit2name["s"] = "Time"
        g.name2unit["Dist"] = UnitInfo("Dist", "m")
        g.unit2name["m"] = "Dist"
        g.name2unit["Force"].relation = {"Dist": 1, "Time": -2}
        self.assertDictEqual(decode_unit({"N": 2})[0], {"Dist": 2, "Time": -4})
        self.assertEqual(decode_unit({"N": 2})[1], 1)

    def test_unit2str(self):
        self.assertEqual(unit2str({"A": 1, "B": 2, "C": -1}), "B^2*A*C^(-1)")

    def test_encode_unit(self):
        g.name2unit["Force"] = UnitInfo("Force", "N")
        g.unit2name["N"] = "Force"
        self.assertEqual(encode_unit({"Force": 1}), {"N": 1})

    def test_add_subunit(self):
        g.name2unit["Force"] = UnitInfo("Force", "N")
        g.unit2name["N"] = "Force"
        add_subunit("N", "kN", 1000)
        add_subunit("kN", "mN", 1000)
        self.assertEqual(g.name2unit[g.unit2name["mN"]].subunit["mN"], 1000000)
        self.assertRaises(Exception, add_subunit, "N", "kN", 1000)
        self.assertRaises(Exception, add_subunit, "nN", "tN", 1000)
        self.assertEqual("tN" in g.name2unit, False)

    def test_add_relation(self):
        g.name2unit["Force"] = UnitInfo("Force", "N")
        g.unit2name["N"] = "Force"
        g.name2unit["Time"] = UnitInfo("Time", "s")
        g.unit2name["s"] = "Time"
        g.name2unit["Dist"] = UnitInfo("Dist", "m")
        g.unit2name["m"] = "Dist"
        add_relation("Force", {"Dist": 1, "Time": -2})
        self.assertRaises(Exception, add_relation,
                          "N", {"Dist": 1, "Time": -2})
        self.assertRaises(Exception, add_relation,
                          "Force", {"Dist": 1, "s": -2})

    def test_delete_unit(self):
        g.name2unit["Force"] = UnitInfo("Force", "N")
        g.unit2name["N"] = "Force"
        delete_unit("Force")
        self.assertEqual("N" in g.unit2name, False)
        self.assertEqual("Force" in g.name2unit, False)
