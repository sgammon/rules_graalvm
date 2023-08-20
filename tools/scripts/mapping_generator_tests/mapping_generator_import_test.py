"""Test that the `mapping_generator` module can be imported without errors."""

import unittest


class TestCase(unittest.TestCase):
    def test_importable(self):
        from tools.scripts import mapping_generator
        self.assertIsNotNone(mapping_generator)


if __name__ == "__main__":
    unittest.main()
