"""Test that the `mapping_generator` can be consulted for usage."""

import unittest
from tools.scripts.mapping_generator.generator import invoke


class TestCase(unittest.TestCase):
    def test_importable(self):
        try:
            invoke(args=["--help"])
        except SystemExit as e:
            self.assertEqual(0, e.code)


if __name__ == "__main__":
    unittest.main()
