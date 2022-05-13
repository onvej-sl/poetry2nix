from setuptools import find_packages, setup

setup(
    name="dep1",
    packages=find_packages("src"),
    package_dir={"": "src"},
)
