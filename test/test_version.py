import re
import unittest
from puma.utils import PROJECT_ROOT
from puma.version import version


def read_release_notes(file_path: str) -> [str]:
    """
    Read the content of the release notes file.
    :param file_path: The path to the release notes file.
    :return: The content of the release notes file.
    """
    with open(file_path, 'r') as file:
        return file.readlines()


class TestVersion(unittest.TestCase):
    def setUp(self):
        self.release_notes_path = f"{PROJECT_ROOT}/RELEASE_NOTES"
        self.release_notes = read_release_notes(self.release_notes_path)

    def test_version_in_release_notes_same_as_setup(self):
        first_line = self.release_notes[0]
        match = re.search(r'(\d+\.\d+\.\d+)', first_line)
        first_version_in_release_notes = match.group(1) if match else None
        self.assertIsNotNone(first_version_in_release_notes)
        self.assertEqual(first_version_in_release_notes, version,
                         "Version in release notes is not equal to setup version")
#TODO: add a workflow for test that is triggered upon commit
# call this test from the publish yml so the tests are first run
# ALso add release notes test?
# Also add test to compare the release version in github with the release notes and version.py. Find out how to inject the release version from github in the script